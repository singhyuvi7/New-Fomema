class DropXrayReviewsComment < ActiveRecord::Migration[6.0]
  def change
    remove_column :xray_reviews, :comment, :text
  end
end
