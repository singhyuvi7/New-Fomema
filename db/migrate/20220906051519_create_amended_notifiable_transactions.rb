class CreateAmendedNotifiableTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :amended_notifiable_transactions do |t|
      t.bigint :transaction_id, index: true
      t.bigint :condition_id
      t.bigint :notifiable_id
      t.string :notifiable_type
      t.datetime :email_sent_at
      t.string :email
      t.datetime :sms_sent_at
      t.string :mobile
      t.datetime :notify_pkd_at
      t.datetime :deleted_at
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end

    add_index :amended_notifiable_transactions, [:notifiable_id, :notifiable_type], name: "index_ant_on_notifiable_id_and_notifiable_type"
  end
end