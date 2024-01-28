class Title < ApplicationRecord
  audited
  include CaptureAuthor
  has_many :xray_facilities

  validates :name, presence: true,uniqueness: {case_sensitive: false}

  def self.search_name(name)
    return all if name.blank?
    name = name.strip
    where('titles.name ILIKE ?', "%#{name}%")
  end
end
