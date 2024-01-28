class External::SpLoginController < ExternalController
    layout "external-visitor"
    skip_before_action :authenticate_external_user!, only: [:login]

    def login
        redirect_to external_sp_login_url(subdomain: ENV["SUBDOMAIN_MERTS"].downcase) and return if site == "PORTAL"
        @user = User.new
    end
end