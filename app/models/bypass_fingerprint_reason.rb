class BypassFingerprintReason < ApplicationRecord
    audited
    include CaptureAuthor

    has_many :doctor_transactions, class_name: "Transaction", foreign_key: "doctor_bypass_fingerprint_reason_id"
    has_many :xray_transactions, class_name: "Transaction", foreign_key: "xray_bypass_fingerprint_reason_id"

    validates :code, :description, presence: true, uniqueness: true

    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where('bypass_fingerprint_reasons.code = ?', "#{code}")
    end
  
    def self.search_description(description)
        return all if description.blank?
        description = description.strip
        where('bypass_fingerprint_reasons.description ILIKE ?', "%#{description}%")
    end
end
