class AddCreatedandUpdateBytoXqccLetterFraudCases < ActiveRecord::Migration[6.0]
  def change
    add_column :xqcc_letter_fraud_cases, :created_by, :integer
    add_column :xqcc_letter_fraud_cases, :updated_by, :integer
  end
end
