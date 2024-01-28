class External::EmployersController < ExternalController
    include ValidateUserable
    include ApprovalAssignmentCheck
    include Watermark

    layout "external-visitor"
    skip_before_action :authenticate_external_user!, only: [:new, :create, :registered, :new_account, :create_new_account, :sign_up, :sign_up_create, :signed_up, :registration, :reregistration, :reregistration_update]

    prepend_before_action :check_captcha, only: [:sign_up_create]

    before_action :set_employer, only: [:edit, :update]
    before_action -> { validate_email_with_plus_sign(params[:email]) }, only: [:sign_up_create, :create, :update]

    # step 1 - sign up, visitor (employer) key in email
    # GET /employers/new
    def new
        @employer = Employer.new
    end

    # POST /employer_registers
    # TODO redirect to confirm page
    def create
        sign_up = SignUp.find_by(token: params[:sign_up_token])
        employer_data = employer_params
        employer_data[:email] = sign_up.email
        employer_data[:status] = "NEW"
        employer_data[:country] = Country.find_by(code: 'MYS')
        if employer_data.key?(:business_registration_number)
            employer_data[:business_registration_number] = employer_data[:business_registration_number].delete('-').strip
        end

        if employer_data[:employer_type_id] == "1"
            bank_payment_id = employer_data[:ic_passport_number]
        else
            bank_payment_id = employer_data[:business_registration_number]
        end

        @employer = Employer.new(employer_data.merge({
            bank_payment_id: bank_payment_id
        }))

        if @employer.try(:employer_type).try(:name) == 'INDIVIDUAL' && @employer.ic_passport_number.blank?
            @employer.errors.add(:ic_passport_number, "IC/Passport number is required")
        elsif @employer.try(:employer_type).try(:name) == 'COMPANY' && @employer.business_registration_number.blank?
            @employer.errors.add(:business_registration_number, "Business registration number is required")
        end

        begin
            if @employer.errors.count == 0 && @employer.save
                sign_up.sign_upable = @employer
                sign_up.save!

                params[:employer][:uploads].each do |upload|
                    if (!upload[:category].nil? && !upload[:documents].nil?)
                        add_watermark(upload[:documents])
                        upl = @employer.uploads.create(category: upload[:category])
                        upl.documents.attach(upload[:documents])
                    end
                end

                # pending for approval
                if SystemConfiguration.find_by(code: "EMPLOYER_APPROVAL").value == "1"
                    employer_register_approval_reply_days = SystemConfiguration.find_by(code: "EMPLOYER_REGISTER_APPROVAL_REPLY_DAYS").value
                    approval_assigned_to("EMPLOYER_REGISTRATION")
                    @employer.update({
                        status: "APPROVAL",
                        assigned_to: @assigned_to_user_id
                    })
                    flash.now[:dark] = "Registration is successful. Your account is pending for approval. Once approved, you will receive activation email in your registered email to activate your account."
                    EmployerMailer.with({
                        recipient: sign_up.email,
                        employer: @employer,
                        employer_register_approval_reply_days: employer_register_approval_reply_days
                    }).pending_approval_email.deliver_later
                    @activation_link = ""
                # skip approval
                else
                    @employer.update({
                        status: "ACTIVE"
                    })
                    @employer.update_code
                    user = @employer.create_user(skip_confirmation: true)
                    user.password_changed_at = (user.role.password_policy.password_expiry+1).months.ago
                    user.save
                    # sign_in(:external_user, user)
                    @activation_link = "#{ENV["APP_URL_PORTAL"]}#{user.activation_link}"
                    flash[:dark] = "Registration is successful. Please check your registered email for activation email to activate your account."
                    EmployerMailer.with({
                        recipient: sign_up.email,
                        activation_link: @activation_link,
                        employer: @employer,
                        name: @employer.name
                    }).approved_email.deliver_later
                end
            else
                flash.now[:error] = @employer.errors.full_messages.join(', ')
                render :registration and return
                # flash[:error] = @employer.errors.full_messages.join(', ')
                # redirect_to send("new_external_employer_path") and return
            end
            # /@request.save!
        rescue ActiveRecord::RecordInvalid => invalid
            flash[:error] = invalid.to_s
            redirect_to send("new_external_employer_path") and return
        end
    end

    def edit
    end

    def update
        @employer.assign_attributes(employer_params)
        if @employer.save!
            render plain: "updated"
        else
            redirect_to send("edit_external_employer_path", @employer), alert: "check inputs"
        end
    end

    def registered
        @confirm_link = "#{ENV["APP_URL_PORTAL"]}users/confirmation?confirmation_token=#{User.last.confirmation_token}"
        # render plain: "use this link to confirm user: #{@confirm_link}"
    end

    # sign up process
    def sign_up
    end

    def sign_up_create
        # Check if user already sign up and finish registration.
        email = params[:email].upcase
        user = User.find_by(email: email)
        sign_up = SignUp.find_by(email: email)

        if user
            if user.userable_type.eql?("Organization")
                flash[:error] = "Email is registered"
                redirect_to sign_up_external_employers_path, flash: {email: email} and return
            end

            # if employer account ACTIVE, ask to login
            if user.userable.status === 'ACTIVE'
                flash[:error] = "Your account already active. Please login"
                redirect_to sign_up_external_employers_path, flash: {email: email} and return
            elsif user.userable.status === 'REJECTED'
                # if employer account got rejected, ask him to contact fomema branch
                flash[:error] = "Your registration has been rejected. Please contact FOMEMA for more information."
                redirect_to sign_up_external_employers_path, flash: {email: email} and return
            else
                flash[:error] = "Employer already registered"
                redirect_to sign_up_external_employers_path, flash: {email: email} and return
            end
            # check email exist in sign up table
            # resend the confirmation email if already sign up before

            sign_up = SignUp.find_by(email: email)

        elsif sign_up
            signup_email_notification(sign_up, sign_up.token, true)
            flash[:error] = 'We have resend the confirmation email to your registered email to proceed for registration.'
            redirect_to sign_up_external_employers_path

        else
            # If user not yet sign up, we create a registration link with token
            token           = generateToken
            signup          = SignUp.find_or_create_by(email: email)
            signup.token    = token
            signup.save!
            signup_email_notification(signup, token, false)
            flash[:dark]    = "Sign up is successful. Please check your registered email for confirmation email to proceed for registration."
            flash[:token]   = token
            redirect_to signed_up_external_employers_path
        end
    end

    def signup_email_notification(signup, token, resend)
        if resend
            EmployerMailer.with({
                recipient: signup.email,
                token: token,
                url: "#{ENV["APP_URL_PORTAL"]}employers/reregistration?token=#{token}"
            }).resend_sign_up_email.deliver_later
        else
            EmployerMailer.with({
                recipient: signup.email,
                token: token,
                url: "#{ENV["APP_URL_PORTAL"]}employers/registration?token=#{token}"
            }).sign_up_email.deliver_later
        end
    end

    def generateToken

        token = SecureRandom.hex(15)

        while SignUp.where(token: token).count > 0
            token = SecureRandom.hex(15)
        end

        return token
    end

    def signed_up
        @registration_link = "#{ENV["APP_URL_PORTAL"]}employers/registration?token=#{flash[:token]}"
    end
    # /sign up process

    def registration
        # check token exist and not yet register employer
        sign_up = SignUp.find_by(token: params[:token])
        @employer = Employer.find_by({email: sign_up.email})
        if (sign_up.nil? || (!sign_up.sign_upable_id.nil? && !@employer&.code.nil?) || (!@employer.nil? && @employer.status == 'REJECTED'))
            @error = "Invalid registration"
            render "error" and return
        end
        @employer = Employer.new({email: sign_up.email})
    end

    def reregistration
        sign_up = SignUp.find_by(token: params[:token])
        @employer = Employer.find_by({email: sign_up.email})
        if (sign_up.nil? || !sign_up.sign_upable_id.nil? && !@employer.code.nil?)
            @error = "Invalid registration"
            render "error" and return
        end
        @employer = Employer.new({email: sign_up.email}) if !@employer
    end

    def reregistration_update
        sign_up = SignUp.find_by(token: params[:sign_up_token])
        employer_register_approval_reply_days = SystemConfiguration.find_by(code: "EMPLOYER_REGISTER_APPROVAL_REPLY_DAYS").value
        employer_data = employer_params
        employer_data[:status] = "NEW"
        if employer_data.key?(:business_registration_number)
            employer_data[:business_registration_number] = employer_data[:business_registration_number].delete('-').strip
        end

        if employer_data[:employer_type_id] == "1"
            employer_data[:business_registration_number] = nil
            employer_data[:pic_name] = nil
            employer_data[:pic_phone] = nil
            bank_payment_id = employer_data[:ic_passport_number]
        else
            employer_data[:ic_passport_number] = nil
            bank_payment_id = employer_data[:business_registration_number]
        end

        @employer = sign_up.sign_upable
        if (!@employer)
            employer_data[:email] = sign_up.email
            employer_data[:status] = "NEW"
            employer_data[:country] = Country.find_by(code: 'MYS')

            @employer = Employer.new(employer_data.merge({
                bank_payment_id: bank_payment_id
            }))
        end

        begin
            if @employer.update(employer_data.merge({
                bank_payment_id: bank_payment_id
            }))
                sign_up.sign_upable = @employer
                sign_up.save!

                if params[:employer][:uploads]
                    params[:employer][:uploads].each do |upload|
                        if (!upload[:category].nil? && !upload[:documents].nil?)
                            add_watermark(upload[:documents])
                            upl = @employer.uploads.create(category: upload[:category])
                            upl.documents.attach(upload[:documents])
                        end
                    end
                end

                # pending for approval
                if SystemConfiguration.find_by(code: "EMPLOYER_APPROVAL").value == "1"
                    employer_register_approval_reply_days = SystemConfiguration.find_by(code: "EMPLOYER_REGISTER_APPROVAL_REPLY_DAYS").value
                    approval_assigned_to("EMPLOYER_REGISTRATION")
                    @employer.update({
                        status: "APPROVAL"
                    })
                    @employer.update({
                        assigned_to: @assigned_to_user_id
                    }) if @employer.assigned_to.nil?

                    flash.now[:dark] = "Registration is successful. Your account is pending for approval. Once approved, you will receive activation email in your registered email to activate your account."
                    EmployerMailer.with({
                        recipient: sign_up.email,
                        employer: @employer,
                        employer_register_approval_reply_days: employer_register_approval_reply_days
                    }).pending_approval_email.deliver_later
                    @activation_link = ""
                # skip approval
                else
                    @employer.update({
                        status: "ACTIVE"
                    })
                    @employer.update_code
                    user = @employer.create_user(skip_confirmation: true)
                    user.password_changed_at = (user.role.password_policy.password_expiry+1).months.ago
                    user.save
                    # sign_in(:external_user, user)
                    @activation_link = "#{ENV["APP_URL_PORTAL"]}#{user.activation_link}"
                    flash[:dark] = "Registration is successful. Please check your registered email for activation email to activate your account."
                    EmployerMailer.with({
                        recipient: sign_up.email,
                        activation_link: @activation_link,
                        employer: @employer,
                        name: @employer.name
                    }).approved_email.deliver_later
                end
            else
                render :reregistration and return
            end
            # /@request.save!
        rescue ActiveRecord::RecordInvalid => invalid
            redirect_to send("new_internal_#{controller_name}_path"), notice: invalid.to_s
        end
    end

    private
    def employer_params
        params.require(:employer).permit(:id, :employer_type_id, :name, :business_registration_number, :ic_passport_number, :address1, :address2, :address3, :address4, :country_id, :state_id, :postcode, :town_id, :phone, :fax, :email, :pic_name, :pic_phone, :personal_data_consent, :comment, :bank_payment_id, documents: [])
    end

    def check_captcha
        unless verify_recaptcha
            render :sign_up
        end
    end

    def set_employer
        @employer = Employer.find(params[:id])
    end
end