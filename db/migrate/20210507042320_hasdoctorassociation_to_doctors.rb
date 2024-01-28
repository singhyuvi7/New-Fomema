class HasdoctorassociationToDoctors < ActiveRecord::Migration[6.0]
  def change
    add_column :doctors, :has_doctor_association, :boolean
    add_column :doctors, :membership_number, :string
    add_column :doctors, :name_of_association, :string
  end
end
