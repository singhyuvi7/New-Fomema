class AddPaymentMethodsCategory < ActiveRecord::Migration[6.0]
  def change
    add_column :payment_methods, :category, :string
    add_index :payment_methods, :category
  end
end
