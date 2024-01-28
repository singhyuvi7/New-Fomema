class Zone < ApplicationRecord
    audited
    include CaptureAuthor

    has_many :bank_drafts
    has_many :organizations

    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where('zones.code = ?', "#{code}")
    end
  
    def self.search_name(name)
        return all if name.blank?
        name = name.strip
        where('zones.name ILIKE ?', "%#{name}%")
    end
end
