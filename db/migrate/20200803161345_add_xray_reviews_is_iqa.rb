class AddXrayReviewsIsIqa < ActiveRecord::Migration[6.0]
  def change
    add_column :xray_reviews, :is_iqa, :string, default: "N"
  end
end
