class AddIndexToServiceProviderGroups < ActiveRecord::Migration[6.0]
  def change
    add_index :service_provider_groups, :code
  end
end
