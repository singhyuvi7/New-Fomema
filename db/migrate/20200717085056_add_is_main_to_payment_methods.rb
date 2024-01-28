class AddIsMainToPaymentMethods < ActiveRecord::Migration[6.0]
  def change
    add_column :payment_methods, :is_main, :boolean
  end
end
