class AddUsersDeletedAtIndex < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :deleted_at
  end
end
