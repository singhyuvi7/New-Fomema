class DropPcrReviewsReassignFields < ActiveRecord::Migration[6.0]
  def change
    remove_column :pcr_reviews, :is_reassign, :boolean, default: false
    remove_column :pcr_reviews, :reassign_at, :datetime
  end
end
