class CreatePasswordPolicies < ActiveRecord::Migration[5.2]
  def change
    create_table :password_policies do |t|
      t.string :name
      t.integer :minimum_length, default: 7
      t.boolean :require_alphabet, default: true
      t.boolean :require_numeric, default: true
      t.boolean :require_special_characters, default: false
      t.boolean :require_small_and_capital, default: false
      t.integer :block_previous_password, default: 0
      t.integer :password_expiry, default: 0
      t.string :status, index: true, default: 'ACTIVE'
      t.string :approval_status, index: true, default: 'NEW_RECORD'
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
