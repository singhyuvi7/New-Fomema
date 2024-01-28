class CreateXrayReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :xray_reviews do |t|
      t.belongs_to :transaction, index: {unique: true}
      t.belongs_to :batch

      t.string :case_type
      t.string :is_id_incomplete
      t.json :id_incomplete
      t.string :is_id_wrong
      t.json :id_wrong
      t.string :is_id_not_clear
      t.json :id_not_clear
      t.string :is_id_not_printed
      t.json :id_not_printed
      # processing_procedure
      t.string :is_proc_chemical_defect
      t.json :proc_chemical_defect
      t.string :is_proc_marks_of_film
      t.json :proc_marks_of_film
      t.string :is_proc_fog
      t.json :proc_fog
      t.string :is_proc_screen_defect
      t.json :proc_screen_defect
      # positioning technique
      t.string :is_pos_roi_cut_off
      t.json :pos_roi_cut_off
      t.string :is_pos_roi_not_clearly_visualized
      t.json :pos_roi_not_clearly_visualized
      t.string :is_pos_collimation
      t.json :pos_collimation
      t.string :is_pos_scapular_not_retracted
      t.string :is_pos_poor_inspiratory_effort

      # exposure factors
      t.string :is_exp_overexposure
      t.string :is_exp_underexposure
      # exposure artifacts
      t.string :is_arti_processing_artifacts
      t.string :is_arti_poor_handling_artifacts
      # superimposed
      t.string :is_super_same_thoracic_cage
      t.string :is_super_different_thoracic_cage
      # primary anatomical marker
      t.string :is_pam_wrong_placement
      t.string :is_pam_not_available
      # blue
      t.string :is_blur_movement
      t.string :is_blur_breathing

      t.string :is_improper_report
      t.string :is_no_diagnostic_value

      t.string :taken_by
      t.string :reported_by

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
