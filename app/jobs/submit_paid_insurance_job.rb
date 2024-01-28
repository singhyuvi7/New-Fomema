class SubmitPaidInsuranceJob < ApplicationJob
    queue_as :default

    def perform(order: nil, response_url: nil, backend_url: nil)

        provider_code = order.insurance_purchases.first&.insurance_service_provider&.code

        if order.organization&.code == 'PT' && order.customerable_type =='Employer'
            url = InsuranceService.api_3_url(provider_code: provider_code)
        else
            url = InsuranceService.api_3_url_nios(provider_code: provider_code)
        end

        uri = URI.parse(url)

        submit_data = InsuranceService.paid_premium_submit_data(order: order, response_url: response_url, backend_url: backend_url)
        param = InsuranceService.encrypt(submit_data.to_json, provider_code)
        body = {
            "param" => param
        }

        log_data = {
            name: "Insurance",
            request_type: "OUTGOING",
            method: "submit_paid_premium",
            url: url,
            params: submit_data,
            body: body
        }
        api_log = ApiLog.create(log_data)

        net = Net::HTTP.new(uri.host, uri.port);
        # net.read_timeout = 30
        if uri.scheme == 'https'
            net.use_ssl = true
            net.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end

        request = Net::HTTP::Post.new(uri)
        request.set_form(body)

        response = net.request(request)
        api_log.update({
            response: response,
            full_response: response.body
        })
    end
end
