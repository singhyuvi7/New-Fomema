class AddOrdersOrganizationId < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :organization_id, :bigint, index: true
  end
end
