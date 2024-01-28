class AddRadiologistAssignedAtToXrayExaminations < ActiveRecord::Migration[6.0]
    def change
        add_column :xray_examinations, :radiologist_assigned_at, :datetime
        add_index :xray_examinations, :radiologist_assigned_at
        add_column :xray_appeal_retakes, :radiologist_assigned_at, :datetime
        add_index :xray_appeal_retakes, :radiologist_assigned_at
    end
end