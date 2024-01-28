class CreateFpxBanks < ActiveRecord::Migration[6.0]
  def change
    create_table :fpx_banks do |t|
      t.string :code
      t.string :name
      t.string :display_name
      t.string :msg_token
      t.string :status
      t.timestamps
      t.bigint :created_by
      t.bigint :updated_by
    end
  end
end
