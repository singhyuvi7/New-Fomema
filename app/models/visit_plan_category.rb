class VisitPlanCategory < ApplicationRecord
    CATEGORIES = {
        "ROUTINE" => "ROUTINE",
        "INVESTIGATIVE" => "INVESTIGATIVE",
        "TARGETTED" => "TARGETTED"
    }

    audited
    include CaptureAuthor

    belongs_to :visit_plan
end
