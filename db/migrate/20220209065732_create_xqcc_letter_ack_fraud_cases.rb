class CreateXqccLetterAckFraudCases < ActiveRecord::Migration[6.0]
  def change
    create_table :xqcc_letter_ack_fraud_cases do |t|
      t.string :transaction_code
      t.string :xray_ref_no
      t.string :employer_ref_no
      t.string :xray_code
      t.string :doctor_code
      t.string :employer_code
      t.string :worker_code
      t.string :worker_name
      t.string :worker_passport
      t.text   :xray_address
      t.text   :doctor_address
      t.text   :employer_address
      t.date    :xray_date
      t.date    :audit_date
      t.string  :employer_name
      t.string  :xray_name
      t.integer :created_by_user
      t.integer :updated_by
      t.timestamps
  end

  add_index :xqcc_letter_ack_fraud_cases, :transaction_code
  add_index :xqcc_letter_ack_fraud_cases, :xray_ref_no
  add_index :xqcc_letter_ack_fraud_cases, :employer_ref_no
  add_index :xqcc_letter_ack_fraud_cases, :xray_code
  add_index :xqcc_letter_ack_fraud_cases, :doctor_code
  add_index :xqcc_letter_ack_fraud_cases, :employer_code
  add_index :xqcc_letter_ack_fraud_cases, :worker_code
  add_index :xqcc_letter_ack_fraud_cases, :worker_name
  add_index :xqcc_letter_ack_fraud_cases, :worker_passport
  add_index :xqcc_letter_ack_fraud_cases, :xray_date
  add_index :xqcc_letter_ack_fraud_cases, :audit_date
  add_index :xqcc_letter_ack_fraud_cases, :employer_name

  end
end