class AddExpiryToAgents < ActiveRecord::Migration[6.0]
  def change
    add_column :agents, :expired_at, :datetime
    add_index :agents, :expired_at
  end
end
