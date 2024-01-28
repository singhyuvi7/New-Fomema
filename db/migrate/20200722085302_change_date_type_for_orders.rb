class ChangeDateTypeForOrders < ActiveRecord::Migration[6.0]
  def change
    change_column :orders, :date, :datetime
  end
end
