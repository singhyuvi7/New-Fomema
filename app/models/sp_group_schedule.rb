class SpGroupSchedule < ApplicationRecord
    SP_SCHEDULEABLE_TYPES = {
        "Doctor" => "Doctor",
        "Laboratory" => "Laboratory",
        "XrayFacility" => "X-Ray Facility"
    }

    audited
    include CaptureAuthor

    belongs_to :sp_schedulable, polymorphic: true
    belongs_to :service_provider_group, optional: true

    def self.search_sp_schedulable_type(sp_schedulable_type)
        return all if sp_schedulable_type.blank?
        where("sp_group_schedules.sp_schedulable_type = ?", "#{sp_schedulable_type}")
    end

    def self.search_service_provider_group(service_provider_group)
        return all if service_provider_group.blank?
        where("sp_group_schedules.service_provider_group_id = ?", service_provider_group)
    end

end
