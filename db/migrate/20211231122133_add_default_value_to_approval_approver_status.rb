class AddDefaultValueToApprovalApproverStatus < ActiveRecord::Migration[6.0]
  def change
    change_column :approval_approvers, :status, :string, default: 'ACTIVE'
  end
end
