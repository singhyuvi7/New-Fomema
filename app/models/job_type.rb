class JobType < ApplicationRecord
  audited
  include CaptureAuthor

  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :foreign_workers

  def self.search_name(name)
    return all if name.blank?
    name = name.strip
    where('job_types.name ILIKE ?', "%#{name}%")
  end

  def self.job_types_bahasa
    {
      "AGRICULTURE" => "Pertanian",
      "CONSTRUCTION" => "Pembinaan",
      "DOMESTIC" => "Domestik",
      "MANUFACTURING" => "Pembuatan",
      "PLANTATION" => "Perladangan",
      "SERVICE" => "Perkhidmatan",
      "MINING" => "Perlombongan"
    }
  end
end