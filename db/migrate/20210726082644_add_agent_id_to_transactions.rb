class AddAgentIdToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :agent_id, :bigint
  end
end
