class AddImageConfirmedToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :worker_image_confirmed, :boolean, default: false
    add_column :transactions, :xray_worker_image_confirmed, :boolean, default: false
  end
end
