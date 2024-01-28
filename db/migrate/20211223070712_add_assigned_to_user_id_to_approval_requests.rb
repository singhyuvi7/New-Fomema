class AddAssignedToUserIdToApprovalRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :approval_requests, :assigned_to_user_id, :bigint
    add_index :approval_requests, :assigned_to_user_id
  end
end
