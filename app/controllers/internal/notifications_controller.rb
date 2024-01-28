module Internal
  class NotificationsController < InternalController
    def index
      @notifications = Notification.where(recipientable: current_user).order(created_at: :desc)
    end
  end
end