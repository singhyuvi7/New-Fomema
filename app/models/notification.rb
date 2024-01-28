class Notification < ApplicationRecord
  belongs_to :recipientable, polymorphic: true
  belongs_to :notifiable, polymorphic: true

  enum notification_type: { reject_notification: 'reject_notification', draft_notification: 'draft_notification' }
end
