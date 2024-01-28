class AddBankDraftsZoneId < ActiveRecord::Migration[6.0]
  def change
    add_column :bank_drafts, :zone_id, :bigint, index: true
  end
end
