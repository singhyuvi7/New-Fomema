class CreateDoctors < ActiveRecord::Migration[5.2]
  def change
    create_table :doctors do |t|
      t.string :code, index: true
      t.string :name, index: true
      t.string :company_name
      t.belongs_to :title, optional: true
      t.string :clinic_name, index: true
      t.string :icno, index: true
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :address4
      t.belongs_to :country, optional: true, index: true
      t.belongs_to :state, optional: true, index: true
      t.belongs_to :town, optional: true, index: true
      t.string :postcode
      t.string :phone
      t.string :fax
      t.string :mobile
      t.string :email
      t.string :email_payment
      t.string :qualification
      t.integer :apc_year
      t.string :apc_number
      t.date :renewal_agreement_date
      t.belongs_to :district_health_office, optional: true, index: true
      t.boolean :has_xray
      # t.string :xray_code
      t.integer :fp_device
      t.integer :quota, default: 0, index: true
      t.integer :quota_used, default: 0, index: true
      t.integer :quota_modifier, default: 0, index: true
      t.integer :solo_clinic
      t.integer :group_clinic
      # t.belongs_to :clinic, optional: true, index: true
      t.belongs_to :xray_facility, optional: true, index: true
      t.belongs_to :laboratory, optional: true, index: true
      t.text :comment
      t.json :pairing_options

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
