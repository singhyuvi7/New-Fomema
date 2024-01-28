# frozen_string_literal: true
module External
  module Users
    class ConfirmationsController < Devise::ConfirmationsController
      layout "external-visitor"
      # GET /resource/confirmation/new
      # def new
      #   super
      # end

      # POST /resource/confirmation
      # def create
      #   super
      # end

      # GET /resource/confirmation?confirmation_token=abcdef
      def show
        super do |resource|
          sign_in(:external_user,resource)
          if resource.userable_type == ["Employer","Agency"]
            resource.update(status: "ACTIVE")
            resource.userable.update(status: "ACTIVE")
          end
        end
      end

      # protected

      # The path used after resending confirmation instructions.
      # def after_resending_confirmation_instructions_path_for(resource_name)
      #   super(resource_name)
      # end

      # The path used after confirmation.
      # def after_confirmation_path_for(resource_name, resource)
      #   super(resource_name, resource)
      # end
      private
      def after_confirmation_path_for(resource_name, resource)
        if resource.userable_type == ["Employer","Agency"]
          if !resource.userable.blank?
            return external_root_path
          end
          new_external_employer_path
        end
        external_root_path
      end
    end
  end
end
