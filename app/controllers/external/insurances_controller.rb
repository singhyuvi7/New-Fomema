class External::InsurancesController < ExternalController
    skip_before_action :verify_authenticity_token, only: [:premium_calculated, :policy, :insurance_orders]
    skip_before_action :authenticate_external_user!, only: [:policy, :insurance_orders]

    # submit data to insurance calculator
    def submit_calculator
        @order = Order.find(params[:order_id])
        @provider_code = params[:provider_code]
        @old_insurance_service_provider_id = @order.insurance_service_provider_id

        if ["PENDING", "PENDING_AUTHORIZATION", "PAID", "CANCELLED", "FAILED"].include?(@order.status)
            flash_add(:errors, "Order #{@order.code} is #{@order.status}")
            redirect_to external_orders_path and return
        end

        # update order's insurance service provider
        insurance_service_provider = InsuranceServiceProvider.find_by(code: @provider_code)
        @order.update({
            insurance_service_provider_id: insurance_service_provider.id
        })

        if @order.customerable_type == 'Agency'
            @url = InsuranceService.api_1_url_nios(provider_code: @provider_code)
        else
            @url = InsuranceService.api_1_url(provider_code: @provider_code)
        end

        @submit_data = InsuranceService.calculator_submit_data(order: @order, response_url: premium_calculated_external_insurances_url, backend_url: premium_calculated_external_insurances_url)

        log_data = {
            name: "Insurance",
            request_type: "OUTGOING",
            method: "submit_calculator",
            url: @url,
            params: @submit_data
        }
        ApiLog.create(log_data)

        flash.keep
        render "shared/insurances/submit_calculator"
    end

    # receive data from insurance calculator
    def premium_calculated
        log_data = {
            name: "Insurance",
            request_type: "INCOMING",
            method: "premium_calculated",
            params: params
        }
        ApiLog.create(log_data)

        provider_code = params[:provider_code]&.strip&.upcase || "HOWDEN"
        decrypted_data = InsuranceService.decrypt(params[:param], provider_code)

        data = JSON.parse(decrypted_data)
        @order = Order.find_by(code: data["ORDER_CODE"])
        insurance_service_provider = InsuranceServiceProvider.find_by(code: provider_code)

        # to ensure insurance data inserted to order items before payment by the correct provider
        if !['PAID', 'PENDING_AUTHORIZATION', 'PENDING', 'CANCELLED', 'FAILED'].include?(@order.status) && @order.insurance_service_provider_id == insurance_service_provider.id
            InsuranceService.save_calculated_premium(data: decrypted_data, provider_code: provider_code)
        elsif ['PAID', 'PENDING_AUTHORIZATION', 'PENDING', 'CANCELLED', 'FAILED'].include?(@order.status)
            flash_add(:errors, "Premium failed to update. Order #{@order.code} is #{@order.status}")
        elsif @order.insurance_service_provider_id != insurance_service_provider.id
            flash_add(:errors, "Premium failed to update. Please click on Calculate Insurance Premium button for re-calculation.")
        end

        flash.keep
        redirect_to edit_external_order_path(@order)
    end

    # payment at fomema done, submit to insurance
    def submit_paid_premium
        @order = Order.find(params[:order_id])
        @provider_code = @order.insurance_purchases.first&.insurance_service_provider&.code
        @url = InsuranceService.api_3_url(provider_code: @provider_code)
        @submit_data = InsuranceService.paid_premium_submit_data(order: @order, response_url: policy_external_insurances_url, backend_url: policy_external_insurances_url)

        log_data = {
            name: "Insurance",
            request_type: "OUTGOING",
            method: "submit_paid_premium",
            url: @url,
            params: @submit_data
        }
        ApiLog.create(log_data)

        flash.keep
        render "shared/insurances/submit_paid_premium"
    end

    # receive policy data
    def policy
        provider_code = params[:provider_code]&.strip&.upcase || "HOWDEN"
        decrypted_data = InsuranceService.decrypt(params[:param], provider_code)

        log_data = {
            name: "Insurance",
            request_type: "INCOMING",
            method: "policy",
            params: params,
            body: decrypted_data
        }
        ApiLog.create(log_data)

        InsuranceService.save_policy(data: decrypted_data)

        # data = JSON.parse(params[:data])
        # @order = Order.find_by(code: data["ORDER_CODE"])

        # flash_add(:notices, "Insurance purchased")
        # redirect_to external_worker_lists_path
        render inline: 'OK'
    end

    # get orders related to insurance
    def insurance_orders
        provider_code = params[:provider_code]&.strip&.upcase || "HOWDEN"
        decrypted_data = InsuranceService.decrypt(params[:param], provider_code)

        log_data = {
            name: "Insurance",
            api_type: "REST_API",
            request_type: "INCOMING",
            method: "insurance_orders",
            params: params,
            body: decrypted_data,
            ip_address: get_ip_address
        }
        @api_log = ApiLog.create(log_data)

        @insurance_orders = InsuranceService.get_insurance_orders(data: decrypted_data)

        encrypted_data = InsuranceService.encrypt(@insurance_orders.to_json, provider_code)
        json_body = {
            "param" => encrypted_data
        }

        @api_log.update(response: @insurance_orders, full_response: json_body)

        render json: json_body
    end
end
