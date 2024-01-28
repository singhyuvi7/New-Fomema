class CreatePcrReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :pcr_reviews do |t|
      t.belongs_to :transaction, index: {unique: true}

      t.string :case_type
      t.string :id_quality
      t.text :id_quality_comment
      t.string :processing
      t.text :processing_comment
      t.string :positioning
      t.text :positioning_comment
      t.string :exposure
      t.text :exposure_comment
      t.string :artifacts
      t.text :artifacts_comment
      t.string :inspiratory_effort
      t.text :inspiratory_effort_comment
      t.string :movement_breathing
      t.text :movement_breathing_comment
      t.string :anatomical_marker
      t.text :anatomical_marker_comment
      t.string :other_quality
      t.text :other_quality_comment

      t.string :thoracic_cage
      t.text :thoracic_cage_comment
      t.string :heart_shape_and_size
      t.text :heart_shape_and_size_comment
      t.string :lung_fields
      t.text :lung_fields_comment
      t.string :mediastinum_and_hila
      t.text :mediastinum_and_hila_comment
      t.string :pleura_hemidiaphragms_costopherenic_angles
      t.text :pleura_hemidiaphragms_costopherenic_angles_comment
      t.string :focal_lesion
      t.text :focal_lesion_comment
      t.string :other_findings
      t.text :other_findings_comment

      t.text :comment
      t.string :status, index: true
      t.string :result, index: true
      t.datetime :transmitted_at, index: true
      t.datetime :picked_up_at, index: true

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
      t.bigint :picked_up_by, index: true
    end
  end
end
