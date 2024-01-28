require 'csv'

class External::AgencyEmployersController < ExternalController
    include ValidateUserable
    include DocumentViewCheck
    include Watermark
    include AgencySopAcknowledgeCheck

    before_action :set_employer, only: [:show, :edit, :update, :destroy, :approval, :registration_approval, :registration_approval_update, :bulk_upload_foreign_worker, :remove_document_at_index, :move_fw, :move_fw_update]
    before_action -> { validate_user_email?(@employer, params[:employer][:email]) }, only: [:update]
    before_action -> { validate_email_with_plus_sign(params[:employer][:email]) }, only: [:create, :update]

    before_action -> { has_viewed?(@employer) }, only: [:registration_approval_update]
    before_action -> { agency_sop_acknowledge_check?(Agency.find_by(id: current_user.userable_id)) }, if: -> { current_user.userable_type == 'Agency' }, only: [ :index]

    # GET /employers
    # GET /employers.json
    def index

        has_any_parameter   = [:code, :icno].map {|param_name| params[param_name].present? }.include?(true)

        if has_any_parameter
            employers = Employer.search_code_active(params[:code])
            .search_roc_or_icno_active(params[:icno])
            #.order(created_at: :desc)

            if has_permission?("VIEW_ALL_EMPLOYER")
                if employers.first&.email.blank? && employers.first&.status = "ACTIVE"
                    employers = Employer.none
                    flash.now[:warning] = "Email address is incomplete. Please update email address before proceeding.";
                end
            elsif has_permission?("VIEW_BRANCH_EMPLOYER")
                employers = employers.where("employers.organization_id = ?", current_user.userable_id)
            elsif has_permission?("VIEW_OWN_EMPLOYER")
                employers = employers.where("employers.created_by = ?", current_user.id)
            end
        else
            employers = Employer.none
            flash.now[:warning] = "Filter is required";
        end

        @employers = employers.page(params[:page])
        .per(get_per).includes(:employer_type).includes(:state).includes(:town)
    end

    # GET /employers/1
    # GET /employers/1.json
    def show
    end

    def show_ori
        @employer = Employer.find(params[:id])
    end

    # GET /employers/new
    def new
        @employer = Employer.new
    end

    # POST /employers
    # POST /employers.json
    def create
        if User.find_by(email: params[:employer][:email]).present?
            flash[:error] = "Could not create employer, user with the email #{params[:employer][:email]} already exists"
            redirect_to external_employers_url and return
        end
        employer_data = employer_params

        if employer_data.key?(:business_registration_number)
            employer_data[:business_registration_number] = employer_data[:business_registration_number].delete('-').strip
        end

        if employer_data[:employer_type_id] == "1"
            bank_payment_id = employer_data[:ic_passport_number]
        else
            bank_payment_id = employer_data[:business_registration_number]
        end

        @employer = Employer.new(employer_data.merge({
            status: "NEW",
            country: Country.find_by(code: 'MYS'),
            bank_payment_id: bank_payment_id
        }))

        begin
            respond_to do |format|
                if @employer.save
                    if params[:employer][:uploads].present?
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
                    @employer.update({
                        status: "APPROVAL"
                    })
                    flash.now[:dark] = "Registration is successful. Your account is pending for approval. Once approved, you will receive activation email in your registered email to activate your account."
                    EmployerMailer.with({
                        recipient: @employer.email,
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
                        recipient: @employer.email,
                        activation_link: @activation_link,
                        employer: @employer,
                        name: @employer.name
                    }).approved_email.deliver_later
                end
                    format.html { redirect_to external_agency_employers_url(code: @employer.code), notice: "Registration is successful. Your account is pending for approval. Once approved, you will receive activation email in your registered email to activate your account." }
                    format.json { render :show, status: :created, location: @employer }
                else
                    format.html { render :new }
                    format.json { render json: @employer.errors, status: :unprocessable_entity }
                end
            end
        rescue ActiveRecord::RecordInvalid => invalid
            redirect_to external_agency_employers_url, notice: invalid.to_s
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_employer
        @employer = Employer.find(params[:id])
        # @employer.lock(current_user.try(:id)) if @employer.assigned_to.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employer_params
        params.require(:employer).permit(:employer_type_id, :name, :business_registration_number, :ic_passport_number, :address1, :address2, :address3, :address4, :country_id, :state_id, :postcode, :town_id, :phone, :fax, :email, :pic_name, :pic_phone, :personal_data_consent, :status, :bad_payment, :blacklisted, :comment, :bank_id, :bank_account_number, :is_corporate, :bank_payment_id, documents: [])
    end


end