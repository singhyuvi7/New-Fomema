class RemoveMembershipnumberFromDoctors < ActiveRecord::Migration[6.0]
  def change
    remove_column :doctors, :membership_number, :string
  end
end
