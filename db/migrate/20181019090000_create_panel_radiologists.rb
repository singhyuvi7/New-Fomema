class CreatePanelRadiologists < ActiveRecord::Migration[5.2]
  def change
    create_table :panel_radiologists do |t|
      t.belongs_to :xray_facility
      t.belongs_to :radiologist
      
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
