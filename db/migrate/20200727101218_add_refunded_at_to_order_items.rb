class AddRefundedAtToOrderItems < ActiveRecord::Migration[6.0]
  def change
    add_column :order_items, :refunded_at, :datetime, index: true
  end
end
