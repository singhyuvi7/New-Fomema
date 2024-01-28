class CreateEmployers < ActiveRecord::Migration[5.2]
  def change
    create_table :employers do |t|
      t.string :code, index: true

      t.belongs_to :employer_type
      t.string :name, index: true
      t.string :business_registration_number, index: true
      t.string :ic_passport_number, index: true

      t.string :address1
      t.string :address2
      t.string :address3
      t.string :address4
      t.belongs_to :country, optional: true
      t.belongs_to :state, optional: true
      t.belongs_to :town, optional: true
      t.string :postcode
      t.string :phone
      t.string :fax
      t.string :email
      t.string :pic_name
      t.string :pic_phone
      t.boolean :personal_data_consent, default: false

      t.string :status, index: true
      t.boolean :bad_payment, index: true
      t.boolean :blacklisted
      t.datetime :blacklisted_at
      # t.bigint :assigned_to
      t.text :comment
      
      t.text :registration_comment
      t.datetime :registration_approved_at
      t.bigint :registration_approval_by, index: true

      t.datetime :activated_at, index: true
      t.string :approval_status, index: true
      t.string :approval_remark

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
