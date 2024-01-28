class CreateLaboratories < ActiveRecord::Migration[5.2]
  def change
    create_table :laboratories do |t|
      t.string :code, index: true
      t.string :name, index: true
      t.string :company_name
      t.string :business_registration_number
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
      t.string :pic_name
      t.string :pic_phone
      t.string :qualification
      t.string :pathologist_name
      t.string :nsr_number
      t.belongs_to :laboratory_type, optional: true
      t.date :renewal_agreement_date
      t.belongs_to :district_health_office, optional: true
      t.string :classification
      t.string :samm_number
      t.string :license
      t.integer :license_year
      t.boolean :web_service, default: false
      t.string :web_service_passphrase
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
