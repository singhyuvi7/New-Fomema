class AddBelongCommentToPcrReviews < ActiveRecord::Migration[6.0]
    def change
        add_column :pcr_reviews, :belong_comment, :text
    end
end