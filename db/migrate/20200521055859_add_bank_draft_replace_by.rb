class AddBankDraftReplaceBy < ActiveRecord::Migration[6.0]
  def change
    add_column :bank_drafts, :replacement_id, :bigint
    add_index :bank_drafts, :replacement_id
  end
end
