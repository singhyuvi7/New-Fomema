class CallLogCaseType < ApplicationRecord
    audited
    include CaptureAuthor

    has_many :call_logs

    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where('call_log_case_types.code = ?', "#{code}")
    end

    def self.search_description(description)
        return all if description.blank?
        description = description.strip
        where('call_log_case_types.description ILIKE ?', "%#{description}%")
    end
end
