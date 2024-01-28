class External::EmailResetsController < ExternalController
    layout "external-visitor"
    skip_before_action :authenticate_external_user!

    def new
        @email_reset = EmailReset.new
    end

    def create
        email = params[:email_reset][:email].strip.upcase
        code = params[:email_reset][:code].gsub(/[^0-9a-zA-Z]/i, '').upcase
        identity_code = params[:email_reset][:identity_code].gsub(/[^0-9a-zA-Z]/i, '').upcase

        @email_reset = EmailReset.new({
            code: code,
            identity_code: identity_code,
            email: email
        })

        if !verify_recaptcha
            render :new and return
        end

        user = User.where("email ilike ?", email).first
        if user
            @email_reset.status = "EMAIL01"
            @email_reset.save
            redirect_to new_external_email_reset_path, flash: {error: "Your email is exist. Kindly click on Forgot Password."} and return
        end

        employer = Employer.where("email ilike ?", email).first
        if employer
            @email_reset.status = "EMAIL02"
            @email_reset.save
            redirect_to new_external_email_reset_path, flash: {error: "Your email is exist. Kindly click on Forgot Password."} and return
        end

        employers = Employer.where("code ilike ? and (regexp_replace(business_registration_number, '[^0-9a-zA-Z]', '', 'g') ilike ? or regexp_replace(ic_passport_number, '[^0-9a-zA-Z]', '', 'g') ilike ?)", code, identity_code, identity_code)

        if employers.count > 1
            @email_reset.status = "NOTUNIQUE"
            @email_reset.save
            redirect_to new_external_email_reset_path, flash: {error: "Record is not unique, please refer to nearest FOMEMA branch office."} and return
        elsif employers.count == 0
            @email_reset.status = "NOTFOUND"
            @email_reset.save
            redirect_to new_external_email_reset_path, flash: {error: "Infomation provided not match."} and return
        end

        @employer = employers.first

        # Do not use ActiveRecord::Base.transaction, it will work with callbacks after_save or after_commit, but saved_changes & previous_changes methods will stop working.
        # ActiveRecord::Base.transaction do
            @email_reset.resettable = @employer
            @email_reset.status = "COMPLETED"
            @email_reset.save

            # @employer.update({
            #     email: email
            # })
            user = @employer.users.where(code: code).first
            user = @employer.users.where("username ilike ?", code).first if !user
            if !user
                user = @employer.create_user(skip_confirmation: true)
            end
            user.code = code
            user.password_changed_at = (user.role.password_policy.password_expiry+1).months.ago
            user.email = email
            user.save
            user.confirm

            @employer.email = email
            @employer.save(validate: false)

            # no need to send activation email because changing email will send out confirmation email already
            # @activation_link = "#{ENV["APP_URL_PORTAL"]}#{user.activation_link}"
            # EmployerMailer.with({
            #     recipient: @employer.email,
            #     activation_link: @activation_link
            # }).reset_email.deliver_later
        # end

        redirect_to new_external_email_reset_path, flash: {notice: "An email has been sent to #{user.obfuscated_email}. Please check your email to confirm your account and reset your password. "} and return
    end

    private
    def set_email_reset
        @email_reset = EmailReset.find(params[:id])
    end

    def email_reset_params
        params.require(:email_reset).permit(:code, :identity_code, :email)
    end
end
