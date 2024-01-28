class CreateBiodataTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :biodata_transactions do |t|
      t.belongs_to :order_item, index: true
      t.belongs_to :transaction, index: true
      t.string :status, index: true
      t.string :afis_id, index: true

      t.timestamps
    end
  end
end
