class CreateXrayStorageItems < ActiveRecord::Migration[5.2]
  def change
    create_table :xray_storage_items do |t|
      t.belongs_to :xray_storage
      t.belongs_to :transaction

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
