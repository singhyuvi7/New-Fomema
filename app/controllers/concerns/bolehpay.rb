require "boleh"

module Bolehpay
    include OrderPaymentUpdate
    include TransactionDocument
    include Insurance

    def submit_requery(boleh_request)
        method = "SUBMIT_AE"
        url = URI.parse(ENV['BOLEH_REQUERY_URL'])

        form_data = {
            'order_id' => boleh_request.order_number,
            'amount' => boleh_request.amount,
            'api_key' => Boleh.api_key,
        }

        begin
            response = Net::HTTP.post_form(url, form_data)
            log_api(method, form_data, url, response.body, response.body)
        rescue Net::ReadTimeout => e
            log_api(method, form_data, url, e.inspect, e)
        rescue StandardError => e
            log_api(method, form_data, url, e.inspect, e)
        end

        @order = Order.find_by(code: boleh_request.order_number)

        if response && response.code == '200'
            #success
            response = JSON.parse(response.body)

            boleh_response_data = {
                response_category: "BACKEND",
                order_number: response['data']['order_id'],
                amount: response['data']['amount'],
                transaction_id: response['data']['ref_id'],
                status: response['data']['status'],
                payment_date: response['data']['payment_created_date'],
                signature: response['data']['signature'],
            }

            @boleh_response = boleh_request.boleh_responses.create(boleh_response_data)

            if @boleh_response.calculate_signature != response['data']['signature']
                flash[:error] = "Checksum verification failed."
                return
            end

            if !['PAID'].include?(@order.status)
                case @boleh_response.status
                when "approved"
                    @order.update({
                        status: "PAID",
                        comment: "submit_requery"
                    })
                    flash[:notice] = "Order status is paid."

                    case @order.category
                    when "TRANSACTION_REGISTRATION"
                        payment_update_transaction_registration
                        if InsuranceService.order_has_insurance?(order: @order)
                            InsuranceService.generate_worker_code(order: @order)
                            SubmitPaidInsuranceJob.perform_later(order: @order, response_url: policy_external_insurances_url, backend_url: policy_external_insurances_url)
                        end
                    when "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION"
                        payment_update_special_renewal_transaction_registration
                    when "TRANSACTION_CANCELLATION"
                        payment_update_transaction_cancellation
                    when "TRANSACTION_CHANGE_DOCTOR"
                        payment_update_transaction_change_doctor
                    when "FOREIGN_WORKER_AMENDMENT"
                        payment_update_foreign_worker_amendment
                    when "REPRINT_MEDICAL_FORM"
                        @transaction_ids = @order.additional_information["transaction_ids"]
                        print_medical_form
                        return
                    when "INSURANCE_PURCHASE"
                        InsuranceService.generate_worker_code(order: @order)
                        SubmitPaidInsuranceJob.perform_later(order: @order, response_url: policy_external_insurances_url, backend_url: policy_external_insurances_url)
                    when "FOREIGN_WORKER_GENDER_AMENDMENT"
                        payment_update_foreign_worker_gender_amendment_with_approval
                    when "AGENCY_REGISTRATION"
                        payment_update_agency_registration
                    when "AGENCY_RENEWAL"
                        payment_update_agency_renewal
                    end
                when "pending_auth"
                    @order.update({
                        status: "PENDING_AUTHORIZATION",
                        comment: "submit_requery"
                    })
                    flash[:notice] = "Order status is pending authorization."
                when "pending", "processing"
                    @order.update({
                        status: "PENDING",
                        comment: "submit_requery"
                    })
                    flash[:notice] = "Order status is pending."
                when "duplicated"
                    flash[:error] = "Duplicate order initiated."
                else
                    order_status_before_update = @order.status

                    @order.update({
                        status: "FAILED"
                    })

                    flash[:notice] = "Order status is failed."

                    if !['FAILED'].include?(order_status_before_update)
                        case @order.category
                        when "AGENCY_REGISTRATION", "AGENCY_RENEWAL"
                            failed_payment_update_recreate_order
                        end
                    end
                end
            end
        else
            response = JSON.parse(response.body)

            if response['status_code'] == 2000 and response['data'].nil? and response['errors']['order_id'] = "The selected order id is invalid."
                order_status_before_update = @order.status

                @order.update({
                    status: "FAILED"
                })

                flash[:error] = "Order status is failed."

                if !['FAILED'].include?(order_status_before_update)
                    case @order.category
                    when "AGENCY_REGISTRATION", "AGENCY_RENEWAL"
                        failed_payment_update_recreate_order
                    end
                end
            else
                flash[:error] = "Unable to get response from BolehPay. Please try again later. (Error: #{response['message']})"
            end
        end
    end

private
    def log_api(method, params, url, response, full_response)
        log_data = {
            :name => self.class.name,
            :api_type => nil,
            :request_type => 'OUTGOING',
            :url => url,
            :method => method,
            :params => params,
            :response => response,
            :full_response => full_response,
        }

        api_log = ApiLog.create(log_data)
    end
end