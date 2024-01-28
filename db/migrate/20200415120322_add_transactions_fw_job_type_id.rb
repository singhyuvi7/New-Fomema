class AddTransactionsFwJobTypeId < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :fw_job_type_id, :bigint
  end
end
