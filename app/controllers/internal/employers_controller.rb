require 'csv'

class Internal::EmployersController < InternalController
    include ValidateUserable
    include DocumentViewCheck
    include Approvalable
    include ApprovalAssignmentCheck
    include Watermark

    before_action :set_employer, only: [:show, :edit, :update, :destroy, :approval, :registration_approval, :registration_approval_update, :bulk_upload_foreign_worker, :remove_document_at_index, :move_fw, :move_fw_update, :amendment_approval, :amendment_approval_update, :resend_confirmation]
    before_action -> { validate_user_email?(@employer, params[:employer][:email]) }, only: [:update]
    before_action -> { validate_email_with_plus_sign(params[:employer][:email]) }, only: [:create, :update]

    before_action -> { has_viewed?(@employer) }, only: [:registration_approval_update]

    has_scope :comment_logs

    # GET /employers
    # GET /employers.json
    def index
        has_any_parameter   = [:code, :status, :name, :state_id, :icno, :email, :id, :problematic, :document_verified].map {|param_name| params[param_name].present? }.include?(true)

        if has_any_parameter
            @employers = Employer.search_code(params[:code])
            .search_status(params[:status])
            .search_name(params[:name])
            .search_email(params[:email])
            .search_state_id(params[:state_id])
            .search_roc_or_icno(params[:icno])
            .search_id(params[:id])
            .search_problematic(params[:problematic])
            .search_document_verified(params[:document_verified])
            .search_assigned_to(params[:assigned_to])
            .search_request_start_date(params[:request_start_date])
            .search_request_end_date(params[:request_end_date])
            .order(created_at: :desc)

            if has_permission?("VIEW_ALL_EMPLOYER")
            elsif has_permission?("VIEW_BRANCH_EMPLOYER")
                @employers = @employers.where("employers.organization_id = ?", current_user.userable_id)
            elsif has_permission?("VIEW_OWN_EMPLOYER")
                @employers = @employers.where("employers.created_by = ?", current_user.id)
            end
        else
            @employers = Employer.none
            flash.now[:warning] = "Filter is required";
        end

        respond_to do |format|
            format.html do
                @employers = @employers.page(params[:page])
                .per(get_per).includes(:employer_type).includes(:state).includes(:town)
            end
            format.xlsx do
                render xlsx: 'index', filename: "employers-#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx"
            end
            format.json { render json: @employers }
        end
    end

    # GET /employers/1
    # GET /employers/1.json
    def show
    end

    def show_ori
        @employer = Employer.find(params[:id])
    end

    def approval
    end

    def registration_approval
    end

    def registration_approval_update
        approval_data = approval_params

        if ["ACTIVE", "REJECTED"].include? (@employer.status)
            flash[:error] = "Approval is not allowed. The employer registration approval has been approved/rejected earlier."
            redirect_to internal_employers_path and return
        end

        approve_action = params[:approve_action]

        transfer_message = ""
        transfer_documents_to_employer_id = params[:employer_id]
        if !transfer_documents_to_employer_id.blank?
            copy_to_employer = Employer.find(transfer_documents_to_employer_id)
            copy_documents(@employer, copy_to_employer)
            transfer_message = " and transferred the documents to #{copy_to_employer.code}"
        end

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

        @employer.attributes = approval_data

        respond_to do |format|
            if @employer.save(context: context)
                if approve_action === 'APPROVE'
                    # create employer user and send email if approved
                    @employer.update_code
                    @employer.update({
                        document_verified: true
                    })
                    createEmployerUserSendNotification(@employer)
                elsif approve_action === 'REJECT'
                    # send rejected email notification (must send email before update the field)
                    sendRegistrationRejectedNotification(@employer)

                    # update ic/roc and email from sign_ups and employers
                    signup = SignUp.find_by(sign_upable_id: @employer.id)
                    signup.update({
                        email: @employer.email + '.' + @employer.id.to_s + approve_action
                    })

                    if @employer.is_company?
                        @employer.update({
                            business_registration_number: @employer.business_registration_number + @employer.id.to_s + approve_action,
                            email: @employer.email + '.' + @employer.id.to_s + approve_action
                        })
                    else
                        @employer.update({
                            ic_passport_number: @employer.ic_passport_number + @employer.id.to_s + approve_action,
                            email: @employer.email + '.' + @employer.id.to_s + approve_action
                        })
                    end
                elsif approve_action === 'INCOMPLETE'
                    # send incomplete email notification
                    sendRegistrationIncompleteNotification(@employer)
                end

                format.html { redirect_to internal_employers_path, notice: 'Employer Registration was successfully ' + message + transfer_message }
                format.json { render :show, status: :ok, location: @employer }
            else
                format.html { render :registration_approval }
                format.json { render json: @employer.errors, status: :unprocessable_entity }
            end
        end

    end

    def amendment_approval
        @employer.assign_attributes(@employer.approval_item.params)
    end

    def amendment_approval_update
        approval_data = approval_amendment_params

        approve_action = params[:approve_action]
        amendment_comment = params[:amendment_comment]

        # default value act as approve_action APPROVE
        message = 'approved'
        status = 'APPROVED'
        context = :approve_amendment


        if approve_action === 'REJECT'
            message = 'rejected'
            status = 'REJECTED'
            context = :reject_amendment
        end

        # approval_data[:approval_status] = status
        approval_data[:approval_remark] = amendment_comment
        approval_data[:employer_amended_at] = Time.now

        @employer.attributes = approval_data

        respond_to do |format|
            if @employer.save(context: context)
                if approve_action === 'APPROVE'
                    # send email if approved
                    approval_approve_request(@employer, user: current_user, comment: params[:amendment_comment])
                    approve_amendment_email(@employer)

                elsif approve_action === 'REJECT'
                    # send rejected email notification (must send email before update the field)
                    approval_reject_request(@employer, user: current_user, comment: params[:amendment_comment])
                    reject_amendment_email(@employer)
                    @employer.update({
                        employer_amended_at: nil
                    })

                end

                format.html { redirect_to internal_employers_path, notice: 'Employer Amendment was successfully '+ message}
                format.json { render :show, status: :ok, location: @employer }
            else
                format.html { render :amendment_approval }
                format.json { render json: @employer.errors, status: :unprocessable_entity }
            end
        end

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
            redirect_to internal_employers_url and return
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
            status: "ACTIVE",
            country: Country.find_by(code: 'MYS'),
            bank_payment_id: bank_payment_id
        }))

        begin
            respond_to do |format|
                if @employer.save
                    if params[:employer][:uploads].present?
                        params[:employer][:uploads].each do |upload|
                            if (!upload[:category].nil? && !upload[:documents].nil?)
                                upl = @employer.uploads.create(category: upload[:category])
                                upl.documents.attach(upload[:documents])
                            end
                        end
                    end

                    # employer's code
                    @employer.update_code

                    # create employer's user
                    user = @employer.create_user(skip_confirmation: true)
                    user.password_changed_at = (user.role.password_policy.password_expiry+1).months.ago
                    user.save
                    @activation_link = "#{ENV["APP_URL_PORTAL"]}#{user.activation_link}"
                    EmployerMailer.with({
                        recipient: @employer.email,
                        activation_link: @activation_link,
                        employer: @employer,
                        name: @employer.name
                    }).approved_email.deliver_later

                    format.html { redirect_to internal_employers_url(code: @employer.code), notice: "Employer was successfully created." }
                    format.json { render :show, status: :created, location: @employer }
                else
                    format.html { render :new }
                    format.json { render json: @employer.errors, status: :unprocessable_entity }
                end
            end
        rescue ActiveRecord::RecordInvalid => invalid
            redirect_to internal_employers_url, notice: invalid.to_s
        end
    end

    # GET /employers/1/edit
    def edit
        # redirect_to internal_employer_url(@employer) unless @employer.assigned_to.eql?(current_user.id)
    end

    # PATCH/PUT /employers/1
    # PATCH/PUT /employers/1.json
    # request to edit employer
    def update
        employer_data = employer_params

        # individual - 1, company - 2
        if employer_data[:employer_type_id] == '1'
            employer_data[:business_registration_number] = nil
            employer_data[:pic_name] = nil
            employer_data[:pic_phone] = nil
            employer_data[:bank_payment_id] = employer_data[:ic_passport_number]
        else
            employer_data[:ic_passport_number] = nil
        end

        @employer.assign_attributes(employer_data)

        user = User.find_by(userable_id: @employer.id, userable_type: "Employer")
        user.update({
            name: @employer.name
        })

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

                    if params[:remove_uploaded_file].present?
                        ids       = params[:remove_uploaded_file].split(",")
                        @employer.uploads.where(id: ids).destroy_all
                    end

                    if params[:employer][:comment_logs].present?
                        @employer.comment_logs.create(comment: params[:employer][:comment_logs])
                    end

                    format.html { redirect_to internal_employers_url(code: @employer.code), notice: "Employer was successfully updated. If there's changes in email address, a confirmation email will be send out to verify the new email address." }
                    format.json { render :show, status: :ok, location: @employer }
                else
                    format.html { render :edit }
                    format.json { render json: @employer.errors, status: :unprocessable_entity }
                end
            end
        rescue ActiveRecord::RecordInvalid => invalid
            redirect_to internal_employers_url, notice: invalid.to_s
        end
    end

    # DELETE /employers/1
    # DELETE /employers/1.json
    def destroy
        @employer.destroy
        respond_to do |format|
            format.html { redirect_to internal_employers_url, notice: 'Employer was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def bulk_upload_foreign_worker_template
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = 'attachment; filename=bulk_upload_template.csv'
        render :template => "/external/worker_lists/bulk_upload_template.csv.erb"
    end

    def bulk_upload_foreign_worker
        CSV.foreach(params[:foreign_workers].path).with_index do |row, rownum|
            next if row[1].downcase == 'passport number'
            fw = ForeignWorker.create({
                name: row[0],
                passport_number: row[1],
                gender: ForeignWorker::to_gender_code(row[2]),
                date_of_birth: row[3],
                country_id: Country::find_by(code: row[4]).id,
                job_type_id: JobType::find_by(name: row[5]).id,
                plks_number: row[6],
                employer_id: @employer.id
            })
        end
        redirect_to internal_employer_path @employer, flash: {notice: "Bulk upload done"}
    end

    def move_fw
    end

    def move_fw_update
        new_employer = Employer.find(params[:employer_id])
        if new_employer.id == @employer.id
            flash[:warnings] = ["Employer didn't change!"]
            redirect_to internal_employers_path(code: @employer.code) and return
        end
        flash[:errors] = []
        flash[:notices] = []
        error_arrs = []
        failed_count = 0
        moved_count = 0
        @employer.foreign_workers.each do |fw|
            if !fw.update(employer_id: new_employer.id)
                failed_count = failed_count + 1
                error_arrs << "Foreign worker #{fw.name} - #{fw.errors.full_messages.join(", ")}"
            else
                moved_count = moved_count + 1
            end
        end
        if failed_count > 0
            flash[:errors] << "#{failed_count} foreign workers failed to moved."
            if failed_count <= 10
                flash[:errors].concat(error_arrs)
            end
        end
        if moved_count > 0
            flash[:notices] << "#{moved_count} foreign workers successfully moved."
        end
        redirect_to internal_employers_path(code: @employer.code) and return
    end

    def createEmployerUserSendNotification(employer)

        # check user already exist to prevent email not unique error
        #
        user = User.find_by email: @employer.email

        if !user

            # create employer's user
            user = employer.create_user(skip_confirmation: true)
            user.password_changed_at = (user.role.password_policy.password_expiry+1).months.ago
            user.save

        end

        @activation_link = "#{ENV["APP_URL_PORTAL"]}#{user.activation_link}"

        EmployerMailer.with({
            recipient: @employer.email,
            activation_link: @activation_link,
            name: @employer.name,
            employer: @employer
        }).approved_email.deliver_later
    end

    def sendRegistrationRejectedNotification(employer)
        @url = "#{ENV["APP_URL_PORTAL"]}employers/sign-up"
        EmployerMailer.with({
            recipient: @employer.email,
            name: @employer.name,
            reason: employer.registration_comment,
            url: @url
        }).rejected_email.deliver_later
    end

    def sendRegistrationIncompleteNotification(employer)
        signup = SignUp.find_by(email: @employer.email)
        @url = "#{ENV["APP_URL_PORTAL"]}employers/reregistration?token=#{signup.token}"

        EmployerMailer.with({
            recipient: @employer.email,
            name: @employer.name,
            reason: employer.registration_comment,
            url: @url
        }).incomplete_email.deliver_later
    end

    def approve_amendment_email(employer)

        EmployerMailer.with({
            recipient: @employer.email,
            name: @employer.name,
            employer: @employer
        }).approved_amendment_email.deliver_later
    end

    def reject_amendment_email(employer)
        EmployerMailer.with({
            recipient: @employer.email,
            name: @employer.name,
            reason: @employer.approval_remark,
        }).rejected_amendment_email.deliver_later
    end

    def copy_documents(source_employer, destination_employer)
        source_employer.uploads.each do |upload|
            clone_upload = upload.dup
            destination_upload = destination_employer.uploads.create(category: upload[:category])

            upload.documents.each do |document|
                document.blob.open do |tempfile|
                    destination_upload.documents.attach({
                        :io => tempfile,
                        :filename => document.blob.filename,
                        :content_type => document.blob.content_type
                    })
                end
            end
        end
    end

    def export
        has_any_parameter   = [:code, :status, :name, :state_id, :icno, :email, :id, :problematic, :document_verified].map {|param_name| params[param_name].present? }.include?(true)

        if has_any_parameter
            @employers = Employer.search_code(params[:code])
            .search_status(params[:status])
            .search_name(params[:name])
            .search_email(params[:email])
            .search_state_id(params[:state_id])
            .search_roc_or_icno(params[:icno])
            .search_id(params[:id])
            .search_problematic(params[:problematic])
            .search_document_verified(params[:document_verified])
            .joins("LEFT JOIN comment_logs ON comment_logs.commentable_id = employers.id")
            .where("comment_logs.commentable_type = 'Employer' or comment_logs.commentable_type is null")
            .select("employers.*", "comment_logs.comment as log_comment", "comment_logs.created_at as log_created_at", "comment_logs.created_by as log_created_by")

            if has_permission?("VIEW_ALL_EMPLOYER")
            elsif has_permission?("VIEW_BRANCH_EMPLOYER")
                @employers = @employers.where("employers.organization_id = ?", current_user.userable_id)
            elsif has_permission?("VIEW_OWN_EMPLOYER")
                @employers = @employers.where("employers.created_by = ?", current_user.id)
            end
        else
            @employers = Employer.none
            flash.now[:warning] = "Filter is required";
        end

        respond_to do |format|
            format.html do
                @employers = @employers.page(params[:page])
                .per(get_per).includes(:employer_type).includes(:state).includes(:town)
            end
            format.xlsx do
                render xlsx: 'index', filename: "employers-#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx"
            end
        end
    end

    def resend_confirmation
        if has_permission?("RESEND_CONFIRMATION_INSTRUCTION_USER") && @employer.user&.pending_reconfirmation?
            user = @employer.user
            user.resend_confirmation_instructions
            flash[:notice] = "Confirmation instruction resent"
        else
            flash[:notice] = "Either you do not have permission to resend or there is no email pending for confirmation."
        end

        redirect_to internal_employers_url(code: @employer.code)
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_employer
        @employer = Employer.find(params[:id])
        # @employer.lock(current_user.try(:id)) if @employer.assigned_to.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employer_params
        params.require(:employer).permit(:employer_type_id, :name, :business_registration_number, :ic_passport_number, :address1, :address2, :address3, :address4, :country_id, :state_id, :postcode, :town_id, :phone, :fax, :email, :pic_name, :pic_phone, :personal_data_consent, :status, :bad_payment, :blacklisted, :comment, :bank_id, :bank_account_number, :is_corporate, :bank_payment_id, :problematic, :document_verified)
    end

    def approval_params
        params.permit(:registration_comment)
    end

    def approval_amendment_params
        params.permit(:approval_remark, :employer_amended_at)
    end
end