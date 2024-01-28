class ForeignWorkerAmendmentReason < ApplicationRecord
    audited
    include CaptureAuthor

    belongs_to :foreign_worker
    belongs_to :amendment_reason
end
