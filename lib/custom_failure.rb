class CustomFailure < Devise::FailureApp
    def redirect_url
        if request.subdomain == ENV["SUBDOMAIN_NIOS"].downcase
            new_internal_user_session_url(subdomain: ENV["SUBDOMAIN_NIOS"].downcase)
        elsif request.subdomain == ENV["SUBDOMAIN_MERTS"].downcase
            external_sp_login_url(subdomain: ENV["SUBDOMAIN_MERTS"].downcase)
        elsif request.subdomain == ENV["SUBDOMAIN_PORTAL"].downcase
            new_external_user_session_url(subdomain: ENV["SUBDOMAIN_PORTAL"].downcase)
        end

        # if params[:login_user] == "service_provider"
        #     external_sp_login_url(subdomain: ENV["SUBDOMAIN_MERTS"].downcase)
        # else params[:login_user] == "employer"
        #     new_external_user_session_url(subdomain: ENV["SUBDOMAIN_PORTAL"].downcase)
        # end
    end

    def respond
        if http_auth?
            http_auth
        else
            redirect
        end
    end
end