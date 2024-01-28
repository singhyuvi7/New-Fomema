class CreateTransactionDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :transaction_details do |t|
      t.belongs_to :transaction, index: true

      t.string :doc_code, index: true
      t.string :doc_name, index: true
      t.string :doc_company_name
      t.string :doc_clinic_name, index: true
      t.string :doc_address1
      t.string :doc_address2 
      t.string :doc_address3 
      t.string :doc_address4 
      t.bigint :doc_country_id, index: true
      t.bigint :doc_state_id, index: true
      t.bigint :doc_town_id, index: true
      t.string :doc_postcode, index: true
      t.string :doc_service_provider_group_id, optional: true, index: true
      t.decimal :doc_male_rate, index: true
      t.decimal :doc_female_rate, index: true

      t.string :lab_code, index: true
      t.string :lab_name, index: true
      t.string :lab_company_name
      t.string :lab_pic_name, index: true
      t.string :lab_pathologist_name, index: true
      t.string :lab_address1 
      t.string :lab_address2
      t.string :lab_address3 
      t.string :lab_address4 
      t.bigint :lab_country_id, index: true
      t.bigint :lab_state_id, index: true
      t.bigint :lab_town_id, index: true
      t.string :lab_postcode, index: true
      t.string :lab_service_provider_group_id, optional: true, index: true
      t.decimal :lab_male_rate, index: true
      t.decimal :lab_female_rate, index: true

      t.string :xray_code, index: true
      t.string :xray_name, index: true
      t.string :xray_company_name
      t.string :xray_license_holder_name, index: true
      t.string :xray_address1 
      t.string :xray_address2 
      t.string :xray_address3 
      t.string :xray_address4 
      t.bigint :xray_country_id, index: true
      t.bigint :xray_state_id, index: true
      t.bigint :xray_town_id, index: true
      t.string :xray_postcode, index: true
      t.string :xray_service_provider_group_id, optional: true, index: true
      t.decimal :xray_male_rate, index: true
      t.decimal :xray_female_rate, index: true

      t.string :rad_code, index: true
      t.string :rad_name, index: true
      t.string :rad_xray_facility_name, index: true
      t.string :rad_address1 
      t.string :rad_address2 
      t.string :rad_address3 
      t.string :rad_address4 
      t.bigint :rad_country_id, index: true
      t.bigint :rad_state_id, index: true
      t.bigint :rad_town_id, index: true
      t.string :rad_postcode, index: true

      t.timestamps
    end
  end
end
