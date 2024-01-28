class RemoveDistrictHealthOfficesApprovalStatus < ActiveRecord::Migration[6.0]
  def change
    remove_column :district_health_offices, :approval_status, :string
  end
end
