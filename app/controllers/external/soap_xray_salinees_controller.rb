class External::SoapXraySalineesController < ApplicationController
    soap_service namespace: "Xrays", camelize_wsdl: :lower

    soap_action :get_access_token,
        args: {
            userCode:      :string,
            secureCode:    :string,
            passphrase:    :string
        },
        return: {
            status:         :integer,
            token:          :string
        },
        to: :get_access_token

    def get_access_token
        status = 0
        token = nil

        begin
            xray_code       = params[:userCode]
            provider_code   = params[:secureCode]
            passphrase      = DigitalXrayProvider.encrypt_passphrase(params[:passphrase])
            xray_facility   = XrayFacility.where(code: xray_code).first
            xray_provider   = DigitalXrayProvider.where(code: provider_code).where(passphrase: passphrase).first
            active_account  = User.where(username: xray_code).where(status: 'ACTIVE').first

            # 1. check for valid xray facility
            raise AuthenticationFailedError if xray_facility.nil?

            # 2. check for valid secure code and passphrase
            raise AuthenticationFailedError if xray_provider.nil?

            # 3. Check for account locked
            raise AccountLockedError if active_account.nil?

            # 4. Check for xray facility who has default xray provider but not using the provider's service to get access token
            raise AuthenticationFailedError if xray_facility.digital_xray_provider_id and xray_provider.id != xray_facility.digital_xray_provider_id

            token = create_token

            # store token
            token_data = {
                usercode: xray_code,
                digital_xray_provider_code: provider_code,
                token: token,
                last_access: Time.now,
                expired_at: Time.now + SystemConfiguration.get("XRAY_WS_TOKEN_EXPIRY", "10").to_i.minutes
            }

            access_token = WsAccessToken.create(token_data)
            force_prev_token_expiry(xray_code, provider_code, access_token.id)
            status = 1
        rescue AuthenticationFailedError
            status = 0
        rescue AccountLockedError
            status = -1
        rescue StandardError
            status = -99
        end

        @response = {
            status: status,
            token: token
        }

        full_response = render xml: nil, layout: false, content_type: "text/xml"
        log_api('get_access_token', params, @response, full_response)
    end

    soap_action "checkTransactionIDXRayDate",
        args: {
            transactionId:     :string,
            userCode:          :string,
            accessToken:       :string,
            xrayTakenDate:     :string
        },
        return: {
            return:            :integer
        },
        to: :check_transaction_id_xray_date

    def check_transaction_id_xray_date
        result_code = 1

        begin
            xray_code = params[:userCode]

            if is_authorize?(xray_code, params[:accessToken])
                transaction_id          = params[:transactionId]
                xray_taken_date_time    = Time.parse(params[:xrayTakenDate].gsub(/\+\d{2}\:\d{2}/, ""))
                transaction             = get_transaction(transaction_id, xray_code)

                # 1. Check valid Transaction
                raise InvalidTransactionError if transaction.nil?

                case transaction.class.name
                when "Transaction"
                    # 2. Check Xray Medical submitted
                    raise XrayMedicalSubmittedError if transaction.xray_transmit_date.present?

                    # 3. Check transaction expired
                    raise TransactionExpiredError if transaction.expired_merts?

                    # 4. Check xray_taken_date earlier than transaction date
                    raise XrayDateNewerThanTransactionDateError if xray_taken_date_time < transaction.transaction_date
                when "XrayRetake"
                    raise XrayMedicalSubmittedError             if transaction.completed_at?
                    raise XrayDateNewerThanTransactionDateError if xray_taken_date_time < transaction.created_at
                end

                # 5. Check X-Ray date later than current time (invalid date)
                raise XrayDateLaterThanCurrentTimeError     if xray_taken_date_time > Time.now
            end
        rescue ExpiredTokenError
            result_code = -2
        rescue InvalidTokenError
            result_code = -4
        rescue InvalidTransactionError
            result_code = 0
        rescue XrayMedicalSubmittedError
            result_code = -5
        rescue TransactionExpiredError
            result_code = -6
        rescue XrayDateNewerThanTransactionDateError
            result_code = -7
        rescue XrayDateLaterThanCurrentTimeError
            result_code = -8
        rescue StandardError
            result_code = -99
        end

        @response = { status: result_code }
        full_response = render xml: nil, layout: false, content_type: "text/xml"
        log_api('check_transaction_id_xray_date', params, @response, full_response)
    end

    soap_action :update_upload_status,
        args: {
            transactionId:     :string,
            userCode:          :string,
            accessToken:       :string,
            uploadStatus:      :integer
        },
        return: {
            return:            :integer
        },
        to: :update_upload_status

    def update_upload_status
        result_code = 1

        begin
            xray_code = params[:userCode]

            if is_authorize?(xray_code, params[:accessToken])
                transaction_id  = params[:transactionId]
                upload_status   = params[:uploadStatus].to_i
                transaction     = get_transaction(transaction_id, xray_code)

                # 1. Check valid Transaction
                raise InvalidTransactionError if transaction.nil?

                transaction.update(digital_xray_provider_id: @ws_access_token.digital_xray_provider&.id)


                case transaction.class.to_s
                when "XrayRetake"
                    trans_id = transaction.transaction_id
                when "Transaction"
                    trans_id = transaction.id
                end

                xray_examination                   = XrayExamination.find_or_initialize_by(transaction_id: trans_id, sourceable: transaction)
                xray_examination.xray_ref_number   ||= transaction.code
                xray_examination.update(upload_status: upload_status)
            end
        rescue ExpiredTokenError
            result_code = -2
        rescue InvalidTokenError
            result_code = -4
        rescue InvalidTransactionError
            result_code = 0
        rescue StandardError
            result_code = -99
        end

        @response = { status: result_code }
        full_response = render xml: nil, layout: false, content_type: "text/xml"
        log_api('update_upload_status', params, @response, full_response)
    end

    def get_transaction(transaction_id, xray_code)
        case transaction_id.to_s.first(2)
        when "88", "99"
            XrayRetake.joins(:xray_facility).where(code: transaction_id, xray_facilities: { code: xray_code }).order(:id).last
        else
            Transaction.joins(:xray_facility).where(code: transaction_id, xray_facilities: { code: xray_code }).first
        end
    end

    def is_authorize?(xray_code, token)
        @ws_access_token = WsAccessToken.where(usercode: xray_code).where(token: token).first

        # 1. check valid token
        raise InvalidTokenError if @ws_access_token.nil?

        # 2. check token expired
        raise ExpiredTokenError unless @ws_access_token.expired_at > Time.now

        return true
    end

    def create_token
        token = rand(36**50).to_s(36)
    end

    # set previous user token as expired
    def force_prev_token_expiry(xray_code, provider_code, latest_token_id)
        WsAccessToken.where(usercode: xray_code).where(digital_xray_provider_code: provider_code).where("id < ?", latest_token_id).where("expired_at > ?", Time.now).update({ :expired_at => Time.now })
    end

    def log_api(method, params, response, full_response)
        log_data = {
            name: self.class.name,
            api_type: 'SOAP',
            request_type: 'INCOMING',
            method: method,
            params: params,
            response: response,
            full_response: full_response,
            ip_address: get_ip_address
        }

        api_log = ApiLog.create(log_data)
    end
end

class InvalidTransactionError < StandardError; end

class XrayMedicalSubmittedError < StandardError; end

class TransactionExpiredError < StandardError; end

class XrayDateNewerThanTransactionDateError < StandardError; end

class XrayDateLaterThanCurrentTimeError < StandardError; end

class InvalidTokenError < StandardError; end

class ExpiredTokenError < StandardError; end

class AuthenticationFailedError < StandardError; end

class AccountLockedError < StandardError; end