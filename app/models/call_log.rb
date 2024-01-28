class CallLog < ApplicationRecord
    CALLABLE_TYPES = {
        "XrayFacility" => "X-Ray Facility",
        "Doctor" => "Doctor",
        "Laboratory" => "Laboratory",
        "Radiologist" => "Radiologist",
        "Employer" => "Employer",
    }

    STATUSES = {
        "OPEN" => "Open",
        "CLOSE" => "Close",
    }

    audited
    include CaptureAuthor

    has_many :call_log_follow_ups
    belongs_to :call_log_case_type, optional: true
    belongs_to :callable, polymorphic: true, optional: true

    def self.search_id(id)
        return all if id.blank?
        where(id: id)
    end

    def self.search_callable_type(callable_type)
        return all if callable_type.blank?
        where(callable_type: callable_type)
    end

    def self.search_callable_code(callable, callable_code)
        return all if callable.blank? or callable_code.blank?
        callable_code = callable_code.strip
        where("exists (select 1 from #{callable.table_name} where call_logs.callable_id = #{callable.table_name}.id and #{callable.table_name}.code ilike ?)", callable_code)
    end

    def self.search_callable_name(callable, callable_name)
        return all if callable.blank? or callable_name.blank?
        callable_name = callable_name.strip
        where("exists (select 1 from #{callable.table_name} where call_logs.callable_id = #{callable.table_name}.id and #{callable.table_name}.name ilike ?)", "%#{callable_name}%")
    end

    def self.search_call_date_from(date_from)
        return all if date_from.blank?
        where("call_logs.called_at >= ?", date_from)
    end

    def self.search_call_date_to(date_to)
        return all if date_to.blank?
        where("call_logs.called_at < ?", (date_to.to_date + 1.day).strftime("%Y-%m-%d"))
    end
end
