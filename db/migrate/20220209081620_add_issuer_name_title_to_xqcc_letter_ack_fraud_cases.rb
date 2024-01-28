class AddIssuerNameTitleToXqccLetterAckFraudCases < ActiveRecord::Migration[6.0]
  def change
    add_column :xqcc_letter_ack_fraud_cases, :issuer_name, :string
    add_column :xqcc_letter_ack_fraud_cases, :issuer_title, :string
    add_column :xqcc_letter_ack_fraud_cases, :explaination_date, :date
    add_index :xqcc_letter_ack_fraud_cases,  :issuer_name
    add_index :xqcc_letter_ack_fraud_cases,  :issuer_title
    add_index :xqcc_letter_ack_fraud_cases,  :explaination_date
  end
end
