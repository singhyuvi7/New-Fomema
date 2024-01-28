module Sms
    def send_sms(data)
        method = 'sendSMS'
        ret = true

        url = URI.parse("#{ENV['MESSAGING_HOST']}/api/sendSMS")
        header = {'Content-Type': 'application/json'}

        begin
            http = Net::HTTP::new(url.host, url.port)
            http.use_ssl = true
            request = Net::HTTP::Post.new(url.request_uri, header)
            request.body = data.to_json
            response = http.request(request)
            log_api(method, data, url, response.body, response.to_json)
        rescue Net::ReadTimeout => e
            ret = false
            log_api(method, request_msg, url, e.inspect, e)
        rescue StandardError => e
            ret = false
            log_api(method, request_msg, url, e.inspect, e)
        end

        if response && response.code == '200'
            # success
            # response = JSON.parse(response.body)
            ret = true
        else
            # error in request
            ret = false
        end
        return ret
    end
private
    def log_api(method, params, url, response, full_response)
        log_data = {
            :name => self.class.name,
            :api_type => 'REST_API',
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