class CreateVisitReportLaboratories < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_report_laboratories do |t|
      t.belongs_to :visit_report
      t.belongs_to :laboratory

      t.string :doctor_name
      t.string :type_of_visit
      t.string :moh_representative

      t.string :organization_chart
      t.text :organization_chart_comment
      
      t.string :adequate_chart
      t.text :adequate_chart_comment

      # qualification
      t.integer :qlf_nontech_degree_count, :default => 0
      t.integer :qlf_nontech_diploma_count, :default => 0
      t.integer :qlf_nontech_certificate_count, :default => 0
      t.integer :qlf_tech_degree_count, :default => 0
      t.integer :qlf_tech_diploma_count, :default => 0
      t.integer :qlf_tech_certificate_count, :default => 0
      t.integer :qlf_despatch_degree_count, :default => 0
      t.integer :qlf_despatch_diploma_count, :default => 0
      t.integer :qlf_despatch_certificate_count, :default => 0
      t.integer :qlf_other_degree_count, :default => 0
      t.integer :qlf_other_diploma_count, :default => 0
      t.integer :qlf_other_certificate_count, :default => 0

      # specimen collection
      t.integer :specimen_collection_per_day
      t.string :packaging_despatch_specimen_bag
      t.string :packaging_to_laboraotry
      t.text :packaging_comment
      t.string :traceability_from_clinic
      t.text :traceability_from_clinic_comment
      t.string :traceability_from_despatch
      t.text :traceability_from_despatch_comment
      t.string :traceability_from_laboratory
      t.text :traceability_from_laboratory_comment
      t.string :speciment_centrifucation
      t.text :speciment_centrifucation_comment
      t.string :speciment_rejection
      t.text :speciment_rejection_comment
      t.string :rejection_criteria
      t.text :rejection_criteria_comment

      # specimen storage
      t.string :keep_negative_specimen
      t.text :keep_negative_specimen_comment
      t.string :keep_positive_specimen
      t.text :keep_positive_specimen_comment
      t.string :adequate_space
      t.text :adequate_space_comment
      t.string :appropriate_temperature
      t.text :appropriate_temperature_comment
      t.string :specimen_traceability
      t.text :specimen_traceability_comment
      t.string :specimen_tube_used_acceptable
      t.text :specimen_tube_used_comment
      t.string :urine_container_acceptable
      t.text :urine_container_comment
      t.string :keep_negative_malaria_slide
      t.text :keep_negative_malaria_slide_comment
      t.string :quality_check
      t.text :quality_check_comment

      # laboratory health and service
      t.string :laboratory_handbook
      t.text :laboratory_handbook_comment
      t.string :biologial_waste
      t.text :biologial_waste_comment
      t.string :emergency_eyewash
      t.text :emergency_eyewash_comment

      # reporting / record keeping
      t.string :check_report_before_transmission
      t.text :check_report_before_transmission_comment
      t.string :avoid_result_manipulation_precaution
      t.text :avoid_result_manipulation_precaution_comment
      t.string :result_transmission
      t.text :result_transmission_comment

      # conclusion
      t.string :satisfactory
      t.text :comment
      t.string :name_of_lab_personnel
      t.string :designation

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
