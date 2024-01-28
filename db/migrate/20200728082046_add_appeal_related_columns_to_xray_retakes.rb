class AddAppealRelatedColumnsToXrayRetakes < ActiveRecord::Migration[6.0]
    def change
        add_column :xray_retakes, :current_appeal_retake, :boolean, default: true
        add_column :xray_retakes, :pcr_id, :integer
        add_column :xray_retakes, :pcr_picked_up_at, :datetime
        add_index :xray_retakes, :current_appeal_retake
        add_index :xray_retakes, :pcr_id
        add_index :xray_retakes, :pcr_picked_up_at
        remove_column :xray_appeal_retakes, :xray_examinationable_id, :integer
        remove_column :xray_appeal_retakes, :xray_examinationable_type, :string
        remove_column :xray_examinations, :xray_examinationable_id, :integer
        remove_column :xray_examinations, :xray_examinationable_type, :string
        rename_column :pcr_pools, :appeal_id, :medical_appeal_id
        rename_column :pcr_reviews, :appeal_id, :medical_appeal_id
        rename_column :digital_xray_movements, :appeal_id, :medical_appeal_id
        add_column :pcr_reviews, :xray_details, :string
        add_index :pcr_reviews, :xray_details
        add_column :pcr_reviews, :xray_details_comment, :text
        add_column :pcr_pools, :xray_retake_id, :bigint
        add_index :pcr_pools, :xray_retake_id
    end
end