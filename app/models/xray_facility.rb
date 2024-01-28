class XrayFacility < ApplicationRecord
    REQ_TYPE = '07'
    CODE_PREFIX = 'X'

    FP_DEVICES = {
        "1" => "Installed",
        "0" => "Not installed",
        "9" => "TEMPORARY UNAVAILABLE",
        "8" => "TEMPORARY UNAVAILABLE (UPDATED FROM BACKEND)"
    }

    FILM_TYPES = {
        "DIGITAL" => "Digital",
        "ANALOG" => "Physical / Analog"
    }

    DOCUMENT_TYPES = {
        "XRAY_LICENSE" => "XRAY LICENSE",
        "LAMPIRAN_A" => "LAMPIRAN A",
    }

    FILTER_STATUSES = {
        "ACTIVE" => "Active",
        "INACTIVE" => "Inactive",
        "TEMPORARY_INACTIVE" => "Temporary Inactive",
        "DRAFT" => "Draft",
        "APPROVAL" => "Pending For Approval",
        "APPROVAL2" => "To Concur",
        "PENDING_PAYMENT" => "Pending For Payment",
        "TO_ACTIVATE" => "To Activate",
        "REVERTED" => "Reverted",
        "REJECTED" => "Rejected"
    }

    audited
    include CaptureAuthor
    include ApprovalableModel
    acts_as_approval_resource
    include SearchGeo
    include Sequence
    include GenCodeTwo
    include FilterScope
    include RecordStatus
    include ServiceProviderStatus
    include Sage
    include SuspensionHistory

    belongs_to :service_provider_group, optional: true
    belongs_to :district_health_office, optional: true
    belongs_to :title, optional: true
    belongs_to :state, optional: true
    belongs_to :town, optional: true
    belongs_to :bank, optional: true
    belongs_to :payment_method, optional: true
    belongs_to :country, optional: true
    belongs_to :race, optional: true

    has_many :transactions
    # has_and_belongs_to_many :radiologists
    has_many :favourite_radiologists
    has_many :radiologists, through: :favourite_radiologists
    has_one :user, as: :userable
    has_many :users, as: :userable
    has_one :operating_hour, as: :operating_hourable
    has_many :visit_plan_items, as: :visitable
    has_many :panel_radiologists
    has_many :status_schedules, as: :status_scheduleable
    has_many :sp_group_schedules, as: :sp_schedulable
    has_many :orders, as: :customerable
    has_many :medical_appeals, inverse_of: :xray_facility
    has_many :bank_drafts, as: :payerable
    has_many :doctors
    has_many :visit_report_xray_facilities
    has_many :visit_reports, as: :visitable
    has_many :uploads, as: :uploadable
    # validates :name, presence: true
    # validates :email, presence: true, uniqueness: {case_sensitive: false}
    # validates_format_of :mobile, :with =>  /\A(\+?6?01)[0|1|2|3|4|6|7|8|9]\-*[0-9]{7,8}\Z/, :message => "Wrong Number Format"
    # validates_format_of :phone, :with =>  /\A(\+?6?01)[0|1|2|3|4|6|7|8|9]\-*[0-9]{7,8}\Z/, :message => "Wrong Number Format"
    # validates :fax, :format => { :with => /\A(\+?6?03)[0|1|2|3|4|6|7|8|9]\-*[0-9]{7,8}\Z/, :message => "Wrong Number Format" }, :allow_blank => true
    validates_format_of :apc_year, :with => /\A(19|20)\d{2}\z/, :message => "is not a valid year"

    before_create :set_country_id
    after_commit :update_finance_system
    after_save :update_user_email, if: -> { saved_changes[:email] }
    after_save :update_license_status, if: -> { saved_changes[:xray_license_expiry_date] }

    delegate :name, to: :town, prefix: true, allow_nil: true
    delegate :name, to: :state, prefix: true, allow_nil: true
    delegate :name, to: :title, prefix: true, allow_nil: true
    delegate :name, to: :district_health_office, prefix: true, allow_nil: true
    delegate :name, to: :service_provider_group, prefix: true, allow_nil: true
    delegate :name, to: :bank, prefix: true, allow_nil: true
    delegate :name, to: :payment_method, prefix: true, allow_nil: true

    scope :allocated, lambda {
        where(id: Doctor.pluck(:xray_facility_id).compact.uniq)
    }

    scope :xray_license_approval_requests, -> {
        joins("join approval_items on xray_facilities.id = approval_items.resource_id join approval_requests on approval_items.request_id = approval_requests.id and approval_items.resource_type = 'XrayFacility'")
        .where("approval_requests.category = 'XRAY_FACILITY_LICENSE_EXPIRY_AMENDMENT'")
    }

    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where('xray_facilities.code = ?', "#{code}")
    end

    def self.search_name(name)
        return all if name.blank?
        name = name.strip
        where('xray_facilities.name ILIKE ?', "%#{name}%")
    end

    def self.search_license_holder_name(license_holder_name)
        return all if license_holder_name.blank?
        license_holder_name = license_holder_name.strip
        where('xray_facilities.license_holder_name ILIKE ?', "%#{license_holder_name}%")
    end

    def self.search_status(status)
        return all if status.blank?
        case status
        when "ACTIVE", "INACTIVE", "TEMPORARY_INACTIVE"
            where("status = ?", status)
        when "DRAFT"
            where("approval_status in (?)", ["NEW_DRAFT", "UPDATE_DRAFT"])
        when "APPROVAL"
            where("approval_status in (?)", ["NEW_PENDING_APPROVAL", "UPDATE_PENDING_APPROVAL"])
        when "APPROVAL2"
            where("approval_status in (?)", ["NEW_PENDING_APPROVAL2", "UPDATE_PENDING_APPROVAL2"])
        when "PENDING_PAYMENT"
            where("exists (select 1 from orders where orders.customerable_id = xray_facilities.id and orders.customerable_type = 'XrayFacility' and orders.category = 'XRAY_FACILITY_REGISTRATION' and status in ('NEW', 'PENDING_PAYMENT'))")
        when "TO_ACTIVATE"
            where("approval_status in ('NEW_APPROVED') and status in ('INACTIVE') and activated_at is NULL and exists (select 1 from orders where orders.customerable_id = xray_facilities.id and orders.customerable_type = 'XrayFacility' and orders.category = 'XRAY_FACILITY_REGISTRATION' and status in ('PAID'))")
        when "REVERTED"
            where("approval_status in (?)", ["NEW_REVERTED", "UPDATE_REVERTED"])
        when "REJECTED"
            where("approval_status in (?)", ["NEW_REJECTED", "UPDATE_REJECTED"])
        end
    end

    def self.search_clinic_name(clinic_name)
        return all if clinic_name.blank?
        clinic_name = clinic_name.strip
        joins(:doctors).where("Doctors.clinic_name ILIKE ?", "%#{clinic_name}%")
    end

    def self.search_doctor_code(doctor_code)
        return all if doctor_code.blank?
        doctor_code = doctor_code.strip
        joins(:doctors).where("Doctors.code = ?", doctor_code)
    end

    def self.search_doctor_name(doctor_name)
        return all if doctor_name.blank?
        doctor_name = doctor_name.strip
        joins(:doctors).where("Doctors.name ILIKE ?", "%#{doctor_name}%")
    end

    def self.search_activated(activated)
        return all if activated.blank?
        activated = ['1', 'y', 'yes', 'true'].include?(activated.to_s.downcase)
        where("xray_facilities.activated_at is #{activated ? 'not null' : 'null'}")
    end

    def self.search_icno(icno)
        return all if icno.blank?
        icno = icno.strip
        where('xray_facilities.icno = ?', icno)
    end

    def self.search_service_provider_group(service_provider_group_id)
        return all if service_provider_group_id.blank?
        if service_provider_group_id == '* NON GROUP'
            where(service_provider_group_id: [nil, ""])
        else
            where(service_provider_group_id: service_provider_group_id)
        end
    end

    def create_user(skip_confirmation: nil, update_password: true)
        role = Role.find_by(code: 'XRAY_FACILITY')
        data = {
            username: self.code.upcase,
            name: name || code,
            email: self.email,
            userable: self,
            role_id: role.id,
            password: "!aB2" + SecureRandom.hex(8)
        }
        data[:password_changed_at] = (role.password_policy.password_expiry+1).months.ago if update_password
        user = User.new(data)

        user.skip_confirmation! if skip_confirmation
        user.save!
    end

    def activate
        self.update_attributes({
            status: "ACTIVE",
            activated_at: DateTime.now
        })
    end

    def update_code(force_update: false)
        if !force_update and !self.code.blank?
            return
        end

        self.update_attributes(code: generate_code)
    end

    def generate_code
        code_gen(CODE_PREFIX, self.state.code, self.name[0,1])
    end

    def set_country_id
        self.assign_attributes(country_id: Country.malaysia_id)
    end

    def registration_order
        self.orders.where("category = 'XRAY_FACILITY_REGISTRATION'").last
    end

    def registration_paid?
        !(self.orders.where("category = 'XRAY_FACILITY_REGISTRATION' and status in ('NEW', 'PENDING_PAYMENT')").count > 0)
    end

    def biometric_device_order
        self.orders.where("category = 'XRAY_FACILITY_BIOMETRIC_DEVICE'").last
    end

    def biometric_device_paid?
        !(self.orders.where("category = 'XRAY_FACILITY_BIOMETRIC_DEVICE' and status in ('NEW', 'PENDING_PAYMENT')").count > 0)
    end

    def update_paid_biometric_device(is_paid)
        self.update({
            paid_biometric_device: is_paid,
        })
    end

    def change_address_pending_order
        self.orders.joins("join order_items on orders.id = order_items.order_id join fees on order_items.fee_id = fees.id and fees.code = 'XRAY_FACILITY_CHANGE_ADDRESS'")
        .where("orders.status in (?)", ["NEW", "PENDING_PAYMENT", "FAILED"]).first
    end

    def xray_facility_address
        "#{ address1 } #{ address2 } #{ address3 } #{ address4 }"
    end

    def displayed_address
        "#{ address1 } #{ address2 } #{ address3 } #{ address4 }, #{ postcode } #{ town&.name }, #{ state&.name }"
    end

    def status_reason_display
        XrayFacility::ALL_STATUS_REASONS[status_reason]
    end

    def doctors_count(active: false)
        active ? doctors.active.size : doctors.size
    end

    def total_worker_allocated
        # doctors.map(&:quota_used).inject(0, &:+)
        now = Time.now
        transactions.where("transaction_date between ? and ?", now.beginning_of_year, now.end_of_year).count
    end

    def total_worker_allocated_by_provider
        now = Time.now
        transactions.where("transaction_date between ? and ?", now.beginning_of_year, now.end_of_year)
        .where("digital_xray_provider_id is not null")
        .group(:digital_xray_provider_id)
        .count
        .sort_by{|provider, count| provider}
    end

    def total_worker_allocated_last_year_by_provider
        now = Time.now
        transactions.where("transaction_date between ? and ?", now.last_year.beginning_of_year, now.last_year.end_of_year)
        .where("digital_xray_provider_id is not null")
        .group(:digital_xray_provider_id)
        .count
        .sort_by{|provider, count| provider}
    end

    def update_finance_system
        if ['NEW_APPROVED','UPDATE_APPROVED'].include?(approval_status)
            @vendor_status = approval_status
            submit_vendor (self)
        end
    end

    def update_user_email
       user = User.where(:userable_type => 'XrayFacility',:userable_id => self.id).first
        if user.present?
            user.email = self.email
            user.confirm
            user.save
        end
    end

    def total_transactions_for(year)
        transactions.created_by_year(year).size
    end

    def update_license_status
        if self.xray_license_expiry_date < Date.today
            self.update({
                moh_license_status: 'INVALID'
            })
        end

        if self.xray_license_expiry_date >= Date.today
            self.update({
                moh_license_status: 'VALID'
            })
        end
    end

    def xqcc_letter_xray_address
        ["<b>#{ license_holder_name }<br>#{ code }</b>","<b>#{name}</b>", address1, address2, address3, address4, "#{ postcode } #{ town&.name }", state&.name].select(&:present?).join("\n")
    end

    def mobile_with_country_code?
        !mobile.blank? ? mobile.strip.start_with?(*ENV['MOBILE_WITH_COUNTRY_CODE'].split(',')) : false
    end

    def mobile_without_country_code?
        !mobile.blank? ? mobile.strip.start_with?(*ENV['MOBILE_WITHOUT_COUNTRY_CODE'].split(',')) : false
    end

    def amended_notifiable_xray_address
        [license_holder_name, code, name, address1, address2, address3, address4, "#{ postcode } #{ town&.name }", state&.name].select(&:present?).join("\n")
    end
end