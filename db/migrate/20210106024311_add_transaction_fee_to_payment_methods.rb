class AddTransactionFeeToPaymentMethods < ActiveRecord::Migration[6.0]
  def change
    add_column :payment_methods, :transaction_fee, :decimal, default: 0, comment: 'In Percentage (%)'
  end
end
