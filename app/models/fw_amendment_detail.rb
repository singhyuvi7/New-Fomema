class FwAmendmentDetail < ApplicationRecord
    audited
    include CaptureAuthor
    
    belongs_to :fw_amendment
end
