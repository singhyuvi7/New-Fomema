class DropXrayPendingReviewsXrayReviewIdPcrReviewId < ActiveRecord::Migration[6.0]
  def change
    remove_column :xray_pending_reviews, :xray_review_id, :bigint, index: true
    remove_column :xray_pending_reviews, :pcr_review_id, :bigint, index: true
  end
end
