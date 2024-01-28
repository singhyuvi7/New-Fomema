class AddActiveToPaymentMethods < ActiveRecord::Migration[6.0]
  def change
    add_column :payment_methods, :active, :boolean, default: true
  end
end
