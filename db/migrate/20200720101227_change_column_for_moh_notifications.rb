class ChangeColumnForMohNotifications < ActiveRecord::Migration[6.0]
    def change
        remove_column :moh_notifications, :quarantine_release_date
        add_column :moh_notifications, :quarantine_release_date, :datetime
        add_index :moh_notifications, :quarantine_release_date
    end
end