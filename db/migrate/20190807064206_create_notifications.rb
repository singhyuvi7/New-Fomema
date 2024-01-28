class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string :notifiable_type
      t.bigint :notifiable_id
      t.string :recipientable_type
      t.bigint :recipientable_id
      t.string :notification_type

      t.timestamps
    end
  end
end
