class AddIssuerNameTitleToXqccLetterFraudCases < ActiveRecord::Migration[6.0]
  def change
    add_column :xqcc_letter_fraud_cases, :issuer_name, :string
    add_column :xqcc_letter_fraud_cases, :issuer_title,:string
    add_index  :xqcc_letter_fraud_cases, :issuer_name
    add_index  :xqcc_letter_fraud_cases, :issuer_title
  end
end
