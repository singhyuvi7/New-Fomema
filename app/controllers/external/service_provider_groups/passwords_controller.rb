# frozen_string_literal: true
module External
    module ServiceProviderGroups
      class PasswordsController < Devise::PasswordsController
  
        prepend_before_action :check_captcha, only: [:create]
  
        layout "external-visitor"
        # GET /resource/password/new
        # def new
        #   super
        # end
  
        # POST /resource/password
        # def create
        #   super
        # end
  
        # GET /resource/password/edit?reset_password_token=abcdef
        def edit
          super
          current_user = User.with_reset_password_token(params[:reset_password_token])
          @password_requirements = current_user.password_requirements
        end
  
        # PUT /resource/password
        # def update
        #   super
        # end
  
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
  end