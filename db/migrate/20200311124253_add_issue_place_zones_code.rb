class AddIssuePlaceZonesCode < ActiveRecord::Migration[6.0]
  def change
    add_column :issue_place_zones, :code, :string
    add_index :issue_place_zones, :code
  end
end
