class CreateXrayDispatchItems < ActiveRecord::Migration[5.2]
  def change
    create_table :xray_dispatch_items do |t|
      t.belongs_to :xray_dispatch
      t.belongs_to :transaction
      
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
