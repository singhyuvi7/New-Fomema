class AddOrganizationsStatus < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :status, :string, default: 'ACTIVE', index: true
  end
end
