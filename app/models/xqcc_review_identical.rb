class XqccReviewIdentical < ApplicationRecord
    belongs_to :xray_review
    belongs_to :identical_xray_review, :class_name => :XrayReview, :foreign_key => "identical_xray_review_id", optional: true
end
