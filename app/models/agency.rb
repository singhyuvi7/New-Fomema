class Agency < ApplicationRecord
    REQ_TYPE = '09'
    CODE_PREFIX = 'FA'

    audited
    include CaptureAuthor
    include CaptureOrganization
    ## mount_uploaders :documents, DocumentUploader
    include ApprovalableModel
    acts_as_approval_resource
    include SearchGeo
    include Sequence
    include GenCodeTwo
    include Sage

    STATUSES = {
        "NEW" => "New",
        "APPROVAL" => "Pending For Approval",
        "REJECTED" => "Rejected",
        "INCOMPLETE" => "Incomplete",
        "ACTIVE" => "Active",
        "INACTIVE" => "Inactive",
        "TEMPORARY_INACTIVE" => "Temporary Inactive",
    }

    DOCUMENT_TYPES = {
        # "AGREEMENT_FOMEMA_WITH_AGENT" => "AGREEMENT BETWEEN FOMEMA SDN BHD AND AGENCY",
        "COMPANY_REGISTRATION_DOCUMENT" => "COMPANY'S REGISTRATION DOCUMENT (SSM/FORM 9)",
        "FORM_49" => "COMPANY'S REGISTRATION DOCUMENT (FORM 49)",
        "LICENCE_JTKSM" => "LICENCE (JTKSM)",
        "DIRECTOR_NRIC" => "NRIC OF DIRECTOR",
        # "CONTACT_PIC_NRIC" => "NRIC OF CONTACT PERSON IN CHARGE PERFORM WORKER'S REGISTRATION",
        # "FW_AGENCY_IDENTITY_CARD" => "IDENTITY DOCUMENT ISSUED BY JTKSM",
        # "COMPANY_AUTHORIZATION_LETTER" => "COMPANY AUTHORIZATION LETTER"
    }

    NIOS_DOCUMENT_TYPES = {
        "AGREEMENT_FOMEMA_WITH_AGENT" => "AGREEMENT BETWEEN FOMEMA SDN BHD AND AGENCY",
        "COMPANY_REGISTRATION_DOCUMENT" => "COMPANY'S REGISTRATION DOCUMENT (SSM/FORM 9)",
        "FORM_49" => "COMPANY'S REGISTRATION DOCUMENT (FORM 49)",
        "LICENCE_JTKSM" => "LICENCE (JTKSM)",
        "DIRECTOR_NRIC" => "NRIC OF DIRECTOR",
        "CONTACT_PIC_NRIC" => "NRIC OF CONTACT PERSON IN CHARGE PERFORM WORKER'S REGISTRATION",
        "FW_AGENCY_IDENTITY_CARD" => "IDENTITY DOCUMENT ISSUED BY JTKSM",
        "COMPANY_AUTHORIZATION_LETTER" => "COMPANY AUTHORIZATION LETTER",
        "OTHER" => "OTHER"
    }

    belongs_to :organization, optional: true
    belongs_to :agency_license_category, optional: true
    belongs_to :state, optional: true
    belongs_to :town, optional: true
    belongs_to :bank, optional: true
    belongs_to :creator, class_name: 'User', optional: true, foreign_key: :created_by
    has_many :users, as: :userable, inverse_of: :userable
    # has_many :agency_supplements

    has_one :sign_up, as: :sign_upable
    has_many :orders, as: :customerable
    has_many :users, as: :userable
    has_one :user, as: :userable
    # has_many :supplement_users,  -> { where.not(agency_supplement_id: nil) }, class_name: "User", as: :userable
    ## has_many :notifications, as: :notifiable, dependent: :destroy
    has_many :uploads, as: :uploadable
    # has_many :foreign_workers
    has_many :transactions
    has_many :bank_drafts, as: :payerable
    has_many :refunds, as: :customerable
    has_many :comment_logs, as: :commentable

    ## validates :documents, file_size: { less_than_or_equal_to: 10.megabytes, message: 'Document exceeded maximum file size of 10MB' }, file_content_type: { allow: ['image/jpeg', 'image/png', 'image/jpg', 'application/pdf'], message: 'Invalid file type uploaded' }
    validates :name, :email, presence: true, if: Proc.new {|e| !e.status.eql?("INACTIVE") }
    ## validates :email, uniqueness: { case_sensitive: false }, :if => lambda { |o| o.status != 'INACTIVE' }
    validate :email_unique
    validate :primary_id_unique

    # validate only when reject approval
    validates_presence_of :registration_comment, on: :reject_registration

    scope :get_comment_logs, -> (agency_id) {
        comment_logs = []
        comment_log = joins("LEFT JOIN comment_logs ON comment_logs.commentable_id = agencies.id")
        .where("comment_logs.commentable_type = 'Agency' and comment_logs.commentable_id = ?", agency_id)
        .pluck("to_char(comment_logs.created_at, 'dd/mm/yyyy'), comment_logs.comment").map{ |e| e.join(' - ')}
        comment_logs << comment_log
        return comment_logs
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
        where('agencies.name ILIKE ?', "%#{name}%")
    end

    def self.search_email(email)
        return all if email.blank?
        email = email.strip
        where('agencies.email ILIKE ?', "%#{email.gsub('_', '\\_')}%")
    end

    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where('agencies.code = ?', "#{code}")
    end

    def self.search_state_id(state_id)
        return all if state_id.blank?
        where('agencies.state_id = ?', "#{state_id}")
    end

    def self.search_roc(roc_no)
        return all if roc_no.blank?
        roc_no = roc_no.strip
        where("agencies.business_registration_number = ? OR agencies.license_number = ?", "#{roc_no}", "#{roc_no}")
    end

    def self.search_id(id)
        return all if id.blank?
        id = id.strip
        where("agencies.id = ?", id)
    end

    def self.search_status(status)
        return all if status.blank?
        where('agencies.status = ?', "#{status}")
    end

    def self.search_problematic(problematic)
        return all if problematic.blank?
        where('agencies.problematic = ?', "#{problematic}")
    end

    def self.search_document_verified(document_verified)
        return all if document_verified.blank?
        where('agencies.document_verified = ?', "#{document_verified}")
    end

    def self.search_sop_acknowledge(sop_acknowledge)
        return all if sop_acknowledge.blank?
        where('agencies.sop_acknowledge = ?', "#{sop_acknowledge}")
    end

    def self.search_role(role)
        return all if role.blank?
        joins(:user).where('users.role_id = ?', "#{role}")
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
            role_id: role_id.nil? ? Role.find_by(code: 'AGENCY_UNPAID').id : role_id,
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

    def displayed_address
        "#{ address1 } #{ address2 } #{ address3 } #{ address4 }, #{ postcode } #{ town&.name }, #{ state&.name }"
    end

    def after_save_callback
        if saved_change_to_status? && (self.status.eql?("INACTIVE") || self.status.eql?("TEMPORARY_INACTIVE"))
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
        user = User.where(:userable_type => 'Agency',:userable_id => self.id).first
        if user.present? && user.email != self.email
            user.email = self.email
            user.save
            # user.confirm
        end
    end

    def primary_id_field
        :business_registration_number
    end

    def primary_id
        self.try(:business_registration_number)
    end

    def email_unique
        if self.status != 'INACTIVE' && Agency.where("email ilike ? and status != 'INACTIVE'", self.email.gsub('_', '\\_')).where.not(id: self.id).count > 0
            errors.add :email, "has already been taken"
        elsif self.status != 'INACTIVE' && Employer.where("email ilike ? and status != 'INACTIVE'", self.email.gsub('_', '\\_')).count > 0
            errors.add :email, "has already been taken by employer"
        end
    end

    def primary_id_unique
        if self.status != 'INACTIVE' && Agency.where("business_registration_number ilike ? and status != 'INACTIVE'", self.business_registration_number).where.not(id: self.id).count > 0
            errors.add :business_registration_number, "has already been taken"
        end
    end

    def clean_primary_id
        self.business_registration_number = self.business_registration_number&.gsub(/[^0-9a-zA-Z]/, '')&.upcase
    end

    def has_refund_with_failed_payment?
        refunds.where("refunds.status = 'PAYMENT_FAILED'").count > 0
    end

    # def has_supplement_account?
    #     employer_supplements.where("employer_id = ?", self.id).count > 0
    # end

    def has_created_renewal_order?
        # orders.where("orders.category = ? and date(orders.created_at) >= ? and date(orders.created_at) <= ?", 'AGENCY_RENEWAL', self.expired_at.beginning_of_day - SystemConfiguration.find_by(code: "AGENCY_RENEWAL_X_DAYS_BEFORE_EXPIRY").value.to_i.days, self.expired_at.beginning_of_day).count > 0
        self.renewal_order_created
    end

    def has_created_registration_order?
        orders.where("orders.category = ?", 'AGENCY_REGISTRATION').count > 0
    end

    def has_document_uploaded?
        uploads.where("uploads.uploadable_type = 'Agency' and uploads.uploadable_id = ?", self.id).count > 0
    end

    def document_uploaded
        uploads.where("uploads.uploadable_type = 'Agency' and uploads.uploadable_id = ?", self.id)
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