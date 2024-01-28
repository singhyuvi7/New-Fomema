module OrderPaymentUpdate
    include ApprovalAssignmentCheck
    include Approvalable
    include WorkerBlocking

    def payment_update_transaction_registration
        trans_date = "1998-03-14"

        @order.order_items.joins(:fee).where("fees.code" => ["TRANSACTION_MALE", "TRANSACTION_FEMALE"]).each do |order_item|
            foreign_worker = order_item.order_itemable
            if !order_item.additional_information.blank? && order_item.additional_information.key?("foreign_worker")
                foreign_worker.update(order_item.additional_information["foreign_worker"])
            end

            is_order_item_id_exist = Transaction.search_transaction_date_start(trans_date).where(:order_item_id => order_item.id)
            if is_order_item_id_exist.blank?
                begin
                    transaction = Transaction.create!({
                        order_item_id: order_item.id,
                        foreign_worker_id: foreign_worker.id,
                        employer_id: foreign_worker.employer_id,
                        transaction_date: DateTime.now,
                        expired_at: DateTime.now + SystemConfiguration.find_by(code: "TRANSACTION_EXPIRY_DAYS").value.to_i.days,
                        approval_status: 'NEW_APPROVED',
                        fw_name: foreign_worker.name,
                        fw_gender: foreign_worker.gender,
                        fw_date_of_birth: foreign_worker.date_of_birth,
                        fw_passport_number: foreign_worker.passport_number,
                        fw_country_id: foreign_worker.country_id,
                        fw_maid_online: foreign_worker.maid_online,
                        fw_plks_number: foreign_worker.plks_number,
                        fw_job_type_id: foreign_worker.job_type_id,
                        fw_pati: foreign_worker.pati,
                        is_sp_transmit_blocked: foreign_worker.is_sp_transmit_blocked,
                        is_imm_blocked: foreign_worker.is_imm_blocked,
                        is_special_renewal: false,
                        created_by: @order.created_by,
                        updated_by: @order.created_by,
                        organization_id: @order.organization_id
                    })

                    foreign_worker.update_code
                    transaction.update({
                        fw_code: foreign_worker.code
                    })

                    if @order.customerable_type == 'Agency'
                        transaction.update({
                            agency_id: @order.customerable.id,
                            # is_imm_blocked: true
                        })

                        # block_reason = BlockReason.find_by(code: "DOCVERIFY", category: "BLOCK")
                        # block_comment = "PENDING DOCUMENT VERIFICATION BY OPERATION TEAM"
                        # block_imm(foreign_worker, block_reason, block_comment)
                    end

                rescue ActiveRecord::RecordNotUnique
                    ## order_item_id already exists.
                end
            end
        end
    end

    def payment_update_special_renewal_transaction_registration
        trans_date = "1998-03-14"

        @order.order_items.joins(:fee).where("fees.code" => ["TRANSACTION_MALE", "TRANSACTION_FEMALE"]).each do |order_item|
        # @order.order_items.exclude_convenient_fee.each do |order_item|
            foreign_worker = order_item.order_itemable
            if !order_item.additional_information.blank? and order_item.additional_information.key?("foreign_worker")
                foreign_worker.update(order_item.additional_information["foreign_worker"])
            end

            is_order_item_id_exist = Transaction.search_transaction_date_start(trans_date).where(:order_item_id => order_item.id)

            if is_order_item_id_exist.blank?
                begin
                    # foreign_worker.update_code

                    t = Transaction.create!({
                        order_item_id: order_item.id,
                        foreign_worker_id: foreign_worker.id,
                        employer_id: foreign_worker.employer_id,
                        transaction_date: DateTime.now,
                        expired_at: DateTime.now + SystemConfiguration.find_by(code: "TRANSACTION_EXPIRY_DAYS").value.to_i.days,
                        # approval_status: 'READY',
                        comment: order_item.comment,
                        fw_code: foreign_worker.code,
                        fw_name: foreign_worker.name,
                        fw_gender: foreign_worker.gender,
                        fw_date_of_birth: foreign_worker.date_of_birth,
                        fw_passport_number: foreign_worker.passport_number,
                        fw_country_id: foreign_worker.country_id,
                        fw_maid_online: foreign_worker.maid_online,
                        fw_plks_number: foreign_worker.plks_number,
                        fw_job_type_id: foreign_worker.job_type_id,
                        fw_pati: foreign_worker.pati,
                        is_sp_transmit_blocked: foreign_worker.is_sp_transmit_blocked,
                        is_imm_blocked: foreign_worker.is_imm_blocked,
                        is_special_renewal: true,
                        status: "NEW_PENDING_APPROVAL",
                        created_by: @order.created_by,
                        updated_by: @order.created_by,
                        organization_id: @order.organization_id
                    })

                    if @order.customerable_type == 'Agency'
                        t.update({
                            agency_id: @order.customerable.id,
                            #is_imm_blocked: true
                        })
                        # block_reason = BlockReason.find_by(code: "DOCVERIFY", category: "BLOCK")
                        # block_comment = "PENDING DOCUMENT VERIFICATION BY OPERATION TEAM"
                        # block_imm(foreign_worker, block_reason, block_comment)
                    end

                    if @order.organization&.code == 'PT'
                        user = @order.customerable.user
                    else
                        user = current_user
                    end

                    approval_assigned_to("TRANSACTION_SPECIAL_RENEWAL") if @order.organization&.code == 'PT'
                    approval_new_request(t, user: user, category: "TRANSACTION_SPECIAL_RENEWAL", assigned_to_user_id: @assigned_to_user_id)
                    if order_item.additional_information.key?("special_renewal_reasons") and !order_item.additional_information["special_renewal_reasons"].blank?
                        order_item.additional_information["special_renewal_reasons"].each do |reason|
                            t.transaction_special_renewals.create({
                                reason: reason
                            })
                        end
                    end

                rescue ActiveRecord::RecordNotUnique
                    ## order_item_id already exists.
                end
            end
        end
    end

    def payment_update_transaction_cancellation
        @order.order_items.exclude_convenient_fee.each do |order_item|
            transaction = order_item.order_itemable
            transaction.update({
                status: 'CANCELLED',
            })
            tc = transaction.transaction_cancels.where(status: "PENDING_PAYMENT").order(created_at: :desc).first_or_create
            tc.update({
                cancelled_at: Time.now,
                status: "COMPLETED"
            })
        end
    end

    def payment_update_transaction_change_doctor
        @order.order_items.exclude_convenient_fee.each do |order_item|
            transaction = order_item.order_itemable
            transaction.assign_attributes(order_item.additional_information["transaction"])
            approval_update_request(transaction, category: "TRANSACTION_CHANGE_DOCTOR")
            transaction.transaction_change_sps.find(order_item.additional_information["transaction_change_sp_id"]).update({
                status: "APPROVAL"
            })

            # auto approve
            user = User.admin_user
            approval_comment = 'Transaction change doctor request is approved automatically'
            approval_approve_request(transaction, user: user, comment: approval_comment)
            transaction.transaction_change_sps.where(status: "APPROVAL").order(created_at: :desc).first.update({
                decision: "APPROVE",
                status: "APPROVED",
                approval_comment: approval_comment,
                approval_by: user.id,
                approval_at: Time.now
            })
            transaction.reset_reprint_count
            # end auto approve
        end
    end

    def payment_update_foreign_worker_amendment
        # Do not use ActiveRecord::Base.transaction, it will work with callbacks after_save or after_commit, but saved_changes & previous_changes methods will stop working.
        # ActiveRecord::Base.transaction do
            changes = {}

            order_item = @order.order_items.exclude_convenient_fee.first
            additional_information = order_item.additional_information
            additional_information["changes"].each do |k, v|
                changes[k] = v[1]
            end
            foreign_worker = order_item.order_itemable
            foreign_worker.assign_attributes(order_item.get_additional_information_changes_new)
            if foreign_worker.critical_change?
                fw_changes =  foreign_worker.changes
                fw_amendment_comment = foreign_worker.amendment_reason_comment
                fw_amendment_amendment_reasons = foreign_worker.amendment_reasons
                flash[:notice] = "Amendment submitted. Auto-notification email will be sent once approved/rejected within 3 working days"

                approval_assigned_to("FOREIGN_WORKER_AMENDMENT")

                approval_update_request(foreign_worker, category: "FOREIGN_WORKER_AMENDMENT", additional_information: {order_id: @order.id}, assigned_to_user_id: @assigned_to_user_id)

                fw_amendment = foreign_worker.fw_amendments.create({
                    approval_item_id: foreign_worker.approval_item.id,
                    comment: fw_amendment_comment
                })
                # fw_changes["amendment_reasons"][1].each do |amendment_reason_id|
                fw_amendment_amendment_reasons.each do |amendment_reason_id|
                    fw_amendment.fw_amendment_reasons.create({
                        amendment_reason_id: amendment_reason_id
                    })
                end
                fw_changes.each do |field, field_changes|
                    if ["name", "date_of_birth", "country_id", "passport_number", "gender"].include?(field)
                        fw_amendment.fw_amendment_details.create({
                            field: field,
                            old_value: field_changes[0],
                            new_value: field_changes[1]
                        })
                    end
                end

                # auto approve
                case site
                when "NIOS"
                    user = User.admin_user
                    approval_comment = 'Worker amendment request is approved automatically'
                    approval_approve_request(foreign_worker, user: user, comment: approval_comment)
                end
                # end auto approve
            else
                approval_update_request(foreign_worker, category: "FOREIGN_WORKER_AMENDMENT", additional_information: {order_id: @order.id})
                approval_request = foreign_worker.approval_request
                approval_approve_request(foreign_worker)

                flash[:notices] = ["Worker amendment request submitted and approved."]
            end
        # end
        # /db-transaction
    end

    def payment_update_transaction_extention
        @order.order_items.exclude_convenient_fee.each do |order_item|
            order_item.order_itemable.extend
        end
    end

    def payment_update_foreign_worker_gender_amendment
        changes = {}

        order_item = @order.order_items.exclude_convenient_fee.first
        additional_information = order_item.additional_information
        additional_information["changes"].each do |k, v|
            changes[k] = v[1]
        end
        foreign_worker = order_item.order_itemable
        foreign_worker.assign_attributes(order_item.get_additional_information_changes_new)

        flash[:notices] = ["Foreign worker gender updated"]

        if foreign_worker.gender_changed? and foreign_worker.gender.eql?("M")
            amount = Fee.find_by(code: "TRANSACTION_FEMALE").amount - Fee.find_by(code: "TRANSACTION_MALE").amount
            if amount > 0
                @refund = Refund.create({
                    customerable: foreign_worker.employer,
                    category: "FOREIGN_WORKER_GENDER_AMENDMENT",
                    payment_method_id: foreign_worker&.latest_transaction&.order_item&.order&.payment_method_id,
                    amount: amount,
                    status: 'PENDING_SEND',
                    additional_information: {
                        order_id: @order.id
                    }
                })
                @refund.refund_items.create({
                    refund_itemable: foreign_worker,
                    amount: amount
                })

                ## send refund as batch instead of realtime
                # submit_refund (@refund)

                flash[:notices] << "Refund #{@refund.code} created"
            end
        end

        # foreign_worker.save
        fw_changes =  foreign_worker.changes
        approval_update_request(foreign_worker, category: "FOREIGN_WORKER_GENDER_AMENDMENT")
        fw_amendment = foreign_worker.fw_amendments.create({
            approval_item_id: foreign_worker.approval_item.id
        })
        fw_changes.each do |field, field_changes|
            if ["name", "date_of_birth", "country_id", "passport_number", "gender"].include?(field)
                fw_amendment.fw_amendment_details.create({
                    field: field,
                    old_value: field_changes[0],
                    new_value: field_changes[1]
                })
            end
        end
        foreign_worker.assign_attributes(foreign_worker.approval_item.params)
        approval_approve_request(foreign_worker)
    end

    def payment_update_foreign_worker_gender_amendment_with_approval
        changes = {}

        order_item = @order.order_items.exclude_convenient_fee.first
        additional_information = order_item.additional_information
        additional_information["changes"].each do |k, v|
            changes[k] = v[1]
        end
        foreign_worker = order_item.order_itemable
        foreign_worker.assign_attributes(order_item.get_additional_information_changes_new)

        # foreign_worker.save
        fw_changes =  foreign_worker.changes

        user = current_user
        if current_user.blank?
            user = @order.customerable.user
        end

        approval_assigned_to("FOREIGN_WORKER_AMENDMENT")

        approval_update_request(foreign_worker, user: user, category: "FOREIGN_WORKER_GENDER_AMENDMENT", additional_information: {fee_id: Fee.find_by(code: "FOREIGN_WORKER_GENDER_AMENDMENT").id, order_id: @order.id}, assigned_to_user_id: @assigned_to_user_id)

        fw_amendment = foreign_worker.fw_amendments.create({
            approval_item_id: foreign_worker.approval_item.id,
            created_by: user.id,
            updated_by: user.id
        })

        fw_changes.each do |field, field_changes|
            if ["amendment_reasons"].include?(field)
                fw_amendment.fw_amendment_reasons.create({
                    amendment_reason_id: field_changes[1][0],
                    created_by: user.id,
                    updated_by: user.id
                })
            end

            if ["name", "date_of_birth", "country_id", "passport_number", "gender"].include?(field)
                fw_amendment.fw_amendment_details.create({
                    field: field,
                    old_value: field_changes[0],
                    new_value: field_changes[1],
                    created_by: user.id,
                    updated_by: user.id
                })
            end
        end

        flash[:notices] = ["Amendment submitted. Auto-notification email will be sent once approved/rejected within 3 working days."]
    end

    def payment_update_agency_registration
        @order.order_items.joins(:fee).where("fees.code" => ["AGENCY_REGISTRATION"]).each do |order_item|
            agency = order_item.order_itemable
            if agency.expired_at.nil?
                agency.update({
                    expired_at: DateTime.now.beginning_of_day + SystemConfiguration.find_by(code: "AGENCY_EXPIRY_DAYS").value.to_i.days
                })
                user = User.find_by(code: agency.code)
                role = Role.find_by(code: 'AGENCY')
                user.update({
                    role_id: role.id
                })

                @agency = Agency.find_by(code: agency.code)
                AgencyMailer.with({
                    agency:@agency
                }).agency_certificate_email.deliver_later

            end

        end

    end

    def payment_update_agency_renewal
        @order.order_items.joins(:fee).where("fees.code" => ["AGENCY_RENEWAL"]).each do |order_item|
            agency = order_item.order_itemable
            if agency.renewal_order_created
                if agency.expired_at > Time.now
                    expired_date = agency.expired_at.beginning_of_day + SystemConfiguration.find_by(code: "AGENCY_EXPIRY_DAYS").value.to_i.days
                else
                    expired_date = @order.paid_at.beginning_of_day + SystemConfiguration.find_by(code: "AGENCY_EXPIRY_DAYS").value.to_i.days
                end
                agency.update({
                    expired_at: expired_date,
                    renewal_order_created: false,
                    sop_acknowledge: false
                })

                user = User.find_by(code: agency.code)
                if user.role&.code == 'AGENCY_UNPAID'
                    role = Role.find_by(code: 'AGENCY')
                    user.update({
                        role_id: role.id
                    })
                end

                @agency = Agency.find_by(code: agency.code)
                AgencyMailer.with({
                    agency:@agency
                }).agency_certificate_email.deliver_later

            end
        end
    end

    def failed_payment_update_recreate_order
        order = Order.create({
            customerable: @order.customerable,
            category: @order.category,
            amount: @order.amount,
            status: 'NEW',
            created_by: @order.created_by,
            updated_by: @order.updated_by,
            organization_id: @order.organization_id
        })

        @order.order_items.each do |order_item|
            unless order_item.fee.is_convenient_fee?
                order.order_items.create({
                    order_itemable_id: order_item.order_itemable_id,
                    order_itemable_type: order_item.order_itemable_type,
                    fee_id: order_item.fee_id,
                    amount: order_item.amount,
                    created_by: order_item.created_by,
                    updated_by: order_item.updated_by
                })
            end
        end
    end

    def payment_update_biometric_device
        @order.customerable.update_paid_biometric_device(true)
    end
end
