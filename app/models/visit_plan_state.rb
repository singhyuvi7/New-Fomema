class VisitPlanState < ApplicationRecord
    audited
    include CaptureAuthor

    belongs_to :visit_plan
    belongs_to :state
end
