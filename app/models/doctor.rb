# frozen_string_literal: true

class Doctor < ApplicationRecord
    REQ_TYPE = '03'
    CODE_PREFIX = 'D'
    FP_DEVICES = {
        "1" => "Installed",
        "0" => "Not installed",
        "9" => "TEMPORARY UNAVAILABLE",
        "8" => "TEMPORARY UNAVAILABLE (UPDATED FROM BACKEND)"
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
    belongs_to :laboratory, optional: true
    belongs_to :xray_facility, optional: true
    belongs_to :state, optional: true
    belongs_to :town, optional: true
    belongs_to :bank, optional: true
    belongs_to :payment_method, optional: true
    belongs_to :country, optional: true
    belongs_to :race, optional: true

    has_one :user, as: :userable
    has_many :users, as: :userable
    has_one :operating_hour, as: :operating_hourable
    has_many :transactions
    has_many :doctor_examinations
    has_many :visit_plan_items, as: :visitable
    has_many :status_schedules, as: :status_scheduleable
    has_one :latest_status_schedule, -> { order created_at: :desc }, class_name: 'StatusSchedule', as: :status_scheduleable
    has_many :sp_group_schedules, as: :sp_schedulable
    has_many :orders, as: :customerable
    has_many :medical_appeals, inverse_of: :doctor
    has_many :bank_drafts, as: :payerable

    has_many :medical_appeals, as: :registered_by, inverse_of: :registered_by

    has_many :visit_report_doctors
    has_one  :latest_visit_report, -> { order(id: :desc) }, class_name: "VisitReportDoctor", foreign_key: "doctor_id"
    has_many :medical_appeal_assignments,         as: :user, inverse_of: :user

    # serialize :pairing_options, Hash

    # validates :name, presence: true
    # validates :icno, presence: true, uniqueness: {case_sensitive: false}
    # validates :email, presence: true, uniqueness: {case_sensitive: false}
    # validates_format_of :mobile, :with =>  /\A(\+?6?01)[0|1|2|3|4|6|7|8|9]\-*[0-9]{7,8}\Z/, :message => "Wrong Number Format"
    # validates_format_of :phone, :with =>  /\A(\+?6?01)[0|1|2|3|4|6|7|8|9]\-*[0-9]{7,8}\Z/, :message => "Wrong Number Format"
    # validates :fax, :format => { :with => /\A(\+?6?03)[0|1|2|3|4|6|7|8|9]\-*[0-9]{7,8}\Z/,:message => "Wrong Number Format"}, :allow_blank => true
    validates_format_of :apc_year, :with => /\A(19|20)\d{2}\z/, :message => "is not a valid year"

    before_create :set_country_id
    after_save :allocate_xray_facility, if: -> { saved_changes[:xray_facility_id] }
    after_save :allocate_laboratory, if: -> { saved_changes[:laboratory_id] }
    after_commit :update_finance_system
    after_save :update_user_email, if: -> { saved_changes[:email] }

    delegate :name, to: :town, prefix: true, allow_nil: true
    delegate :name, to: :state, prefix: true, allow_nil: true
    delegate :name, to: :title, prefix: true, allow_nil: true
    delegate :name, to: :district_health_office, prefix: true, allow_nil: true
    delegate :name, to: :service_provider_group, prefix: true, allow_nil: true
    delegate :name, to: :bank, prefix: true, allow_nil: true
    delegate :name, to: :payment_method, prefix: true, allow_nil: true
    delegate :name, :code, :email, :phone, :fax, :displayed_address, :address1, :address2, :address3, :address4, :postcode, :town_name, :state_name, to: :xray_facility, prefix: true, allow_nil: true
    delegate :name, :code, :email, :phone, :fax, :displayed_address, :address1, :address2, :address3, :address4, :postcode, :town_name, :state_name, to: :laboratory, prefix: true, allow_nil: true

    scope :certification_date_between, lambda { |start_date, end_date|
        includes(:transactions)
        .where(transactions: { certification_date: DateTime.parse(start_date).in_time_zone('Kuala Lumpur').beginning_of_day..DateTime.parse(end_date).in_time_zone('Kuala Lumpur').end_of_day })
    }

    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where('doctors.code = ?', "#{code}")
    end

    def self.search_name(name)
        return all if name.blank?
        name = name.strip
        where('doctors.name ILIKE ?', "%#{name}%")
    end

    def self.search_icno(icno)
        return all if icno.blank?
        icno = icno.strip
        where('doctors.icno = ?', "#{icno}")
    end

    def self.search_clinic_name(clinic_name)
        return all if clinic_name.blank?
        clinic_name = clinic_name.strip
        where('doctors.clinic_name ILIKE ?', "%#{clinic_name}%")
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
            where("exists (select 1 from orders where orders.customerable_id = doctors.id and orders.customerable_type = 'Doctor' and orders.category = 'DOCTOR_REGISTRATION' and status in ('NEW', 'PENDING_PAYMENT'))")
        when "TO_ACTIVATE"
            where("approval_status in ('NEW_APPROVED') and status in ('INACTIVE') and activated_at is NULL and exists (select 1 from orders where orders.customerable_id = doctors.id and orders.customerable_type = 'Doctor' and orders.category = 'DOCTOR_REGISTRATION' and status in ('PAID'))")
        when "REVERTED"
            where("approval_status in (?)", ["NEW_REVERTED", "UPDATE_REVERTED"])
        when "REJECTED"
            where("approval_status in (?)", ["NEW_REJECTED", "UPDATE_REJECTED"])
        end
    end

    def self.search_activated(activated)
        return all if activated.blank?
        activated = ['1', 'y', 'yes', 'true'].include?(activated.to_s.downcase)
        where("doctors.activated_at is #{activated ? 'not null' : 'null'}")
    end

    def self.search_associated_lab(laboratory_code)
        return all if laboratory_code.blank?
        laboratory_code = laboratory_code.strip
        laboratory_id = Laboratory.where(:code => laboratory_code).pluck(:id).first
        where("laboratory_id = ?",laboratory_id)
    end

    def self.search_associated_xray(xray_facility_code)
        return all if xray_facility_code.blank?
        xray_facility_code = xray_facility_code.strip
        xray_facility_id = XrayFacility.where(:code => xray_facility_code).pluck(:id).first
        where("xray_facility_id = ?",xray_facility_id)
    end

    def self.search_service_provider_group(service_provider_group_id)
        return all if service_provider_group_id.blank?
        if service_provider_group_id == '* NON GROUP'
            where(service_provider_group_id: [nil, ""])
        else
            where(service_provider_group_id: service_provider_group_id)
        end
    end

    def self.search_has_xray(has_xray)
        return all if has_xray.blank?
        if has_xray == "true"
            where("doctors.has_xray = #{has_xray}")
        else
            where("doctors.has_xray = #{has_xray} or doctors.has_xray is null")
        end
    end

    def create_user(skip_confirmation: nil, update_password: true)
        role = Role.find_by(code: 'DOCTOR')
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
        return if !force_update and !self.code.blank?

        self.update_attributes(code: generate_code)
    end

    def generate_code
        code_gen(CODE_PREFIX, self.state.code, self.name[0,1])
    end

    def set_country_id
        self.assign_attributes(country_id: Country.malaysia_id)
    end

    def xray_facility_pairing_options
        (self.pairing_options["xray_facilities"] if !self.pairing_options.nil?) || []
    end

    def laboratory_pairing_options
        (self.pairing_options["laboratories"] if !self.pairing_options.nil?) || []
    end

    def xray_facility_pairing_options_display
        names = []
        xray_facility_pairing_options.each do |xfid|
            names << XrayFacility.find(xfid)&.name
        end
        names.join(', ')
    end

    def laboratory_pairing_options_display
        names = []
        laboratory_pairing_options.each do |lid|
            names << Laboratory.find(lid)&.name
        end
        names.join(', ')
    end

    def doctor_address
        "#{ address1 } #{ address2 } #{ address3 } #{ address4 }"
    end

    def displayed_address
        "#{ address1 } #{ address2 } #{ address3 } #{ address4 }, #{ postcode } #{ town&.name }, #{ state&.name }"
    end

    def displayed_quota
        quota + quota_modifier
    end

    def available_quota
        quota - quota_used + quota_modifier - quota_pending_on_order
    end

    def available_quota_with_grace
        available_quota + 25
    end

    def quota_pending_on_order
        Order.joins("orders join order_items on orders.id = order_items.order_id").where("orders.category = 'TRANSACTION_CHANGE_DOCTOR'").where("orders.status in ('NEW', 'PENDING_APPROVAL', 'PENDING_PAYMENT')").where("(order_items.additional_information->'doctor_id')::text = ?", "#{self.id}").size
    end

    def over_quota_yes_no
        displayed_quota <= quota_used ? 'Yes' : 'No'
    end

    def quota_used_include_pending_order
        quota_used + quota_pending_on_order
    end

    def current_year_certified_worker_count
        Transaction.have_assigned_doctor(self.id).by_year('certification_date', Date.current.year).size
    end

    def status_reason_display
        Doctor::ALL_STATUS_REASONS[status_reason]
    end

    def fp_device_display
        Doctor::FP_DEVICES[fp_device.to_s]
    end

    def update_quota_used(integer)
        self.update(quota_used: quota_used + integer)
    end

    def total_transactions_for(year)
        transactions.created_by_year(year).size
    end

    def registration_order
        self.orders.where("category = 'DOCTOR_REGISTRATION'").last
    end

    def registration_paid?
        !(self.orders.where("category = 'DOCTOR_REGISTRATION' and status in ('NEW', 'PENDING_PAYMENT')").count > 0)
    end

    def biometric_device_order
        self.orders.where("category = 'DOCTOR_BIOMETRIC_DEVICE'").last
    end

    def biometric_device_paid?
        !(self.orders.where("category = 'DOCTOR_BIOMETRIC_DEVICE' and status in ('NEW', 'PENDING_PAYMENT')").count > 0)
    end

    def update_paid_biometric_device(is_paid)
        self.update({
            paid_biometric_device: is_paid,
        })
    end

    def change_address_pending_order
        self.orders.joins("join order_items on orders.id = order_items.order_id join fees on order_items.fee_id = fees.id and fees.code = 'DOCTOR_CHANGE_ADDRESS'")
        .where("orders.status in (?)", ["NEW", "PENDING_PAYMENT", "FAILED"]).first
    end

    def allocate_xray_facility
        service_provider = XrayFacility.to_s
        Allocate.create({
            doctor_id: id,
            old_allocatable_id: saved_changes[:xray_facility_id].first,
            old_allocatable_type: service_provider,
            new_allocatable_id: saved_changes[:xray_facility_id].second,
            new_allocatable_type: service_provider
        })
    end

    def allocate_laboratory
        service_provider = Laboratory.to_s
        Allocate.create({
            doctor_id: id,
            old_allocatable_id: saved_changes[:laboratory_id].first,
            old_allocatable_type: service_provider,
            new_allocatable_id: saved_changes[:laboratory_id].second,
            new_allocatable_type: service_provider
        })
    end

    def update_finance_system
        if ['NEW_APPROVED','UPDATE_APPROVED'].include?(approval_status)
            @vendor_status = approval_status
            submit_vendor (self)
        end
    end

    def update_user_email
       user = User.where(:userable_type => 'Doctor',:userable_id => self.id).first
        if user.present?
            user.email = self.email
            user.confirm
            user.save
        end
    end

    def xqcc_letter_doctor_address
        display_doc_tag = "DR. " if name[0..1] != "DR"
        ["<b>#{ display_doc_tag }#{ name } (#{ code })</b>", clinic_name, address1, address2, address3, address4, "#{ postcode } #{ town&.name }", state&.name].select(&:present?).join("\n")
    end

    def mobile_with_country_code?
        !mobile.blank? ? mobile.strip.start_with?(*ENV['MOBILE_WITH_COUNTRY_CODE'].split(',')) : false
    end

    def mobile_without_country_code?
        !mobile.blank? ? mobile.strip.start_with?(*ENV['MOBILE_WITHOUT_COUNTRY_CODE'].split(',')) : false
    end

    def amended_notifiable_doctor_address
        [ name, code, clinic_name, address1, address2, address3, address4, "#{ postcode } #{ town&.name }", state&.name].select(&:present?).join("\n")
    end
end
