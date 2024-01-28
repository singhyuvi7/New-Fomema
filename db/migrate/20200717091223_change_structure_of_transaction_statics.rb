class ChangeStructureOfTransactionStatics < ActiveRecord::Migration[6.0]
    def change
        rename_column :transaction_statics, :condition_hiv, :hiv
        rename_column :transaction_statics, :condition_tuberculosis, :tuberculosis
        rename_column :transaction_statics, :condition_malaria, :malaria
        rename_column :transaction_statics, :condition_leprosy, :leprosy
        rename_column :transaction_statics, :condition_std, :std
        rename_column :transaction_statics, :condition_hepatitis, :hepatitis
        rename_column :transaction_statics, :condition_cancer, :cancer
        rename_column :transaction_statics, :condition_epilepsy, :epilepsy
        rename_column :transaction_statics, :condition_psychiatric_disorder, :psychiatric_disorder
        rename_column :transaction_statics, :condition_other, :other
        rename_column :transaction_statics, :condition_hypertension, :hypertension
        rename_column :transaction_statics, :condition_heart_diseases, :heart_diseases
        rename_column :transaction_statics, :condition_bronchial_asthma, :bronchial_asthma
        rename_column :transaction_statics, :condition_diabetes_mellitus, :diabetes_mellitus
        rename_column :transaction_statics, :condition_peptic_ulcer, :peptic_ulcer
        rename_column :transaction_statics, :condition_kidney_diseases, :kidney_diseases
        rename_column :transaction_statics, :condition_urine_for_pregnant, :pregnant
        rename_column :transaction_statics, :condition_urine_for_opiates, :opiates
        rename_column :transaction_statics, :condition_urine_for_cannabis, :cannabis
        remove_column :transaction_statics, :arrival_date
        remove_column :transaction_statics, :transaction_date
        remove_column :transaction_statics, :examination_date
        remove_column :transaction_statics, :certify_date
        add_column :transaction_statics, :arrival_date, :datetime
        add_column :transaction_statics, :transaction_date, :datetime
        add_column :transaction_statics, :examination_date, :datetime
        add_column :transaction_statics, :certify_date, :datetime
        add_index :transaction_statics, :certify_date
    end
end