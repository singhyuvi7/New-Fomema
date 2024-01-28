class AmendmentReason < ApplicationRecord
  audited
  include CaptureAuthor

  has_many :foreign_workers

  def self.search_code(code)
    return all if code.blank?
    code = code.strip
    where('amendment_reasons.code = ?', "#{code}")
  end

  def self.search_description(description)
    return all if description.blank?
    description = description.strip
    where('amendment_reasons.description ILIKE ?', "%#{description}%")
  end
end
