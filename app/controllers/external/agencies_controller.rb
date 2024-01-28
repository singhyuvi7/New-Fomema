class External::AgenciesController < ExternalController
        include ValidateUserable
        include Watermark

        layout "external-visitor"
        skip_before_action :authenticate_external_user!, only: [:new, :create, :registered, :new_account, :create_new_account, :sign_up, :sign_up_create, :signed_up, :registration, :reregistration, :reregistration_update, :agency_agreement]

        prepend_before_action :check_captcha, only: [:sign_up_create]

        before_action :set_agency, only: [:edit, :update]
        before_action -> { validate_email_with_plus_sign(params[:email]) }, only: [:sign_up_create, :create, :update]

        # step 1 - sign up, visitor (agency) key in email
        # GET /agencies/new
        def new
            @agency = Agency.new
        end

        # POST /agency_registers
        # TODO redirect to confirm page
        def create
            sign_up = SignUp.find_by(token: params[:sign_up_token])
            agency_data = agency_params
            agency_data[:email] = sign_up.email
            agency_data[:status] = "NEW"
            agency_data[:country] = Country.find_by(code: 'MYS')
            organization = Organization.find_by(code: 'PT')
            agency_data[:organization_id] = organization.id
            if agency_data.key?(:business_registration_number)
                agency_data[:business_registration_number] = agency_data[:business_registration_number].delete('-').strip
            end

            bank_payment_id = agency_data[:business_registration_number]

            @agency = Agency.new(agency_data.merge({
                bank_payment_id: bank_payment_id
            }))

            begin
                if @agency.save
                    sign_up.sign_upable = @agency
                    sign_up.save!

                    params[:agency][:uploads].each do |upload|
                        if (!upload[:category].nil? && !upload[:documents].nil?)
                            add_watermark(upload[:documents])
                            upl = @agency.uploads.create(category: upload[:category])
                            upl.documents.attach(upload[:documents])
                        end
                    end

                    # pending for approval
                    if SystemConfiguration.find_by(code: "AGENCY_APPROVAL").value == "1"
                        agency_register_approval_reply_days = SystemConfiguration.find_by(code: "AGENCY_REGISTER_APPROVAL_REPLY_DAYS").value
                        @agency.update({
                            status: "APPROVAL"
                        })
                        flash.now[:dark] = "Registration is successful. Your account is pending for approval. Once approved, you will receive activation email in your registered email to activate your account."
                        AgencyMailer.with({
                            recipient: sign_up.email,
                            agency: @agency,
                            agency_register_approval_reply_days: agency_register_approval_reply_days
                        }).pending_approval_email.deliver_later
                        @activation_link = ""
                    # skip approval
                    else
                        @agency.update({
                            status: "ACTIVE"
                        })
                        @agency.update_code
                        user = @agency.create_user(skip_confirmation: true)
                        user.password_changed_at = (user.role.password_policy.password_expiry+1).months.ago
                        user.save
                        # sign_in(:external_user, user)
                        @activation_link = "#{ENV["APP_URL_PORTAL"]}#{user.activation_link}"
                        flash[:dark] = "Registration is successful. Please check your registered email for activation email to activate your account."
                        AgencyMailer.with({
                            recipient: sign_up.email,
                            activation_link: @activation_link,
                            agency: @agency,
                            name: @agency.name
                        }).approved_email.deliver_later
                        create_registration_order(@agency, user)
                    end
                else
                    flash.now[:error] = @agency.errors.full_messages.join(', ')
                    render :registration and return
                    # flash[:error] = @agency.errors.full_messages.join(', ')
                    # redirect_to send("new_external_employer_path") and return
                end
                # /@request.save!
            rescue ActiveRecord::RecordInvalid => invalid
                flash[:error] = invalid.to_s
                redirect_to send("new_external_agency_path") and return
            end
        end

        def edit
        end

        def update
            @agency.assign_attributes(agency_params)
            if @agency.save!
                render plain: "updated"
            else
                redirect_to send("edit_external_agency_path", @agency), alert: "check inputs"
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
                    redirect_to sign_up_external_agencies_path, flash: {email: email} and return
                end

                # if agency account ACTIVE, ask to login
                if user.userable.status === 'ACTIVE'
                    flash[:error] = "Your account already active. Please login"
                    redirect_to sign_up_external_agencies_path, flash: {email: email} and return
                elsif user.userable.status === 'REJECTED'
                    # if agency account got rejected, ask him to contact fomema branch
                    flash[:error] = "Your registration has been rejected. Please contact FOMEMA for more information."
                    redirect_to sign_up_external_agencies_path, flash: {email: email} and return
                else
                    flash[:error] = "Agency already registered"
                    redirect_to sign_up_external_agencies_path, flash: {email: email} and return
                end
                # check email exist in sign up table
                # resend the confirmation email if already sign up before

                sign_up = SignUp.find_by(email: email)

            elsif sign_up
                signup_email_notification(sign_up, sign_up.token, true)
                flash[:error] = 'We have resend the confirmation email to your registered email to proceed for registration.'
                redirect_to sign_up_external_agencies_path

            else
                # If user not yet sign up, we create a registration link with token
                token           = generateToken
                signup          = SignUp.find_or_create_by(email: email)
                signup.token    = token
                signup.save!
                signup_email_notification(signup, token, false)
                flash[:dark]    = "Sign up is successful. Please check your registered email for confirmation email to proceed for registration."
                flash[:token]   = token
                redirect_to signed_up_external_agencies_path
            end
        end

        def signup_email_notification(signup, token, resend)
            if resend
                AgencyMailer.with({
                    recipient: signup.email,
                    token: token,
                    url: "#{ENV["APP_URL_PORTAL"]}agencies/reregistration?token=#{token}"
                }).resend_sign_up_email.deliver_later
            else
                AgencyMailer.with({
                    recipient: signup.email,
                    token: token,
                    url: "#{ENV["APP_URL_PORTAL"]}agencies/registration?token=#{token}"
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
            @registration_link = "#{ENV["APP_URL_PORTAL"]}agencies/registration?token=#{flash[:token]}"
        end
        # /sign up process

        def registration
            # check token exist and not yet register agency
            sign_up = SignUp.find_by(token: params[:token])
            @agency = Agency.find_by({email: sign_up.email})
            if (sign_up.nil? || (!sign_up.sign_upable_id.nil? && !@agency&.code.nil?) || (!@agency.nil? && @agency.status == 'REJECTED'))
                @error = "Invalid registration"
                render "error" and return
            end
            @agency = Agency.new({email: sign_up.email})
        end

        def reregistration
            sign_up = SignUp.find_by(token: params[:token])
            @agency = Agency.find_by({email: sign_up.email})
            if (sign_up.nil? || !sign_up.sign_upable_id.nil? && !@agency.code.nil?)
                @error = "Invalid registration"
                render "error" and return
            end
            @agency = Agency.new({email: sign_up.email}) if !@agency
        end

        def reregistration_update
            sign_up = SignUp.find_by(token: params[:sign_up_token])
            agency_register_approval_reply_days = SystemConfiguration.find_by(code: "AGENCY_REGISTER_APPROVAL_REPLY_DAYS").value
            agency_data = agency_params
            agency_data[:status] = "NEW"
            if agency_data.key?(:business_registration_number)
                agency_data[:business_registration_number] = agency_data[:business_registration_number].delete('-').strip
            end

                license_number = agency_data[:license_number]
                bank_payment_id = agency_data[:business_registration_number]

            @agency = sign_up.sign_upable
            if (!@agency)
                agency_data[:email] = sign_up.email
                agency_data[:status] = "NEW"
                agency_data[:country] = Country.find_by(code: 'MYS')

                @agency = Agency.new(agency_data.merge({
                    bank_payment_id: bank_payment_id
                }))
            end

            begin
                if @agency.update(agency_data.merge({
                    bank_payment_id: bank_payment_id
                }))
                    sign_up.sign_upable = @agency
                    sign_up.save!

                    if params[:agency][:uploads]
                        params[:agency][:uploads].each do |upload|
                            if (!upload[:category].nil? && !upload[:documents].nil?)
                                add_watermark(upload[:documents])
                                upl = @agency.uploads.create(category: upload[:category])
                                upl.documents.attach(upload[:documents])
                            end
                        end
                    end

                    # pending for approval
                    if SystemConfiguration.find_by(code: "AGENCY_APPROVAL").value == "1"
                        agency_register_approval_reply_days = SystemConfiguration.find_by(code: "AGENCY_REGISTER_APPROVAL_REPLY_DAYS").value
                        @agency.update({
                            status: "APPROVAL"
                        })
                        flash.now[:dark] = "Registration is successful. Your account is pending for approval. Once approved, you will receive activation email in your registered email to activate your account."
                        AgencyMailer.with({
                            recipient: sign_up.email,
                            agency: @agency,
                            agency_register_approval_reply_days: agency_register_approval_reply_days
                        }).pending_approval_email.deliver_later
                        @activation_link = ""
                    # skip approval
                    else
                        @agency.update({
                            status: "ACTIVE"
                        })
                        @agency.update_code
                        user = @agency.create_user(skip_confirmation: true)
                        user.password_changed_at = (user.role.password_policy.password_expiry+1).months.ago
                        user.save
                        # sign_in(:external_user, user)
                        @activation_link = "#{ENV["APP_URL_PORTAL"]}#{user.activation_link}"
                        flash[:dark] = "Registration is successful. Please check your registered email for activation email to activate your account."
                        AgencyMailer.with({
                            recipient: sign_up.email,
                            activation_link: @activation_link,
                            agency: @agency,
                            name: @agency.name
                        }).approved_email.deliver_later
                        create_registration_order(@agency, user)
                    end
                else
                    render :reregistration and return
                end
                # /@request.save!
            rescue ActiveRecord::RecordInvalid => invalid
                redirect_to send("new_internal_#{controller_name}_path"), notice: invalid.to_s
            end
        end

        def agency_agreement
            send_file(
                "#{Rails.root}/public/files/Agency_Agreement.pdf",
                filename: "Agency_Agreement.pdf",
                type: "application/pdf"
            )
        end

        def agency_sop
            send_file(
                "#{Rails.root}/public/files/Agency_Sop.pdf",
                filename: "Agency_Sop.pdf",
                type: "application/pdf"
            )
        end

        private
        def agency_params
            params.require(:agency).permit(:id, :name, :business_registration_number, :agency_license_category_id, :license_number, :license_expired_at, :director_name, :director_ic_number, :pic_name, :pic_ic_number, :pic_phone, :address1, :address2, :address3, :address4, :country_id, :state_id, :town_id, :postcode, :phone, :email, :bank_id, :bank_payment_id, :bank_account_number, :personal_data_consent, :expired_at, :agreement_accepted, documents: [])
        end

        def check_captcha
            unless verify_recaptcha
                render :sign_up
            end
        end

        def set_agency
            @agency = Agency.find(params[:id])
        end

        def create_registration_order(agency, user)
            if !agency.has_created_registration_order?
                fee = Fee.find_by(code: 'AGENCY_REGISTRATION')
                organization = Organization.find_by(code: 'PT')
                order = Order.create({
                    customerable: user.userable,
                    category: "AGENCY_REGISTRATION",
                    date: Time.now,
                    amount: fee.amount,
                    status: 'NEW',
                    organization_id: organization.id
                })
                order.order_items.create({
                    order_itemable: agency,
                    fee_id: fee.id,
                    amount: fee.amount
                })
            end
        end
    end
