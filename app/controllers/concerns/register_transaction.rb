module RegisterTransaction
    def register_transaction(allow_special_renewal: true)
        normal_workers = []
        special_workers = []
        conditional_workers = []
        @failed_messages = []
        @warning_messages = []
        special_worker_reason_codes = {}

        # run check on each foreign worker
        (params[:foreign_worker_ids] || params[:ids]).each do |fw_id|
            TransactionCart.where(created_by: current_user.id, foreign_worker_id: fw_id).destroy_all
            check_result = check_fw(fw_id)
            foreign_worker = check_result[:foreign_worker]
            special_renewal_reason_descriptions = check_result[:special_renewal_reason_descriptions]
            @failed_messages = @failed_messages + check_result[:failed_messages]
            @warning_messages = @warning_messages. + check_result[:warning_messages]
            special_worker_reason_codes[foreign_worker.id] = check_result[:special_worker_reason_codes]

            if check_result[:failed_messages].length == 0
                if check_result[:special_renewal]
                    if allow_special_renewal
                        special_workers << foreign_worker
                    else
                        @failed_messages << "#{foreign_worker.name} is (#{special_renewal_reason_descriptions.join(", ")}). No registration is allowed."
                    end
                elsif check_result[:conditional_renewal]
                    conditional_workers << foreign_worker
                else
                    normal_workers << foreign_worker
                end
            end
        end

        if @failed_messages.length > 0
            flash[:errors] = []
            flash[:errors].concat @failed_messages
            # @redirect_to = case site
            # when "NIOS"
            #     internal_employer_employer_workers_path @employer
            # when "PORTAL"
            #     external_worker_lists_path
            # end
            # return
        end

        if @warning_messages.length > 0
            flash[:warnings] = []
            flash[:warnings].concat @warning_messages
        end

        # create normal order
        if current_user.userable_type =='Agency'
             customer= @agency
        else
             customer=@employer
        end

        if normal_workers.length > 0 || conditional_workers.length > 0
            order_data = {
                customerable: customer,
                category: "TRANSACTION_REGISTRATION",
            }
            if @payment_method
                order_data[:payment_method_id] = @payment_method.id
            end
            @order = Order.create(order_data)

            if normal_workers.length > 0
                normal_workers.each do |foreign_worker|
                    fee = Fee.find_by(code: "TRANSACTION_#{ForeignWorker::GENDERS[foreign_worker.gender]}")
                    @order.order_items.create({
                        order_itemable: foreign_worker,
                        fee_id: fee.id,
                        amount: fee.amount
                    })
                end
            end

            if conditional_workers.length > 0
                conditional_workers.each do |foreign_worker|
                    fee = Fee.find_by(code: "TRANSACTION_#{ForeignWorker::GENDERS[foreign_worker.gender]}")
                    @order.order_items.create({
                        order_itemable: foreign_worker,
                        fee_id: fee.id,
                        amount: fee.amount,
                        additional_information: {
                            comments: "Conditional renewal"
                        }
                    })
                end
            end

            if site == "PORTAL"
                flash[:info] = "Payment (#{@order.code}) is created, please proceed to payment."
            else
                flash[:info] = "Order (#{@order.code}) is created, please proceed to payment."
            end

            @redirect_to = case site
            when "NIOS"
                edit_internal_order_path(@order)
            when "PORTAL"
                edit_external_order_path(@order)
            end
        end
        # /create normal order

        # create special renewal order
        if current_user.userable_type =='Agency'
            customer= @agency
       else
            customer=@employer
       end

        if special_workers.length > 0
            special_order_data = {
                customerable: customer,
                category: "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION",
                status: "NEW"
            }
            if @payment_method
                special_order_data[:payment_method_id] = @payment_method.id
            end
            special_order = Order.create(special_order_data)

            special_workers.each do |foreign_worker|
                fee = Fee.find_by(code: "TRANSACTION_#{ForeignWorker::GENDERS[foreign_worker.gender]}")
                comments = []
                if foreign_worker.renew_within_3_month? && foreign_worker.has_ignore_special_renewal_rule_transaction?
                    comments << Transaction::SPECIAL_RENEWAL_REASONS["3MONTH"]
                end
                # if foreign_worker.has_incomplete_transaction?
                #     comments << Transaction::SPECIAL_RENEWAL_REASONS["INCOMPLETE"]
                # end
                if foreign_worker.previous_transaction_unsuitable? && !foreign_worker.previous_transaction_with_blood_group_discrepancy?
                    comments << Transaction::SPECIAL_RENEWAL_REASONS["UNFIT"]
                end
                # if foreign_worker.previous_transaction_with_blood_group_discrepancy?
                #     comments << Transaction::SPECIAL_RENEWAL_REASONS["BLOOD_GROUP_DISCREPANCY"]
                # end
                special_order.order_items.create({
                    order_itemable: foreign_worker,
                    fee_id: fee.id,
                    amount: fee.amount,
                    additional_information: {
                        comments: comments.join("\n"),
                        special_renewal_reasons: special_worker_reason_codes[foreign_worker.id]
                    }
                })
                @special_renewal_messages="<font color='red'> #{foreign_worker.name}(#{foreign_worker.passport_number}) is previously unsuitable.  Click Make Payment to continue, or Cancel Payment to cancel.</font>"
            end
            if site == "PORTAL"
                flash[:info] = "Payment (#{special_order.code}) is created, please proceed to payment.<br>".concat @special_renewal_messages
            else
                flash[:warning] = "Order (#{special_order.code}) for special renewal is created, please proceed payment"
            end


            @redirect_to = case site
            when "NIOS"
                edit_internal_order_path(special_order)
            when "PORTAL"
                edit_external_order_path(special_order)
            end
        end
        # /create special renewal order
    end
    # /register_transaction

    def check_fw(fw_id)
        foreign_worker = ForeignWorker.find(fw_id)
        expiry_day = SystemConfiguration.find_by(code: "BLOCK_TRANSACTION_RENEWAL_WITHIN_DAYS").value
        ret = {
            failed_messages: [],
            warning_messages: [],
            special_renewal_reason_descriptions: [],
            special_worker_reason_codes: [],
            special_renewal: false,
            foreign_worker: foreign_worker,
            conditional_renewal: false
        }

        if current_user.userable_type !='Agency' && @employer.email.blank?
            ret[:failed_messages] << "Email address is incomplete. Please update email address before proceeding."
        elsif current_user.userable_type !='Agency' && foreign_worker.previous_transaction_unsuitable? && (@employer.bank_id.blank? || @employer.bank_account_number.blank?)
            ret[:failed_messages] << "Bank details incomplete.Click Profile to update."
        elsif !current_user.employer_supplement_id.blank? and current_user.employer_supplement_id != foreign_worker.employer_supplement_id
            ret[:failed_messages] << "Please transfer #{foreign_worker.name} before make a payment"
        elsif current_user.userable_type == 'Agency' && (foreign_worker.has_pending_transaction_registration_order_employer?)
            ret[:failed_messages] << "#{foreign_worker.name} (#{foreign_worker.passport_number}) has pending payment in Employer Portal. You are not allowed to complete the payment process."
        elsif (foreign_worker.has_pending_transaction_registration_order?)
            if ["PENDING_AUTHORIZATION", "PENDING"].include?(foreign_worker.pending_transaction_registration_order.status)
                ret[:failed_messages] << "#{foreign_worker.name} has pending authorization (Payment Code #{foreign_worker.pending_transaction_registration_order&.code})."
            else
                ret[:failed_messages] << "#{foreign_worker.name} has pending payment (Payment Code #{foreign_worker.pending_transaction_registration_order&.code}), please click Payment to complete the process."
            end
        elsif (foreign_worker.has_pending_gender_amendment_order?)
            ret[:failed_messages] << "#{foreign_worker.name} has pending payment for gender amendment (Payment Code #{foreign_worker.pending_transaction_registration_order&.code}), please click Payment to complete the process."
        elsif (foreign_worker.has_pending_gender_amendment_approval?)
            ret[:failed_messages] << "#{foreign_worker.name} gender amendment request is pending for approval."
        elsif foreign_worker.status == 'INACTIVE'
            ret[:failed_messages] << "#{foreign_worker.name} is INACTIVE"
        elsif foreign_worker.is_reg_medical_blocked?
            if site == "PORTAL"
                ret[:failed_messages] << "Medical information for #{foreign_worker.name} – #{foreign_worker.code || 'N/A'} / #{foreign_worker.passport_number} is blocked in the systems. Kindly capture the prompt message along with front page of the passport copy and latest work permit for the respective worker and email to cs@fomema.com.my for assistance."
            else
                ret[:failed_messages] << "#{foreign_worker.name} is blocked from purchasing medical form"
            end
        elsif foreign_worker.monitoring?
            ret[:failed_messages] << "#{foreign_worker.name} is under monitoring"
        elsif !foreign_worker.code.blank? && foreign_worker.plks_number.blank?
            ret[:failed_messages] << "#{foreign_worker.name} PLKS Number required"
        elsif foreign_worker.employer_id != @employer.id
            ret[:failed_messages] << "#{foreign_worker.name} - Employer not match"
        elsif foreign_worker.renew_within_x_day? && !foreign_worker.previous_transaction_with_blood_group_discrepancy? && !foreign_worker.previous_transaction_gender_different? && !foreign_worker.has_ignore_renewal_rule_transaction? && !foreign_worker.has_ignore_special_renewal_rule_transaction?
            ret[:failed_messages] << "#{foreign_worker.name} is not allowed to renew within #{expiry_day} days"
        elsif foreign_worker.renew_within_x_day? && foreign_worker.previous_transaction_with_blood_group_discrepancy? && foreign_worker.has_incomplete_transaction?
            ret[:failed_messages] << "#{foreign_worker.name} is not allowed to renew within #{expiry_day} days"
        elsif foreign_worker.renew_within_3_month? && !foreign_worker.has_ignore_special_renewal_rule_transaction?
            ret[:failed_messages] << "#{foreign_worker.name} is not allowed to renew within 3 month from certification date"
        elsif foreign_worker.special_renewal?
            if foreign_worker.previous_transaction_unsuitable? && !foreign_worker.previous_transaction_with_blood_group_discrepancy?
                ret[:special_renewal_reason_descriptions] << Transaction::SPECIAL_RENEWAL_REASONS["UNFIT"]
                ret[:special_worker_reason_codes] << "UNFIT"
            end
            # if foreign_worker.has_incomplete_transaction?
            #     ret[:special_renewal_reason_descriptions] << Transaction::SPECIAL_RENEWAL_REASONS["INCOMPLETE"]
            #     ret[:special_worker_reason_codes] << "INCOMPLETE"
            # end
            if foreign_worker.renew_within_3_month? && foreign_worker.has_ignore_special_renewal_rule_transaction?
                  ret[:special_renewal_reason_descriptions] << Transaction::SPECIAL_RENEWAL_REASONS["3MONTH"]
                  ret[:special_worker_reason_codes] << "3MONTH"
            end
            # if foreign_worker.previous_transaction_with_blood_group_discrepancy?
            #     ret[:special_renewal_reason_descriptions] << Transaction::SPECIAL_RENEWAL_REASONS["BLOOD_GROUP_DISCREPANCY"]
            #     ret[:special_worker_reason_codes] << "BLOOD_GROUP_DISCREPANCY"
            # end
            # ret[:warning_messages] << "#{foreign_worker.name} is (#{ret[:special_renewal_reason_descriptions].join(", ")}). No registration is allowed."
            ret[:special_renewal] = true
        elsif  foreign_worker&.approval_status == "UPDATE_PENDING_APPROVAL"
            ret[:failed_messages] << "#{foreign_worker.name} (#{foreign_worker.passport_number}) - Amendment pending approval."
        elsif foreign_worker.has_pending_gender_amendment_order?
            ret[:failed_messages] << "#{foreign_worker.name} has pending gender amendment order."
        elsif foreign_worker.has_pending_gender_amendment_approval?
            ret[:failed_messages] << "#{foreign_worker.name} has pending gender amendment approval."
        # elsif current_user.userable_type =='Agency' && foreign_worker.address1.blank?
        #     if foreign_worker&.approval_status != "UPDATE_PENDING_APPROVAL"
        #         ret[:failed_messages] << "#{foreign_worker.name} (#{foreign_worker.passport_number}) - Accommodation of foreign worker (Address) is incomplete. Kindly update by clicking on Amendment button to avoid any failure to your registration."
        #     else
        #         ret[:failed_messages] << "#{foreign_worker.name} (#{foreign_worker.passport_number}) - Amendment pending approval."
        #     end
        elsif foreign_worker.conditional_renewal?
            ret[:conditional_renewal] = true
        end
        return ret
    end
end
