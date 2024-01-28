class AddIndexXrayExaminationsTransactionId < ActiveRecord::Migration[6.0]
  def change
    add_index :xray_examinations, :transaction_id
  end
end
