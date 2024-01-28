class CreateClinics < ActiveRecord::Migration[5.2]
  def change
    create_table :clinics do |t|
      t.string :code, index: true
      t.string :name, index: true
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :address4
      t.belongs_to :country, optional: true
      t.belongs_to :state, optional: true
      t.belongs_to :town, optional: true
      t.belongs_to :xray_facility, optional: true
      t.string :postcode
      t.string :phone
      t.string :fax
      t.string :email
      t.string :pic_name
      t.string :pic_phone
      t.text :comment
      
      t.datetime :registration_approved_at
      t.datetime :activated_at, index: true
      t.string :approval_status, index: true
      t.string :approval_remark
      
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end

    # add_reference :doctors, :clinic, index: true, optional: true
  end
end
