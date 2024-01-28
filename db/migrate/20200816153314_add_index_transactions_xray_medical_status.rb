class AddIndexTransactionsXrayMedicalStatus < ActiveRecord::Migration[6.0]
  def change
    add_index :transactions, :xray_status
    add_index :transactions, :medical_status
  end
end
