class AddAssignedToToEmployers < ActiveRecord::Migration[6.0]
  def change
    add_column :employers, :assigned_to, :bigint
    add_index :employers, :assigned_to
  end
end
