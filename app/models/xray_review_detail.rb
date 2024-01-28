class XrayReviewDetail < ApplicationRecord
    audited
    include CaptureAuthor

    belongs_to :xray_review
    belongs_to :condition

    delegate :code, to: :condition, allow_nil: true
end
