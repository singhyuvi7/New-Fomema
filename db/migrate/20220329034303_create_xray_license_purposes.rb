class CreateXrayLicensePurposes < ActiveRecord::Migration[6.0]
  def change
    create_table :xray_license_purposes do |t|
      t.string :name
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
