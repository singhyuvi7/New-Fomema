class CallLogFollowUp < ApplicationRecord
    audited
    include CaptureAuthor

    belongs_to :call_log
end
