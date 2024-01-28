class AddIsPopUpToBulletins < ActiveRecord::Migration[6.0]
  def change
    add_column :bulletins, :is_pop_up, :boolean, default: false
  end
end
