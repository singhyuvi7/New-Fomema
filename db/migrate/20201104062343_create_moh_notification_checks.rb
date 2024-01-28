class CreateMohNotificationChecks < ActiveRecord::Migration[6.0]
    def change
        create_table :moh_notification_checks do |t|
            t.bigint    :transaction_id
            t.string    :final_result
            t.datetime  :final_result_date
            t.timestamps
        end

        add_index :moh_notification_checks, :transaction_id
        add_index :moh_notification_checks, :final_result
        add_index :moh_notification_checks, :final_result_date
    end
end