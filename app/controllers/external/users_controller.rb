class External::UsersController < ExternalController
    skip_before_action :authenticate_external_user!, only: [:activate]

    def activate
        user = User.find_by(activation_token: params[:activation_token])
        if user.present? 
            if user.confirmed_at.blank? || user.confirmed_at+3.day >= DateTime.now
                if user.userable.status == 'ACTIVE'
                    pw_changed_count = OldPassword.where(password_archivable_type: 'User', password_archivable_id: user.id).count
                    if pw_changed_count > 0
                        render plain: 'Your account is already activated.'
                    else
                        sign_in(:external_user, user)
                        redirect_to external_root_path
                    end
                else
                    user.update(status: 'ACTIVE', 'confirmed_at': DateTime.now)
                    sign_in(:external_user, user)
                    if user.userable && user.userable.status == 'INACTIVE'
                        user.userable.update({
                            status: 'ACTIVE'
                        })
                    end
                    redirect_to external_root_path
                end
            else
                render plain: 'Error. Activation code is expired.'
            end
        else
            render plain: 'Error. Activation code invalid.'
        end
    end
end