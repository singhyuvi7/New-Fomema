class AddTimestampsToMedicalAppeals < ActiveRecord::Migration[6.0]
    def change
        add_column :medical_appeals, :doctor_done_at, :datetime
        add_index :medical_appeals, :doctor_done_at
        add_column :medical_appeals, :laboratory_done_at, :datetime
        add_index :medical_appeals, :laboratory_done_at
        add_column :medical_appeals, :xray_facility_done_at, :datetime
        add_index :medical_appeals, :xray_facility_done_at
        add_column :medical_appeals, :radiologist_done_at, :datetime
        add_index :medical_appeals, :radiologist_done_at
    end
end