class ChangeSpReason < ApplicationRecord
    audited
    include CaptureAuthor

    has_many :transactions

    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where('change_sp_reasons.code = ?', "#{code}")
    end

    def self.search_description(description)
        return all if description.blank?
        description = description.strip
        where('change_sp_reasons.description ILIKE ?', "%#{description}%")
    end
end
