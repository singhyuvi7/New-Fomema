class AddBypassDatesToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :doctor_bypass_fingerprint_date, :datetime, index: true
    add_column :transactions, :xray_bypass_fingerprint_date, :datetime, index: true
  end
end
