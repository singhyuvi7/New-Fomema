class PcrReviewDetail < ApplicationRecord
    audited
    include CaptureAuthor

    belongs_to :pcr_review
    belongs_to :condition
end
