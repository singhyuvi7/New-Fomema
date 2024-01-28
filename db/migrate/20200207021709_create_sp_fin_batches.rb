class CreateSpFinBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :sp_fin_batches do |t|
      t.belongs_to :fin_batch
      
      t.bigint :batchable_id
      t.string :batchable_type

      # data that fomema need
      t.decimal :total_amount
      t.string :status

      t.timestamps
    end
  end
end
