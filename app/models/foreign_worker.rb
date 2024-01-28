class ForeignWorker < ApplicationRecord
    REQ_TYPE = '01'
    CODE_PREFIX = 'W'

    GENDERS = {
        "M" => "MALE",
        "F" => "FEMALE",
    }

    DOCUMENT_TYPES = {
        "PASSPORT" => "PASSPORT",
        "WORKINGPERMIT" => "WORK PERMIT/ CALLING VISA/ SMO SLIP/ APPROVAL SLIP FROM JIM",
    }

    REREG_DOCUMENT_TYPES = {
        "FOREIGN_WORKER_IMAGE" => "VERIFIED FOREIGN WORKER IMAGE",
        "SUSPICIOUS_IMAGE" => "SUSPICIOUS FOREIGN WORKER IMAGE",
    }

    DOCUMENT_TYPES_AGENCY_WORKER = {
        "PASSPORT" => "PASSPORT FRONT PAGE",
        "WORKING_PERMIT_CALLING_VISA" => "WORK PERMIT/ CALLING VISA/ SMO SLIP/ APPROVAL SLIP FROM JIM / SPECIAL_PASS",
        "EMPLOYERNRIC_PASSPORT"  => "EMPLOYER'S IC / PASSPORT / COMPANY SSM",
        "AUTHORISATION_LETTER" => "AUTHORISATION LETTER",
    }

    DOCUMENT_TYPES_CHANGE_EMPLOYER = {
        "CE_PASSPORT" => "PASSPORT FRONT PAGE",
        "CE_WORKING_PERMIT_CALLING_VISA" => "WORK PERMIT/ CALLING VISA/ SMO SLIP/ APPROVAL SLIP FROM JIM",
        "CE_RTK_QUOTA_EMAIL" => "RTK QUOTA APPROVAL EMAIL",
    }

    MAID_ONLINE = {
        "PRAON" => "MAID ONLINE",
        "FOMEMA" => "FOMEMA",
        "RTK" => "RECALIBRATION"
    }

    INSURANCE = [{
            "id" => 1,
            "ins_id" => "001",
            "name" => "TUNE INSURANCE MALAYSIA",
            "code" => ENV["INSURANCE_TUNE_CODE"],
            "key" => ENV["INSURANCE_TUNE_KEY"],
            "url" => ENV["INSURANCE_TUNE_URL"],
            "img" => "tune.png"
        },{
            "id" => 2,
            "ins_id" => "002",
            "name" => "QBE INSURANCE MALAYSIA",
            "code" =>  ENV["INSURANCE_QBE_CODE"],
            "key" =>  ENV["INSURANCE_QBE_KEY"],
            "url" => ENV["INSURANCE_QBE_URL"],
            "img" => "qbe.png"
        },{
            "id" => 3,
            "ins_id" => "003",
            "name" => "CHUBB INSURANCE MALAYSIA",
            "code" => ENV["INSURANCE_CHUBB_CODE"],
            "key" => ENV["INSURANCE_CHUBB_KEY"],
            "url" => ENV["INSURANCE_CHUBB_URL"],
            "img" => "chubb.png"
        }
    ]

    MONITORINGS = {
        "N" => "No",
        "Y" => "Yes"
    }

    PORTAL_STATUSES = {
        "UPDATE_PENDING_APPROVAL" => "Amendment Pending for Approval",
        "UPDATE_APPROVED" => "Amendment Approved",
        "UPDATE_REJECTED" => "Amendment Rejected"
    }

    STATUSES = {
        "ACTIVE" => "Active",
        "INACTIVE" => "Inactive"
    }

    audited
    include CaptureAuthor
    include CaptureOrganization
    include ApprovalableModel
    acts_as_approval_resource
    include Sequence
    include GenCodeTwo

    belongs_to :country, optional: true
    belongs_to :job_type, optional: true
    belongs_to :employer
    belongs_to :state, optional: true
    belongs_to :town, optional: true
    belongs_to :employer_supplement, optional: true
    belongs_to :amendment_reason, optional: true
    belongs_to :amender, class_name: "User", foreign_key: :amended_by, optional: true
    belongs_to :block_reason, optional: true
    belongs_to :unblock_reason, class_name: "BlockReason", optional: true
    belongs_to :blocker, class_name: "User", foreign_key: "blocked_by", optional: true
    belongs_to :unblocker, class_name: "User", foreign_key: "unblocked_by", optional: true
    belongs_to :monitor_reason, optional: true
    belongs_to :latest_transaction, class_name: "Transaction", foreign_key: "latest_transaction_id", optional: true
    belongs_to :creator, class_name: 'User', optional: true, foreign_key: :created_by
    belongs_to :latest_insurance_purchase, class_name: "InsurancePurchase", foreign_key: "latest_insurance_purchase_id", optional: true

    has_many :uploads, as: :uploadable
    has_many :transactions
    has_many :order_items, as: :order_itemable
    has_many :medical_appeals, through: :transactions, inverse_of: :foreign_worker
    has_many :biodata_requests
    has_many :biodata_responses
    has_many :fingerprint_responses
    has_many :foreign_worker_amendment_reasons
    has_many :fw_block_logs
    has_many :fw_monitor_logs
    has_many :foreign_worker_changes
    has_many :fw_amendments
    has_many :fw_change_employers
    has_many :fw_documents_history
    has_one :latest_fw_change_employer, -> { order(created_at: :desc) }, class_name: 'FwChangeEmployer'
    has_many :fw_verification_pars

    accepts_nested_attributes_for :uploads

    validates :name, :gender, :date_of_birth, :passport_number, :country_id, :job_type_id, :plks_number, presence: true
    # validates :passport_number, uniqueness: { scope: [:gender, :date_of_birth, :country_id], case_sensitive: false, message: "Exact match found based on criteria Passport No., country, date of birth, gender." }
    validate :gender_change_only_once
    validate :critical_fields_unique_check

    before_update :check_gender_change
    after_save :sync_amendment_reasons
    after_save :sync_transactions
    before_save :before_save_callback
    after_save :after_save_callback
    after_save :send_approval_email, if: -> { saved_changes[:approval_status] }
    after_commit :log_changes
    before_save :strip_name, if: :name_changed?
    before_save :cleanup_dob_and_arrival_date

    delegate :name, to: :country, prefix: true, allow_nil: true
    delegate :name, to: :job_type, prefix: true, allow_nil: true
    delegate :name, to: :state, prefix: true, allow_nil: true
    delegate :name, to: :town, prefix: true, allow_nil: true
    delegate :name, :phone, :displayed_address, :town_name, :state_name, :state_code, to: :employer, prefix: true, allow_nil: true

    # used in mspd unsuitable foreign worker report
    scope :filter_transaction_date, lambda { |start_date, end_date|
        includes(:transactions).where(transactions: { transaction_date: DateTime.parse(start_date).in_time_zone('Kuala Lumpur').beginning_of_day..DateTime.parse(end_date).in_time_zone('Kuala Lumpur').end_of_day }) if start_date.present?
    }
    scope :filter_certification_date, lambda { |start_date, end_date|
        includes(:transactions).where(transactions: { certification_date: DateTime.parse(start_date).in_time_zone('Kuala Lumpur').beginning_of_day..DateTime.parse(end_date).in_time_zone('Kuala Lumpur').end_of_day }) if start_date.present?
    }

    scope :unsuitable, -> { joins(:latest_transaction).where(transactions: { final_result: 'UNSUITABLE' }) }

    scope :active, -> { where(status: "ACTIVE") }

    scope :approval_requests, -> {
        joins("join approval_items on foreign_workers.id = approval_items.resource_id join approval_requests on approval_items.request_id = approval_requests.id and approval_items.resource_type = 'ForeignWorker'")
    }

    scope :change_employer_requests, -> {
        joins("join fw_change_employers on foreign_workers.id = fw_change_employers.foreign_worker_id")
    }

    scope :latest_change_employer_requests, -> {
        change_employer_requests.where("fw_change_employers.id in (select max(id) from fw_change_employers as b where b.foreign_worker_id = foreign_workers.id)")
    }

    def self.search_name(name)
        return all if name.blank?
        name = name.strip
        where('foreign_workers.name ILIKE ?', "%#{name}%")
    end

    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where('foreign_workers.code = ?', "#{code}")
    end

    def self.search_passport(passport)
        return all if passport.blank?
        passport = passport.strip
        where('foreign_workers.passport_number = ?', "#{passport.upcase}")
    end

    def self.search_employer(employer)
        return all if employer.blank?
        where('foreign_workers.employer_id = ?', employer);
    end

    def self.search_gender(gender)
        return all if gender.blank?
        where('foreign_workers.gender = ?', "#{gender}");
    end

    def self.search_monitoring(monitoring)
        return all if monitoring.blank?
        where('foreign_workers.monitoring = ?', "#{monitoring}");
    end

    def self.search_date_of_birth(date_of_birth)
        return all if date_of_birth.blank?
        where('foreign_workers.date_of_birth = ?', "#{date_of_birth}");
    end

    def self.search_employer_code(employer_code)
        return all if employer_code.blank?
        where("exists (select 1 from employers where foreign_workers.employer_id = employers.id and employers.code = ?)", employer_code);
    end

    def self.search_country(country)
        return all if country.blank?
        where('foreign_workers.country_id = ?', country)
    end

    def self.search_id(id)
        return all if id.blank?
        where('foreign_workers.id = ?', id)
    end

    def self.search_pending_approval(pending_approval)
        return all if pending_approval.blank?
        where("foreign_workers.approval_status in (?)", ["NEW_PENDING_APPROVAL", "UPDATE_PENDING_APPROVAL"])
    end

    def self.search_approval_status(approval_status)
        return all if approval_status.blank?
        where('foreign_workers.approval_status = ?', "#{approval_status}");
    end

    def self.search_status(status)
        return all if status.blank?
        case status
        when "HAS_SPECIAL_RENEWAL_PENDING_APPROVAL"
            where("exists (select 1 from order_items join orders on order_items.order_id = orders.id and orders.status = 'PENDING_APPROVAL' where order_items.order_itemable_id = foreign_workers.id and order_items.order_itemable_type = 'ForeignWorker')")
        when "CHANGE_EMPLOYER_PENDING_APPROVAL"
            latest_change_employer_requests.where("fw_change_employers.status = 'APPROVAL'")
        when "CHANGE_EMPLOYER_REJECTED"
            latest_change_employer_requests.where("fw_change_employers.status = 'REJECTED'")
        when "CHANGE_EMPLOYER_REVERTED"
            latest_change_employer_requests.where("fw_change_employers.status = 'REVERTED'")
        when "CHANGE_EMPLOYER_APPROVED"
            latest_change_employer_requests.where("fw_change_employers.status = 'APPROVED'")
        else
            where("foreign_workers.approval_status = ?", "#{status}");
        end
    end

    def self.search_blocked(blocked)
        return all if blocked.blank?
        where('foreign_workers.blocked = ?',blocked)
    end

    def self.search_employer_state(employer_state_id)
        return all if employer_state_id.blank?
        joins(:employer).where(employers: { state_id: employer_state_id })
    end

    def self.search_branch(branch_id)
        return all if branch_id.blank?

        # ids = ForeignWorker.joins(:audits).where(audits: { user_type: 'User' }).joins( "INNER JOIN users ON audits.user_id = users.id" ).where('users.userable_type = ? and users.userable_id = ?','Organization',branch_id).pluck('foreign_workers.id').uniq

        # where('foreign_workers.organization_id = ? or foreign_workers.id in (?)',branch_id,ids)

        where("foreign_workers.organization_id = ? or exists ( select 1 from foreign_workers join audits on foreign_workers.id = audits.auditable_id and audits.auditable_type = 'ForeignWorker' join users on audits.user_id = users.id where users.userable_id = ? and users.userable_type = 'Organization' )", branch_id, branch_id)
    end

    def self.search_request_start_date(start_date)
        return all if start_date.blank?

        approval_requests.where("approval_requests.state = 0 and approval_items.id = (SELECT MAX(id) FROM approval_items temp_ai WHERE temp_ai.resource_id = foreign_workers.id and resource_type = 'ForeignWorker')").where("approval_requests.created_at >= ?",start_date.to_date.beginning_of_day)
    end

    def self.search_request_end_date(end_date)
        return all if end_date.blank?

        date = end_date.to_date + 1.day

        approval_requests.where("approval_requests.state = 0 and approval_items.id = (SELECT MAX(id) FROM approval_items temp_ai WHERE temp_ai.resource_id = foreign_workers.id and resource_type = 'ForeignWorker')").where("approval_requests.created_at < ?",date.strftime('%Y-%m-%d'))
    end

    def self.search_supplement(employer_supplement_id)
        return all if employer_supplement_id.blank?
        return where("employer_supplement_id is null") if ['*SELF'].include?(employer_supplement_id)
        where(employer_supplement_id: employer_supplement_id)
    end

    def self.search_assigned_to(assigned_to, status)
        return all if assigned_to.blank? or status.blank?
        case status
        when "CHANGE_EMPLOYER_PENDING_APPROVAL", "CHANGE_EMPLOYER_REJECTED", "CHANGE_EMPLOYER_REVERTED", "CHANGE_EMPLOYER_APPROVED"
            change_employer_requests.where("fw_change_employers.approval_at is null and fw_change_employers.assigned_to = ?", assigned_to)
        when "UPDATE_APPROVED"
            approval_requests.where("approval_requests.state = 4 and approval_items.id = (SELECT MAX(id) FROM approval_items temp_ai WHERE temp_ai.resource_id = foreign_workers.id and resource_type = 'ForeignWorker')").where("approval_requests.assigned_to_user_id = ?", assigned_to)
        when "UPDATE_REJECTED"
            approval_requests.where("approval_requests.state = 3 and approval_items.id = (SELECT MAX(id) FROM approval_items temp_ai WHERE temp_ai.resource_id = foreign_workers.id and resource_type = 'ForeignWorker')").where("approval_requests.assigned_to_user_id = ?", assigned_to)
        else
            approval_requests.where("approval_requests.state = 0 and approval_items.id = (SELECT MAX(id) FROM approval_items temp_ai WHERE temp_ai.resource_id = foreign_workers.id and resource_type = 'ForeignWorker')").where("approval_requests.assigned_to_user_id = ?", assigned_to)
        end
    end

    def self.search_without_code(without_code)
        return all if !without_code
        where("foreign_workers.code is null")
    end
    ##

    def has_pending_transaction?
        latest_transaction_id.blank? ? false : !["CANCELLED", "CERTIFIED"].include?(latest_transaction&.status)
    end

    def monitoring?
        self.monitoring.eql?("Y")
    end

    def has_pending_transaction_registration_order?
        order_items.joins(:order).where("orders.category in (?) and orders.status in (?)", ["TRANSACTION_REGISTRATION", "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION"], ["NEW", "PENDING_PAYMENT", "PENDING_AUTHORIZATION", "PENDING"]).count > 0
    end

    def has_pending_transaction_registration_order_employer?
        order_items.joins(:order).where("orders.category in (?) and orders.status in (?) and customerable_type = 'Employer' ", ["TRANSACTION_REGISTRATION", "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION"], ["NEW", "PENDING_PAYMENT", "PENDING_AUTHORIZATION", "PENDING"]).count > 0
    end

    def pending_transaction_registration_order
        order_items.joins(:order).where("orders.category in (?) and orders.status in (?)", ["TRANSACTION_REGISTRATION", "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION"], ["NEW", "PENDING_PAYMENT", "PENDING_AUTHORIZATION", "PENDING"]).order("orders.created_at desc").first&.order
    end

    def special_renewal?
        # renew_within_3_month? or has_incomplete_transaction? or previous_transaction_unsuitable? or previous_transaction_with_blood_group_discrepancy?
        previous_transaction_unsuitable?
    end

    def conditional_renewal?
        !renew_within_x_day? and has_incomplete_transaction?
    end

    # renew within 3 months
    def renew_within_3_month?
        # transactions.where("transactions.status in (?) and transaction_date >= ?", ["CERTIFIED"], 3.months.ago.strftime("%F")).count > 0
        t = transactions.order("transactions.transaction_date desc").first  #commented by hl
        if !t
            return false
        end
        previous_transaction_unsuitable? && !previous_transaction_with_blood_group_discrepancy? && !t.certification_date.nil? && t.certification_date >= 3.months.ago && !['CANCELLED','REJECTED'].include?(t.status)   #commented by hl
    end

    # incomplete worker
    def has_incomplete_transaction?
        # transactions.where("transactions.status not in (?)", ["CERTIFIED", "CANCELLED", "CANCEL_PENDING_PAYMENT"]).count > 0
        t = transactions.order("transactions.transaction_date desc").first
        if !t
            return false
        end
        !["CERTIFIED", "CANCELLED", "CANCEL_PENDING_PAYMENT", "REVIEW", "REJECTED"].include?(t.status)
    end

    # unsuitable
    def previous_transaction_unsuitable?
        t = transactions.where("transactions.status in (?)", ["CERTIFIED"]).order("transactions.transaction_date desc").first
        if !t
            return false
        elsif t && t.final_result == "UNSUITABLE" && t.is_imm_blocked == true && t.transaction_quarantine_reasons.joins(:quarantine_reason).where("quarantine_reasons.code = ?", "10009").count > 0
            return false
        end
        t.final_result == 'UNSUITABLE'
    end

    # blood group discrepancy
    def previous_transaction_with_blood_group_discrepancy?
        t = transactions.where("transactions.status in (?)", ["CERTIFIED"]).order("transactions.transaction_date desc").first
        if t && t.final_result == "UNSUITABLE" && t.is_imm_blocked == true && t.transaction_quarantine_reasons.joins(:quarantine_reason).where("quarantine_reasons.code = ?", "10009").count > 0
            return true
        end
        return false
    end

    def previous_transaction_gender_different?
        t = transactions.order("transactions.transaction_date desc").first
        if self.gender != t.fw_gender
            return true
        end
        return false
    end

    # register within x days from registration date/examination date. x value get from system configuration TRANSACTION_EXPIRY_DAYS
    def renew_within_x_day?
        prohibited_date = DateTime.now.beginning_of_day - SystemConfiguration.find_by(code: "BLOCK_TRANSACTION_RENEWAL_WITHIN_DAYS").value.to_i.days

        t = transactions.where("date(transactions.transaction_date) > ? or (transactions.certification_date is null and transactions.medical_examination_date is not null and date(transactions.medical_examination_date) > ?)", prohibited_date, prohibited_date)
            .order("transactions.transaction_date desc").first
        if !t
            return false
        end
        !["CANCELLED", "CANCEL_PENDING_PAYMENT", "REJECTED"].include?(t.status)
    end

    def has_ignore_renewal_rule_transaction?
        t = transactions.where("transactions.status not in (?)", ["CANCELLED", "REJECTED"])
            .order("transactions.transaction_date desc").first
        if !t
            return false
        end
        t.ignore_renewal_rule == true
    end

    def has_ignore_special_renewal_rule_transaction?
        t = transactions.where("transactions.status not in (?)", ["CANCELLED", "REJECTED"])
            .order("transactions.transaction_date desc").first
        if !t
            return false
        end
        t.ignore_special_renewal_rule == true
    end

    def update_code(force_update: false)
        if !force_update and !self.code.blank?
            return
        end

        upd = {code: generate_code}
        if self.approval_status.blank?
            upd = upd.merge({
                approval_status: 'NEW_APPROVED'
            })
        end
        self.update_attributes(upd)
    end

    def generate_code
        code_gen(CODE_PREFIX, self.employer.state.code, self.name[0,1])
    end

    def is_company?
        employer_type_id == 2
    end

    def is_maid_online?
        self.maid_online.eql?('PRAON') or self.employer&.employer_type&.name === 'MAID ONLINE'
    end

    def is_recalibration?
        self.maid_online.eql?('RTK')
    end

    def programme_indicator
        indicator = nil

        case maid_online
        when "PRAON"
            indicator = 'MAID ONLINE'

        when "RTK"
            indicator = 'RECALIBRATION'

        else
            indicator = '-'
        end
    end

    def self.to_gender_code(str)
        case str.downcase
        when 'male', 'm'
            return 'M'
        when 'female', 'f'
            return 'F'
        end
    end

    def check_gender_change
        self.gender_amended_at = Time.now if (self.gender_changed? and !self.gender_was.nil? and !self.code.blank?)
    end

    def gender_change_only_once
        errors.add(:gender, "cannot change more than once, it was changed on #{gender_amended_at.strftime("%F")}") if gender_changed? and !gender_amended_at.nil?
    end

    def sync_amendment_reasons
        if saved_change_to_amendment_reasons?
            foreign_worker_amendment_reasons.where("amendment_reason_id not in (?)", (amendment_reasons || [])).destroy_all
            (amendment_reasons || []).each do |ar_id|
                foreign_worker_amendment_reasons.where("amendment_reason_id = ?", ar_id).first_or_create({
                    foreign_worker_id: id,
                    amendment_reason_id: ar_id.to_i
                })
            end
        end
    end

    def sync_transactions
        if [:code, :name, :date_of_birth, :passport_number, :country_id, :maid_online, :plks_number, :job_type_id, :pati].any?{ |key| self.saved_changes.key?(key) }

            days = (SystemConfiguration.get("LAST_X_DAYS_TO_UPDATE_TRANSACTION") || '0')

            can_sync = (days == '0' || self.latest_transaction.blank?) ? true : (self.latest_transaction&.created_at >= days.to_i.days.ago || (!self.latest_transaction.medical_examination_date.blank? && self.latest_transaction&.medical_examination_date >= days.to_i.days.ago))

            if ['NEW', 'NEW_PENDING_APPROVAL', 'EXAMINATION', 'CERTIFICATION', 'REVIEW', 'CANCEL_PENDING_PAYMENT','CERTIFIED'].include?(self.latest_transaction.try(:status)) && can_sync == true
                # do not update fw_maid_online field to RTK if latest transaction date less than 11-Jan-2021
                if(self.maid_online == 'RTK' && self.latest_transaction&.created_at < Date.parse('2021-01-11'))
                    self.latest_transaction.update({
                        fw_code: self.code,
                        fw_name: self.name,
                        fw_date_of_birth: self.date_of_birth,
                        fw_passport_number: self.passport_number,
                        fw_country_id: self.country_id,
                        fw_plks_number: self.plks_number,
                        fw_job_type_id: self.job_type_id,
                        fw_pati: self.pati
                    })
                else
                    self.latest_transaction.update({
                        fw_code: self.code,
                        fw_name: self.name,
                        fw_date_of_birth: self.date_of_birth,
                        fw_passport_number: self.passport_number,
                        fw_country_id: self.country_id,
                        fw_maid_online: self.maid_online,
                        fw_plks_number: self.plks_number,
                        fw_job_type_id: self.job_type_id,
                        fw_pati: self.pati
                    })
                end
            end
        end
        if [:gender].any?{ |key| self.saved_changes.key?(key) }
            if ['NEW', 'NEW_PENDING_APPROVAL', 'EXAMINATION', 'CANCEL_PENDING_PAYMENT'].include?(self.latest_transaction.try(:status)) && self.latest_transaction.try(:medical_examination_date).blank? && (self.latest_transaction.try(:expired_at) > Time.now || (self.latest_transaction.try(:expired_at) <= Time.now && self.latest_transaction.try(:ignore_expiry) == true))
                self.latest_transaction.update({
                    fw_gender: self.gender
                })
            end
        end
    end

    def before_save_callback
        if self.monitoring.eql?('Y')
            self.unmonitor_comment = ''
        # elsif self.monitoring.eql?('N')
        #     self.monitor_reason_id = nil
        #     self.monitor_comment = ''
        end

        self.passport_number = self.passport_number.upcase if !self.passport_number.blank?
        self.name = self.name.upcase if !self.name.blank?
    end

    def after_save_callback
        if saved_change_to_monitoring?
            if self.monitoring.eql?('Y')
                fw_monitor_logs.create({
                    monitor_reason_id: self.monitor_reason_id,
                    monitor_comment: self.monitor_comment,
                    monitor_request_by: updated_by,
                    monitor_request_at: Time.now,
                })
            elsif self.monitoring.eql?('N')
                fw_monitor_log = fw_monitor_logs.order(id: :desc).first_or_create
                fw_monitor_log.update({
                    unmonitor_comment: self.unmonitor_comment,
                    unmonitor_request_by: updated_by,
                    unmonitor_request_at: Time.now,
                })
            end
        end

        if !self.latest_transaction_id.blank?
            lt = self.latest_transaction
            latest_transaction_change_data = {}
            if saved_change_to_is_sp_transmit_blocked?
                latest_transaction_change_data[:is_sp_transmit_blocked] = self.is_sp_transmit_blocked
            end
            if saved_change_to_is_imm_blocked?
                if !self.is_imm_blocked && lt.final_result == "UNSUITABLE" && lt.is_imm_blocked && lt.transaction_quarantine_reasons.joins(:quarantine_reason).where("quarantine_reasons.code = ?", "10009").count > 0
                else
                    latest_transaction_change_data[:is_imm_blocked] = self.is_imm_blocked
                end
            end
            if latest_transaction_change_data.size > 0
                lt.assign_attributes(latest_transaction_change_data)
                lt.save(validate: false)
            end
        end
    end

    def log_changes
        # log critical field changes
        [:code, :name, :passport_number, :gender, :date_of_birth, :country_id, :status].each do |sym|
            if self.saved_changes.key?(sym)
                foreign_worker_changes.create({
                    created_by: Current.user.nil? ? nil : Current.user.id,
                    field: sym.to_s,
                    old_value: self.saved_changes[sym][0],
                    new_value: self.saved_changes[sym][1],
                })
            end
        end
    end

    def critical_fields_unique_check
        return unless passport_number_changed? || gender_changed? || date_of_birth_changed? || country_id_changed? || (status_changed? && status.eql?("ACTIVE")) || self.status.eql?("ACTIVE")

        wheres = [
            "foreign_workers.passport_number = :passport_number",
            "foreign_workers.gender = :gender",
            "foreign_workers.date_of_birth = :date_of_birth",
            "foreign_workers.country_id = :country_id",
            "foreign_workers.status = :status",
        ]
        binds = {
            passport_number: self.passport_number,
            date_of_birth: self.date_of_birth,
            country_id: self.country_id,
            gender: self.gender,
            status: "ACTIVE",
        }

        if !self.id.blank?
            wheres << "foreign_workers.id != :id"
            binds[:id] = self.id
        end

        errors.add(:base, "Exact match found based on criteria Passport No., country, date of birth, gender.") if ForeignWorker.where(wheres.join(" and "), binds).count > 0
    end

    def critical_change?
        [:name, :date_of_birth, :country_id, :passport_number, :gender].any? { |sym| changes.include?(sym) }
    end

    def gender_name
        case self.gender
        when 'f', 'F'
            "FEMALE"
        when 'm', 'M'
            "MALE"
        else
            nil
        end
    end

    def get_age_in_years
        today = Date.today

        day_month_mod =
            if today.month < date_of_birth.month
                1
            elsif today.month == date_of_birth.month
                if  today.day < date_of_birth.day
                    1
                else
                    0
                end
            else
                0
            end

        today.year - date_of_birth.year - day_month_mod
    end

    def plks_optional?
        plksno = self.plks_number.to_i || 0
        plksno > 2 and plksno % 2 == 1
    end

    def send_approval_email
        if ['UPDATE_APPROVED','UPDATE_REJECTED'].include?(approval_status) && !self.employer&.email.blank?
            EmployerMailer.with({
                foreign_worker: self,
                employer: self.employer
            }).fw_amend_email.deliver_later
        end
    end

    def persisted_transactions
        transactions.select(&:persisted?)
    end

    def renewal?
        return false unless latest_transaction

        latest_transaction.registration_type_renewal?
    end

    def strip_name
        self.name = self.name.strip
    end

    def fw_block_details
        "Block Reason: #{ block_reason&.description } on #{ blocked_at.try(:strftime, "%d/%m/%Y") }. Comments: #{ block_comment }"
    end

    def fw_monitoring_details
        fw_monitor_log  = fw_monitor_logs.where.not(monitor_request_at: nil).order(id: :desc).first
        req_date        = fw_monitor_log&.monitor_request_at&.strftime("%d/%m/%Y")
        "Monitor Reason: #{ monitor_reason&.description } on #{ req_date }. Comments: #{ monitor_comment }"
    end

    def has_pending_gender_amendment_approval?
        ['FOREIGN_WORKER_GENDER_AMENDMENT'].include?(approval_request&.category) && ['pending'].include?(approval_request&.state)
    end

    def has_pending_gender_amendment_order?
        order_items.joins(:order).where("orders.category in (?) and orders.status in (?)", ["FOREIGN_WORKER_GENDER_AMENDMENT"], ["NEW", "PENDING_PAYMENT", "PENDING_AUTHORIZATION", "PENDING"]).count > 0
    end

    def has_valid_latest_transaction_registered_by_employer?
        return false if self.id.nil? || self.code.nil?
        !latest_transaction&.is_agency_transaction? && (latest_transaction.try(:expired_at) > Time.now || (latest_transaction.try(:expired_at) <= Time.now && latest_transaction.try(:ignore_expiry) == true))
    end

    def has_valid_latest_transaction_registered_by_agency?
        latest_transaction&.is_agency_transaction? && (latest_transaction.try(:expired_at) > Time.now || (latest_transaction.try(:expired_at) <= Time.now && latest_transaction.try(:ignore_expiry) == true))
    end

    def can_do_change_employer_approval?
       fw_change_employers.where("fw_change_employers.status = 'APPROVAL'").count > 0
    end
