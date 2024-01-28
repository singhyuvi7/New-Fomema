class Country < ApplicationRecord
    MALAYSIA_CODE = "MYS"
    audited
    include CaptureAuthor
        
    validates :name, :code, presence: true, uniqueness: true

    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where('countries.code = ?', "#{code}")
    end

    def self.search_name(name)
        return all if name.blank?
        name = name.strip
        where('countries.name ILIKE ?', "%#{name}%")
    end

    def self.malaysia_id
        where("countries.code = ?", MALAYSIA_CODE).first.id
    end
end
