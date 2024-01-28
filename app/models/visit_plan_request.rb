class VisitPlanRequest < ApplicationRecord
    audited
    include CaptureAuthor

	SERVICE_PROVIDERS = {
		"Doctor" => "Doctor",
		"XrayFacility" => "X-ray Facility"
	}

    belongs_to :spable, polymorphic: true, optional: true
    belongs_to :state, optional: true
    belongs_to :town, optional: true

	scope :start_date, -> start_date { where("date_of_request >= ?", start_date) }
	scope :end_date, -> end_date { where("date_of_request <= ?", end_date) }
end
