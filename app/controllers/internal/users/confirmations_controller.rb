module Internal
  module Users
    class ConfirmationsController < Devise::ConfirmationsController
      layout "internal-visitor"

      def show
        super do |resource|
          sign_in(:internal_user, resource)
        end
      end
    private
      def after_confirmation_path_for(resource_name, resource)
        internal_root_path
      end
    end
  end
end