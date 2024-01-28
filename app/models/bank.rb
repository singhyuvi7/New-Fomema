class Bank < ApplicationRecord
    STATUSES = {
        "ACTIVE" => "Active",
        "INACTIVE" => "Inactive"
    }

    audited
    include CaptureAuthor

    validates :code, presence: true, uniqueness: true
    validates :name, presence: true

    has_many :bank_drafts

    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where('banks.code = ?', "#{code}")
    end

    def self.search_name(name)
        return all if name.blank?
        name = name.strip
        where('banks.name ILIKE ?', "%#{name}%")
    end

    def self.search_status(status)
        return all if status.blank?
        where('banks.status = ?', status)
    end
end
