class EmployerType < ApplicationRecord
  audited
  include CaptureAuthor

  # PROCESSES = ['INDIVIDUAL', 'COMPANY', 'INDVPRA']

  has_many :employers

  def self.search_name(name)
    return all if name.blank?
    name = name.strip
    where('employer_types.name ILIKE ?', "%#{name}%")
  end
end
