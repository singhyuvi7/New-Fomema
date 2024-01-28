class AddColumnsToVisitReportLaboratories < ActiveRecord::Migration[6.0]
  def change

    drop_table :visit_report_laboratories
    add_column :visit_reports, :laboratory_type_id, :bigint

    create_table :visit_report_laboratories do |t|
      t.belongs_to :visit_report
      t.belongs_to :laboratory
      t.string :category, index: true, default: 'MAIN'

      t.string :laboratory_name
      t.string :address_1
      t.string :address_2
      t.string :address_3
      t.string :address_4
      t.belongs_to :country
      t.belongs_to :state
      t.belongs_to :town
      t.string :postcode

      t.string :type_of_visit
      t.string :moh_representative
      t.string :open_during_operation_hour
      t.text :open_during_operation_hour_comment

      ## collection
      t.string :adequate_facility
      t.text :adequate_facility_comment
      t.string :adequate_staff
      t.text :adequate_staff_comment

      t.string :adequate_instrument
      t.text :adequate_instrument_items, array: true, default: []
      t.text :adequate_instrument_comment

      t.string :despatch_transportation
      t.string :transport_to_test_lab
      t.text :transport_to_test_lab_comment

      t.string :despatch_bag
      t.text :despatch_bag_comment
      t.string :packaging_to_test_lab
      t.text :packaging_to_test_lab_comment

      t.string :clinic_to_despatch
      t.text :clinic_to_despatch_comment
      t.string :despatch_to
      t.text :despatch_to_comment
      t.string :cc_partial_lab_to_test_lab
      t.text :cc_partial_lab_to_test_lab_comment
      t.string :collection_centre_to_test_lab
      t.string :collection_centre_to_test_lab_name
      t.text :collection_centre_to_test_lab_comment

      t.string :registration_record
      t.text :registration_record_comment
      t.string :rejection_register
      t.text :rejection_register_comment
      t.string :rejection_criteria
      t.text :rejection_criteria_comment

      t.text :others

      t.string :pathologist
      t.text :pathologist_comment
      t.string :pathologist_name
      t.string :pathologist_nsr
      t.string :logbook
      t.text :logbook_comment

      ## specimen storage
      t.string :negative_specimens
      t.text :negative_specimens_comment
      t.string :positive_specimens
      t.text :positive_specimens_comment
      t.string :adequate_space
      t.text :adequate_space_comment
      t.string :appropriate_temperature
      t.text :appropriate_temperature_comment
      t.string :negative_malaria
      t.text :negative_malaria_comment
      t.string :quality_check
      t.text :quality_check_comment

      ## reporting/record-keeping
      t.string :checked_before_transcription, :comment => "Reports been checked before transcription/issue"
      t.text :checked_before_transcription_comment
      t.string :precaution_taken, :comment => "Recaution taken to avoid manupulation of results"
      t.text :precaution_taken_comment
      t.string :records_kept_reg_lab, :comment => "Records of specimens and results are kept at the registered lab for at the last two years"
      t.text :records_kept_reg_lab_comment
      t.string :records_kept_at_least, :comment => "Records of specimens and results are kept at least seven years"
      t.text :records_kept_at_least_comment

      # conclusion
      t.string :satisfactory
      t.text :satisfactory_comment
      t.string :lab_personnel_name
      t.string :lab_personnel_designation
      t.text :lab_personnel_signature

      t.string :fomema_officer_name
      t.text :fomema_officer_signature

      t.string :laboratory_email

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end

  end
end
