class AddIndexToSpTransactionsPayments < ActiveRecord::Migration[6.0]
  def change
    add_index :sp_transactions_payments, :pay_at
    add_index :sp_transactions_payments, [:service_providable_id, :service_providable_type], name: :index_sp_trans_payments_on_service_providable
  end
end
