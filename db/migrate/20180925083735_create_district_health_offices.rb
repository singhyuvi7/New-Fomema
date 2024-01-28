class CreateDistrictHealthOffices < ActiveRecord::Migration[5.2]
  def change
    create_table :district_health_offices do |t|
      t.string :code, index: true
      t.string :name
      t.string :email
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :address4
      t.string :phone
      t.string :fax
      t.string :pic_name
      t.string :pic_phone
      t.belongs_to :state, optional: true
      t.belongs_to :town, optional: true
      t.string :postcode
      t.string :status, index: true
      t.string :approval_status, index: true
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
