class AddIndexToApprovalApprovers < ActiveRecord::Migration[6.0]
  def change
    add_index :approval_approvers, :category
    add_index :approval_approvers, :status
  end
end
