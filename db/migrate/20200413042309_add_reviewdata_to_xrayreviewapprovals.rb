class AddReviewdataToXrayreviewapprovals < ActiveRecord::Migration[6.0]
  def change
    add_column :xray_review_approvals, :review_data, :json
  end
end
