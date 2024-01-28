class CreateAgents < ActiveRecord::Migration[6.0]
  def change
    create_table :agents do |t|
      t.string :code, index: true
      t.string :name, index: true
      t.string :business_registration_number, index: true
      t.belongs_to :agency_license_category, optional: true
      t.string :license_number
      t.datetime :license_expired_at
      t.string :director_name
      t.string :director_ic_number
      t.string :pic_name     
      t.string :pic_ic_number
      t.string :pic_phone
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :address4
      t.belongs_to :country, optional: true
      t.belongs_to :state, optional: true
      t.belongs_to :town, optional: true
      t.string :postcode
      t.string :phone
      t.string :email
      t.boolean :personal_data_consent, default: false
      t.string :status, index: true
      t.text :registration_comment
      t.datetime :registration_approved_at
      t.bigint :registration_approval_by, index: true
      t.datetime :activated_at, index: true
      t.string :approval_status, index: true
      t.string :approval_remark
      t.bigint :organization_id
      t.string :bank_payment_id    
      t.belongs_to :bank
      t.string :bank_account_number
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
