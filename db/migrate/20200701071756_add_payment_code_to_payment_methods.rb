class AddPaymentCodeToPaymentMethods < ActiveRecord::Migration[6.0]
  def change
    add_column :payment_methods, :payment_code, :string
  end
end
