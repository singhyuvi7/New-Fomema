class AddIndexToTransactionsAgentId < ActiveRecord::Migration[6.0]
  def change
    add_index :transactions, :agent_id
  end
end
