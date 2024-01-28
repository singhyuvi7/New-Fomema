class CreateRadiologists < ActiveRecord::Migration[5.2]
  def change
    create_table :radiologists do |t|
      t.string :code, index: true
      t.string :name
      t.string :company_name
      t.belongs_to :title, optional: true
      t.string :icno, index: true
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
      t.string :mobile
      t.string :email
      t.string :qualification
      t.boolean :is_panel_xray_facility
      # if is_panel_xray_facility, should have xray facilities in panel_radiologists
      # t.belongs_to :xray_facility, optional: true
      t.belongs_to :district_health_office, optional: true
      t.boolean :is_pcr, default: false
      t.integer :apc_year
      t.string :apc_number
      t.string :nsr_number
      t.date :renewal_agreement_date
      t.text :comment
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
