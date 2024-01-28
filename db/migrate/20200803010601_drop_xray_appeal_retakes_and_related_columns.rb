class DropXrayAppealRetakesAndRelatedColumns < ActiveRecord::Migration[6.0]
    def change
        drop_table :xray_appeal_retakes
        remove_column :digital_xray_movements, :medical_appeal_id
        remove_column :pcr_pools, :xray_appeal_retake_id
    end
end