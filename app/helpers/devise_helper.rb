module DeviseHelper

    # override method
    def devise_error_messages!
        ActiveSupport::Deprecation.warn <<-DEPRECATION.strip_heredoc
      [Devise] `DeviseHelper.devise_error_messages!`
      is deprecated and it will be removed in the next major version.
      To customize the errors styles please run `rails g devise:views` and modify the
      `devise/shared/error_messages` partial.
        DEPRECATION

        return "" if resource.errors.empty?

        render "devise/shared/error_messages", resource: resource
    end

    # new method for forgot password page
    def devise_forgot_password_error_messages!

        return "" if resource.errors.empty?

        render "devise/shared/forgot_password_error_messages", resource: resource
    end

end
