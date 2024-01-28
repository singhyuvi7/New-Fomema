class AddXrayExaminationsTransactionId < ActiveRecord::Migration[6.0]
  def change
    add_column :xray_examinations, :transaction_id, :bigint, index: true
  end
end
