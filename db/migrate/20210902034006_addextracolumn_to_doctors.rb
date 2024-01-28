class AddextracolumnToDoctors < ActiveRecord::Migration[6.0]
  def change
    # add_column :doctors, :nationality, :string
    add_column :doctors, :gender, :string
    # add_column :doctors, :race, :string
  end
end
