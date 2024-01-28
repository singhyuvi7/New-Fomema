class CreateXrayStorages < ActiveRecord::Migration[5.2]
  def change
    create_table :xray_storages do |t|
      t.string :code, index: {unique: true}
      t.string :organization_id
      t.string :status
      t.date :disposal_date

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
