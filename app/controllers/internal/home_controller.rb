class Internal::HomeController < InternalController
    skip_before_action :authenticate_internal_user!, only: [:show_env, :ip]

    # layout "coreui"
    def dashboard
    end

    def sample
        render template: "internal/coreui-sample"
    end

    def test_sleep
        ret = "#{Rails.env}<br>"
        ret = ret + "#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}<br>sleep for #{params[:sleep]} seconds<br>"
        sleep params[:sleep].to_i
        ret = ret + "#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}<br>"
        render inline: ret
    end

    def show_env
        render inline: Rails.env
    end

    def ip
        render inline: "hi, your IP is (#{request.headers["X-Forwarded-For"] || request.remote_ip})"
    end
end
