class ChangeDatetimeNamingConvention < ActiveRecord::Migration[6.0]
    def change
        rename_column :medical_appeals, :xray_selected, :xray_selected_at
        rename_column :xray_examinations, :radiologist_aborted, :radiologist_aborted_at
        rename_column :xray_appeal_retakes, :radiologist_aborted, :radiologist_aborted_at
    end
end
