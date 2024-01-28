class AddXrayNametoXqccLetterFraudCases < ActiveRecord::Migration[6.0]
  def change
    add_column :xqcc_letter_fraud_cases, :xray_name, :string
  end
end
