class CreateDigitalXrayMovements < ActiveRecord::Migration[6.0]
  def change
    create_table :digital_xray_movements do |t|
      t.belongs_to :transaction, index: true
      t.references :moveable, polymorphic: true
      t.string :status, index: true
      t.text :description
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
