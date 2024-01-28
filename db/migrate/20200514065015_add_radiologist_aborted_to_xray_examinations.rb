class AddRadiologistAbortedToXrayExaminations < ActiveRecord::Migration[6.0]
    def change
        add_column :xray_examinations, :radiologist_aborted, :datetime
        add_index :xray_examinations, :radiologist_aborted
        add_column :xray_appeal_retakes, :radiologist_aborted, :datetime
        add_index :xray_appeal_retakes, :radiologist_aborted
    end
end