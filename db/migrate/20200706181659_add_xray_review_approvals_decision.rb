class AddXrayReviewApprovalsDecision < ActiveRecord::Migration[6.0]
  def change
    add_column :xray_review_approvals, :decision, :string
  end
end
