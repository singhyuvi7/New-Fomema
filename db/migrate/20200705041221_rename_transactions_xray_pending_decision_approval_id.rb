class RenameTransactionsXrayPendingDecisionApprovalId < ActiveRecord::Migration[6.0]
  def change
    rename_column :transactions, :xray_pending_decision_approval_id, :xray_pending_decision_approval_by
  end
end
