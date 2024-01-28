class AddVariousFieldsToXrayExaminationRetakes < ActiveRecord::Migration[6.0]
    def change
        add_column :xray_examination_retakes, :radiologist_saved_at, :datetime
        add_index :xray_examination_retakes, :radiologist_saved_at
        add_column :xray_examination_retakes, :radiologist_started_at, :datetime
        add_index :xray_examination_retakes, :radiologist_started_at
        add_column :xray_examination_retakes, :radiologist_transmitted_at, :datetime
        add_index :xray_examination_retakes, :radiologist_transmitted_at
        add_column :xray_examination_retakes, :radiologist_aborted_at, :datetime
        add_index :xray_examination_retakes, :radiologist_aborted_at
        add_column :xray_examination_retakes, :radiologist_assigned_at, :datetime
        add_index :xray_examination_retakes, :radiologist_assigned_at
    end
end