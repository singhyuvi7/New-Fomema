class DropTransactionsXrayPendingDecisionApprovalFields < ActiveRecord::Migration[6.0]
  def change
    remove_column :transactions, :xray_pending_decision_approval_by, :bigint, index: true
    remove_column :transactions, :xray_pending_decision_approval_decision, :string
    remove_column :transactions, :xray_pending_decision_approval_comment, :text
  end
end
