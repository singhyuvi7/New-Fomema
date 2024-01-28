class DropXrayPendingDecisionsApprovalStatus < ActiveRecord::Migration[6.0]
  def change
    remove_column :xray_pending_decisions, :approval_status, :string
  end
end
