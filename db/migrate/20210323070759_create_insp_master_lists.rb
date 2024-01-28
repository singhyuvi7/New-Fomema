class CreateInspMasterLists < ActiveRecord::Migration[6.0]
  def change
    create_table :insp_master_lists do |t|
      t.belongs_to :insp_master_list_batch
      t.date :visit_date, index: true
      t.string :name_of_clinic
      t.string :doctor_code, index: true
      t.string :xray_code, index: true
      t.string :name_of_doctor
      t.string :location
      t.string :state
      t.text :inspected_by
      t.string :serial_no
      t.string :visit_report_id, index: true
      t.string :nc_clinic
      t.string :nc_xray
      t.string :repeated_offence
      t.string :letter_ref
      t.date :letter_date
      t.date :date_of_faxed
      t.date :follow_up_date
      t.string :reminder_letter
      t.date :reply_date
      t.string :present_in_meeting
      t.date :report_date
      t.string :report_by
      t.text :remarks

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
