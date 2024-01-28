class SoapXrayClient
    require 'savon'

    def initialize

        @xray_url = ENV["SOAP_XRAY_WEBSERVICE_URL"]

        @client = Savon.client(wsdl: @xray_url)
    end

    # list of available operations in wsdl
    def operations
        operations = @client.operations
    end

    def get_access_token(xray_code, secure_code, passphrase)

        data = {
            userCode: xray_code,
            secureCode: secure_code,
            passphrase: passphrase,
        }

        response = @client.call(
            :get_access_token,
            message: data,
            )

        result = response.body[:get_access_token_response]

        log_api(__method__.to_s, data, result, response)

        result
    end

    def check_transaction_id_xray_date(transaction_id, xray_code, token, xray_taken_date)

        data = {
            transactionId: transaction_id,
            userCode: xray_code,
            accessToken: token,
            xrayTakenDate: xray_taken_date,
        }

        response = @client.call(
            :check_transaction_id_xray_date,
            message: data,
            )

        result = response.body[:check_transaction_id_xray_date_response]

        log_api(__method__.to_s, data, result, response)

        result
    end

    def update_upload_status(transaction_id, xray_code, token, upload_status)

        data = {
            transactionId: transaction_id,
            userCode: xray_code,
            accessToken: token,
            uploadStatus: upload_status,
        }

        response = @client.call(
            :update_upload_status,
            message: data,
            )

        result = response.body[:update_upload_status_response]

        log_api(__method__.to_s, data, result, response)

        result
    end

    def log_api(element_name, body, response, full_response)

        params = { :element_name => element_name.camelize }

        log_data = {
            :name => self.class.name,
            :api_type => 'SOAP',
            :request_type => 'OUTGOING',
            :url => @xray_url,
            :params => params,
            :body => body,
            :response => response,
            :full_response => full_response,
            :requested_by => @user_id
        }

        api_log = ApiLog.create(log_data)
    end

end