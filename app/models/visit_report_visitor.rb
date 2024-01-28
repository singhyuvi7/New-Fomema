class VisitReportVisitor < ApplicationRecord
    audited
    include CaptureAuthor

    belongs_to :visit_report
    belongs_to :visitor, class_name: 'User', optional: true, foreign_key: :visitor_id
end
