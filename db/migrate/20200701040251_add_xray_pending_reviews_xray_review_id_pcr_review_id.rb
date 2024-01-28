class AddXrayPendingReviewsXrayReviewIdPcrReviewId < ActiveRecord::Migration[6.0]
  def change
    add_column :xray_pending_reviews, :xray_review_id, :bigint, index: true
    add_column :xray_pending_reviews, :pcr_review_id, :bigint, index: true
  end
end
