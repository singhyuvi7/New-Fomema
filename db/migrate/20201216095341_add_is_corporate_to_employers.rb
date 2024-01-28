class AddIsCorporateToEmployers < ActiveRecord::Migration[6.0]
  def change
    add_column :employers, :is_corporate, :boolean, default: false
  end
end
