class DigitalXrayProvider < ApplicationRecord
    require 'digest'

    audited
    include CaptureAuthor

    has_many :transactions
    
    validates :name, :code, presence: true, uniqueness: true
  
    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where('digital_xray_providers.code = ?', "#{code}")
    end
  
    def self.search_name(name)
        return all if name.blank?
        name = name.strip
        where('digital_xray_providers.name ILIKE ?', "%#{name}%")
    end

    def self.encrypt_passphrase(str)
        Digest::MD5.hexdigest(str)
    end
end