class AddNotificationReleasedDateToMohNotifications < ActiveRecord::Migration[6.0]
    def change
        add_column :moh_notifications, :notification_release_date, :datetime
        add_index :moh_notifications, :notification_release_date
    end
end