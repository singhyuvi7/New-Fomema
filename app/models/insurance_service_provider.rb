class InsuranceServiceProvider < ApplicationRecord
    audited
    include CaptureAuthor

    # has_many :insurance_purchases
    has_many :orders

    validates :code, presence: true, uniqueness: true
    validates :name, presence: true
    validates :display_name, presence: true
    validates :payment_to_code, presence: true

    ACTIVE = {
        "Yes" => true,
        "No" => false
    }

    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where('insurance_service_providers.code = ?', "#{code}")
    end

    def self.search_name(name)
        return all if name.blank?
        name = name.strip
        where('insurance_service_providers.name ILIKE ?', "%#{name}%")
    end

    def self.search_display_name(display_name)
        return all if display_name.blank?
        where('insurance_service_providers.display_name ILIKE ?', "%#{display_name}%")
    end

    def self.search_active(active)
        return all if active.blank?
        where('insurance_service_providers.active = ?', active)
    end
end
