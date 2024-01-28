class AddGroupIdToSpTransactionsPayments < ActiveRecord::Migration[6.0]
  def change
    add_reference :sp_transactions_payments, :service_provider_group, :null => true
  end
end
