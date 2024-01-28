class AddPcrResultToMedicalAppeals < ActiveRecord::Migration[6.0]
    def change
        add_column :medical_appeals, :pcr_result, :string
        add_index :medical_appeals, :pcr_result
        add_column :medical_appeals, :xray_result, :string
        add_index :medical_appeals, :xray_result
    end
end