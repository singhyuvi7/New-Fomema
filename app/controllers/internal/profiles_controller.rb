class Internal::ProfilesController < InternalController

  before_action :set_current_user_profile, :set_password_requirements #, only: []

  skip_before_action :check_password_expiry, only: [:password, :password_update]

  def profile
  end

  def profile_update
    @employer = @user.userable
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to internal_profile_url, notice: 'Profile was successfully updated.' }
        # format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :profile }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def password
  end

  def password_update
    respond_to do |format|
      if @user.update(password_params)
        sign_in(:internal_user, @user, bypass: true)
        format.html { redirect_to internal_root_url, notice: 'Password was successfully updated.' }
        # format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :password }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_current_user_profile
    @user = current_user
  end

  def set_password_requirements
    @password_requirements = current_user.password_requirements
  end

  def user_params
    params.require(:user).permit(:title_id)
  end

  def employer_params
    params.require(:employer).permit(:name, :address1, :address2, :address3, :address4, :town_id, :phone, :fax, :pic_name, :pic_phone)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
