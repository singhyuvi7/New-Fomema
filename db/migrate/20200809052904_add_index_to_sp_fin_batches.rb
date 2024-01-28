class AddIndexToSpFinBatches < ActiveRecord::Migration[6.0]
  def change
    add_index :sp_fin_batches, :reference_id
    add_index :sp_fin_batch_items, :reference_id
  end
end
