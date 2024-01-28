class AddFwTransactionIdToFingerprintResponse < ActiveRecord::Migration[6.0]
  def change
    add_column :fingerprint_responses, :fw_transaction_id, :bigint, index: true
  end
end
