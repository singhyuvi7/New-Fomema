class AddMleFindingToPendingDecisions < ActiveRecord::Migration[6.0]
  def change
    add_column :xray_pending_decisions, :condition_hiv, :string
    add_column :xray_pending_decisions, :condition_tuberculosis, :string
    add_column :xray_pending_decisions, :condition_malaria, :string
    add_column :xray_pending_decisions, :condition_leprosy, :string
    add_column :xray_pending_decisions, :condition_std, :string
    add_column :xray_pending_decisions, :condition_hepatitis, :string
    add_column :xray_pending_decisions, :condition_cancer, :string
    add_column :xray_pending_decisions, :condition_epilepsy, :string
    add_column :xray_pending_decisions, :condition_psychiatric_disorder, :string
    add_column :xray_pending_decisions, :condition_other, :string
    add_column :xray_pending_decisions, :condition_hypertension, :string
    add_column :xray_pending_decisions, :condition_heart_diseases, :string
    add_column :xray_pending_decisions, :condition_bronchial_asthma, :string
    add_column :xray_pending_decisions, :condition_diabetes_mellitus, :string
    add_column :xray_pending_decisions, :condition_peptic_ulcer, :string
    add_column :xray_pending_decisions, :condition_kidney_diseases, :string
    add_column :xray_pending_decisions, :condition_urine_for_pregnant, :string
    add_column :xray_pending_decisions, :condition_urine_for_opiates, :string
    add_column :xray_pending_decisions, :condition_urine_for_cannabis, :string
    add_column :xray_pending_decisions, :certification_comment, :text
  end
end
