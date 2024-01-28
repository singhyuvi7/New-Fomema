class AddXrayPendingDecisionsApprovalDecisionCommentBy < ActiveRecord::Migration[6.0]
  def change
    add_column :xray_pending_decisions, :approval_by, :bigint, index: true
    add_column :xray_pending_decisions, :approval_decision, :string
    add_column :xray_pending_decisions, :approval_comment, :text
  end
end
