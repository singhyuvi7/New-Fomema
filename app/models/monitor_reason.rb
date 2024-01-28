class MonitorReason < ApplicationRecord
    audited
    include CaptureAuthor

    def self.search_code(code)
      return all if code.blank?
      code = code.strip
      where('monitor_reasons.code = ?', "#{code}")
    end
  
    def self.search_description(description)
      return all if description.blank?
      description = description.strip
      where('monitor_reasons.description ILIKE ?', "%#{description}%")
    end
end
