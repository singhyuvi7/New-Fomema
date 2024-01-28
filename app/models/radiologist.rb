class Radiologist < ApplicationRecord
    REQ_TYPE = '08'
    CODE_PREFIX = 'R'

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
    include ServiceProviderStatus

    belongs_to :district_health_office, optional: true
    belongs_to :title, optional: true
    belongs_to :state, optional: true
    belongs_to :town, optional: true
    belongs_to :country, optional: true
    belongs_to :race, optional: true

    has_many :transactions
    has_many :favourite_radiologists
    has_many :xray_facilities, through: :favourite_radiologists
    has_one :user, as: :userable
    has_many :users, as: :userable
    has_many :panel_radiologists
    has_many :status_schedules, as: :status_scheduleable
    has_many :orders, as: :customerable
    has_many :bank_drafts, as: :payerable
    has_many :medical_appeals, inverse_of: :radiologist

    # validates :name, presence: true
    # validates :email, presence: true, uniqueness: {case_sensitive: false}
    # validates_format_of :mobile, :with =>  /\A(\+?6?01)[0|1|2|3|4|6|7|8|9]\-*[0-9]{7,8}\Z/, :message => "Wrong Number Format"
    # validates_format_of :phone, :with =>  /\A(\+?6?01)[0|1|2|3|4|6|7|8|9]\-*[0-9]{7,8}\Z/, :message => "Wrong Number Format"
    # validates :fax, :format => { :with => /\A(\+?6?03)[0|1|2|3|4|6|7|8|9]\-*[0-9]{7,8}\Z/, :message => "Wrong Number Format" }, :allow_blank => true
    validates_format_of :apc_year, :with => /\A(19|20)\d{2}\z/, :message => "is not a valid year"

    before_create :set_country_id
    after_save :update_user_email, if: -> { saved_changes[:email] }

    delegate :name, to: :town, prefix: true, allow_nil: true
    delegate :name, to: :state, prefix: true, allow_nil: true
    delegate :name, to: :title, prefix: true, allow_nil: true
    delegate :name, to: :district_health_office, prefix: true, allow_nil: true

    scope :active, -> { where(status: 'ACTIVE') }

    def self.search_name(name)
        return all if name.blank?
        name = name.strip
        where("radiologists.name ILIKE ?", "%#{name}%")
    end

    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where("radiologists.code = ?", "#{code}")
    end

    def self.search_icno(icno)
        return all if icno.blank?
        icno = icno.strip
        where("radiologists.icno = ?", "#{icno}")
    end

    def self.search_facility_name(xray_facility_name)
        return all if xray_facility_name.blank?
        xray_facility_name = xray_facility_name.strip
        where("radiologists.xray_facility_name ILIKE ?", "%#{xray_facility_name}%")
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
            where("exists (select 1 from orders where orders.customerable_id = radiologists.id and orders.customerable_type = 'Radiologist' and orders.category = 'RADIOLOGIST_REGISTRATION' and status in ('NEW', 'PENDING_PAYMENT'))")
        when "TO_ACTIVATE"
            where("approval_status in ('NEW_APPROVED') and status in ('INACTIVE') and activated_at is NULL and exists (select 1 from orders where orders.customerable_id = radiologists.id and orders.customerable_type = 'Radiologist' and orders.category = 'RADIOLOGIST_REGISTRATION' and status in ('PAID'))")
        when "REVERTED"
            where("approval_status in (?)", ["NEW_REVERTED", "UPDATE_REVERTED"])
        when "REJECTED"
            where("approval_status in (?)", ["NEW_REJECTED", "UPDATE_REJECTED"])
        end
    end

    def self.search_activated(activated)
        return all if activated.blank?
        activated = ['1', 'y', 'yes', 'true'].include?(activated.to_s.downcase)
        where("radiologists.activated_at is #{activated ? 'not null' : 'null'}")
    end

    def create_user(skip_confirmation: nil, update_password: true)
        role = Role.find_by(code: 'RADIOLOGIST')
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

    def sync_panel_radiologists(xray_facilities)
        if xray_facilities.nil?
            xray_facilities = []
        end
        panel_radiologists.where.not(xray_facility_id: xray_facilities).delete_all
        xray_facilities.each do |xray_facility_id|
            panel_radiologists.where(xray_facility_id: xray_facility_id).first_or_create
        end
    end

    def registration_order
        self.orders.where("category = 'RADIOLOGIST_REGISTRATION'").last
    end

    def registration_paid?
        is_panel_xray_facility or !(self.orders.where("category = 'RADIOLOGIST_REGISTRATION' and status in ('NEW', 'PENDING_PAYMENT')").count > 0)
    end

    def displayed_address
        "#{ address1 } #{ address2 } #{ address3 } #{ address4 }, #{ postcode } #{ town&.name }, #{ state&.name }"
    end

    def status_reason_display
        Radiologist::ALL_STATUS_REASONS[status_reason]
    end

    def is_panel_xray_facility_yes_no
        self.is_panel_xray_facility ? "YES" : "NO"
    end

    def is_pcr_yes_no
        self.is_pcr ? "YES" : "NO"
    end

    def xray_facility_count
        xray_facilities.count
    end

    def update_user_email
        user = User.where(:userable_type => 'Radiologist', :userable_id => self.id).first
        if user.present?
            user.email = self.email
            user.confirm
            user.save
        end
    end

    def total_transactions_for(year)
        transactions.created_by_year(year).count
    end

    def total_worker_allocated
        total_transactions_for(Time.current.year)
    end
end