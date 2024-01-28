class XrayWebService
    require "savon"
    require "resolv-replace"

    def initialize(options = {})
        @options                = options
        # Please take note, if we introduce another digital xray provider -> @transaction.digital_xray_provider
        xray_provider           = @options[:source].digital_xray_provider || DigitalXrayProvider.find_by(code: "SHC") # Salinee Health Care.
        raise NotExistXrayProviderError if xray_provider.blank?
        @options[:provider_url] = xray_provider.provider_url
        @client                 = Savon.client(wsdl: @options[:provider_url], follow_redirects: true)
    end

    def delete_study(remark)
        data                    = { transactionID: @options[:code], remark: remark }

        begin
            response            = @client.call(:delete_study, message: data)
        rescue Net::OpenTimeout
            save_error_log("XrayWebService.delete_study")
            return :timeout_error
        end

        result                  = response.body[:delete_study_response][:delete_study_result]
        log_api(__method__.to_s, data, result, response, @options[:params])
        result
    end

    def is_digital_xray_available
        data            = { transactionID: @options[:code]}

        begin
            response    = @client.call(:is_digital_xray_available, message: data)
        rescue Net::OpenTimeout
            save_error_log("XrayWebService.is_digital_xray_available")
            return :timeout_error
        end

        result          = response.body[:is_digital_xray_available_response][:is_digital_xray_available_result]
        log_api(__method__.to_s, data, result, response, @options[:params])
        result
    end

    def view_tab_digital_xray_trans_id
        data                = { transactionID: @options[:code] }

        begin
            response        = @client.call(:view_tab_digital_xray_trans_id, message: data)
        rescue Net::OpenTimeout
            save_error_log("XrayWebService.view_tab_digital_xray_trans_id")
            return :timeout_error
        end

        result              = response.body[:view_tab_digital_xray_trans_id_response][:view_tab_digital_xray_trans_id_result]
        log_api(__method__.to_s, data, result, response, @options[:params])

        if result.present? && result[:tab_study_details].class == Array && result[:tab_study_details].size > 1
            image_url           = result[:tab_study_details].map {|hash| [hash[:study_date], hash[:study_path]] }
            latest_study_date   = result[:tab_study_details].map {|hash| hash[:study_date] }.max
            update_xray_taken_date(latest_study_date)
        elsif result.present?
            image_url           = result[:tab_study_details][:study_path]
            study_date          = result[:tab_study_details][:study_date]
            update_xray_taken_date(study_date)
        end

        image_url
    end

    def log_api(element_name, body, response, full_response, params = nil)
        ApiLog.create(
            name:           self.class.name,
            api_type:       "SOAP",
            request_type:   "OUTGOING",
            method:         element_name.camelize,
            url:            @options[:provider_url],
            params:         params,
            body:           body,
            response:       response,
            full_response:  full_response,
            requested_by:   @options[:user_id]
        )
    end

    def update_xray_taken_date(xray_taken_date)
        source           = @options[:source]
        xray_examination = @options[:exam]

        case source.class.to_s
        when "XrayRetake"
            source_date = source.created_at.to_date
            date_type   = "xray retake date"
        when "Transaction"
            source_date = [source.medical_examination_date, source.transaction_date].compact.min.to_date
            date_type   = source_date == source.transaction_date ? "transaction registration date" : "transaction medical examination date"
        end

        if xray_taken_date.to_date < source_date
            error = "Xray taken date (#{ xray_taken_date.strftime("%d-%m-%Y %H:%M:%S") }) is earlier than #{ date_type } (#{ source_date.strftime("%d-%m-%Y %H:%M:%S") })."
            xray_examination.update(xray_api_error: error)
        else
            xray_examination.update(xray_taken_date: xray_taken_date, digital_xray_available: true)
        end
    end
private
    def save_error_log(error_name)
        error_options   = @options.slice(:code, :user_id, :provider_url, :params)
        error_options.merge!(xray_exam_id: @options[:exam].id) if @options[:exam].present?
        user            = User.find_by(id: @options[:user_id])
        error_options.merge! user.slice(:email, :code, :name, :userable_type).transform_keys {|key| "user_#{ key }" } if user.present?
        send_notice     = ErrorLogger.where(event_type: error_name, notice_sent: true, created_at: 5.minutes.ago..Time.now).count == 0
        ErrorLogger.create(event_type: error_name, user_id: user&.id, user_code: user&.code, user_email: user&.email, user_name: user&.name, parameters: @options[:params], notice_sent: send_notice)
        SystemMailer.xray_server_timeout_report(error_options).deliver_later if send_notice
    end
end

class NotExistXrayProviderError < StandardError; end