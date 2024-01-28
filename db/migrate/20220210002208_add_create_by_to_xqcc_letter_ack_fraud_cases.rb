class AddCreateByToXqccLetterAckFraudCases < ActiveRecord::Migration[6.0]
  def change
    add_column :xqcc_letter_ack_fraud_cases, :created_by, :integer
  end
end
