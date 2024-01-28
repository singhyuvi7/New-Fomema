class AddBadAtToBankDrafts < ActiveRecord::Migration[6.0]
  def change
    add_column :bank_drafts, :bad_at, 	:datetime, index: true
    add_column :bank_drafts, :sync_bad_date, 	:datetime, index: true
  end
end
