class AddIndexBypassDateToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_index :transactions, :doctor_bypass_fingerprint_reason_id
    add_index :transactions, :xray_bypass_fingerprint_reason_id
    add_index :transactions, :doctor_bypass_fingerprint_date
    add_index :transactions, :xray_bypass_fingerprint_date
  end
end
