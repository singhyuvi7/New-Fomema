class CreateXrayExaminations < ActiveRecord::Migration[5.2]
  def change
    create_table :xray_examinations do |t|
      t.belongs_to :transaction, index: {unique: true}
      t.bigint :xray_examinationable_id
      t.string :xray_examinationable_type

      t.string :xray_examination_not_done, default: "NO"
      t.date  :xray_taken_date
      t.string :xray_ref_number
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
      t.text :impression

      t.string :result, index: true
      t.datetime :transmitted_at, index: true

      # xray image upload status

      t.integer :upload_status

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end

    add_index :xray_examinations, [:xray_examinationable_id, :xray_examinationable_type], name: "index_xray_examinations_xray_examinationable"
  end
end
