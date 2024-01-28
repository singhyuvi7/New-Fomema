class XrayLicensePurposes < ApplicationRecord
    audited
    include CaptureAuthor
    validates :name, presence: true

    def self.search_name(name)
        return all if name.blank?
        name = name.strip
        where('xray_license_purposes.name = ?', "#{name}")
    end
end
