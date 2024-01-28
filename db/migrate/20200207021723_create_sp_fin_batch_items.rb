class CreateSpFinBatchItems < ActiveRecord::Migration[5.2]
  def change
    create_table :sp_fin_batch_items do |t|
      t.belongs_to :sp_fin_batch
      t.belongs_to :transaction
      t.decimal :amount

      t.timestamps
    end
  end
end
