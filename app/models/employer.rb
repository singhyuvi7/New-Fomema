class Employer < ApplicationRecord
    REQ_TYPE = '05'
    CODE_PREFIX = 'E'

    audited
    include CaptureAuthor
    include CaptureOrganization
    # mount_uploaders :documents, DocumentUploader
    include ApprovalableModel
    acts_as_approval_resource
    include SearchGeo
    include Sequence
    include GenCodeTwo
    include Sage

    STATUSES = {
        "NEW" => "New",
        "APPROVAL" => "Registration Pending For Approval",
        "UPDATE_PENDING_APPROVAL" => "Amendment Pending For Approval",
        "UPDATE_APPROVED" => "Amendment Approved",
        "UPDATE_REJECTED" => "Amendment Rejected",
        "REJECTED" => "Rejected",
        "INCOMPLETE" => "Incomplete",
        "ACTIVE" => "Active",
        "INACTIVE" => "Inactive"
    }

    DOCUMENT_TYPES = {
        "COMPANY_REGISTRATION_PAPER" => "COMPANY REGISTRATION PAPER",
        "LETTER_OF_AUTHORIZATION" => "LETTER OF AUTHORIZATION",
        "CONTACT_PERSON_NRIC" => "CONTACT PERSON NRIC",
        "CALLING_VISA_WORK_PERMIT" => "WORK PERMIT/ CALLING VISA / SMO SLIP/ APPROVAL SLIP FROM JIM",
        "CALLING_VISA_WORK_PERMIT_MAID" => "CALLING VISA / WORK PERMIT FOR APPLICATION OF FOREIGN DOMESTIC HELPER",
        "NRIC_PASSPORT" => "NRIC / PASSPORT",
        "FRONT_PASSPORT_VISIT_PASS" => "PASSPORT FRONT PAGE / VISIT PASS",
        "RTK_QUOTA_EMAIL" => "RTK QUOTA APPROVAL EMAIL",
    }

    NIOS_DOCUMENT_TYPES = {
        "COMPANY_REGISTRATION_PAPER" => "COMPANY REGISTRATION PAPER",
        "LETTER_OF_AUTHORIZATION" => "LETTER OF AUTHORIZATION",
        "CONTACT_PERSON_NRIC" => "CONTACT PERSON NRIC",
        "CALLING_VISA_WORK_PERMIT" => "CALLING VISA / WORK PERMIT",
        "CALLING_VISA_WORK_PERMIT_MAID" => "CALLING VISA / WORK PERMIT FOR APPLICATION OF FOREIGN DOMESTIC HELPER",
        "NRIC_PASSPORT" => "NRIC / PASSPORT",
        "FRONT_PASSPORT_VISIT_PASS" => "PASSPORT FRONT PAGE / VISIT PASS",
        "OTHER" => "OTHER",
    }

    INDIVIDUAL_TYPE_IDS = [
        1
    ]

    COMPANY_TYPE_IDS = [
        2
    ]

	IS_CORPORATE = {
        "Yes" => true,
        "No"  => false
	}

    belongs_to :organization, optional: true
    belongs_to :employer_type, optional: true
    belongs_to :state, optional: true
    belongs_to :town, optional: true
    belongs_to :bank, optional: true
    belongs_to :creator, class_name: 'User', optional: true, foreign_key: :created_by
    has_many :users, as: :userable, inverse_of: :userable
    has_many :employer_supplements

    has_one :sign_up, as: :sign_upable
    has_many :orders, as: :customerable
    has_many :users, as: :userable
    has_one :user,  -> { where(employer_supplement_id: nil) }, as: :userable
    has_many :supplement_users,  -> { where.not(employer_supplement_id: nil) }, class_name: "User", as: :userable
    # has_many :notifications, as: :notifiable, dependent: :destroy
    has_many :uploads, as: :uploadable
    has_many :foreign_workers
    has_many :transactions
    has_many :bank_drafts, as: :payerable
    has_many :medical_appeals, through: :transactions, inverse_of: :employer
    has_many :refunds, as: :customerable
    has_many :comment_logs, as: :commentable

    # validates :documents, file_size: { less_than_or_equal_to: 10.megabytes, message: 'Document exceeded maximum file size of 10MB' }, file_content_type: { allow: ['image/jpeg', 'image/png', 'image/jpg', 'application/pdf'], message: 'Invalid file type uploaded' }
    validates :name, :email, :employer_type_id, presence: true, if: Proc.new {|e| !e.status.eql?("INACTIVE") }
    # validates :business_registration_number, uniqueness: { scope: :employer_type_id, case_sensitive: false }, if: :is_company?
    # validates :ic_passport_number, uniqueness: { scope: :employer_type_id, case_sensitive: false }, if: :is_individual?
    # validates :email, uniqueness: { case_sensitive: false }, :if => lambda { |o| o.status != 'INACTIVE' }
    validate :email_unique
    validate :primary_id_unique

    # validate only when reject approval
    validates_presence_of :registration_comment, on: :reject_registration

    scope :get_comment_logs, -> (employer_id) {
        comment_logs = []
        comment_log = joins("LEFT JOIN comment_logs ON comment_logs.commentable_id = employers.id")
        .where("comment_logs.commentable_type = 'Employer' and comment_logs.commentable_id = ?", employer_id)
        .pluck("to_char(comment_logs.created_at, 'dd/mm/yyyy'), comment_logs.comment").map{ |e| e.join(' - ')}
        comment_logs << comment_log
        return comment_logs
    }

    scope :approval_requests, -> {
        joins("join approval_items on employers.id = approval_items.resource_id join approval_requests on approval_items.request_id = approval_requests.id and approval_items.resource_type = 'Employer'")
    }

    before_save :clean_primary_id
    after_save :after_save_callback
    after_commit :patch_finance_system, on: :update
    after_save :update_user_email, if: -> { saved_changes[:email] }

    delegate :name, to: :town, prefix: true, allow_nil: true
    delegate :name, :code, to: :state, prefix: true, allow_nil: true

    def self.search_name(name)
        return all if name.blank?
        name = name.strip
        where('employers.name ILIKE ?', "%#{name}%")
    end

    def self.search_email(email)
        return all if email.blank?
        email = email.strip
        where('employers.email ILIKE ?', "%#{email.gsub('_', '\\_')}%")
    end

    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where('employers.code = ?', "#{code}")
    end

    def self.search_code_active(code)
        return all if code.blank?
        code = code.strip
        where("employers.code = '#{code}' and employers.status='ACTIVE'" )
    end

    def self.search_state_id(state_id)
        return all if state_id.blank?
        where('employers.state_id = ?', "#{state_id}")
    end

    def self.search_roc_or_icno(icno)
        return all if icno.blank?
        icno = icno.strip
        where("employers.business_registration_number = ? OR employers.ic_passport_number = ?", "#{icno}", "#{icno}")
    end

    def self.search_roc_or_icno_active(icno)
        return all if icno.blank?
        icno = icno.strip

        joins("join transactions transactions on employers.id=transactions.employer_id")
        .where("employers.business_registration_number ='#{icno}' OR employers.ic_passport_number = '#{icno}'")
        .where("employers.status='ACTIVE'")
        .group("employers.id,employers.code")
        .order("3 desc")
        .select ("employers.id,employers.code,max(transactions.transaction_date)latest_transaction,employers.*")
    end

    def self.search_id(id)
        return all if id.blank?
        id = id.strip
        where("employers.id = ?", id)
    end

    def self.search_status(status)
        return all if status.blank?
       # where('employers.status = ?', "#{status}")
       where("employers.status ='#{status}' OR employers.approval_status='#{status}'")
    end

    def self.search_problematic(problematic)
        return all if problematic.blank?
        where('employers.problematic = ?', "#{problematic}")
    end

    def self.search_document_verified(document_verified)
        return all if document_verified.blank?
        where('employers.document_verified = ?', "#{document_verified}")
    end

    def self.search_assigned_to(assigned_to)
        return all if assigned_to.blank?
        where('employers.assigned_to = ?', "#{assigned_to}")
    end

    def self.search_request_start_date(start_date)
        return all if start_date.blank?

        approval_requests.where("approval_items.id = (SELECT MAX(id) FROM approval_items temp_ai WHERE temp_ai.resource_id = employers.id and resource_type = 'Employer')").where("approval_requests.created_at >= ?",start_date.to_date.beginning_of_day)
    end

    def self.search_request_end_date(end_date)
        return all if end_date.blank?

        date = end_date.to_date + 1.day

        approval_requests.where("approval_items.id = (SELECT MAX(id) FROM approval_items temp_ai WHERE temp_ai.resource_id = employers.id and resource_type = 'Employer')").where("approval_requests.created_at < ?",date.strftime('%Y-%m-%d'))
    end

    # def lock(user_id)
    #   self.update_columns(assigned_to: user_id)
    # end

    def create_user(skip_confirmation: nil, role_id: nil, password: nil)
        data = {
            username: code,
            name: name || code,
            email: email,
            userable: self,
            role_id: role_id.nil? ? Role.find_by(code: 'EMPLOYER').id : role_id,
            password: password.nil? ? "!aB2" + SecureRandom.hex(8) : password
        }
        user = User.new(data)

        user.skip_confirmation! if skip_confirmation
        user.save!
        return user
    end

    def update_code(force_update: false)
        if !force_update and !self.code.blank?
            return
        end

        self.update_attributes(code: generate_code)

        post_finance_system
    end

    def generate_code
        code_gen(CODE_PREFIX, self.state.code, self.name[0,1])
    end

    def is_company?
        employer_type_id == 2
    end

    def is_individual?
        [1, 3].include?(employer_type_id)
    end

    def displayed_address
        "#{ address1 } #{ address2 } #{ address3 } #{ address4 }, #{ postcode } #{ town&.name }, #{ state&.name }"
    end

    def after_save_callback
        if saved_change_to_status? && self.status.eql?("INACTIVE")
            self.user.status = 'INACTIVE'
            self.user.save(validate: false)
        elsif saved_change_to_status? && self.status.eql?("ACTIVE")
            if !self.user.nil?
                self.user.status = 'ACTIVE'
                self.user.save(validate: true)
            end
        end
    end

    def post_finance_system
        @vendor_status = 'NEW_APPROVED'
        submit_vendor (self)
    end

    def patch_finance_system
        @vendor_status = 'UPDATE_APPROVED'
        submit_vendor (self)
    end

    def update_user_email
       user = User.where(:userable_type => 'Employer',:userable_id => self.id).first
        if user.present? && user.email != self.email
            user.email = self.email
            user.save
            # user.confirm
        end
    end

    def primary_id_field
        case self.employer_type.name
        when 'INDIVIDUAL'
            :ic_passport_number
        when 'COMPANY'
            :business_registration_number
        end
    end

    def primary_id
        case self.employer_type.name
        when 'INDIVIDUAL'
            self.try(:ic_passport_number)
        when 'COMPANY'
            self.try(:business_registration_number)
        end
    end

    def email_unique
        if self.status != 'INACTIVE' && Employer.where("email ilike ? and status != 'INACTIVE'", self.email.gsub('_', '\\_')).where.not(id: self.id).count > 0
            errors.add :email, "has already been taken"
        elsif self.status != 'INACTIVE' && Agency.where("email ilike ? and status != 'INACTIVE'", self.email.gsub('_', '\\_')).count > 0
            errors.add :email, "has already been taken by agency"
        end
    end

    def primary_id_unique
        if is_company?
            if self.status != 'INACTIVE' && Employer.where("business_registration_number ilike ? and status != 'INACTIVE'", self.business_registration_number).where(employer_type: COMPANY_TYPE_IDS).where.not(id: self.id).count > 0
                errors.add :business_registration_number, "has already been taken"
            end
        elsif is_individual?
            if self.status != 'INACTIVE' && Employer.where("ic_passport_number ilike ? and status != 'INACTIVE'", self.ic_passport_number).where(employer_type: INDIVIDUAL_TYPE_IDS).where.not(id: self.id).count > 0
                errors.add :ic_passport_number, "has already been taken"
            end
        end
    end

    def clean_primary_id
        self.business_registration_number = self.business_registration_number&.gsub(/[^0-9a-zA-Z]/, '')&.upcase
        self.ic_passport_number = self.ic_passport_number&.gsub(/[^0-9a-zA-Z]/, '')&.upcase
    end

    def xqcc_letter_employer_address
        ["<b>#{ name }</b>", address1, address2, address3, address4, "#{ postcode } #{ town&.name }", state&.name].select(&:present?).join("\n")
    end

    def has_refund_with_failed_payment?
        refunds.where("refunds.status = 'PAYMENT_FAILED'").count > 0
    end

    def has_supplement_account?
        employer_supplements.where("employer_id = ?", self.id).count > 0
    end

    def has_document_uploaded?
        uploads.where("uploads.uploadable_type = 'Employer' and uploads.uploadable_id = ?", self.id).count > 0
    end

    def document_uploaded
        uploads.where("uploads.uploadable_type = 'Employer' and uploads.uploadable_id = ?", self.id)
    end

    def phone_is_mobile_with_country_code?
        !phone.blank? ? phone.strip.start_with?(*ENV['MOBILE_WITH_COUNTRY_CODE'].split(',')) : false
    end

    def phone_is_mobile_without_country_code?
        !phone.blank? ? phone.strip.start_with?(*ENV['MOBILE_WITHOUT_COUNTRY_CODE'].split(',')) : false
    end

    def pic_phone_is_mobile_with_country_code?
        !pic_phone.blank? ? pic_phone.strip.start_with?(*ENV['MOBILE_WITH_COUNTRY_CODE'].split(',')) : false
    end

    def pic_phone_is_mobile_without_country_code?
        !pic_phone.blank? ? pic_phone.strip.start_with?(*ENV['MOBILE_WITHOUT_COUNTRY_CODE'].split(',')) : false
    end
end