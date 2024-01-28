class CreateTransactionSpecialRenewals < ActiveRecord::Migration[6.0]
  def change
    create_table :transaction_special_renewals do |t|
      t.bigint :transaction_id, index: true
      t.string :reason, index: true
      t.timestamps
    end
  end
end
