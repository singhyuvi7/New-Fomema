# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# added to remove field_with_errors class in reset password screen when has error
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
    html_tag.html_safe
end