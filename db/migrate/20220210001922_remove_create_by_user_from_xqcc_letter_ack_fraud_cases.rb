class RemoveCreateByUserFromXqccLetterAckFraudCases < ActiveRecord::Migration[6.0]
  def change
    remove_column :xqcc_letter_ack_fraud_cases, :created_by_user, :integer
  end
end
