module Insurance
    def get_insurance_data
        @order = Order.where(:code => params[:order_code]).first

        employer = current_user.userable
        authcode = get_auth_code(employer.code,params[:agent_code],params[:agent_key])
        order_items = @order.order_items.exclude_convenient_fee

        worker_list = []

        order_items.each do |item|
            if item.order_itemable_type == ForeignWorker.to_s
                foreign_worker = {
                    REGID: item.id, # order_item_id
                    WORKER_NAME: item.order_itemable.name,
                    SEX: item&.gender,
                    DATE_OF_BIRTH: item.order_itemable.date_of_birth.strftime('%Y%m%d'), # YYYYMMDD
                    PASSPORT_NO: item.order_itemable.passport_number,
                    COUNTRY_CODE: item.order_itemable.country.code,
                    JOB_TYPE: item.order_itemable.job_type.name,
                    ARRIVAL_DATE: item.order_itemable.arrival_date.present? ? item.order_itemable.arrival_date.strftime('%Y%m%d') : '',
                    ISPATI: item.order_itemable.pati ? 1 : 0, # 0=Not PATI, 1=PATI
                }
                worker_list.push(foreign_worker)
            end
        end

        jsondata = {
            BATCH_ID: @order.id,
            EMPLOYER_CODE: employer.code,
            EMPLOYER_NAME: employer.name,
            EMPLOYER_TYPE: employer.employer_type.name.downcase == 'individual' ? '1' : '2', # 1=Indv, 2=Co
            EMPLOYER_EMAIL: employer.email,
            EMPLOYER_ADDRESS1: employer.address1,
            EMPLOYER_ADDRESS2: employer.address2,
            EMPLOYER_ADDRESS3: employer.address3,
            EMPLOYER_ADDRESS4: employer.address4,
            EMPLOYER_STATECODE: employer.state&.code,
            EMPLOYER_POSTCODE: employer.postcode,
            EMPLOYER_COUNTRYCODE: employer.country&.code,
            EMPLOYER_TELEPHONE: employer.phone,
            EMPLOYER_FAX: employer.fax,
            EMPLOYER_ROC_NO: employer.business_registration_number,
            EMPLOYER_IC_PASSPORT_NO: employer.ic_passport_number,
            AUTHCODE: authcode,
            WORKER_LIST: worker_list
        }

        jsondata = JSON(jsondata)

        render plain: jsondata and return
    end

    def insurance_purchase
        # store params in log
        InsuranceResponseLog.create(response: params)

        # jsondata or id as param name
        # need to check uppercase JSONDATA and ID
        jsondata = {}

        if params.has_key?(:jsondata)
            jsondata = params[:jsondata]
        end

        if params.has_key?(:id)
            jsondata = params[:id]
        end

        if params.has_key?(:JSONDATA)
            jsondata = params[:JSONDATA]
        end

        if params.has_key?(:ID)
            jsondata = params[:ID]
        end

        if jsondata.present?
            jsondata = JSON(jsondata)

            if jsondata.key?('BATCH_ID')
                order_id = jsondata['BATCH_ID']
                insurance_provider = jsondata['INSURANCE_PROVIDER']
                employer_code = jsondata['EMPLOYER_CODE']

                if jsondata.key?('WORKER_LIST')
                    jsondata['WORKER_LIST'].each do |item|
                        order_item_id = item['REGID']
                        start_date = item['START_DATE']
                        end_date = item['END_DATE']
                        product_purchased = item['PRODUCT_PURCHASED']
                        worker_name = item['WORKER_NAME']

                        start_date = DateTime.parse(start_date)
                        start_date = start_date.strftime('%Y-%m-%d')
                        end_date = DateTime.parse(end_date)
                        end_date = end_date.strftime('%Y-%m-%d')

                        insurance = InsurancePurchase.new(
                            order_id: order_id,
                            order_item_id: order_item_id,
                            start_date: start_date,
                            end_date: end_date,
                            product_purchased: product_purchased,
                            batch_id: order_id,
                            reg_id: order_item_id,
                            employer_id: Employer.where(:code => employer_code).pluck(:id).first,
                            insurance_provider: insurance_provider,
                            fw_name: worker_name
                        )
                        insurance.save!
                    end
                    message = 'success'
                else
                    message = 'worker_list is empty'
                end
            else
                message = 'batch_id is empty'
            end
        else
            message = 'no params received'
        end

        render plain: message and return
    end

    # purchase insurance from selected fw in cart
    def purchase_insurance(provider_code)
        if current_user.userable_type == 'Agency'
            customer = @agency
        else
            customer = @employer
        end

        Order.transaction do
            flash[:errors] = []
            order_data = {
                customerable: customer,
                category: "INSURANCE_PURCHASE",
            }
            @order = Order.create(order_data)

            fee = Fee.find_by(code: "INSURANCE_GROSS_PREMIUM")
            params[:ids].each do |fw_id|
                # remove processed FW from cart
                TransactionCart.where(created_by: current_user.id, foreign_worker_id: fw_id).destroy_all

                if @employer.email.blank?
                    flash[:error] = "Email address is incomplete. Please update email address before proceeding."
                elsif ["PENDING", "PENDING_AUTHORIZATION", "PAID", "CANCELLED", "FAILED"].include?(@order.status)
                    flash[:error] = "Order #{@order.code} is #{@order.status}"
                else
                    # check if FW has pending order
                    add_fw_rs = InsuranceService.order_add_fw(order: @order, fw_id: fw_id, fee: fee)
                    if add_fw_rs.is_a? String
                        flash[:errors] << add_fw_rs
                        next
                    end
                end
            end
        end
        # /db-transaction
        if @order.order_items.count > 0
            if site == "PORTAL"
                @redirect_to = submit_calculator_external_insurances_path(@order.id, provider_code: provider_code)
            else
                @redirect_to = submit_calculator_internal_insurances_path(@order.id, provider_code: provider_code)
            end
        else
            @order.destroy
            if site == "PORTAL"
                @redirect_to = external_worker_lists_path
            else
                @redirect_to = internal_employer_employer_workers_url
            end
        end
    end

private
    def get_auth_code(emp_code,agent_code,agent_key)
        hash_empcode = Digest::MD5.hexdigest(emp_code)
        hash_agentcode = Digest::MD5.hexdigest(agent_code)
        hash_agentkey = Digest::MD5.hexdigest(agent_key)
        authcode = Digest::MD5.hexdigest(hash_empcode+hash_agentcode+hash_agentkey)

        return authcode
    end
end