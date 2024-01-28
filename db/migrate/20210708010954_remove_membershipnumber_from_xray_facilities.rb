class RemoveMembershipnumberFromXrayFacilities < ActiveRecord::Migration[6.0]
  def change
    remove_column :xray_facilities, :membership_number, :string
  end
end
