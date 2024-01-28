class FwChangeEmployer < ApplicationRecord
    STATUSES = {
        "APPROVAL" => "Pending Approval",
        "APPROVED" => "Approved",
        "REJECTED" => "Rejected",
        # "REVERTED" => "Reverted",
    }

    DECISIONS = {
        "APPROVE" => "Approve",
        # "REVERT" => "Revert",
        "REJECT" => "Reject",
    }

    # audited
    include CaptureAuthor

    belongs_to :foreign_worker, class_name: "ForeignWorker", foreign_key: "foreign_worker_id", optional: true
    belongs_to :fw_country, class_name: "Country", optional: true
    belongs_to :old_employer, class_name: "Employer", foreign_key: "old_employer_id", optional: true
    belongs_to :new_employer, class_name: "Employer", foreign_key: "new_employer_id", optional: true

    belongs_to :request_user, class_name: 'User', optional: true, foreign_key: :requested_by
    belongs_to :approval_user, class_name: 'User', optional: true, foreign_key: :approval_by
    belongs_to :assigned_to_user, class_name: 'User', optional: true, foreign_key: :assigned_to

    # scope :change_employer_requests, -> {
    #     joins("join fw_change_employers on foreign_workers.id = fw_change_employers.foreign_worker_id")
    # }

    def self.search_worker_code(worker_code)
        return all if worker_code.blank?
        worker_code = worker_code.strip
        where("exists (select 1 from foreign_workers where fw_change_employers.foreign_worker_id = foreign_workers.id and foreign_workers.code = ?)", worker_code.upcase)
    end

    def self.search_worker_name(worker_name)
        return all if worker_name.blank?
        worker_name = worker_name.strip
        where("exists (select 1 from foreign_workers where fw_change_employers.foreign_worker_id = foreign_workers.id and foreign_workers.name ILIKE ?)", "%#{worker_name}%")
    end

    def self.search_gender(gender)
        return all if gender.blank?
        where("exists (select 1 from foreign_workers where fw_change_employers.foreign_worker_id = foreign_workers.id and foreign_workers.gender = ?)", gender)
    end

    def self.search_passport(worker_passport)
        return all if worker_passport.blank?
        worker_passport = worker_passport.strip
        where("exists (select 1 from foreign_workers where fw_change_employers.foreign_worker_id = foreign_workers.id and foreign_workers.passport_number = ?)", worker_passport.upcase)
    end

    def self.search_country(country)
        return all if country.blank?
        where("exists (select 1 from foreign_workers where fw_change_employers.foreign_worker_id = foreign_workers.id and foreign_workers.country_id = ?)", country)
    end

    def self.search_date_of_birth(date_of_birth)
        return all if date_of_birth.blank?
        where("exists (select 1 from foreign_workers where fw_change_employers.foreign_worker_id = foreign_workers.id and foreign_workers.date_of_birth = ?)", date_of_birth)
    end

    def self.search_status(status)
        return all if status.blank?
        where('fw_change_employers.status = ?', status);
    end

    def self.search_request_start_date(start_date)
        return all if start_date.blank?
        where('fw_change_employers.created_at >= ?', start_date.to_date.beginning_of_day);
    end

    def self.search_request_end_date(end_date)
        return all if end_date.blank?
        where('fw_change_employers.created_at <= ?', end_date.to_date.end_of_day);
    end

    def self.search_assigned_to(assigned_to)
       return all if assigned_to.blank?
       where('fw_change_employers.assigned_to = ?', assigned_to);
    end

    def self.search_fixed_worker_name(worker_name)
        return all if worker_name.blank?
        worker_name = worker_name.strip
        where('fw_change_employers.fw_name ILIKE ?', "%#{worker_name}%");
    end

    def self.search_fixed_passport(worker_passport)
        return all if worker_passport.blank?
        worker_passport = worker_passport.strip
       where('fw_change_employers.fw_passport_number = ?', worker_passport);
    end

    def fw_gender_name
        case self.fw_gender
        when 'f', 'F'
            "FEMALE"
        when 'm', 'M'
            "MALE"
        else
            nil
        end
    end
end