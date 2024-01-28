# frozen_string_literal: true
module External::Users
    class PasswordsController < Devise::PasswordsController

        prepend_before_action :check_captcha, only: [:create]

        layout "external-visitor"
        # GET /resource/password/new
        def new
            if params[:username]
                @user = User.find_by(username: params[:username])
            end
            super
        end

        # POST /resource/password
        # def create
        #   super
        # end

        def create
            # render inline: "do nothing~" and return
            if params[:external_user].present?
                params_code     = params[:external_user][:code]
                params_email    = params[:external_user][:email]

                if params_code.present? || params_email.present?
                    if params_code.present?
                        user    = User.find_by_code(params_code)
                    elsif params_email.present?
                        user    = User.find_by_email(params_email)
                    end
                    
                    if params[:username].present?
                        user = User.find_by(username: params[:username])
                        if user.email.blank?
                            flash[:error] = "Email is not registered, please contact FOMEMA branch."
                            redirect_to new_external_user_password_path and return
                        end
                        user.send_reset_password_instructions
                        redirect_to new_external_user_password_path, notice: "Please check email for reset instruction" and return
                    end
                end
            end

            if user.present?
                if user.email.present?
                    params[:external_user][:email] = user.email
                else
                    flash[:error] = "Email not found, please contact FOMEMA branch."
                    redirect_to new_external_user_password_path and return    
                end
            else
                type = params_code.present? ? 'Code' : 'Email'

                flash[:error] = "#{type} not found, please contact FOMEMA branch."
                redirect_to new_external_user_password_path and return
            end
            
            self.resource = user
            resource.send_reset_password_instructions
            yield resource if block_given?

            if successfully_sent?(resource)
                set_flash_message! :notice, :send_instructions_with_email, resource_email: resource.obfuscated_email
                respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
            else
              respond_with(resource)
            end
        end

        # GET /resource/password/edit?reset_password_token=abcdef
        def edit
            super
            current_user = User.with_reset_password_token(params[:reset_password_token])

            if current_user.nil?
                flash[:error] = "Please use the current reset password link."
                redirect_to new_external_user_password_path and return
            elsif current_user.status.eql?("INACTIVE")
                flash[:error] = "User deactivated"
                redirect_to new_external_user_password_path and return
            end

            if current_user.blank?
                flash[:not_found] = true
                redirect_to new_external_user_password_path
            elsif !current_user.reset_password_period_valid?
                flash[:expired] = true
                redirect_to new_external_user_password_path
            else
                @password_requirements = current_user.password_requirements
            end
        end

        # PUT /resource/password
        def update
            super do |user|
                redirect_to edit_external_user_password_path(reset_password_token: params[:external_user][:reset_password_token]), errors: user.errors.messages[:password] and return if user.errors.messages.present?
            end
        end

        # protected

        # def after_resetting_password_path_for(resource)
        #   super(resource)
        # end

        # The path used after sending reset password instructions
        def after_sending_reset_password_instructions_path_for(resource_name)
            super(resource_name)

            # redirect to same page
            new_internal_user_password_path
        end
        # def after_sending_reset_password_instructions_path_for(resource_name)
        #   super(resource_name)
        # end

        private

        def check_captcha
            unless verify_recaptcha
                self.resource = resource_class.new
                respond_with_navigational(resource) { render :new }
            end
        end

    end
end