class DropLqccRelatedTable < ActiveRecord::Migration[6.0]
  def up
    # drop_table :anti_seras
    # drop_table :reagents
    # drop_table :control_cells

    drop_table :visit_report_barcodings
    drop_table :visit_report_bfmp_details
    drop_table :visit_report_blood_groupings
    drop_table :visit_report_bools
    drop_table :visit_report_control_cell_conditions
    drop_table :visit_report_control_cells
    drop_table :visit_report_coverages
    drop_table :visit_report_dipstick_reader_details
    drop_table :visit_report_eqa_details
    drop_table :visit_report_gcms_details
    drop_table :visit_report_hbsag_appeal_details
    drop_table :visit_report_hbsag_appeals
    drop_table :visit_report_hbsag_screenings
    drop_table :visit_report_hbsag_verification_details
    drop_table :visit_report_hbsag_verifications
    drop_table :visit_report_hcg_verification_details
    drop_table :visit_report_hcg_verifications
    drop_table :visit_report_hiv_confirmatories
    drop_table :visit_report_hiv_confirmatory_details
    drop_table :visit_report_hiv_screenings
    drop_table :visit_report_hiv_verification_details
    drop_table :visit_report_hiv_verifications
    drop_table :visit_report_interactions
    drop_table :visit_report_iqa_details
    drop_table :visit_report_laboratory_personnels
    drop_table :visit_report_malaria_bfmps
    drop_table :visit_report_malaria_screenings
    drop_table :visit_report_methods
    drop_table :visit_report_pathologists
    drop_table :visit_report_reagent_conditions
    drop_table :visit_report_reagents
    drop_table :visit_report_registrations
    drop_table :visit_report_sop_details
    drop_table :visit_report_specimen_tubes
    drop_table :visit_report_test_worksheet_details
    drop_table :visit_report_tpha_verification_details
    drop_table :visit_report_tphas
    drop_table :visit_report_transportations
    drop_table :visit_report_urine_biochemistries
    drop_table :visit_report_urine_biochemistry_verification_details
    drop_table :visit_report_urine_biochemistry_verifications
    drop_table :visit_report_urine_containers
    drop_table :visit_report_urine_drug_screenings
    drop_table :visit_report_urine_drug_verification_details
    drop_table :visit_report_urine_drug_verifications
    drop_table :visit_report_urine_pregnancy_tests
    drop_table :visit_report_vdrls
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
