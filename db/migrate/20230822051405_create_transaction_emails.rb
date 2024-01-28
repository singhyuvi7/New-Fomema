class CreateTransactionEmails < ActiveRecord::Migration[6.0]
  def change
    create_table :transaction_emails do |t|
      t.bigint :transaction_id, index: true
      t.string :send_type, index: true
      t.string :email
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
