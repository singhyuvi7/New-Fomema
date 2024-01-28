class CreateTransactionCertifyStatics < ActiveRecord::Migration[6.0]
  def change
    create_table :transaction_certify_statics do |t|
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
      t.string :result
      t.string :doc_result
      t.string :final_result
      t.datetime :final_result_date
      t.datetime :arrival_date
      t.datetime :transaction_date
      t.datetime :examination_date
      t.datetime :certify_date
      t.string :tcupi_ind
      t.integer :hiv
      t.integer :tuberculosis
      t.integer :malaria
      t.integer :leprosy
      t.integer :std
      t.integer :hepatitis
      t.integer :cancer
      t.integer :epilepsy
      t.integer :psychiatric_disorder
      t.integer :other
      t.integer :hypertension
      t.integer :heart_diseases
      t.integer :bronchial_asthma
      t.integer :diabetes_mellitus
      t.integer :peptic_ulcer
      t.integer :kidney_diseases
      t.integer :pregnant
      t.integer :opiates
      t.integer :cannabis
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :transaction_certify_statics, :transaction_id
    add_index :transaction_certify_statics, :certify_date
    add_index :transaction_certify_statics, :country_id
    add_index :transaction_certify_statics, :emp_town_id
    add_index :transaction_certify_statics, :emp_state_id
    add_index :transaction_certify_statics, :doc_town_id
    add_index :transaction_certify_statics, :doc_state_id

  end
end
