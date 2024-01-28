class Clinic < ApplicationRecord
  audited
  include CaptureAuthor

  belongs_to :country, optional: true
  belongs_to :state, optional: true
  belongs_to :town, optional: true

  def self.search_code(code)
    return all if code.blank?
    code = code.strip
    where('clinics.code = ?', "#{code}")
  end

  def self.search_name(name)
    return all if name.blank?
    name = name.strip
    where('clinics.name ILIKE ?', "%#{name}%")
  end
end
