class CreateTransactionStatics < ActiveRecord::Migration[6.0]
    def change
        create_table :transaction_statics do |t|
            t.bigint :transaction_id
            t.string :code
            t.string :worker_code
            t.string :worker_name
            t.string :passport_number
            t.integer :country_id
            t.string :emp_code
            t.string :emp_name
            t.string :emp_address1
            t.string :emp_address2
            t.string :emp_address3
            t.string :emp_address4
            t.string :emp_postcode
            t.integer :emp_town_id
            t.integer :emp_state_id
            t.string :doc_code
            t.string :doc_name
            t.string :clinic_name
            t.string :doc_phone
            t.string :doc_address1
            t.string :doc_address2
            t.string :doc_address3
            t.string :doc_address4
            t.string :doc_postcode
            t.integer :doc_town_id
            t.integer :doc_state_id
            t.string :xray_code
            t.string :xray_name
            t.string :lab_code
            t.string :lab_name
            t.string :job_type
            t.string :gender
            t.string :dob
            t.string :arrival_date
            t.string :transaction_date
            t.string :examination_date
            t.string :certify_date
            t.string :final_result
            t.string :tcupi_ind
            t.integer :condition_hiv
            t.integer :condition_tuberculosis
            t.integer :condition_malaria
            t.integer :condition_leprosy
            t.integer :condition_std
            t.integer :condition_hepatitis
            t.integer :condition_cancer
            t.integer :condition_epilepsy
            t.integer :condition_psychiatric_disorder
            t.integer :condition_other
            t.integer :condition_hypertension
            t.integer :condition_heart_diseases
            t.integer :condition_bronchial_asthma
            t.integer :condition_diabetes_mellitus
            t.integer :condition_peptic_ulcer
            t.integer :condition_kidney_diseases
            t.integer :condition_urine_for_pregnant
            t.integer :condition_urine_for_opiates
            t.integer :condition_urine_for_cannabis
            t.timestamps
        end

        add_index :transaction_statics, :transaction_id
        add_index :transaction_statics, :certify_date
        add_index :transaction_statics, :country_id
        add_index :transaction_statics, :emp_town_id
        add_index :transaction_statics, :emp_state_id
        add_index :transaction_statics, :doc_town_id
        add_index :transaction_statics, :doc_state_id
    end
end