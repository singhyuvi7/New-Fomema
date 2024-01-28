class DropXrayPendingReviewsPrevUnsuitableType < ActiveRecord::Migration[6.0]
  def change
    remove_column :xray_pending_reviews, :prev_unsuitable_type, :string, index: true
  end
end
