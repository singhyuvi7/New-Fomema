class CreateXrayExaminationRetakes < ActiveRecord::Migration[5.2]
  def change
    create_table :xray_examination_retakes do |t|
      t.belongs_to :transaction, index: {unique: true}
      t.belongs_to :xray_retake
      t.belongs_to :xray_facility
      t.belongs_to :radiologist
      t.integer :xray_fp_result
      t.boolean :xray_worker_identity_confirmed, default: false
      t.string :xray_film_type # analogue or digital
      t.string :xray_reporter_type # self reporting or assign to radiologist
      t.bigint :xray_examinationable_id
      t.string :xray_examinationable_type

      t.string :xray_examination_not_done, default: false
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

    add_index :xray_examination_retakes, [:xray_examinationable_id, :xray_examinationable_type], name: "index_xray_examination_retakes_xray_examinationable"

  end
end
