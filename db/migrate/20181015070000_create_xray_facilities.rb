class CreateXrayFacilities < ActiveRecord::Migration[5.2]
  def change
    create_table :xray_facilities do |t|
      t.string :code, index: true
      t.string :name, index: true
      t.string :company_name
      t.belongs_to :title, optional: true
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
      t.string :email_payment
      t.string :license_holder_name
      t.string :icno, index: true
      t.string :mobile
      t.string :qualification
      
      t.belongs_to :district_health_office, optional: true
      t.string :xray_license_number
      t.string :xray_file_number
      t.boolean :xray_fac_flag
      t.string :xray_license_tujuan
      t.date :xray_license_expiry_date
      t.boolean :radiologist_operated
      t.string :radiologist_name
      t.integer :apc_year
      t.string :apc_number
      t.string :film_type
      t.date :renewal_agreement_date
      t.integer :fp_device
      t.text :comment

      t.belongs_to :service_provider_group, optional: true, index: true
      t.decimal :male_rate, default: 0
      t.decimal :female_rate, default: 0
      t.belongs_to :bank, optional: true
      t.string :bank_account_number
      t.string :bank_payment_id

      t.string :status, index: true
      t.string :status_reason
      
      t.datetime :registration_approved_at
      t.datetime :activated_at, index: true
      t.string :approval_status, index: true
      t.string :approval_remark
      
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
