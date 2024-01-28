class VisitPlanItem < ApplicationRecord
    audited
    include CaptureAuthor

    belongs_to :visit_plan
    belongs_to :visitable, polymorphic: true
end
