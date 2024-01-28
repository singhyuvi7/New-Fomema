class ChangeAgentsToAgencies < ActiveRecord::Migration[6.0]
  def change
    rename_table :agents, :agencies
    rename_column :transactions, :agent_id, :agency_id
  end
end
