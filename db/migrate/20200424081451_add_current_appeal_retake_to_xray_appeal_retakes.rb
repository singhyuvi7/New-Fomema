class AddCurrentAppealRetakeToXrayAppealRetakes < ActiveRecord::Migration[6.0]
    def change
        add_column :xray_appeal_retakes, :current_appeal_retake, :boolean, default: true
        add_index :xray_appeal_retakes, :current_appeal_retake
        add_column :pcr_pools, :xray_appeal_retake_id, :bigint
        add_index :pcr_pools, :xray_appeal_retake_id
    end
end