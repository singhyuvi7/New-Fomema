class AddRadiologistsUserId < ActiveRecord::Migration[6.0]
  def change
    add_column :radiologists, :user_id, :bigint, index: true
  end
end
