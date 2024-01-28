class ChangeDecimalToBeIntegerForDurationPerCycle < ActiveRecord::Migration[6.0]
  def change
    change_column :visit_report_blood_groupings, :duration_per_cycle, :integer
    change_column :visit_report_blood_groupings, :sample_per_cycle, :integer

    change_column :visit_report_malaria_screenings, :duration_per_cycle, :integer
    change_column :visit_report_malaria_screenings, :sample_per_cycle, :integer

    change_column :visit_report_malaria_bfmps, :duration_per_slide, :integer

    change_column :visit_report_hiv_screenings, :duration_per_cycle, :integer
    change_column :visit_report_hiv_screenings, :sample_per_cycle, :integer

    change_column :visit_report_hiv_verifications, :duration_per_cycle, :integer
    change_column :visit_report_hiv_verifications, :sample_per_cycle, :integer

    change_column :visit_report_hiv_confirmatories, :duration_per_cycle, :integer
    change_column :visit_report_hiv_confirmatories, :sample_per_cycle, :integer

    change_column :visit_report_hbsag_screenings, :duration_per_cycle, :integer
    change_column :visit_report_hbsag_screenings, :sample_per_cycle, :integer

    change_column :visit_report_hbsag_verifications, :duration_per_cycle, :integer
    change_column :visit_report_hbsag_verifications, :sample_per_cycle, :integer

    change_column :visit_report_hbsag_appeals, :duration_per_cycle, :integer
    change_column :visit_report_hbsag_appeals, :sample_per_cycle, :integer

    change_column :visit_report_vdrls, :duration_per_cycle, :integer
    change_column :visit_report_vdrls, :sample_per_cycle, :integer

    change_column :visit_report_tphas, :duration_per_cycle, :integer
    change_column :visit_report_tphas, :sample_per_cycle, :integer

    change_column :visit_report_urine_drug_screenings, :opiates_duration_per_cycle, :integer
    change_column :visit_report_urine_drug_screenings, :opiates_sample_per_cycle, :integer
    change_column :visit_report_urine_drug_screenings, :cannabinoids_duration_per_cycle, :integer
    change_column :visit_report_urine_drug_screenings, :cannabinoids_sample_per_cycle, :integer

    change_column :visit_report_urine_drug_verifications, :opiates_duration_per_cycle, :integer
    change_column :visit_report_urine_drug_verifications, :opiates_sample_per_cycle, :integer
    change_column :visit_report_urine_drug_verifications, :cannabinoids_duration_per_cycle, :integer
    change_column :visit_report_urine_drug_verifications, :cannabinoids_sample_per_cycle, :integer

    change_column :visit_report_urine_pregnancy_tests, :duration_per_cycle, :integer
    change_column :visit_report_urine_pregnancy_tests, :sample_per_cycle, :integer
    change_column :visit_report_urine_pregnancy_tests, :hcg_detection_level, :integer
    
    change_column :visit_report_hcg_verifications, :duration_per_cycle, :integer
    change_column :visit_report_hcg_verifications, :sample_per_cycle, :integer

    change_column :visit_report_urine_biochemistries, :duration_per_cycle, :integer
    change_column :visit_report_urine_biochemistries, :sample_per_cycle, :integer

    change_column :visit_report_urine_biochemistry_verifications, :duration_per_cycle, :integer
    change_column :visit_report_urine_biochemistry_verifications, :sample_per_cycle, :integer

  end
end
