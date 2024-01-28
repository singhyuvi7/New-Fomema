class Laboratory < ApplicationRecord
    REQ_TYPE = '06'
    CODE_PREFIX = 'L'

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

    belongs_to :laboratory_type, optional: true
    belongs_to :district_health_office, optional: true
    belongs_to :service_provider_group, optional: true
    belongs_to :state, optional: true
    belongs_to :town, optional: true
    belongs_to :bank, optional: true
    belongs_to :payment_method, optional: true
    has_one :user, as: :userable
    has_many :users, as: :userable
    has_one :operating_hour, as: :operating_hourable
    has_many :transactions
    has_many :laboratory_examinations
    has_many :visit_plan_items, as: :visitable
    has_many :status_schedules, as: :status_scheduleable
    has_many :sp_group_schedules, as: :sp_schedulable
    has_many :orders, as: :customerable
    has_many :bank_drafts, as: :payerable
    has_many :doctors
    has_many :medical_appeals, inverse_of: :laboratory
    has_many :visit_report_laboratories

    # validates :name, :business_registration_number, :phone, :email, :address1, :state_id, :postcode, :town_id, :pic_name, :pic_phone, :laboratory_type_id, :qualification, :status, :license, :license_year, :web_service, presence: true
    # validates :business_registration_number, presence: true, uniqueness: {case_sensitive: false}
    # validates :email, presence: true, uniqueness: {case_sensitive: false}
    # validates_format_of :phone, :with =>  /\A(\+?6?01)[0|1|2|3|4|6|7|8|9]\-*[0-9]{7,8}\Z/, :message => "Wrong Number Format"
    # validates_format_of :fax, :with =>  /\A(\+?6?03)[0|1|2|3|4|6|7|8|9]\-*[0-9]{7,8}\Z/, :message => "Wrong Number Format"

    before_create :set_country_id
    after_commit :update_finance_system
    after_save :update_user_email, if: -> { saved_changes[:email] }

    delegate :name, to: :town, prefix: true, allow_nil: true
    delegate :name, to: :state, prefix: true, allow_nil: true
    delegate :name, to: :title, prefix: true, allow_nil: true
    delegate :name, to: :district_health_office, prefix: true, allow_nil: true
    delegate :name, to: :service_provider_group, prefix: true, allow_nil: true
    delegate :name, to: :bank, prefix: true, allow_nil: true
    delegate :name, to: :payment_method, prefix: true, allow_nil: true
    delegate :name, to: :laboratory_type, prefix: true, allow_nil: true

    scope :allocated, lambda {
        where(id: Doctor.pluck(:laboratory_id).compact.uniq)
    }

    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where('laboratories.code = ?', "#{code}")
    end

    def self.search_business_registration_number(business_registration_number)
        return all if business_registration_number.blank?
        business_registration_number = business_registration_number.strip
        where('laboratories.business_registration_number = ?', "#{business_registration_number}")
    end

    def self.search_name(name)
        return all if name.blank?
        name = name.strip
        where('laboratories.name ILIKE ?', "%#{name}%")
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
            where("exists (select 1 from orders where orders.customerable_id = laboratories.id and orders.customerable_type = 'Laboratory' and orders.category = 'LABORATORY_REGISTRATION' and status in ('NEW', 'PENDING_PAYMENT'))")
        when "TO_ACTIVATE"
            where("approval_status in ('NEW_APPROVED') and status in ('INACTIVE') and activated_at is NULL and exists (select 1 from orders where orders.customerable_id = laboratories.id and orders.customerable_type = 'Laboratory' and orders.category = 'LABORATORY_REGISTRATION' and status in ('PAID'))")
        when "REVERTED"
            where("approval_status in (?)", ["NEW_REVERTED", "UPDATE_REVERTED"])
        when "REJECTED"
            where("approval_status in (?)", ["NEW_REJECTED", "UPDATE_REJECTED"])
        end
    end

    def self.search_clinic_name(clinic_name)
        return all if clinic_name.blank?
        clinic_name = clinic_name.strip
        joins(:doctors).where("doctors.clinic_name ILIKE ?", "%#{clinic_name}%")
    end

    def self.search_doctor_code(doctor_code)
        return all if doctor_code.blank?
        doctor_code = doctor_code.strip
        joins(:doctors).where("doctors.code = ?", doctor_code)
    end

    def self.search_doctor_name(doctor_name)
        return all if doctor_name.blank?
        doctor_name = doctor_name.strip
        joins(:doctors).where("doctors.name ILIKE ?", "%#{doctor_name}%")
    end

    def self.search_activated(activated)
        return all if activated.blank?
        activated = ['1', 'y', 'yes', 'true'].include?(activated.to_s.downcase)
        where("laboratories.activated_at is #{activated ? 'not null' : 'null'}")
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
        role = Role.find_by(code: 'LABORATORY')
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
        self.orders.where("category = 'LABORATORY_REGISTRATION'").last
    end

    def registration_paid?
        !(self.orders.where("category = 'LABORATORY_REGISTRATION' and status in ('NEW', 'PENDING_PAYMENT')").count > 0)
    end

    def change_address_pending_order
        self.orders.joins("join order_items on orders.id = order_items.order_id join fees on order_items.fee_id = fees.id and fees.code = 'LABORATORY_CHANGE_ADDRESS'")
        .where("orders.status in (?)", ["NEW", "PENDING_PAYMENT", "FAILED"]).first
    end

    def laboratory_address
        "#{ address1 } #{ address2 } #{ address3 } #{ address4 }"
    end

    def displayed_address
        "#{ address1 } #{ address2 } #{ address3 } #{ address4 }, #{ postcode } #{ town&.name }, #{ state&.name }"
    end

    def status_reason_display
        Laboratory::ALL_STATUS_REASONS[status_reason]
    end

    def web_service_yes_no
        self.web_service ? 'YES' : 'NO'
    end

    def update_finance_system
        if ['NEW_APPROVED','UPDATE_APPROVED'].include?(approval_status)
            @vendor_status = approval_status
            submit_vendor (self)
        end
    end

    def active_gp_count
        doctors.active.size
    end

    def total_worker_allocated
        # doctors.map(&:quota_used).inject(0, &:+)
        now = Time.now
        transactions.where("transaction_date between ? and ?", now.beginning_of_year, now.end_of_year).count
    end

    def update_user_email
        user = User.where(:userable_type => 'Laboratory', :userable_id => self.id).first
        if user.present?
            user.email = self.email
            user.confirm
            user.save
        end
    end

    def self.passphrase_hash(str)
        Digest::MD5.hexdigest("#{str}$1$rasmusle$")
    end

    def self.export_invoice_to_csv(transactions, user, start_date, end_date)
        today                         = Date.today.strftime("%d/%m/%Y")
        certified_start_date          = start_date.to_date.try(:strftime, "%d/%m/%Y")
        certified_end_date            = end_date.to_date.try(:strftime, "%d/%m/%Y")
        total_male                    = transactions.pluck(:fw_gender).count("M")
        total_male_amount             = transactions.where(fw_gender: "M").map(&:amount).sum
        total_female                  = transactions.pluck(:fw_gender).count("F")
        total_female_amount           = transactions.where(fw_gender: "F").map(&:amount).sum
        total_foreign_workers         = transactions.size
        total_foreign_workers_amount  = transactions.map(&:amount).sum

        # For rows 1 - 11
        rows    = []
        rows    << ["Certified Period", "#{certified_start_date} - #{certified_end_date.present? ? certified_end_date : today}"]
        rows    << ["Generate By", user.name]
        rows    << ["Generate At", today]
        rows    << [""]
        rows    << ["", "Count", "Amount (RM)"]
        rows    << ["Male", total_male != 0 ? total_male : 0, total_male_amount != 0 ? total_male_amount : 0]
        rows    << ["Female", total_female != 0 ? total_female : 0, total_female_amount != 0 ? total_female_amount : 0]
        rows    << ["Total", total_foreign_workers, total_foreign_workers_amount]
        rows    << [""]
        rows    << [""]
        rows    << ["#", "Lab Code", "Transaction Code", "Worker Code", "Worker Name", "Gender", "Certification Date", "Amount (RM)"]

        CSV.generate(headers: true) do |csv|
            rows.each do |row|
                csv << row
            end

            transactions.each_with_index do |transaction, index|
                csv << [
                    index + 1,
                    transaction.lab_code, 
                    transaction.trans_code,
                    transaction.fw_code,
                    transaction.fw_name,
                    transaction.fw_gender == "M" ? "MALE" : "FEMALE",
                    transaction.trans_certification_date.strftime("%d/%m/%Y"),
                    transaction.amount
                ]
            end
        end
    end

    def total_transactions_for(year)
        transactions.created_by_year(year).size
    end

end
