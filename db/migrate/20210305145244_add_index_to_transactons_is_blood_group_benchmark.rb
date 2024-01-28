class AddIndexToTransactonsIsBloodGroupBenchmark < ActiveRecord::Migration[6.0]
  def change
    add_index :transactions, :is_blood_group_benchmark
  end
end
