# frozen_string_literal: true
module Internal
  module Users
    class SessionsController < Devise::SessionsController
	layout "internal-devise"

	def create
		cookies[:login_type]  = params[:internal_user][:login_type]
		super
	end

	# before_action :configure_sign_in_params, only: [:create]

	# GET /resource/sign_in
	# def new
	#   super
	# end

	# POST /resource/sign_in
	# def create
	#   super
	# end

	# POST /resource/sign_in
	# def create
	#   cnt = User.joins(:group).where("users.username = ? and groups.site = ?", params["internal_user"]["username"], Group::SITE_INTERNAL).count
	#   if cnt <= 0
	#     set_flash_message(:notice, "Invalid username/password")
	#     destroy and return
	#     # redirect_to new_internal_user_session_path and return
	#   end
	#
	#   self.resource = warden.authenticate!(auth_options)
	#   set_flash_message(:notice, :signed_in) if is_navigational_format?
	#   sign_in(resource_name, resource)
	#   if !session[:return_to].blank?
	#     redirect_to session[:return_to]
	#     session[:return_to] = nil
	#   else
	#     respond_with resource, :location => after_sign_in_path_for(resource)
	#   end
	# end

	# POST /resource/sign_in
	# def create
	#   self.resource = warden.authenticate!(auth_options)
	#   if resource.group.site == Group::SITE_INTERNAL
	#     set_flash_message!(:notice, :signed_in)
	#     sign_in(resource_name, resource)
	#     yield resource if block_given?
	#     respond_with resource, location: after_sign_in_path_for(resource)
	#   else
	#     #
	#   end
	# end

	# DELETE /resource/sign_out
	# def destroy
	#   super
	# end

	# protected

	# If you have extra params to permit, append them to the sanitizer.
	# def configure_sign_in_params
	#   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
	# end
	private
	def after_sign_out_path_for(resource_or_scope)
	  new_internal_user_session_path
	end
    end
  end
end