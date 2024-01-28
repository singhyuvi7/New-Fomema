class AddUseAtToPaymentMethods < ActiveRecord::Migration[6.0]
  def change
    add_column :payment_methods, :use_at, :string, default: 'INTERNAL'
  end
end
