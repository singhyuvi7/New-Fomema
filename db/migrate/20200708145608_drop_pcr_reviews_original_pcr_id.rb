class DropPcrReviewsOriginalPcrId < ActiveRecord::Migration[6.0]
  def change
    remove_column :pcr_reviews, :original_pcr_id, :bigint, index: true
  end
end
