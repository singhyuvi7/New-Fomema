class RetakeReason < ApplicationRecord
    audited
    include CaptureAuthor

    def self.search_name(name)
        return all if name.blank?
        name = name.strip
        where('retake_reasons.name = ?', "#{name}")
      end
end
