class AgencyLicenseCategory < ApplicationRecord
    audited
    include CaptureAuthor
  
    has_many :agencies
  
    def self.search_name(name)
      return all if name.blank?
      name = name.strip
      where('agency_license_categories.name ILIKE ?', "%#{name}%")
    end

    def self.search_code(id)
        return all if id.blank?
        id = id.strip
        where('agency_license_categories.id = ?', "#{id}")
    end
end
