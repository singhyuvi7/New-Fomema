class AddIndexToSpFinBatches2 < ActiveRecord::Migration[6.0]
  def change
    add_index :sp_fin_batches, :batchable_type
    add_index :sp_fin_batches, :service_provider_type
  end
end
