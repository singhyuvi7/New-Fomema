class AddAuthorToSpTransactionsPayments < ActiveRecord::Migration[6.0]
  def change
    add_column :sp_transactions_payments, :created_by, :bigint, index: true
    add_column :sp_transactions_payments, :updated_by, :bigint, index: true
  end
end
