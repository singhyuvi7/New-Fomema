class UsersEmailAllowNull < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :email, :string, null: true
    remove_index :users, :email
    add_index :users, :email
  end
end
