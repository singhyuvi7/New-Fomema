class AddXrayReviewDetailsCols < ActiveRecord::Migration[6.0]
  def change
    add_column :xray_reviews,:is_id_not_available, :string
    add_column :xray_reviews,:id_incomplete_clinic_name, :string
    add_column :xray_reviews,:id_incomplete_worker_name, :string
    add_column :xray_reviews,:id_incomplete_transaction_id, :string
    add_column :xray_reviews,:id_incomplete_xray_taken_date, :string

    add_column :xray_reviews, :id_not_clear_blur, :string
    add_column :xray_reviews, :id_not_clear_fog, :string
    add_column :xray_reviews, :id_not_clear_dark, :string

    add_column :xray_reviews, :id_not_printed_handwritten, :string
    add_column :xray_reviews, :id_not_printed_sticker, :string

    add_column :xray_reviews, :proc_chemical_defect_weak_chemical, :string
    add_column :xray_reviews, :proc_chemical_defect_discoloration, :string
    add_column :xray_reviews, :proc_chemical_defect_stain, :string
    add_column :xray_reviews, :proc_chemical_defect_water_mark, :string
    add_column :xray_reviews, :proc_chemical_defect_poor_agitation, :string

    add_column :xray_reviews, :proc_marks_of_film_film_guide_mark, :string
    add_column :xray_reviews, :proc_marks_of_film_scratches, :string

    add_column :xray_reviews, :proc_fog_partial_fog, :string
    add_column :xray_reviews, :proc_fog_base_fog, :string

    add_column :xray_reviews, :proc_screen_defect_dirty_screen, :string
    add_column :xray_reviews, :proc_screen_defect_spoilt_screen, :string

    add_column :xray_reviews,:id_wrong_clinic_name, :string
    add_column :xray_reviews,:id_wrong_worker_name, :string
    add_column :xray_reviews,:id_wrong_transaction_id, :string
    add_column :xray_reviews,:id_wrong_xray_taken_date, :string
    add_column :xray_reviews,:pos_apices_cut, :string
    add_column :xray_reviews,:pos_chest_wall_cut, :string
    add_column :xray_reviews,:pos_cpa_cut, :string
    add_column :xray_reviews,:pos_rotation, :string
    add_column :xray_reviews,:pos_angulation, :string
    add_column :xray_reviews,:pos_id_obscure_apex, :string
    add_column :xray_reviews,:pos_marker_obscure_apex, :string
    add_column :xray_reviews,:pos_poor_colimation, :string
    add_column :xray_reviews,:pos_no_colimation, :string
    add_column :xray_reviews,:is_improper_marking, :string

    # old system have, but new one dont have option
    add_column :xray_reviews, :is_artifact, :string
    add_column :xray_reviews, :is_blur, :string
    add_column :xray_reviews, :is_marker_problem, :string
    add_column :xray_reviews, :is_envelope_problem, :string

    # column to replace picked_up_by

    add_column :xray_reviews, :radiographer_id, :bigint, index: true
  end
end
