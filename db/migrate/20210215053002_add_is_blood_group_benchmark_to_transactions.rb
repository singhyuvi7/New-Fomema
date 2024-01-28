class AddIsBloodGroupBenchmarkToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :is_blood_group_benchmark, :boolean
  end
end
