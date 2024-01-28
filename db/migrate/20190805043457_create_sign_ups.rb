class CreateSignUps < ActiveRecord::Migration[5.2]
  def change
    create_table :sign_ups do |t|
      t.string :email, index: true
      t.bigint :sign_upable_id
      t.string :sign_upable_type
      t.string :token, index: true
      t.timestamps
    end

    add_index :sign_ups, [:sign_upable_id, :sign_upable_type]
  end
end
