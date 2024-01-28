class AddOrganizationsZoneId < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations, :zone_id, :bigint, index: true
    remove_column :organizations, :bank_zone, :string
  end
end
