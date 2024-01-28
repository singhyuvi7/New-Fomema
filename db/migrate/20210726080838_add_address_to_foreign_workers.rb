class AddAddressToForeignWorkers < ActiveRecord::Migration[6.0]
  def change
    add_column :foreign_workers, :address1, :string
    add_column :foreign_workers, :address2, :string
    add_column :foreign_workers, :address3, :string
    add_column :foreign_workers, :address4, :string
    add_column :foreign_workers, :state_id, :bigint
    add_column :foreign_workers, :town_id, :bigint
    add_column :foreign_workers, :postcode, :string
  end
end
