class FwBlockLog < ApplicationRecord
    ACTIONS = {
        "BLOCK" => "Block",
        "UNBLOCK" => "Unblock"
    }

    include CaptureAuthor

    belongs_to :foreign_worker
    belongs_to :block_reason, optional: true
    belongs_to :requester, class_name: "User", foreign_key: "requested_by", optional: true
    belongs_to :approver, class_name: "User", foreign_key: "approval_by", optional: true
    has_many   :fw_verification_pars
end
