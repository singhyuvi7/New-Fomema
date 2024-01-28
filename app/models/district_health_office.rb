class DistrictHealthOffice < ApplicationRecord
    STATUSES = {
        "ACTIVE" => "Active",
        "INACTIVE" => "Inactive"
    }

    audited
    include CaptureAuthor

    belongs_to :state, optional: true
    belongs_to :town, optional: true
    has_many :laboratories
    has_many :laboratory_revisions

    validates :name, :code, presence: true
    validates :code, uniqueness: {scope: :town_id}
    validates :name, uniqueness: {scope: :town_id}

    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where('district_health_offices.code = ?', "#{code}")
    end

    def self.search_name(name)
        return all if name.blank?
        name = name.strip
        where('district_health_offices.name ILIKE ?', "%#{name}%")
    end
end
