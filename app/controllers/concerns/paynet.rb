require "fpx"

module Paynet
    include OrderPaymentUpdate
    include TransactionDocument
    include Insurance

    def submit_bank_list_enquiry(msg_token)
        method = "SUBMIT_BE"
        url = URI.parse(ENV['FPX_BE_URL'])
        request_checksum = Fpx.sha1("#{msg_token}|BE|#{ENV['FPX_SELLER_EXCHANGE_ID']}|#{Fpx.version}")

        form_data = {
            'fpx_msgType' => 'BE',
            'fpx_msgToken' => msg_token,
            'fpx_sellerExId' => ENV['FPX_SELLER_EXCHANGE_ID'],
            'fpx_version' => Fpx.version,
            'fpx_checkSum' => request_checksum
        }

        begin
            response = Net::HTTP.post_form(url, form_data)
            # Do not log for production to reduce database size
            if ENV['FPX_PRODUCTION'] == '0'
                log_api(method, form_data, url, response.body, response.body)
            end
        rescue Net::ReadTimeout => e
            log_api(method, form_data, url, e.inspect, e)
        rescue StandardError => e
            log_api(method, form_data, url, e.inspect, e)
        end

        bank_group_options = []
        bank_options = []
        res = Hash.new(nil)

        if response.is_a?(Net::HTTPSuccess)
            response.body.split("&").each{ |element|
                x = element.split("=")
                res[x[0]] = (x[1].blank?) ? x[1] : URI.decode_www_form_component(x[1])
            }

            # Construct response checksum source string
            checksum_source_string = "#{res['fpx_bankList']}|#{res['fpx_msgToken']}|#{res['fpx_msgType']}|#{res['fpx_sellerExId']}"

            if Fpx.verify_checksum(res['fpx_checkSum'], checksum_source_string)
                banks = res['fpx_bankList'].split(",").sort

                banks.each { |a|
                    b = a.split("~")
                    bank = FpxBank.where(code: b[0], msg_token: msg_token)

                    if bank.count > 0
                        display_name = bank.first&.display_name&.upcase
                        # A=Active, B=Blocked
                        if b[1] == 'A'
                            bank_options << [display_name, b[0]]
                        elsif b[1] == 'B'
                            bank_options << [display_name + " (Offline)", "OFFLINE"]
                        end
                    else
                        bank_options << [b[0], b[0]]
                        # FpxBank.create({
                        #     code: b[0],
                        #     display_name: b[0],
                        #     msg_token: msg_token,
                        #     status: 'ACTIVE'
                        # })
                    end
                }

                bank_group_options << [Fpx.msg_token_name(msg_token), bank_options.sort]
            end
        else
            flash[:error] = "Unable to get response from FPX. Please try again later."
            bank_options << ["Unable to retrieve bank list from FPX. Please try again later.", "OFFLINE"]
            bank_group_options << [Fpx.msg_token_name(msg_token), bank_options]
        end

        return bank_group_options
    end

    def submit_authorization_enquiry(fpx_request)
        method = "SUBMIT_AE"
        url = URI.parse(ENV['FPX_AE_URL'])

        form_data = {
            'fpx_msgType' => fpx_request.msg_type,
            'fpx_msgToken' => fpx_request.msg_token,
            'fpx_sellerExId' => fpx_request.seller_ex_id,
            'fpx_sellerExOrderNo' => fpx_request.seller_ex_order_no,
            'fpx_sellerTxnTime' => fpx_request.seller_txn_time,
            'fpx_sellerOrderNo' => fpx_request.seller_order_no,
            'fpx_sellerId' => fpx_request.seller_id,
            'fpx_sellerBankCode' => fpx_request.seller_bank_code,
            'fpx_txnCurrency' => fpx_request.txn_currency,
            'fpx_txnAmount' => ActionController::Base.helpers.number_to_currency(fpx_request.txn_amount, unit: "", delimiter: ""),
            'fpx_buyerEmail' => fpx_request.buyer_email,
            'fpx_checkSum' => fpx_request.checksum,
            'fpx_buyerName' => fpx_request.buyer_name,
            'fpx_buyerBankId' => fpx_request.buyer_bank_id,
            'fpx_productDesc' => fpx_request.product_description,
            'fpx_version' => fpx_request.version,
            'fpx_buyerAccNo' => "",
            'fpx_buyerBankBranch' => "",
            'fpx_buyerIban' => "",
            'fpx_buyerId' => "",
            'fpx_makerName' => ""
        }

        begin
            response = Net::HTTP.post_form(url, form_data)
            log_api(method, form_data, url, response.body, response.body)
        rescue Net::ReadTimeout => e
            log_api(method, form_data, url, e.inspect, e)
        rescue StandardError => e
            log_api(method, form_data, url, e.inspect, e)
        end

        res = Hash.new(nil)

        if response.is_a?(Net::HTTPSuccess)
            response.body.split("&").each{ |element|
                x = element.split("=")
                res[x[0]] = (x[1].blank?) ? x[1] : URI.decode_www_form_component(x[1])
            }

            # Construct response checksum source string
            checksum_source_string = "#{res['fpx_buyerBankBranch']}|#{res['fpx_buyerBankId']}|#{res['fpx_buyerIban']}|#{res['fpx_buyerId']}|#{res['fpx_buyerName']}|#{res['fpx_creditAuthCode']}|#{res['fpx_creditAuthNo']}|#{res['fpx_debitAuthCode']}|#{res['fpx_debitAuthNo']}|#{res['fpx_fpxTxnId']}|#{res['fpx_fpxTxnTime']}|#{res['fpx_makerName']}|#{res['fpx_msgToken']}|#{res['fpx_msgType']}|#{res['fpx_sellerExId']}|#{res['fpx_sellerExOrderNo']}|#{res['fpx_sellerId']}|#{res['fpx_sellerOrderNo']}|#{res['fpx_sellerTxnTime']}|#{res['fpx_txnAmount']}|#{res['fpx_txnCurrency']}"

            if Fpx.verify_checksum(res['fpx_checkSum'], checksum_source_string)
                fpx_response_data = {
                    response_category: "BACKEND",
                    msg_type: res['fpx_msgType'],
                    msg_token: res['fpx_msgToken'],
                    fpx_txn_id: res['fpx_fpxTxnId'],
                    seller_ex_id: res['fpx_sellerExId'],
                    seller_ex_order_no: res['fpx_sellerExOrderNo'],
                    fpx_txn_time: res['fpx_fpxTxnTime'],
                    seller_txn_time: res['fpx_sellerTxnTime'],
                    seller_order_no: res['fpx_sellerOrderNo'],
                    seller_id: res['fpx_sellerId'],
                    txn_currency: res['fpx_txnCurrency'],
                    txn_amount: res['fpx_txnAmount'],
                    checksum: res['fpx_checkSum'],
                    buyer_name: res['fpx_buyerName'],
                    buyer_bank_id: res['fpx_buyerBankId'],
                    debit_auth_code: res['fpx_debitAuthCode'],
                    debit_auth_no: res['fpx_debitAuthNo'],
                    credit_auth_code: res['fpx_creditAuthCode'],
                    credit_auth_no: res['fpx_creditAuthNo']
                }
                @fpx_response = fpx_request.fpx_responses.create(fpx_response_data)

                @order = Order.find_by(code: fpx_request.seller_order_no)

                if !['PAID'].include?(@order.status)
                    case @fpx_response.debit_auth_code
                    when "00"
                        @order.update({
                            status: "PAID",
                            comment: "submit_authorization_enquiry"
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
                    when "99"
                        @order.update({
                            status: "PENDING_AUTHORIZATION",
                            comment: "submit_authorization_enquiry"
                        })
                        flash[:notice] = "Order status is pending authorization."
                    when "09"
                        @order.update({
                            status: "PENDING",
                            comment: "submit_authorization_enquiry"
                        })
                        flash[:notice] = "Order status is pending."
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
                flash[:error] = "Checksum verification failed."
            end
        else
            flash[:error] = "Unable to get response from FPX. Please try again later."
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