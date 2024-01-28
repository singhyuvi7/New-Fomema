class AddCollectionToBankDrafts < ActiveRecord::Migration[6.0]
  def change
    add_column :bank_drafts, :sync_date, :datetime
    add_column :bank_drafts, :sync_cancel_status, :int
  end
end
