require 'csv'

class Internal::AgenciesController < InternalController
    include ValidateUserable
    include DocumentViewCheck
    include Watermark

    before_action :set_agency, only: [:show, :edit, :update, :destroy, :approval, :registration_approval, :registration_approval_update,  :remove_document_at_index ]
    before_action -> { validate_user_email?(@agency, params[:agency][:email]) }, only: [:update]
    before_action -> { validate_email_with_plus_sign(params[:agency][:email]) }, only: [:create, :update]

    before_action -> { has_viewed?(@agency) }, only: [:registration_approval_update]

    has_scope :comment_logs

    # GET /agencies
    # GET /agencies.json
    def index

        has_any_parameter   = [:code, :status, :name, :state_id, :business_registration_number, :email, :id, :problematic, :document_verified, :sop_acknowledge].map {|param_name| params[param_name].present? }.include?(true)

        if has_any_parameter
            @agencies = Agency.search_code(params[:code])
            .search_status(params[:status])
            .search_name(params[:name])
            .search_email(params[:email])
            .search_state_id(params[:state_id])
            .search_roc(params[:business_registration_number])
            .search_id(params[:id])
            .search_problematic(params[:problematic])
            .search_document_verified(params[:document_verified])
            .search_sop_acknowledge(params[:sop_acknowledge])
            .search_role(params[:role])
            .order(created_at: :desc)

            if has_permission?("VIEW_ALL_AGENCY")
            elsif has_permission?("VIEW_BRANCH_AGENCY")
                @agencies = @agencies.where("agencies.organization_id = ?", current_user.userable_id)
            elsif has_permission?("VIEW_OWN_AGENCY")
                @agencies = @agencies.where("agencies.created_by = ?", current_user.id)
            end
        else
            @agencies = Agency.none
            flash.now[:warning] = "Filter is required";
        end

        @agency_comment_logs = @agencies.joins("LEFT JOIN comment_logs ON comment_logs.commentable_id = agencies.id")
        .where("comment_logs.commentable_type = 'Agency' or comment_logs.commentable_type is null")
        .select("agencies.*", "comment_logs.comment as log_comment", "comment_logs.created_at as log_created_at", "comment_logs.created_by as log_created_by")

        respond_to do |format|
            format.html do
                @agencies = @agencies.page(params[:page])
                .per(get_per).includes(:state).includes(:town)
            end
            format.xlsx do
                render xlsx: 'index', filename: "agencies-#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx"
            end
            format.json { render json: @agencies }
        end
    end

    # GET /agencies/1
    # GET /agencies/1.json
    def show
    end

    def show_ori
        @agency = Agency.find(params[:id])
    end

    def approval
    end

    def registration_approval
    end

    def registration_approval_update
        approval_data = approval_params

        approve_action = params[:approve_action]

        # default value act as approve_action APPROVE

        message = 'approved'
        status = 'ACTIVE'
        context = :approve_registration

        if approve_action === 'REJECT'
            message = 'rejected'
            status = 'REJECTED'
            context = :reject_registration
        elsif approve_action === 'INCOMPLETE'
            message = 'incomplete'
            status = 'INCOMPLETE'
            context = :incomplete_registration
        end

        approval_data[:registration_approved_at] = Time.now
        approval_data[:status] = status
        approval_data[:registration_approval_by] = current_user.id

        @agency.attributes = approval_data

        respond_to do |format|
            if @agency.save(context: context)
                if approve_action === 'APPROVE'
                    # create agency user and send email if approved
                    @agency.update_code
                    @agency.update({
                        document_verified: true
                    })
                    createAgencyUserSendNotification(@agency)
                elsif approve_action === 'REJECT'
                    # send rejected email notification (must send email before update the field)
                    sendRegistrationRejectedNotification(@agency)

                    # update ic/roc and email from sign_ups and agencies
                    signup = SignUp.find_by(sign_upable_id: @agency.id)
                    signup.update({
                        email: @agency.email + '.' + @agency.id.to_s + approve_action
                    })
                    @agency.update({
                        business_registration_number: @agency.business_registration_number + @agency.id.to_s + approve_action,
                        email: @agency.email + '.' + @agency.id.to_s + approve_action
                    })
                elsif approve_action === 'INCOMPLETE'
                    # send incomplete email notification
                    sendRegistrationIncompleteNotification(@agency)
                end

                format.html { redirect_to internal_agencies_path, notice: 'Agency Registration was successfully ' + message }
                format.json { render :show, status: :ok, location: @agency }
            else
                format.html { render :registration_approval }
                format.json { render json: @agency.errors, status: :unprocessable_entity }
            end
        end

    end

    # GET /agencies/new
    def new
        @agency = Agency.new
    end

    # POST /agencies
    # POST /agencies.json
    def create
        if User.find_by(email: params[:agency][:email]).present?
            flash[:error] = "Could not create agency, user with the email #{params[:agency][:email]} already exists"
            redirect_to internal_agencies_url and return
        end
        agency_data = agency_params

        if agency_data.key?(:business_registration_number)
            agency_data[:business_registration_number] = agency_data[:business_registration_number].delete('-').strip
        end

        bank_payment_id = agency_data[:business_registration_number]

        @agency = Agency.new(agency_data.merge({
            status: "ACTIVE",
            country: Country.find_by(code: 'MYS'),
            bank_payment_id: bank_payment_id
        }))

        begin
            respond_to do |format|
                if @agency.save
                    if params[:agency][:uploads].present?
                        params[:agency][:uploads].each do |upload|
                            if (!upload[:category].nil? && !upload[:documents].nil?)
                                add_watermark(upload[:documents])
                                upl = @agency.uploads.create(category: upload[:category])
                                upl.documents.attach(upload[:documents])
                            end
                        end
                    end

                    # agency's code
                    @agency.update_code

                    # create agency's user
                    user = @agency.create_user(skip_confirmation: true)
                    user.password_changed_at = (user.role.password_policy.password_expiry+1).months.ago
                    user.save
                    @activation_link = "#{ENV["APP_URL_PORTAL"]}#{user.activation_link}"
                    AgencyMailer.with({
                        recipient: @agency.email,
                        activation_link: @activation_link,
                        agency: @agency,
                        name: @agency.name
                    }).approved_email.deliver_later

                    format.html { redirect_to internal_agencies_url(code: @agency.code), notice: "Agency was successfully created." }
                    format.json { render :show, status: :created, location: @agency }
                else
                    format.html { render :new }
                    format.json { render json: @agency.errors, status: :unprocessable_entity }
                end
            end
        rescue ActiveRecord::RecordInvalid => invalid
            redirect_to internal_agencies_url, notice: invalid.to_s
        end
    end

    # GET /agencies/1/edit
    def edit
        # redirect_to internal_agency_url(@agency) unless @agency.assigned_to.eql?(current_user.id)
    end

    # PATCH/PUT /agencies/1
    # PATCH/PUT /agencies/1.json
    # request to edit agency
    def update
        agency_data = agency_params

        # agency_data[:business_registration_number] = nil

        @agency.assign_attributes(agency_data)

        begin
            respond_to do |format|
                if @agency.save

                    if params[:agency][:uploads].present?
                        params[:agency][:uploads].each do |upload|
                            if (!upload[:category].nil? && !upload[:documents].nil?)
                                add_watermark(upload[:documents])
                                upl = @agency.uploads.create(category: upload[:category])
                                upl.documents.attach(upload[:documents])
                            end
                        end
                    end

                    if params[:remove_uploaded_file].present?
                        ids       = params[:remove_uploaded_file].split(",")
                        @agency.uploads.where(id: ids).destroy_all
                    end

                    if params[:agency][:comment_logs].present?
                        @agency.comment_logs.create(comment: params[:agency][:comment_logs])
                    end

                    format.html { redirect_to internal_agencies_url(code: @agency.code), notice: "Agency was successfully updated. If there's changes in email address, a confirmation email will be send out to verify the new email address." }
                    format.json { render :show, status: :ok, location: @agency }
                else
                    format.html { render :edit }
                    format.json { render json: @agency.errors, status: :unprocessable_entity }
                end
            end
        rescue ActiveRecord::RecordInvalid => invalid
            redirect_to internal_agencies_url, notice: invalid.to_s
        end
    end

    # DELETE /agencies/1
    # DELETE /agencies/1.json
    def destroy
        @agency.destroy
        respond_to do |format|
            format.html { redirect_to internal_agencies_url, notice: 'Agency was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def createAgencyUserSendNotification(agency)

        # check user already exist to prevent email not unique error
        #
        user = User.find_by email: @agency.email

        if !user

            # create employer's user
            user = agency.create_user(skip_confirmation: true)
            user.password_changed_at = (user.role.password_policy.password_expiry+1).months.ago
            user.save

        end

        if !agency.has_created_registration_order?
            fee = Fee.find_by(code: 'AGENCY_REGISTRATION')
            organization = Organization.find_by(code: 'PT')
            order = Order.create({
                customerable: user.userable,
                category: "AGENCY_REGISTRATION",
                date: Time.now,
                amount: fee.amount,
                status: 'NEW',
                created_by: user.id,
                updated_by: user.id,
                organization_id: organization.id
            })
            order.order_items.create({
                order_itemable: agency,
                fee_id: fee.id,
                amount: fee.amount,
                created_by: user.id,
                updated_by: user.id
            })
        end

        @activation_link = "#{ENV["APP_URL_PORTAL"]}#{user.activation_link}"

        AgencyMailer.with({
            recipient: @agency.email,
            activation_link: @activation_link,
            name: @agency.name,
            agency: @agency
        }).approved_email.deliver_later
    end

    def sendRegistrationRejectedNotification(agency)
        @url = "#{ENV["APP_URL_PORTAL"]}agencies/sign-up"
        AgencyMailer.with({
            recipient: @agency.email,
            name: @agency.name,
            reason: agency.registration_comment,
            url: @url
        }).rejected_email.deliver_later

    end

    def sendRegistrationIncompleteNotification(agency)
        signup = SignUp.find_by(email: @agency.email)
        @url = "#{ENV["APP_URL_PORTAL"]}agencies/reregistration?token=#{signup.token}"

        AgencyMailer.with({
            recipient: @agency.email,
            name: @agency.name,
            reason: agency.registration_comment,
            url: @url
        }).incomplete_email.deliver_later

    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_agency
        @agency = Agency.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def agency_params
        params.require(:agency).permit(:id, :name, :business_registration_number, :agency_license_category_id, :license_number, :license_expired_at, :director_name, :director_ic_number, :pic_name, :pic_ic_number, :pic_phone, :address1, :address2, :address3, :address4, :country_id, :state_id, :town_id, :postcode, :phone, :email, :bank_id, :bank_payment_id, :bank_account_number, :status, :problematic, :document_verified)
    end

    def approval_params
        params.permit(:registration_comment)
    end
end