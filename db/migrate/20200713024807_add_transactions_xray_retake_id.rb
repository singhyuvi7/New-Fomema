class AddTransactionsXrayRetakeId < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :xray_retake_id, :bigint, index: true
    remove_column :transactions, :xray_retake_status, :string
    remove_column :transactions, :xray_retake_comment, :text
    remove_column :transactions, :retake_xray_facility_id, :bigint, index: true
  end
end
