class AddIgnoredToXrayReviewApprovals < ActiveRecord::Migration[6.0]
    def change
        add_column :xray_review_approvals, :ignored, :boolean, default: false
        add_index :xray_review_approvals, :ignored
    end
end