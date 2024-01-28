class AddPaidAtToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :paid_at, 	:datetime
    add_index  :orders, :paid_at
  end
end
