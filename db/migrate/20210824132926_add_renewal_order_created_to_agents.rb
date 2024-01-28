class AddRenewalOrderCreatedToAgents < ActiveRecord::Migration[6.0]
  def change
    add_column :agents, :renewal_order_created, :boolean
    add_index :agents, :renewal_order_created
  end
end
