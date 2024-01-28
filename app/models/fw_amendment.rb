class FwAmendment < ApplicationRecord
    audited
    include CaptureAuthor

    belongs_to :foreign_worker
    has_many :fw_amendment_details
    has_many :fw_amendment_reasons
end
