class PcrReviewsNormalizeClean < ActiveRecord::Migration[6.0]
    def change
        remove_column :pcr_reviews, :id_quality, :string
        remove_column :pcr_reviews, :id_quality_comment, :string
        remove_column :pcr_reviews, :processing, :string
        remove_column :pcr_reviews, :processing_comment, :string
        remove_column :pcr_reviews, :positioning, :string
        remove_column :pcr_reviews, :positioning_comment, :string
        remove_column :pcr_reviews, :exposure, :string
        remove_column :pcr_reviews, :exposure_comment, :string
        remove_column :pcr_reviews, :artifacts, :string
        remove_column :pcr_reviews, :artifacts_comment, :string
        remove_column :pcr_reviews, :inspiratory_effort, :string
        remove_column :pcr_reviews, :inspiratory_effort_comment, :string
        remove_column :pcr_reviews, :movement_breathing, :string
        remove_column :pcr_reviews, :movement_breathing_comment, :string
        remove_column :pcr_reviews, :anatomical_marker, :string
        remove_column :pcr_reviews, :anatomical_marker_comment, :string
        remove_column :pcr_reviews, :other_quality, :string
        remove_column :pcr_reviews, :other_quality_comment, :string
        remove_column :pcr_reviews, :thoracic_cage, :string
        remove_column :pcr_reviews, :thoracic_cage_comment, :string
        remove_column :pcr_reviews, :heart_shape_and_size, :string
        remove_column :pcr_reviews, :heart_shape_and_size_comment, :string
        remove_column :pcr_reviews, :lung_fields, :string
        remove_column :pcr_reviews, :lung_fields_comment, :string
        remove_column :pcr_reviews, :mediastinum_and_hila, :string
        remove_column :pcr_reviews, :mediastinum_and_hila_comment, :string
        remove_column :pcr_reviews, :pleura_hemidiaphragms_costopherenic_angles, :string
        remove_column :pcr_reviews, :pleura_hemidiaphragms_costopherenic_angles_comment, :string
        remove_column :pcr_reviews, :focal_lesion, :string
        remove_column :pcr_reviews, :focal_lesion_comment, :string
        remove_column :pcr_reviews, :other_findings, :string
        remove_column :pcr_reviews, :other_findings_comment, :string
    end
end
