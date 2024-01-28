class VisitPlanTown < ApplicationRecord
    audited
    include CaptureAuthor

    belongs_to :visit_plan
    belongs_to :state
    belongs_to :town
end
