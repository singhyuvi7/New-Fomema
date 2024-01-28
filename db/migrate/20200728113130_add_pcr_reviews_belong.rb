class AddPcrReviewsBelong < ActiveRecord::Migration[6.0]
  def change
    add_column :pcr_reviews, :belong, :string
  end
end
