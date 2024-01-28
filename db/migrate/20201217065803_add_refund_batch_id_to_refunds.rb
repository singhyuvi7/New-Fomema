class AddRefundBatchIdToRefunds < ActiveRecord::Migration[6.0]
  def change
    add_column :refunds, :refund_batch_id, :bigint, null: true, index: true
  end
end
