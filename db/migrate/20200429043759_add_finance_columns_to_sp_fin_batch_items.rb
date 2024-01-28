class AddFinanceColumnsToSpFinBatchItems < ActiveRecord::Migration[6.0]
  def change
    add_column :sp_fin_batch_items, :reference_id, :string
  end
end
