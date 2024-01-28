class AddRadiologistTimestampsToXrayExaminations < ActiveRecord::Migration[6.0]
    def change
        add_column :xray_examinations, :radiologist_started_at, :datetime
        add_index :xray_examinations, :radiologist_started_at
        add_column :xray_examinations, :radiologist_transmitted_at, :datetime
        add_index :xray_examinations, :radiologist_transmitted_at
    end
end