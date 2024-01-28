class AddJsonbColumnToTransactionAmendment < ActiveRecord::Migration[6.0]
  def change
  	add_column :transaction_amendments, :medical_conditions, :jsonb, null: false, default: {}
  	add_index  :transaction_amendments, :medical_conditions, using: :gin
  end
end
