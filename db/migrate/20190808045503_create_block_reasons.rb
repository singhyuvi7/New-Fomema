class CreateBlockReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :block_reasons do |t|
      t.string :category, index: true
      t.string :code, index: true
      t.string :description
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
