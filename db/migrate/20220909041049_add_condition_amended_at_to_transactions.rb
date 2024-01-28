class AddConditionAmendedAtToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :condition_amended_at, :datetime
  end
end
