class AddFingerprintDateToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :doctor_fp_result_date, 	:datetime
    add_column :transactions, :xray_fp_result_date, 	:datetime
  end
end
