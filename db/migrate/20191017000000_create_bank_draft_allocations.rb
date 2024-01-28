class CreateBankDraftAllocations < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_draft_allocations do |t|
      t.belongs_to :bank_draft
      t.belongs_to :order
      t.decimal :amount
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
