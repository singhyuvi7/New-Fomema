class Internal::LaboratoriesController < InternalController
    has_scope :allocated, type: :boolean

    include Approvalable
    include ServiceProviderDocument
    include ValidateUserable

    before_action :set_laboratory, only: [:show, :edit, :draft, :cancel, :update, :destroy, :approval, :approval_update, :concur, :concur_update, :approval_letter, :registration_invoice, :activate, :bulk_reallocate, :bulk_reallocate_update, :operation_hours, :change_address_approval, :registration_letter, :allocated_workers, :suspension_history, :summary_loading_statistic]
    before_action :set_date_time, only: %i[suspension_history]
    before_action -> { validate_user_email?(@laboratory, params[:laboratory][:email]) }, only: [:update]
    before_action -> { validate_email_with_plus_sign(params[:laboratory][:email]) }, only: [:create, :update]
    before_action :set_company_name, only: %i[suspension_history]

    before_action -> { can_access?("VIEW_LABORATORY") }, only: [:index, :show]
    before_action -> { can_access?("DELETE_LABORATORY") }, only: [:destroy]
    before_action -> { can_access?("MSPD_REPORTS") }, only: [:summary_loading_statistic, :suspension_history]

    # GET /laboratories
    # GET /laboratories.json
    def index
        if params[:cookied_path] == "y" && session[:cookied_laboratory_approval_path].present?
            redirect_to "#{ request.path }?#{ session[:cookied_laboratory_approval_path] }" and return
        elsif ["APPROVAL", "APPROVAL2", "TO_ACTIVATE"].include?(params[:status])
            session[:cookied_laboratory_approval_path] = request.url.split("?")[1].gsub("cookied_path=y", "")
        end

        respond_to do |format|
            format.html do
                @laboratories = filtered_laboratory.order('updated_at DESC').page(params[:page]).per(get_per)
            end
            format.xlsx do
                @pairs = {
                    code: "LABORATORY_CODE",
                    company_name: "COMPANY_NAME",
                    name: "LABORATORY_NAME",
                    business_registration_number: "BUSINESS_REGISTRATION_NUMBER",
                    created_at: "CREATION_DATE",
                    displayed_address: "ADDRESS",
                    postcode: "POSTCODE",
                    town_name: "DISTRICT_NAME",
                    state_name: "STATE_NAME",
                    phone: "PHONE",
                    fax: "FAX",
                    email: "EMAIL",
                    pic_name: "PIC_NAME",
                    pic_phone: "PIC_PHONE",
                    qualification: "QUALIFICATION",
                    pathologist_name: "PATHOLOGIST_NAME",
                    renewal_agreement_date: "RENEWAL_AGREEMENT_DATE",
                    nsr_number: "NSR_NUMBER",
                    laboratory_type_name: "LABORATORY_TYPE",
                    district_health_office_name: "DISTRICT_HEALTH_OFFICE",
                    samm_number: "SAMM_NUMBER",
                    samm_accredited_since: "SAMM_ACCREDITED_SINCE",
                    samm_expiry_date: "SAMM_EXPIRY_DATE",
                    license: "LICENSE",
                    license_year: "LICENSE_YEAR",
                    web_service_yes_no: "WEB_SERVICE",
                    status: "STATUS",
                    status_reason_display: "STATUS_REASON",
                    status_comment: "STATUS_COMMENT",
                    activated_at: "ACTIVATED_AT",
                    active_gp_count: "ACTIVE_GP",
                    total_worker_allocated: "TOTAL_WORKER_ALLOCATED",
                    service_provider_group_name: "SERVICE_PROVIDER_GROUP",
                    total_fw_two_year_ago: "TOTAL_FW_#{2.year.ago.year}",
                    total_fw_one_year_ago: "TOTAL_FW_#{1.year.ago.year}",
                }
                if has_permission?("VIEW_FINANCE_INFO_LABORATORY")
                    @pairs.merge!({
                        male_rate: "MALE_RATE",
                        female_rate: "FEMALE_RATE",
                        bank_name: "BANK",
                        bank_account_number: "BANK_ACCOUNT_NUMBER",
                        bank_payment_id: "BANK_PAYMENT_ID",
                        payment_method_name: "PAYMENT_METHOD",
                        email_payment: "EMAIL_PAYMENT"
                    })
                end
                vd has_permission?("VIEW_FINANCE_INFO_LABORATORY"), @pairs
                @captions = @pairs.values
                @cols = @pairs.keys
                @laboratories = LaboratoryDecorator.decorate_collection filtered_laboratory
                render xlsx: 'index', filename: "Laboratories-#{DateTime.current.to_i}.xlsx"
            end
            format.json do
                @laboratories = filtered_laboratory.order('updated_at DESC')
            end
        end
    end

    # GET /laboratories/1
    # GET /laboratories/1.json
    def show
    end

    # GET /laboratories/new
    def new
        @laboratory = Laboratory.new({
            male_rate: SystemConfiguration.find_by(code: "LABORATORY_DEFAULT_MALE_RATE").try(:value),
            female_rate: SystemConfiguration.find_by(code: "LABORATORY_DEFAULT_FEMALE_RATE").try(:value),
            payment_method_id: PaymentMethod.find_by(code: "OUT_CASHORDER").try(:id)
        })
    end

    # POST /laboratories
    # POST /laboratories.json
    def create
        data = {
            male_rate: SystemConfiguration.find_by(code: "LABORATORY_DEFAULT_MALE_RATE").try(:value),
            female_rate: SystemConfiguration.find_by(code: "LABORATORY_DEFAULT_FEMALE_RATE").try(:value),
            payment_method_id: PaymentMethod.find_by(code: "OUT_CASHORDER").try(:id)
        }.merge(laboratory_params).merge({
            status: "INACTIVE"
        })
        data["bank_payment_id"] = data["business_registration_number"] if data["bank_payment_id"].blank?
        if !params[:web_service_passphrase_clear_text].blank?
            data[:web_service_passphrase] = Laboratory::passphrase_hash(params[:web_service_passphrase_clear_text])
        end

        @laboratory = Laboratory.new(data)
        # if (User.where("email ilike ?", @laboratory.email).count > 0)
        #     @laboratory.errors.add(:email, "not available")
        #     render :new and return
        # end

        @laboratory.save
        OperatingHour.create({operating_hourable: @laboratory})

        notice = ""

        case params[:submit]
        when 'Save draft'
            save_ok = approval_new_request(@laboratory, category: "LABORATORY_REGISTRATION", draft: true)
            notice = "Laboratory saved as draft."
        when 'Submit for approval'
            save_ok = approval_new_request(@laboratory, category: "LABORATORY_REGISTRATION")
            notice = "New laboratory request created."
        end

        respond_to do |format|
            if save_ok
                format.html { redirect_to internal_laboratories_path, notice: notice }
                format.json { render :show, status: :created, location: @laboratory }
            else
                format.html { render :new }
                format.json { render json: @laboratory.errors, status: :unprocessable_entity }
            end
        end
    end

    # GET /laboratories/1/edit
    def edit
    end

    # PATCH/PUT /laboratories/1
    # PATCH/PUT /laboratories/1.json
    def update
        data = laboratory_params
        if !params[:web_service_passphrase_clear_text].blank?
            data[:web_service_passphrase] = Laboratory::passphrase_hash(params[:web_service_passphrase_clear_text])
        end

        @laboratory.assign_attributes(data)
        case params[:submit]
        when 'Save draft'
            update_draft
        when 'Submit for approval'
            if ["address1", "address2", "address3", "address4", "state_id", "town_id", "postcode"].any? { |key| @laboratory.changes.key?(key) } && params[:fee_id].blank?
                @laboratory.errors.add(:base, "Fee is required")
                render :edit and return
            end
            update_approval
        end
        redirect_to @redirect_to || internal_laboratories_path
    end

    def update_draft
        if @laboratory.changes.count == 0
            flash[:error] = "No changes detected"
            @redirect_to = internal_laboratories_path
        else
            approval_update_request(@laboratory, category: "LABORATORY_AMENDMENT", draft: true, additional_information: params[:fee_id] ? {fee_id: params[:fee_id]} : false)
            # @redirect_to = draft_internal_laboratory_path @laboratory
        end
    end

    def update_approval
        # if @laboratory.changes.count == 0
        #     flash[:error] = "No changes detected"
        #     @redirect_to = internal_laboratories_path
        #     return
        # end

        approval_update_request(@laboratory, category: case @laboratory.approval_status
            when "NEW_REJECTED"
                "LABORATORY_REGISTRATION"
            else
                "LABORATORY_AMENDMENT"
            end, additional_information: params[:fee_id] ? {fee_id: params[:fee_id]} : false
        )
        flash[:notice] = "Laboratory submitted for approval."

        @laboratory.assign_attributes(@laboratory.approval_item.params)
        if @laboratory.approval_request.category == "LABORATORY_AMENDMENT" and ["address1", "address2", "address3", "address4", "state_id", "town_id", "postcode"].all? { |key| !@laboratory.changes.key?(key) }
            approval_approve_request(@laboratory)
            flash[:notice] = "Laboratory amendment auto-approved. If there's changes in email address, a confirmation email will be send out to verify the new email address."
        end

        @redirect_to = internal_laboratories_path
    end

    # DELETE /laboratories/1
    # DELETE /laboratories/1.json
    def destroy
        @laboratory.destroy
        respond_to do |format|
            format.html { redirect_to internal_laboratories_url, notice: 'Laboratory was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    # GET /laboratories/1/draft
    def draft
        @laboratory.assign_attributes(@laboratory.approval_item.params)
    end

    def cancel
        begin
            approval_cancel_request(@laboratory)
        rescue Exception => invalid
            flash.now[:error] = invalid.to_s
            redirect_to internal_laboratories_path and return
        end
        redirect_to internal_laboratories_path, notice: 'Request cancelled.'
    end

    # GET /laboratories/1/approval
    def approval
        @laboratory.assign_attributes(@laboratory.approval_item.params)
    end

    # PATCH/PUT /laboratories/1/approval
    # PATCH/PUT /laboratories/1/approval.json
    def approval_update
        @laboratory.assign_attributes(laboratory_approval_params)

        request_type = "Laboratory"
        case @laboratory.approval_request.category
        when "LABORATORY_REGISTRATION"
            request_type = "Laboratory registration request"
        when "LABORATORY_AMENDMENT"
            request_type = "Laboratory amendment request"
        end
        if approval_params[:decision] == 'APPROVE'
            notice = 'Laboratory is approved, concur is needed'
            approval_approve_request(@laboratory, comment: params[:approval][:comment], final_approval: approval_get_approval_tier(@laboratory.approval_status) == 2)
        elsif approval_params[:decision] == 'REJECT'
            notice = 'Laboratory is rejected.'
            approval_reject_request(@laboratory, comment: params[:approval][:comment])
        elsif approval_params[:decision] == 'REVERT'
            notice = 'Laboratory is reverted.'
            approval_revert_request(@laboratory, comment: params[:approval][:comment])
        end
        redirect_to internal_laboratories_path(status: "APPROVAL", cookied_path: "y"), notice: notice
    end

    # GET /laboratories/1/concur
    def concur
        @laboratory.assign_attributes(@laboratory.approval_item.params)
    end

    # PATCH/PUT /laboratories/1/concur
    # PATCH/PUT /laboratories/1/concur.json
    def concur_update
        @laboratory.assign_attributes(@laboratory.approval_item.params)

        case @laboratory.approval_request.category
        when "LABORATORY_REGISTRATION"
            fee = Fee.find_by(code: "LABORATORY_REGISTRATION")
            order = Order.create({
                customerable: @laboratory,
                category: "LABORATORY_REGISTRATION",
                date: Time.now,
                amount: fee.amount,
                status: "NEW"
            })
            order.order_items.create({
                order_itemable: @laboratory,
                fee_id: fee.id,
                amount: fee.amount
            })
            @laboratory.update_code
            flash[:notice] = "Laboratory #{@laboratory.code} concurred, order #{order.code} for laboratory registration is created"
            @redirect_to = internal_laboratories_path(status: "APPROVAL2", cookied_path: "y")
            approval_approve_request(@laboratory, comment: params[:concur][:comment], record_update_attributes: {
                registration_approved_at: Time.now
            })
        when "LABORATORY_AMENDMENT"
            if ["address1", "address2", "address3", "address4", "state_id", "town_id", "postcode"].any? { |key| @laboratory.changes.key?(key) }
                if @laboratory.approval_request && @laboratory.approval_request.try(:additional_information) && @laboratory.approval_request.try(:additional_information).key?("fee_id") && !@laboratory.approval_request.additional_information["fee_id"].blank?
                    fee = Fee.find(@laboratory.approval_request.additional_information["fee_id"])
                else
                    fee = Fee.find_by(code: "LABORATORY_CHANGE_ADDRESS")
                end
                order = Order.create({
                    customerable: @laboratory,
                    category: "LABORATORY_CHANGE_ADDRESS",
                    date: Time.now,
                    amount: fee.amount,
                    status: "NEW"
                })
                order.order_items.create({
                    order_itemable: @laboratory,
                    fee_id: fee.id,
                    amount: fee.amount
                })

                if fee.amount > 0
                    flash[:notice] = "Laboratory amendment concurred. Changes of address detected, order for laboratory amendment is created, please proceed to payment"
                    @redirect_to = edit_internal_order_path order
                else
                    order.update({
                        status: 'PAID',
                        paid_at: DateTime.now,
                        payment_method: PaymentMethod.find_by(code: "FOC")
                    })
                    flash[:notice] = "Laboratory amendment concurred"
                    @redirect_to = internal_laboratories_path(status: "APPROVAL2", cookied_path: "y")
                end
                approval_approve_request(@laboratory, comment: params[:concur][:comment])
            else
                flash[:notice] = "Laboratory amendment concurred"
                @redirect_to = internal_laboratories_path(status: "APPROVAL2", cookied_path: "y")
                approval_approve_request(@laboratory, comment: params[:concur][:comment])
            end
        end
        redirect_to @redirect_to || internal_laboratories_path(status: "APPROVAL2", cookied_path: "y")
    end

    def activate
        @laboratory.activate
        @laboratory.create_user if @laboratory.user.blank?
        redirect_to internal_laboratories_path(status: "TO_ACTIVATE", cookied_path: "y"), notice: 'Laboratory was activated.'
    end

    def bulk_reallocate
        render 'internal/laboratories/bulk_reallocate/edit'
    end

    def bulk_reallocate_update
        doctors = params[:doctors]
        doctors.each do |doctor|
            doctor = JSON.parse(doctor)
            if doctor['new_lab']
                clinic = Doctor.find_by(id: doctor['id'])
                clinic.laboratory_id = doctor['new_lab'] ? doctor['new_lab']['id'] : @laboratory.id
                clinic.save

                # Update transactions to the new laboratory if not certified, not cancelled, not rejected, not expired and no laboratory_examinations record
                Transaction.joins("LEFT OUTER JOIN laboratory_examinations ON laboratory_examinations.transaction_id = transactions.id")
                .where(doctor_id: clinic.id, laboratory_id: @laboratory.id)
                .where("transactions.certification_date IS NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND expired_at > CURRENT_DATE")
                .where("laboratory_examinations.id IS NULL")
                .update(laboratory_id: doctor['new_lab']['id'])

                # create targeted bulletins
                create_bulletin(doctor)
            end
        end
        notice = 'Bulk Re-Allocation Saved Successfully'
        redirect_to internal_laboratory_path, notice: notice
    end

    def create_bulletin(doctor)
        clinic = Doctor.find_by(id: doctor['id'])
        lab = Laboratory.find_by(id: doctor['new_lab']['id'])

        clinic_address =  "</br>#{ clinic.address1 }" if !clinic.address1.blank?
        clinic_address << "</br>#{ clinic.address2 }" if !clinic.address2.blank?
        clinic_address << "</br>#{ clinic.address3 }" if !clinic.address3.blank?
        clinic_address << "</br>#{ clinic.address4 }" if !clinic.address4.blank?
        clinic_address << "</br>#{ clinic.postcode } #{ Town.find_by(id: clinic.town_id).name }"
        clinic_address << "</br>#{ State.find_by(id: clinic.state_id).name }</br>"

        lab_address =  "</br>#{ lab.address1 }" if !lab.address1.blank?
        lab_address << "</br>#{ lab.address2 }" if !lab.address2.blank?
        lab_address << "</br>#{ lab.address3 }" if !lab.address3.blank?
        lab_address << "</br>#{ lab.address4 }" if !lab.address4.blank?
        lab_address << "</br>#{ lab.postcode } #{ Town.find_by(id: lab.town_id).name }"
        lab_address << "</br>#{ State.find_by(id: lab.state_id).name }</br>"

        doctor_content = "
        <p>Dear Dr #{clinic.name},</p>
        <p>Please be informed that you have been allocated to the following laboratory: </p>
        <p>
            <b>#{ lab.name } (#{ lab.code })</b>
            #{ lab_address }
            Phone: #{ lab.phone }
        </p>
        <p>However, this allocation may change from time to time and you would be informed accordingly. We seek your kind cooperation to refer the foreign workers to the appropriate facility which is also indicated in their FOMEMA's medical examination form.</p>
        <p>Thank you.</p>
        <p>Yours faithfully,</p>
        <p><b>Management of Service Providers Department</b></p>
        "

        lab_content = "
        <p>Dear PIC,</p>
        <p>Please be informed that you have been assigned to the following clinic:</p>
        <p>
            <b>#{ clinic.name } (#{ clinic.code })</b>
            #{ clinic_address }
            Phone: #{ clinic.phone }
        </p>
        <p>However, this allocation may change from time to time and you would be informed accordingly.</p>
        <p>Thank you.</p>
        <p>Yours faithfully,</p>
        <p><b>Management of Service Providers Department</b></p>
        "

        bulletins = [
            {
                title: "CHANGE OF LABORATORY FACILITY",
                content: doctor_content,
                audienceable_type: "Doctor",
                audienceable_id: clinic.id,
            },{
                title: "ALLOCATION OF CLINIC",
                content: lab_content,
                audienceable_type: "Laboratory",
                audienceable_id: lab.id,
            }
        ]

        bulletins.each do |bulletin|
            bulletin_params = {
                title: bulletin[:title],
                content: bulletin[:content],
                publish_from: Time.now,
                publish_to: Time.now + 30.days,
                require_acknowledge: false,
                is_pop_up: false
            }

            bulletin_audience_params = {
                bulletin_audienceable_type: bulletin[:audienceable_type],
                bulletin_audienceable_id: bulletin[:audienceable_id]
            }

            b = Bulletin.create(bulletin_params)
            b.bulletin_audiences.create(bulletin_audience_params)
        end
    end

    def operation_hours
        @operating_hour = OperatingHour.find_or_create_by({
            operating_hourable: @laboratory
        })
    end

    def search_laboratory
        @laboratories = Laboratory.search_code(params[:code])
        .search_name(params[:name])
        .search_state(params[:state_id])
        .search_postcode(params[:postcode])
        .search_town(params[:town_id])

        respond_to do |format|
            format.json { render :json => @laboratories.to_json(:include => [:state, :town, :doctors]), status: :ok }
        end
    end

    def allocated_workers
        @start_date = params[:date_from].presence
        @end_date = params[:date_to].presence
        @date_source = params[:date_source]
        respond_to do |format|
            format.html do
                render "internal/laboratories/allocated_workers/allocated_workers"
            end
            format.xlsx do
                @transactions =
                    @laboratory
                    .transactions
                    .left_joins(:employer, :fw_job_type, :fw_country, :laboratory, :doctor).joins(employer: :state)
                    .select("transactions.*, employers.name as emp_name, employers.pic_name as emp_pic_name, employers.pic_phone as emp_pic_phone, job_types.name as fw_jt_name, countries.name as fw_cty_name, states.name as emp_state_name, laboratories.code as laboratory_code, laboratories.name as laboratory_facility_name, laboratories.company_name as laboratory_company_name, case when transactions.registration_type = 1 then 'RENEWAL' else 'NEW' end as renewal, doctors.code doc_code, doctors.name doc_name")
                    .then { |transactions| transactions.send(:"#{@date_source}_between", @start_date, @end_date) }
                render xlsx: 'allocated_workers', filename: "Laboratory-#{@laboratory.code}-AllocatedForeignWorkers-#{DateTime.current.strftime("%Y%m%d%H%M%S")}.xlsx", template: "internal/laboratories/allocated_workers/allocated_workers"
            end
       end
    end

    def suspension_history
        @headers = %w[# Date Action Reason]
        @activities = @laboratory.suspension_activities

        respond_to do |format|
            format.html
            format.pdf { render_pdf }
            format.xlsx { render_xlsx }
        end
    end

    def summary_loading_statistic
        @previous_year = Time.now.prev_year
        @current_year = Time.now
    end

    private

    def set_laboratory
        @laboratory = Laboratory.find(params[:id])
    end

    def laboratory_params
        params.require(:laboratory).permit(:name, :company_name, :business_registration_number, :address1, :address2, :address3, :address4, :country_id, :state_id, :postcode, :town_id, :phone, :fax, :email, :email_payment, :pic_name, :pic_phone, :qualification, :pathologist_name, :nsr_number, :laboratory_type_id, :renewal_agreement_date, :status, :district_health_office_id, :samm_accredited_since, :samm_expiry_date, :samm_number, :license, :license_year, :web_service, :web_service_passphrase, :comment, :male_rate, :female_rate, :bank_id, :bank_payment_id, :bank_account_number, :payment_method_id)
    end

    def laboratory_approval_params
        params.require(:laboratory).permit()
    end

    def filtered_laboratory
        apply_scopes(Laboratory)
            .includes(:state, :town)
            .search_code(params[:code])
            .search_business_registration_number(params[:business_registration_number])
            .search_name(params[:name])
            .search_state(params[:state_id])
            .search_postcode(params[:postcode])
            .search_town(params[:town_id])
            .search_status(params[:status])
            .search_activated(params[:activated])
            .search_service_provider_group(params[:service_provider_group_id])
    end

    def render_pdf
        render pdf: action_name,
               template: "internal/laboratories/#{action_name}/_pdf_template.html.haml",
               header: {
                   html: {
                       template: "internal/laboratories/#{action_name}/pdf_template_header"
                   }
               },
               **default_pdf_options
    end

    def render_xlsx
       render xlsx: 'index', filename: "#{action_name.camelize}-#{DateTime.current.to_i}.xlsx",
              template: "internal/laboratories/#{action_name}/index"
    end

    def pdf_margin
        {
            top: 50,
            left: 12,
            right: 12,
            bottom: 10
        }
    end

    def default_pdf_options
       {
            layout: 'pdf.html',
            margin: pdf_margin,
            page_size: nil,
            page_height: '21cm',
            page_width: '29.7cm',
            dpi: '300'
       }
    end

    def set_date_time
        @date = DateTime.current.strftime('%d/%m/%Y')
        @time = DateTime.current.strftime('%H:%M:%S %p')
    end

    def set_company_name
        @company_name = SystemConfiguration.find_by(code: 'COMPANY_NAME')&.value
    end
end
