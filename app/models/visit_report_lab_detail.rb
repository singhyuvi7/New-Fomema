class VisitReportLabDetail < ApplicationRecord
    audited
    include CaptureAuthor

    belongs_to :visit_report_laboratory
end
