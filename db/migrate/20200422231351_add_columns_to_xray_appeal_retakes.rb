class AddColumnsToXrayAppealRetakes < ActiveRecord::Migration[6.0]
    def change
        add_column :xray_appeal_retakes, :xray_worker_identity_confirmed, :boolean, default: false
        add_column :xray_appeal_retakes, :xray_reporter_type, :string
        add_column :xray_appeal_retakes, :radiologist_id, :integer
        add_column :xray_appeal_retakes, :xray_examination_not_done, :string, default: false
        add_column :xray_appeal_retakes, :thoracic_cage, :string
        add_column :xray_appeal_retakes, :thoracic_cage_comment, :text
        add_column :xray_appeal_retakes, :heart_shape_and_size, :string
        add_column :xray_appeal_retakes, :heart_shape_and_size_comment, :text
        add_column :xray_appeal_retakes, :lung_fields, :string
        add_column :xray_appeal_retakes, :lung_fields_comment, :text
        add_column :xray_appeal_retakes, :mediastinum_and_hila, :string
        add_column :xray_appeal_retakes, :mediastinum_and_hila_comment, :text
        add_column :xray_appeal_retakes, :pleura_hemidiaphragms_costopherenic_angles, :string
        add_column :xray_appeal_retakes, :pleura_hemidiaphragms_costopherenic_angles_comment, :text
        add_column :xray_appeal_retakes, :focal_lesion, :string
        add_column :xray_appeal_retakes, :focal_lesion_comment, :text
        add_column :xray_appeal_retakes, :other_findings, :string
        add_column :xray_appeal_retakes, :other_findings_comment, :text
        add_column :xray_appeal_retakes, :impression, :text
        add_column :xray_appeal_retakes, :upload_status, :integer
        add_column :xray_appeal_retakes, :radiologist_saved_at, :datetime
        add_column :xray_appeal_retakes, :radiologist_started_at, :datetime
        add_column :xray_appeal_retakes, :radiologist_transmitted_at, :datetime
        add_index :xray_appeal_retakes, :radiologist_saved_at
        add_index :xray_appeal_retakes, :radiologist_started_at
        add_index :xray_appeal_retakes, :radiologist_transmitted_at
        add_index :xray_appeal_retakes, :xray_worker_identity_confirmed
        add_index :xray_appeal_retakes, :radiologist_id
        add_index :xray_appeal_retakes, :xray_reporter_type
    end
end