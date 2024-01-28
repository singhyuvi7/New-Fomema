class LaboratoryType < ApplicationRecord
  audited
  include CaptureAuthor

  ## used at visit reports
  LABORATORY_TYPES = {
    1 => "Full/Partial",
    2 => "Full/Partial",
    3 => "Collection"
  }

  validates :name, presence: true
  validates :name, uniqueness: true
  
  has_many :laboratories

  def self.search_name(name)
    return all if name.blank?
    name = name.strip
    where('laboratory_types.name ILIKE ?', "%#{name}%")
  end
end
