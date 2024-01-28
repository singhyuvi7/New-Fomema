class DropIssuePlaceZones < ActiveRecord::Migration[6.0]
  def change
    remove_column :bank_drafts, :issue_place_zone_id, :bigint
    drop_table :issue_place_zones
  end
end
