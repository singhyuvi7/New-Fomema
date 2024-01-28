class Association < ApplicationRecord
    audited
    include CaptureAuthor  

    validates :name, :code, presence: true

    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where('associations.code = ?', "#{code}")
    end
    
    def self.search_name(name)
        return all if name.blank?
        name = name.strip
        where('associations.name ilike ?', "%#{name}%")
    end
end
