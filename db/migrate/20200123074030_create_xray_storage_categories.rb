class CreateXrayStorageCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :xray_storage_categories do |t|
      t.belongs_to :xray_storage, index: true
      t.timestamps
      t.string :category, index: true
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
