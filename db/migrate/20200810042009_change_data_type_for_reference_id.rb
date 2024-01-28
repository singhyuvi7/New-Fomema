class ChangeDataTypeForReferenceId < ActiveRecord::Migration[6.0]
  def change
    change_column :sp_fin_batches, :reference_id, 'bigint USING CAST(reference_id AS bigint)'
  end
end
