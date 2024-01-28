class FwMonitorLog < ApplicationRecord
    include CaptureAuthor

    belongs_to :foreign_worker
    belongs_to :monitor_reason
    belongs_to :monitor_requestor, class_name: "User", foreign_key: "monitor_request_by", optional: true
    belongs_to :unmonitor_requestor, class_name: "User", foreign_key: "unmonitor_request_by", optional: true
end
