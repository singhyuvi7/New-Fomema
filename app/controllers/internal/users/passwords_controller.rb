module Internal::Users
    class PasswordsController < Devise::PasswordsController
        layout "internal-devise"

        def edit
            super
            current_user = User.with_reset_password_token(params[:reset_password_token])

            if current_user.status.eql?("INACTIVE")
                flash[:error] = "User deactivated"
                redirect_to new_internal_user_password_path and return
            end

            if current_user.blank?
                flash[:not_found] = true
                redirect_to new_internal_user_password_path
            elsif !current_user.reset_password_period_valid?
                flash[:expired] = true
                redirect_to new_internal_user_password_path
            else
                @password_requirements = current_user.password_requirements
            end
        end

        def update
            super do |user|
                redirect_to edit_internal_user_password_path(reset_password_token: params[:internal_user][:reset_password_token]), errors: user.errors.messages[:password] and return if user.errors.messages.present?
            end
        end

        def create
            if params[:internal_user].present? && params[:internal_user][:email].present?
                email   = params[:internal_user][:email]
                user    = User.find_by("LOWER(email) = ? and userable_type = ?", email.downcase,'Organization')
            end

            if user.present?
                params[:internal_user][:email] = user.email
            end

            super
        end
    end
end