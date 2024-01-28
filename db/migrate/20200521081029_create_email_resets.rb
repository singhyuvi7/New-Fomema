class CreateEmailResets < ActiveRecord::Migration[6.0]
  def change
    create_table :email_resets do |t|
      t.string :code
      t.string :identity_code
      t.string :email
      t.string :status
      t.bigint :resettable_id
      t.string :resettable_type
      t.timestamps
    end

    add_index :email_resets, [:resettable_id, :resettable_type]
  end
end
