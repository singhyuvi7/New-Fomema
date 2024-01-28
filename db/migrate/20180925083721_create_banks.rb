class CreateBanks < ActiveRecord::Migration[5.2]
  def change
    create_table :banks do |t|
      t.string :code, index: true
      t.string :name
      t.string :status, index: true, default: "INACTIVE"
      t.string :swift_code
      t.boolean :local_bank
      t.string :routing
      t.string :routing2
      t.integer :bank_draft_expiry_day, default: 0
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
