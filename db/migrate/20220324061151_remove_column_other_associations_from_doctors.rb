class RemoveColumnOtherAssociationsFromDoctors < ActiveRecord::Migration[6.0]
  def change
    remove_column :doctors, :other_association
  end
end
