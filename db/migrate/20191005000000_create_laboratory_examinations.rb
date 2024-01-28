class CreateLaboratoryExaminations < ActiveRecord::Migration[5.2]
  def change
    create_table :laboratory_examinations do |t|
      t.belongs_to :transaction, index: {unique: true}
      t.belongs_to :laboratory, index: true

      t.string :laboratory_test_not_done, default: false
      t.datetime :specimen_taken_date
      t.datetime :specimen_received_date
      t.string :blood_specimen_barcode
      t.string :urine_specimen_barcode
      t.string :blood_group
      t.string :blood_group_rhesus
      t.string :blood_group_other
      t.string :blood_group_rhesus_other
      t.string :elisa
      t.string :hbsag
      t.string :vdrl
      t.string :tpha
      t.string :malaria
      t.string :bfmp
      t.string :opiates
      t.string :cannabis
      t.string :pregnancy
      t.string :pregnancy_serum_beta_hcg
      # t.string :colour                  # Removed based on meeting on 2019-01-07
      # t.string :specific_gravity        # Removed based on meeting on 2019-01-07
      t.string :sugar
      t.decimal :sugar_value
      t.string :albumin
      t.decimal :albumin_value
      # t.string :microscopic_examination # Removed based on meeting on 2019-01-07
      t.text :abnormal_reason
      t.date :laboratory_report_date

      t.string :result, index: true
      t.datetime :transmitted_at, index: true

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
