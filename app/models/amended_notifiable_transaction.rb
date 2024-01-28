class AmendedNotifiableTransaction < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    belongs_to :transactionz, class_name: "Transaction", foreign_key: "transaction_id", inverse_of: :amended_notifiable_transactions, optional: true
    belongs_to :user, class_name: "User", foreign_key: "created_by", inverse_of: :amended_notifiable_transactions, optional: true
    belongs_to :notifiable, polymorphic: true, optional: true

    def self.communicable_diseases
        {
        "3501" => "HIV",
        "3502" => "TB",
        "3503" => "MALARIA",
        "3504" => "LEPROSY",
        "3505" => "SYPHILIS",
        "3506" => "HEPB",
        }
    end

    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        joins(:transactionz).where('transactions.code = ?', code)
    end

    def self.search_fw_code(worker_code)
        return all if worker_code.blank?
        joins(:transactionz).where("transactions.fw_code = ? OR transactions.fw_name ilike ?", worker_code, "%#{worker_code}%")
    end

    def self.search_fw_name(worker_name)
        return all if worker_name.blank?
        worker_name = worker_name.strip
        joins(:transactionz).where("transactions.fw_name ilike ?", "%#{worker_name}%")
    end

    def self.search_fw_country(country_id)
        return all if country_id.blank?
        joins(:transactionz).where(fw_country_id: country_id)
    end

    def self.search_fw_passport(passport_number)
        return all if passport_number.blank?
        passport_number = passport_number.strip
        joins(:transactionz).where("fw_passport_number = ?", passport_number)
    end

    def self.search_certification_date_start(certification_date_start)
        return all if certification_date_start.blank?
        joins(:transactionz).where('transactions.certification_date >= ?', certification_date_start)
    end

    def self.search_certification_date_end(certification_date_end)
        return all if certification_date_end.blank?
        joins(:transactionz).where('transactions.certification_date < ?', Time.parse(certification_date_end) + 1.day)
    end

    def self.search_amended_date_start(amended_date_start)
        return all if amended_date_start.blank?
        where('created_at >= ?', amended_date_start)
    end

    def self.search_amended_date_end(amended_date_end)
        return all if amended_date_end.blank?
        where('created_at < ?', Time.parse(amended_date_end) + 1.day)
    end
end
