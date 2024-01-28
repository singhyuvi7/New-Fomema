class CreateXqccBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :xqcc_batches do |t|
      t.string :code, index: true
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
