class AddcolumnotherassociationToDoctors < ActiveRecord::Migration[6.0]
  def change
    add_column :doctors, :other_association, :string
  end
end
