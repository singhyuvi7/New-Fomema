class AddMedicalConditionsToTransactionResultUpdate < ActiveRecord::Migration[6.0]
  def change
    add_column :transaction_result_updates, :medical_conditions, :jsonb, default: {}, null: false
    add_index :transaction_result_updates, :medical_conditions, name: "index_tru_on_medical_conditions", using: :gin
  end
end
