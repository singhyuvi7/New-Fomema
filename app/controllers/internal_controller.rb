class InternalController < ApplicationController
    layout "internal"
    before_action :authenticate_internal_user!
    before_action :current_user,          if: :internal_user_signed_in?
    before_action :check_password_expiry, if: :internal_user_signed_in?

    around_action :set_current_user

    def current_user
        current_internal_user
    end

    def set_current_user
        Current.user = current_user
        yield
    ensure
        # to address the thread variable leak issues in Puma/Thin webserver
        Current.user = nil
    end             

    def password_path
        internal_password_path
    end
end