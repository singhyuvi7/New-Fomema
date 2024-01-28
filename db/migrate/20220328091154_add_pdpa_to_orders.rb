class AddPdpaToOrders < ActiveRecord::Migration[6.0]
  def change
      add_column :orders, :personal_data_consent, :boolean, default: false
  end
end
