class AddAssociationNameToDoctors < ActiveRecord::Migration[6.0]
  def change
    add_column :doctors, :associations, :json
  end
end
