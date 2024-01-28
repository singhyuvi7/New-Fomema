class CreateMohNotifications < ActiveRecord::Migration[6.0]
    def change
        create_table :moh_notifications do |t|
            t.bigint    :transaction_id
            t.string    :disease
            t.string    :release_flag
            t.string    :quarantined
            t.string    :quarantine_release_date
            t.bigint    :created_by
            t.bigint    :updated_by
            t.timestamps
        end

        add_index :moh_notifications, :transaction_id
        add_index :moh_notifications, :disease
        add_index :moh_notifications, :release_flag
        add_index :moh_notifications, :quarantined
        add_index :moh_notifications, :quarantine_release_date
        add_index :moh_notifications, :created_by
        add_index :moh_notifications, :updated_by
    end
end