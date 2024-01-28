class User < ApplicationRecord
    STATUSES = {
        "ACTIVE" => "Active",
        "INACTIVE" => "Inactive"
    }

    # full user types
    USERABLE_TYPES = {
        "Organization" => "FOMEMA",
        "Employer" => "EMPLOYER",
        "Doctor" => "DOCTOR",
        "Laboratory" => "LABORATORY",
        "Radiologist" => "RADIOLOGIST",
        "XrayFacility" => "X-RAY FACILITY",
        "Agency" => "AGENCY"
    }

    # for new - only organization
    USERABLE_TYPES_NEW = {
        "Organization" => "FOMEMA"
    }

    attr_writer :login
    attr_writer :login_type
    attr_writer :login_from
    attr_writer :login_user_type

    audited
    include CaptureAuthor
    acts_as_paranoid
    acts_as_approval_user

    # Include default devise modules. Others available are:
    # :lockable, :omniauthable
    devise :database_authenticatable, :registerable, :recoverable, :confirmable, :rememberable, :trackable, :password_expirable, :password_archivable, :session_limitable, :timeoutable, request_keys: [:subdomain]

    # has_many :permissions, foreign_key: "user_id", class_name: "UserPermission"

    belongs_to :userable, polymorphic: true, optional: true, inverse_of: :users
    belongs_to :role
    belongs_to :employer_supplement, optional: true
    belongs_to :title, optional: true

    has_many :user_permissions
    has_many :role_permissions,                     through: :role
    has_many :bulletin_user_view_logs
    has_many :notifications,                        as: :recipientable
    has_many :medical_mle1_reviews,                 class_name: "MedicalReview",  foreign_key: "medical_mle1_id", inverse_of: :medical_mle1
    has_many :medical_mle2_reviews,                 class_name: "MedicalReview",  foreign_key: "medical_mle2_id", inverse_of: :medical_mle2
    has_many :mle1_tcupi_reviews,                   class_name: "TcupiReview",    foreign_key: "medical_mle1_id", inverse_of: :medical_mle1
    has_many :mle2_tcupi_reviews,                   class_name: "TcupiReview",    foreign_key: "medical_mle2_id", inverse_of: :medical_mle2
    has_many :officer_of_appeals,                   class_name: "MedicalAppeal",  foreign_key: "officer_in_charge_id",    inverse_of: :officer_in_charge
    has_many :qa_by_reviews,                        class_name: "MedicalReview",  foreign_key: "qa_by",           inverse_of: :qa_by_id



    has_many :medical_appeal_comments,              class_name: "MedicalAppealComment", foreign_key: "created_by", inverse_of: :user
    has_many :appeal_mle2_approvals,                class_name: "MedicalAppealApproval", foreign_key: "medical_mle2_id", inverse_of: :medical_mle2
    has_many :medical_appeal_assignments,           as: :user, inverse_of: :user
    has_many :medical_appeals,                      as: :registered_by, inverse_of: :registered_by
    has_many :transactions_not_done,                class_name: "Transaction",    foreign_key: "not_done_officer_id", inverse_of: :not_done_officer
    has_many :xray_retakes_as_pcr,                  class_name: "XrayRetake", foreign_key: "pcr_id", inverse_of: :pcr
    has_many :transaction_result_updates,           class_name: "TransactionResultUpdate", foreign_key: "created_by", inverse_of: :user
    has_many :transaction_amendments,               class_name: "TransactionAmendment", foreign_key: "created_by", inverse_of: :user
    has_many :transaction_amendments_approved,      class_name: "TransactionAmendment", foreign_key: "approval_by", inverse_of: :approved_by

    has_many :transaction_reversions,               class_name: "TransactionReversion", foreign_key: "created_by", inverse_of: :user
    has_many :approval_approvers,                   class_name: "ApprovalApprover", foreign_key: "user_id", inverse_of: :assigned_to

    accepts_nested_attributes_for :user_permissions
    accepts_nested_attributes_for :employer_supplement

    before_create :save_callback

    # email and password validation from devise
    validates_format_of     :email, with: Devise.email_regexp, allow_blank: true, if: :will_save_change_to_email?
    validate                :email_uniqueness, if: :will_save_change_to_email? # to fit client's requirements

    validates_presence_of     :password, if: :password_required?
    validates_confirmation_of :password, if: :password_required?
    validates_length_of       :password, within: Devise.password_length, allow_blank: true

    validate :password_complexity
    validates :username, presence: true, uniqueness: { case_sensitive: false }
    validates :role_id, presence: true
    # validates :group_id, presence: true

    def login
        @login
    end

    def login_type
        @login_type
    end

    def login_from
        @login_from
    end

    def login_user_type
        @login_user_type
    end

    def self.find_for_authentication(warden_conditions)
        @subdomain = warden_conditions[:subdomain].upcase
        # @subdomain.sub!('-LOCAL', '-UAT')
        #external login page - employer
        if warden_conditions[:login_from] == "ext_employer_login"
            if warden_conditions[:login_type] == "Email"
                current_user = where("LOWER(email) = ?", warden_conditions[:login].strip.downcase).where(role_id: Role.where(site: @subdomain), userable_type: ['Employer']).first
            elsif warden_conditions[:login_type] == "Code"
                current_user = where("username = ?", warden_conditions[:login].strip.upcase).where(role_id: Role.where(site: @subdomain), userable_type: ['Employer']).first
            end

        #external login page - agency
        elsif warden_conditions[:login_from] == "ext_agency_login"
            if warden_conditions[:login_type] == "Email"
                current_user = where("LOWER(email) = ?", warden_conditions[:login].strip.downcase).where(role_id: Role.where(site: @subdomain), userable_type: ['Agency']).first
            elsif warden_conditions[:login_type] == "Code"
                current_user = where("username = ?", warden_conditions[:login].strip.upcase).where(role_id: Role.where(site: @subdomain), userable_type: ['Agency']).first
            end

        #internal login page - nios
        elsif warden_conditions[:login_from] == "int_employer_login"
            if warden_conditions[:login_type] == "Email"
                current_user = where("LOWER(email) = ?", warden_conditions[:login].strip.downcase).where(role_id: Role.where(site: @subdomain)).first
            elsif warden_conditions[:login_type] == "Code"
                current_user = where("username = ?", warden_conditions[:login].strip.upcase).where(role_id: Role.where(site: @subdomain)).first
            end

        #sp-login page - service provider
        elsif warden_conditions[:login_from] == "ext_sp_login"
            if warden_conditions[:login_type] == "Email"
                current_user = where("LOWER(email) = ?", warden_conditions[:login].strip.downcase).where(role_id: Role.where(site: @subdomain), userable_type: ['Doctor','Laboratory','Radiologist','XrayFacility']).first
            elsif warden_conditions[:login_type] == "Code"
                current_user = where("username = ?", warden_conditions[:login].strip.upcase).where(role_id: Role.where(site: @subdomain), userable_type: ['Doctor','Laboratory','Radiologist','XrayFacility']).first
            end
        end
    end

    def active_for_authentication?
        #remember to call the super
        #then put our own check to determine "active" state using
        #our own "is_active" column
        super and self.status.eql?("ACTIVE")
    end

    # A callback method used to deliver confirmation
    # instructions on creation. This can be overriden
    # in models to map to a nice sign up e-mail.
    def send_on_create_confirmation_instructions
        # if self.userable_type == 'Employer'
        #   return
        # end
        send_confirmation_instructions
    end

    def sync_user_permissions(permissions)
        if permissions.nil?
            permissions = []
        end
        UserPermission.where(user_id: id).where.not(permission: permissions).delete_all
        permissions.each do |perm|
            UserPermission.where(user_id: id).where(permission: perm).first_or_create
        end
    end

    def current_permissions
        if (!defined? @permissions)
            @permissions = user_permissions.pluck(:permission)
        end
        @permissions
    end

    def has_all_permission?(permissions)
        permissions.each do |permission|
            if !current_permissions.include? permission
                return false
            end
        end
        true
    end

    def self.expire_password_after
        password_policy = Current.user.try(:role).try(:password_policy)
        password_policy.try(:password_expiry).eql?(0) ? false : try(:months)
    end

    def deny_old_passwords
        password_policy = self.try(:role).try(:password_policy)
        password_policy.try(:block_previous_password)
    end

    def expire_password
        self.need_change_password! if true
    end

    def password_complexity
        password_policy = role.password_policy

        error_arrs = ["at least #{password_policy.minimum_length} character"]
        alphabets = password_policy.require_alphabet? ? '(?=.*?[a-z])' : ''
        # alphabets_error = "1 lowercase," unless alphabets.eql?('')
        if (!alphabets.eql?(''))
            error_arrs << "at least 1 lowercase"
        end
        numeric = password_policy.require_numeric? ? '(?=.*?[0-9])' : ''
        # numeric_error = "1 digit and" unless numeric.eql?('')
        if (!numeric.eql?(''))
            error_arrs << "at least 1 digit"
        end
        special_characters = password_policy.require_special_characters? ? '(?=.*?[#?!@$%^&*-])' : ''
        # special_characters_error = "1 special character" unless special_characters.eql?('')
        if (!special_characters.eql?(''))
            error_arrs << "at least 1 special character"
        end
        small_and_caps = password_policy.require_small_and_capital? ? '(?=.*?[A-Z])(?=.*?[a-z])' : ''
        # small_and_caps_error = small_and_caps.eql?('') ?  alphabets_error : "1 uppercase, 1 lowercase,"
        if (!small_and_caps.eql?(''))
            error_arrs << "mix of lowercase and uppercase"
        end
        alpha = small_and_caps.eql?('') ? alphabets : small_and_caps

        regex = /^#{alpha}#{numeric}#{special_characters}.{#{password_policy.minimum_length},}$/
        return if password.blank? || password =~ regex

        # errors.add :password, "Complexity requirement not met. Length should be at least #{password_policy.minimum_length} characters and include: #{small_and_caps_error} #{numeric_error} #{special_characters_error}"
        errors.add :password, error_arrs.join(", ")
    end

    # generate array of password requirements
    # formatting is controlled by the method caller

    def password_requirements
        password_policy = role.password_policy
        requirements = []
        requirements.push("Password must have at least #{password_policy.minimum_length} characters")

        if password_policy.require_alphabet
            requirements.push("Password must have at least one alphabet character")
        end

        if password_policy.require_numeric
            requirements.push("Password must have at least one numeric character")
        end

        if password_policy.require_special_characters
            requirements.push("Password must have at least one special characters")
        end

        if password_policy.require_small_and_capital
            requirements.push("Password must have at least one capital letter and one small letter")
        end

        if password_policy.password_expiry
            requirements.push("Password must change every #{password_policy.password_expiry} month")
        end

        return requirements
    end

    # email must be unique for a given site (`roles`.`sites`) and code (`users`.`code`)
    def email_uniqueness
        return unless User.joins(:role).where(email: email, code: code).where(roles: { site: role.site }).exists?
        errors.add :email, 'has already been taken'
    end

    # activation
    def create_activation_token
        self.activation_token = SecureRandom.hex(15)
        self.save!
        #TODO send token by email
    end

    def activation_link
        if self.activation_token.nil? || self.activation_token.empty?
            create_activation_token
        end
        "users/activate?activation_token=#{self.activation_token}"
    end
    # /activation

    # permissions
    def sync_user_permissions(permissions)
        if permissions.nil?
            permissions = []
        end
        UserPermission.where(user_id: id).where.not(permission: permissions).delete_all
        permissions.each do |perm|
            UserPermission.where(user_id: id).where(permission: perm).first_or_create
        end
    end

    def current_permissions
        user_permissions.pluck(:permission)
    end
    # /permissions

    # search/filter
    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where('users.code ilike ?', "%#{code}%")
    end

    def self.search_name(name)
        return all if name.blank?
        name = name.strip
        where('users.name ILIKE ?', "%#{name}%")
    end

    def self.search_username(username)
        return all if username.blank?
        username = username.strip
        where('users.username ilike ?', "%#{username}%")
    end

    def self.search_email(email)
        return all if email.blank?
        email = email.strip
        where('users.email ilike ?', "%#{email}%")
    end

    def self.search_role(role)
        return all if role.blank?
        where('users.role_id in (?)', "#{role}")
    end

    def self.search_status(status)
        return all if status.blank?
        where('users.status = ?', "#{status}")
    end

    def self.search_permission(permission)
        return all if permission.blank?
        permission = permission.strip
        where("exists (select 1 from role_permissions where role_permissions.role_id = users.role_id and role_permissions.permission = ?) or exists (select 1 from user_permissions where user_id = users.id and user_permissions.permission = ?)", permission, permission)
    end
    # /search/filter

    def self.system_user
        where("lower(email) = ?", "noreply@fomema.com.my").first
    end

    def self.admin_user
        where("lower(email) = ?", "itsupport@fomema.com.my").first
    end

    # scopes
    scope :active, -> {where("users.status = 'ACTIVE'")}

    scope :role_code, -> role_code { joins(:role).where(roles: { code: role_code }) }

    scope :pcr_role, -> { joins(:role).where(roles: { code: 'PCR' }) }

    scope :except_user, -> user_id { where.not(id: user_id) }

    scope :appeal_users, -> { joins(:role_permissions).where(role_permissions: { permission: "EDIT_APPEAL_TODO" }) }
    # end of scopes

    def notification_count
        notifications.count
    end

    # From Joey
    # Overrides the devise method session_limitable so that users can login to the same account in multiple browsers.
    # This works by preventing the super whenever unique_session_id method is called, as that column is only used by Devise.
    # Ref => https://stackoverflow.com/questions/57007719/how-to-apply-session-limitable-at-a-specific-user-devise-security
    def respond_to?(method_name, include_private = false)
        if method_name.to_s == "unique_session_id" && self.session_limitable_disabled
            false
        else
            super
        end
    end

    def bulletins
        Bulletin.filter_date_and_audiences(userable_type, userable.id)
    end

    def obfuscated_email
        s = self.email.split('@')
        "#{s[0][0..2]}#{(s[0][3..-1])&.gsub(/[a-zA-Z0-9]/, '*')}@#{s[1][0..2]}#{s[1][3..-1]&.gsub(/[a-zA-Z0-9]/, '*')}"
    end

    private
    def save_callback
        # if !self.code.nil?
        #   self.username = self.code
        # elsif !self.email.nil?
        #   self.username = self.email
        # end
        if self.code.nil?
            self.code = self.username || self.email
        end
        if self.username.nil?
            self.username = self.code || self.email
        end
    end

    protected
    def password_required?
        return false unless confirmed?

        !persisted? || !password.nil? || !password_confirmation.nil?
    end
end