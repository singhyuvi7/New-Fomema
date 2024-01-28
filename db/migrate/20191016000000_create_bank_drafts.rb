class CreateBankDrafts < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_drafts do |t|
      t.string :number, index: true
      t.bigint :payerable_id
      t.string :payerable_type
      t.belongs_to :bank
      t.date  :issue_date
      t.string :issue_place
      t.belongs_to :issue_place_zone
      t.decimal :amount, default: 0
      t.decimal :amount_allocated, default: 0
      t.boolean :bad, index: true, default: false
      t.boolean :holded, index: true, default: false
      t.bigint :holded_by, index: true
      t.datetime :holded_at

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end

    add_index :bank_drafts, [:payerable_id, :payerable_type]
  end
end