private
    def cleanup_dob_and_arrival_date
        # Please note, this logic is coded with the assumption to compare the dates by the correct century.

        if date_of_birth?
            if date_of_birth.year < 100
                # Sometimes DOB returns as yy-mm-dd. So to add in the first 2 digits of the year, first add this year's first 2 digits infront of their dob.
                # Next, check if it's greater than the current date, if it is, will minus 100 years.
                # So for example, this person is supposed to be 1970-01-01, but it is returned as 70-01-01.
                # Using the below method, it will try to compare 2070-01-01, which will be greater, then minus 100 years to get 1970-01-01.
                # If the current year is 2020, and they get something like 01-01-01, below method will get 2001-01-01, which will not minus 100 years, and gives the correct century.
                cleaned_date        = date_of_birth.strftime("#{ Date.today.year.to_s[0..-3] }%y-%m-%d").to_date
                cleaned_date        -= 100.years if cleaned_date > Date.today
                self.date_of_birth  = cleaned_date
            elsif date_of_birth > Date.today
                # This conditional assumes that the year is somehow automatically padded somewhere else with the current year's first 2 digits. So like before, also minus 100 years to get the correct century.
                # Which means, if dob is supposed to be in 1970, but somehow is being saved as 2070, then minus 100.
                self.date_of_birth  = date_of_birth - 100.years
            end
        end

        if arrival_date?
            if arrival_date.year < 100
                cleaned_date        = arrival_date.strftime("#{ Date.today.year.to_s[0..-3] }%y-%m-%d").to_date
                cleaned_date        -= 100.years if cleaned_date > Date.today
                self.arrival_date   = cleaned_date
            elsif arrival_date > Date.today
                self.arrival_date   = arrival_date - 100.years
            end
        end
    end
end