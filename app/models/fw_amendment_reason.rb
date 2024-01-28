class FwAmendmentReason < ApplicationRecord
    audited
    include CaptureAuthor

    belongs_to :fw_amendment
    belongs_to :amendment_reason
end
