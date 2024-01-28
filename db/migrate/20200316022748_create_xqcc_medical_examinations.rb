class CreateXqccMedicalExaminations < ActiveRecord::Migration[6.0]
  def change
    create_table :xqcc_medical_examinations do |t|
      t.belongs_to :transaction, index: true
      t.string :condition_hiv
      t.string :condition_tuberculosis
      t.string :condition_malaria
      t.string :condition_leprosy
      t.string :condition_std
      t.string :condition_hepatitis
      t.string :condition_cancer
      t.string :condition_epilepsy
      t.string :condition_psychiatric_disorder
      t.string :condition_other
      t.string :condition_hypertension
      t.string :condition_heart_diseases
      t.string :condition_bronchial_asthma
      t.string :condition_diabetes_mellitus
      t.string :condition_peptic_ulcer
      t.string :condition_kidney_diseases
      t.string :condition_urine_for_pregnant
      t.string :condition_urine_for_opiates
      t.string :condition_urine_for_cannabis
      t.text :certification_comment
      t.belongs_to :sourceable, polymorphic: true, index: { name: "index_xqcc_examinations_on_xqcc_sourceable" }
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
