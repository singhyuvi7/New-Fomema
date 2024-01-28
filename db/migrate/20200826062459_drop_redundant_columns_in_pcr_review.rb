class DropRedundantColumnsInPcrReview < ActiveRecord::Migration[6.0]
    def change
        remove_column :pcr_reviews, :xray_details
        remove_column :pcr_reviews, :xray_details_comment
    end
end