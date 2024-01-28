class Race < ApplicationRecord
	audited
  	include CaptureAuthor
	  
	validates :name, presence: true,uniqueness: {case_sensitive: false}
	
    def self.search_name(name)
        return all if name.blank?
        name = name.strip
        where('races.name ILIKE ?', "%#{name}%")
    end

end
