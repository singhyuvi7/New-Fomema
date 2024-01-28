class State < ApplicationRecord
  ABBREVIATION = {
    "1" => "JHR",
    "2" => "KDH",
    "3" => "KTN",
    "4" => "WKL",
    "5" => "MLK",
    "6" => "NSN",
    "7" => "PAH",
    "8" => "PRK",
    "9" => "PER",
    "A" => "PPG",
    "B" => "SBH",
    "C" => "SWK",
    "D" => "TRG",
    "E" => "SEL",
    "F" => "PUT",
    "G" => "LBN"
  }

  audited
  include CaptureAuthor

  has_many :towns

  validates :name, :code, presence: true
  validates :code, uniqueness: true
  validates :name, uniqueness: true

  def self.search_code(code)
    return all if code.blank?
    code = code.strip
    where('states.code = ?', code)
  end

  def self.search_name(name)
    return all if name.blank?
    name = name.strip
    where('states.name ILIKE ?', "%#{name}%")
  end

  def self.search_long_name(name)
    return all if name.blank?
    name = name.strip
    where('states.long_name ILIKE ?', "%#{name}%")
  end
end
