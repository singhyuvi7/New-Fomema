# frozen_string_literal: true
module External
    module Users
        class SessionsController < Devise::SessionsController
            layout "external-visitor"
            # before_action :configure_sign_in_params, only: [:create]
            after_action :after_login, :only => :create
            before_action :set_cache_headers, only: [:new]

            def create
                cookies[:login_type]  = params[:external_user][:login_type]
                cookies[:login_user_type]  = params[:external_user][:login_user_type]
                super
            end

            # GET /resource/sign_in
            def new
                redirect_to new_external_user_session_url(subdomain: ENV["SUBDOMAIN_PORTAL"].downcase) and return if site == "MERTS"
                super
            end
            #
            # # POST /resource/sign_in
            def create
                cookies[:login_type]  = params[:external_user][:login_type]
                cookies[:login_user_type]  = params[:external_user][:login_user_type]
                if params[:login_user] == 'employer' && params[:external_user][:login_type] == 'Code'
                    u = User.where("username = ?", params[:external_user][:login].upcase).first
                    redirect_to new_external_user_session_path, error: "Username or password is incorrect" and return if u.blank?

                    if u.encrypted_password.blank?
                        if u.email.blank?
                            redirect_to new_external_email_reset_path and return
                        else
                            u.send_reset_password_instructions
                            redirect_to new_external_user_password_path, notice: "An email has been sent to #{u.obfuscated_email}. Please check your email to confirm your account and reset your password. If the email is not correct, please contact FOMEMA customer service to update your email." and return
                            # redirect_to new_external_user_password_path(username: u.username) and return
                        end
                    end
                end

                super
            end

            #
            # # DELETE /resource/sign_out
            # def destroy
            # end

            # protected

            # If you have extra params to permit, append them to the sanitizer.
            # def configure_sign_in_params
            #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
            # end
            private
            def after_sign_out_path_for(resource_or_scope)
                if ["Doctor", "Laboratory", "Radiologist", "XrayFacility"].include?(params[:user_type])
                    external_sp_login_url(subdomain: ENV["SUBDOMAIN_MERTS"].downcase)
                else
                    new_external_user_session_url(subdomain: ENV["SUBDOMAIN_PORTAL"].downcase)
                end
            end

            def after_login
                user = current_external_user
                return if user.nil?
                flash[:after_login] = true
                flash[:bulletin_id] = Bulletin.filter_date_and_audiences(user.userable_type,user.userable_id).where(:is_pop_up => true).order('bulletins.updated_at DESC').pluck(:id).first
            end

            def set_cache_headers
                response.headers["Cache-Control"] = "no-cache, no-store"
                response.headers["Pragma"] = "no-cache"
                response.headers["Expires"] = "Mon, 01 Jan 1990 00:00:00 GMT"
            end
        end
    end
end
