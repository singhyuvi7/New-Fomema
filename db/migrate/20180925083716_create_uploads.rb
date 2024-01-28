class CreateUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :uploads do |t|
      t.bigint :uploadable_id
      t.string :uploadable_type
      t.string :category
      t.string :title
      t.string :remark
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end

    add_index :uploads, [:uploadable_id, :uploadable_type]
  end
end
