class AddTransactionsBypassFingerprints < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :doctor_bypass_fingerprint_reason_id, :bigint, index: true
    add_column :transactions, :xray_bypass_fingerprint_reason_id, :bigint, index: true
  end
end
