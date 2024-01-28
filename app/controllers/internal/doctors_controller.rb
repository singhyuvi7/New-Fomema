# frozen_string_literal: true

# app/controllers/internal/doctors_controller.rb
class Internal::DoctorsController < InternalController
    include Approvalable
    include ServiceProviderDocument
    include ValidateUserable

    before_action :set_doctor, only: %i[show edit draft cancel update destroy approval approval_update concur concur_update activate registration_invoice approval_letter pairing_letter operation_hours change_address_approval temporary_allocation_letter allocation_letter reallocation_back_letter registration_letter allocated_workers suspension_history coupling_history summary_loading_statistic buy_biometric_device]
    before_action :set_date_time, only: %i[suspension_history]
    before_action -> { validate_user_email?(@doctor, params[:doctor][:email]) }, only: [:update]
    before_action -> { validate_email_with_plus_sign(params[:doctor][:email]) }, only: [:create, :update]
    before_action :set_company_name, only: %i[suspension_history wall_list]
    before_action :set_biometric_fees, only: %i[buy_biometric_device]

    before_action -> { can_access?("VIEW_DOCTOR") }, only: [:index, :show]
    before_action -> { can_access?("DELETE_DOCTOR") }, only: [:destroy]
    before_action -> { can_access?("MSPD_REPORTS") }, only: [:summary_loading_statistic, :allocated_workers, :suspension_history]

    # GET /doctors
    # GET /doctors.json
    def index
        if params[:cookied_path] == "y" && session[:cookied_doctor_approval_path].present?
            redirect_to "#{ request.path }?#{ session[:cookied_doctor_approval_path] }" and return
        elsif ["APPROVAL", "APPROVAL2", "TO_ACTIVATE"].include?(params[:status])
            session[:cookied_doctor_approval_path] = request.url.split("?")[1].gsub("cookied_path=y", "")
        end

        respond_to do |format|
            format.html do
                @doctors = filtered_doctor.order('updated_at DESC').page(params[:page]).per(get_per)
            end
            format.xlsx do
                @pairs = {
                    code: "DOCTOR_CODE",
                    company_name: "COMPANY_NAME",
                    title_name: "TITLE",
                    name: "DOCTOR_NAME",
                    clinic_name: "CLINIC_NAME",
                    icno: "ICNO",
                    business_registration_number: "BUSINESS_REGISTRATION_NUMBER",
                    nationality: "NATIONALITY",
                    gender: "GENDER",
                    race: "RACE",
                    created_at: "CREATION_DATE",
                    displayed_address: "ADDRESS",
                    town_name: "GP_DISTRICT",
                    state_name: "GP_STATE",
                    postcode: "GP_POSTCODE",
                    phone: "GP_PHONE",
                    mobile: "GP_MOBILE",
                    fax: "GP_FAX",
                    email: "EMAIL",
                    qualification: "QUALIFICATION",
                    status: "GP_STATUS",
                    renewal_agreement_date: "RENEWAL_AGREEMENT_DATE",
                    apc_number: "APC_NUMBER",
                    apc_year: "APC_YEAR",
                    has_doctor_association:"DOCTOR_ASSOCIATION",
                    name_of_association:"NAME_OF_ASSOCIATION",
                    district_health_office_name: "DISTRICT_HEALTH_OFFICE",
                    fp_device_display: "FP_DEVICE",
                    activated_at: "ACTIVATED_AT",
                    quota: "QUOTA",
                    quota_modifier: "QUOTA_MODIFIER",
                    quota_used: "QUOTA_USED",
                    quota_used_include_pending_order: "QUOTA_USED_INCLUDE_PENDING",
                    displayed_quota: "QUOTA",
                    current_year_certified_worker_count: "CERTIFIED_WORKER",
                    available_quota: "AVAILABLE_QUOTA",
                    over_quota_yes_no: "OVER_QUOTA",
                    status_reason_display: "STATUS_REASON",
                    status_comment: "STATUS_COMMENT",
                    solo_clinic: "SOLO_CLINIC",
                    group_clinic: "GROUP_CLINIC",
                    has_xray: "OWN_XRAY_CLINIC",
                    has_selected_re_medical: "SELECTED_FOR_RE_MEDICAL",
                    xray_facility_pairing_options_display: "XRAY_FACILITY_PAIRING_OPTIONS",
                    laboratory_pairing_options_display: "LABORATORY_PAIRING_OPTIONS",
                    xray_facility_code: "XRAY_CODE",
                    xray_facility_name: "XRAY_NAME",
                    xray_facility_email: "XRAY_EMAIL",
                    xray_facility_phone: "XRAY_PHONE",
                    xray_facility_fax: "XRAY_FAX",
                    xray_facility_displayed_address: "XRAY_ADDRESS",
                    xray_facility_town_name: "XRAY_DISTRICT",
                    xray_facility_state_name: "XRAY_STATE",
                    laboratory_code: "LABORATORY_CODE",
                    laboratory_name: "LABORATORY_NAME",
                    laboratory_email: "LABORATORY_EMAIL",
                    laboratory_displayed_address: "LABORATORY_ADDRESS",
                    laboratory_state: "LAB_STATE",
                    laboratory_district: "LAB_DISTRICT",
                    service_provider_group_name: "SERVICE_PROVIDER_GROUP_NAME",
                    total_fw_two_year_ago: "TOTAL_FW_#{2.year.ago.year}",
                    total_fw_one_year_ago: "TOTAL_FW_#{1.year.ago.year}",
                }
                if has_permission?("VIEW_FINANCE_INFO_DOCTOR")
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
                @captions = @pairs.values
                @cols = @pairs.keys
                @doctors = DoctorDecorator.decorate_collection filtered_doctor
                render xlsx: 'index', filename: "Doctors-#{DateTime.current.to_i}.xlsx"
            end
            format.json do
                @doctors = filtered_doctor.order('updated_at DESC')
            end
        end
    end

    # GET /doctors/1
    # GET /doctors/1.json
    def show
    end

    # GET /doctors/new
    def new
        today = Date.today
        case today.month
        when 1, 2, 3
            quota = 125
        when 4, 5, 6
            quota = 250
        when 7, 8, 9
            quota = 375
        when 10, 11, 12
            quota = 500
        end

        @doctor = Doctor.new({
            quota: quota,
            fp_device: 0,
            male_rate: SystemConfiguration.get("DOCTOR_DEFAULT_MALE_RATE"),
            female_rate: SystemConfiguration.get("DOCTOR_DEFAULT_FEMALE_RATE"),
            payment_method_id: PaymentMethod.find_by(code: "OUT_CASHORDER").try(:id)
        })
        @xray_facilities = []
        @laboratory_facilities = []
    end

    # POST /doctors
    # POST /doctors.json
    def create
        data = {
            male_rate: SystemConfiguration.find_by(code: "DOCTOR_DEFAULT_MALE_RATE").try(:value),
            female_rate: SystemConfiguration.find_by(code: "DOCTOR_DEFAULT_FEMALE_RATE").try(:value),
            payment_method_id: PaymentMethod.find_by(code: "OUT_CASHORDER").try(:id)
        }.merge(doctor_params).merge({
            status: "INACTIVE",
            associations: params[:doctor][:has_doctor_association].to_s.downcase == 'true' ? {association: params[:doctor][:associations]} : nil,
        })
        data["pairing_options"] = pairing_options_from_param
        data["icno"] = data["icno"].gsub(/[^0-9A-Za-z]/, '') if !data["icno"].nil?

        if data['company_name'].blank?
            data["bank_payment_id"] = data["icno"] if data["bank_payment_id"].blank?
        else
            data["bank_payment_id"] = data["business_registration_number"] if data["bank_payment_id"].blank?
        end

        @doctor = Doctor.new(data)
        set_pairings
        # if (User.where("email ilike ?", @doctor.email).count > 0)
        #     @doctor.errors.add(:email, "not available")
        #     render :new and return
        # end

        @doctor.save
        OperatingHour.create({operating_hourable: @doctor})

        notice = ""

        case params[:submit]
        when 'Save draft'
            save_ok = approval_new_request(@doctor, category: "DOCTOR_REGISTRATION", draft: true)
            notice = "Doctor saved as draft."
        when 'Submit for approval'
            save_ok = approval_new_request(@doctor, category: "DOCTOR_REGISTRATION")
            notice = "New doctor request created."
        end

        respond_to do |format|
            if save_ok
                format.html { redirect_to internal_doctors_path, notice: notice }
                format.json { render :show, status: :created, location: @doctor }
            else
                format.html { render :new }
                format.json { render json: @doctor.errors, status: :unprocessable_entity }
            end
        end
    end

    # GET /doctors/1/edit
    def edit
    end

    # PATCH/PUT /doctors/1
    # PATCH/PUT /doctors/1.json
    def update
        data = doctor_params

        data = doctor_params.merge({
            associations: params[:doctor][:has_doctor_association].to_s.downcase == 'true' ? {association: params[:doctor][:associations]} : nil,
        }) unless (params[:doctor][:has_doctor_association]).nil?

        data["pairing_options"] = pairing_options_from_param
        data["icno"] = data["icno"].gsub(/[^0-9A-Za-z]/, '') if !data["icno"].nil?

        @doctor.assign_attributes(data)

        case params[:submit]
        when 'Save draft'
            update_draft
        when 'Submit for approval'
            if ["clinic_name", "address1", "address2", "address3", "address4", "state_id", "town_id", "postcode"].any? { |key| @doctor.changes.key?(key) } && params[:fee_id].blank?
                @doctor.errors.add(:base, "Fee is required")
                render :edit and return
            end
            update_approval
        end
        redirect_to @redirect_to || internal_doctors_path
    end

    def update_draft
        if @doctor.changes.count == 0
            flash[:error] = "No changes detected"
            @redirect_to = internal_doctors_path
        else
            approval_update_request(@doctor, category: "DOCTOR_AMENDMENT", draft: true, additional_information: params[:fee_id] ? {fee_id: params[:fee_id]} : false)
            # @redirect_to = draft_internal_doctor_path @doctor
        end
    end

    def update_approval
        # if @doctor.changes.count == 0
        #     flash[:error] = "No changes detected"
        #     @redirect_to = internal_doctors_path
        #     return
        # end

        approval_update_request(@doctor, category: case @doctor.approval_status
            when "NEW_REJECTED"
                "DOCTOR_REGISTRATION"
            else
                "DOCTOR_AMENDMENT"
            end, additional_information: params[:fee_id] ? {fee_id: params[:fee_id]} : false
        )
        flash[:notice] = "Doctor submitted for approval."

        @doctor.assign_attributes(@doctor.approval_item.params)
        if @doctor.approval_request.category == "DOCTOR_AMENDMENT" && ["clinic_name", "address1", "address2", "address3", "address4", "state_id", "town_id", "postcode"].all? { |key| !@doctor.changes.key?(key) }
            approval_approve_request(@doctor)
            flash[:notice] = "Doctor amendment auto-approved. If there's changes in email address, a confirmation email will be send out to verify the new email address."
        end

        @redirect_to = internal_doctors_path
    end

    def pairing_options_from_param
        pairing_options = {}
        if (params.include?('xray_facility_pairing_recommendations'))
            pairing_options["xray_facilities"] = params[:xray_facility_pairing_recommendations].split(",")
        end
        if (params.include?('laboratory_pairing_recommendations'))
            pairing_options["laboratories"] = params[:laboratory_pairing_recommendations].split(",")
        end
        pairing_options
    end

    # DELETE /doctors/1
    # DELETE /doctors/1.json
    def destroy
        @doctor.destroy
        respond_to do |format|
            format.html { redirect_to internal_doctors_url, notice: 'Doctor was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    # GET /doctors/1/draft
    def draft
        @doctor.assign_attributes(@doctor.approval_item.params)
        set_pairings
    end

    def cancel
        begin
            approval_cancel_request(@doctor)
        rescue Exception => invalid
            flash.now[:error] = invalid.to_s
            redirect_to internal_doctors_path and return
        end
        redirect_to internal_doctors_path, notice: 'Request cancelled.'
    end

    # GET /doctors/1/approval
    def approval
        @doctor.assign_attributes(@doctor.approval_item.params)
        set_pairings
    end

    # PATCH/PUT /doctors/1/approval
    # PATCH/PUT /doctors/1/approval.json
    def approval_update
        @doctor.assign_attributes(doctor_approval_params)

        request_type = "Doctor"
        case @doctor.approval_request.category
        when "DOCTOR_REGISTRATION"
            request_type = "Doctor registration request"
        when "DOCTOR_AMENDMENT"
            request_type = "Doctor amendment request"
        end

        if approval_params[:decision] == 'APPROVE'
            notice = "#{request_type} is approved"
            approval_approve_request(@doctor, comment: params[:approval][:comment], final_approval: approval_get_approval_tier(@doctor.approval_status) == 2)
        elsif approval_params[:decision] == 'REJECT'
            notice = "#{request_type} is rejected"
            approval_reject_request(@doctor, comment: params[:approval][:comment])
        elsif approval_params[:decision] == 'REVERT'
            notice = "#{request_type} is reverted"
            approval_revert_request(@doctor, comment: params[:approval][:comment])
        end
        redirect_to internal_doctors_path(status: "APPROVAL", cookied_path: "y"), notice: notice
    end

    # GET /doctors/1/concur
    def concur
        @doctor.assign_attributes(@doctor.approval_item.params)
    end

    # PATCH/PUT /doctors/1/concur
    # PATCH/PUT /doctors/1/concur.json
    def concur_update
        @doctor.assign_attributes(@doctor.approval_item.params)
        @doctor.assign_attributes(doctor_concur_params)

        case @doctor.approval_request.category
        when "DOCTOR_REGISTRATION"
            fee = Fee.find_by(code: "DOCTOR_REGISTRATION")
            order = Order.create({
                customerable: @doctor,
                category: "DOCTOR_REGISTRATION",
                date: Time.now,
                amount: fee.amount,
                status: "NEW"
            })
            order.order_items.create({
                order_itemable: @doctor,
                fee_id: fee.id,
                amount: fee.amount
            })
            @doctor.update_code
            flash[:notice] = "Doctor #{@doctor.code} concurred, order #{order.code} for doctor registration is created"
            @redirect_to = internal_doctors_path(status: "APPROVAL2", cookied_path: "y")
            approval_approve_request(@doctor, comment: params[:concur][:comment], record_update_attributes: {
                registration_approved_at: Time.now
            })
        when "DOCTOR_AMENDMENT"
            if ["address1", "address2", "address3", "address4", "state_id", "town_id", "postcode"].any? { |key| @doctor.changes.key?(key) }
                if @doctor.approval_request && @doctor.approval_request.try(:additional_information) && @doctor.approval_request.try(:additional_information).key?("fee_id") && !@doctor.approval_request.additional_information["fee_id"].blank?
                    fee = Fee.find(@doctor.approval_request.additional_information["fee_id"])
                else
                    fee = Fee.find_by(code: "DOCTOR_CHANGE_ADDRESS")
                end
                order = Order.create({
                    customerable: @doctor,
                    category: "DOCTOR_CHANGE_ADDRESS",
                    date: Time.now,
                    amount: fee.amount,
                    status: "NEW"
                })
                order.order_items.create({
                    order_itemable: @doctor,
                    fee_id: fee.id,
                    amount: fee.amount
                })

                if fee.amount > 0
                    flash[:notice] = "Doctor amendment concurred. Changes of address detected, order for doctor amendment is created, please proceed to payment"
                    @redirect_to = edit_internal_order_path order
                else
                    order.update({
                        status: 'PAID',
                        paid_at: DateTime.now,
                        payment_method: PaymentMethod.find_by(code: "FOC")
                    })
                    flash[:notice] = "Doctor amendment concurred."
                    @redirect_to = internal_doctors_path(status: "APPROVAL2", cookied_path: "y")
                end
                approval_approve_request(@doctor, comment: params[:concur][:comment])
            else
                flash[:notice] = "Doctor amendment concurred"
                @redirect_to = internal_doctors_path(status: "APPROVAL2", cookied_path: "y")
                approval_approve_request(@doctor, comment: params[:concur][:comment])
            end
        end
        redirect_to @redirect_to || internal_doctors_path(status: "APPROVAL2", cookied_path: "y")
    end

    def activate
        @doctor.activate
        @doctor.create_user if @doctor.user.blank?
        redirect_to internal_doctors_path(status: "TO_ACTIVATE", cookied_path: "y"), notice: 'Doctor was activated.'
    end

    def filter_xray_facilities
        @xray_facilities = XrayFacility.where(status: 'ACTIVE').search_code(params[:code])
        .search_name(params[:name])
        .search_state(params[:state_id])
        .search_town(params[:town_id]).order(:name).includes(:state, :town)

        @selected_facilities = params[:selected].present? ? params[:selected].uniq.map(&:to_i) : []
        render layout: false
    end

    def filter_laboratories
        @laboratory_facilities = Laboratory.where(status: 'ACTIVE').search_code(params[:code])
        .search_name(params[:name])
        .search_state(params[:state_id])
        .search_town(params[:town_id]).order(:name).includes(:state, :town)

        @selected_facilities = params[:selected].present? ? params[:selected].uniq.map(&:to_i) : []
        render layout: false
    end

    def assign_quota
        ids     = params[:quota_doctor_ids].split(",")
        quota   = params[:allocated_quota].to_i
        doctors = Doctor.where(id: ids)
        errors  = []
        errors  << "There was an error allocating the quota" if doctors.blank?
        errors  << "Can not allocate quota of 0" if quota == 0

        if errors.present?
            redirect_to internal_doctors_path, errors: errors
        else
            doctors.each do |doctor|
                doctor.update(quota_modifier: doctor.quota_modifier + quota)
            end

            redirect_to internal_doctors_path, notice: "Quota allocated"
        end
    end

    def operation_hours
        @operating_hour = OperatingHour.find_or_create_by({
            operating_hourable: @doctor
        })
    end

    def wall_list
        current = Time.now
        @date = current.strftime('%d/%m/%Y')
        @time = current.strftime('%H:%M:%S %p')
        @state = params[:state_id]
        @town = params[:town_id]

        @doctors = filtered_doctor.order('updated_at DESC')

        respond_to do |format|
            format.html { render "pdf_templates/doctors/doctor_wall_list"}
            format.pdf { render pdf: "doctor_wall_list",
                template: 'pdf_templates/doctors/doctor_wall_list.html.erb',
                layout: "pdf.html",
                margin: {
                    top: 30,
                    left: 7,
                    right: 7,
                    bottom: 10,
                },
                page_size: nil,
                page_height: "29.7cm",
                page_width: "21cm",
                dpi: "300",
                header: {
                    html: {
                        template: 'pdf_templates/doctors/doctor_wall_list_header'
                    }
                }
            }
        end
    end

    # def workers
    #     @start_date = params[:date_from].presence
    #     @end_date = params[:date_to].presence
    #     @date_source = params[:date_source]
    #     @headers = ['No.', 'Worker Code', 'Worker Name', 'Employer Code',
    #                 'Trans. Date', 'Exam. Date', 'Certify Date', 'Height',
    #                 'Weight', 'Pulse', 'Systolic', 'Diastolic', 'Bld Grp',
    #                 'RH', 'Fit Ind']
    #    respond_to do |format|
    #         format.html
    #         format.pdf do
    #             return redirect_to(workers_internal_doctor_path(@doctor), notice: 'Please input date') if @start_date.nil? || @end_date.nil?

    #             if @start_date.present? && @end_date.present?
    #                 if @date_source == 'both'
    #                     @transactions =
    #                         @doctor
    #                         .transactions
    #                         .includes(:foreign_worker, :employer, :medical_examination, :laboratory_examination)
    #                         .certified_between(@start_date, @end_date)
    #                         .transaction_date_between(@start_date, @end_date)
    #                         .where(final_result: %w[SUITABLE UNSUITABLE])
    #                         .order(:certification_date, :transaction_date)
    #                         .decorate
    #                 else
    #                     @transactions =
    #                         @doctor
    #                         .transactions
    #                         .includes(:foreign_worker, :employer, :medical_examination, :laboratory_examination)
    #                         .then { |transactions| transactions.send(:"#{@date_source}_between", @start_date, @end_date) }
    #                         .where(final_result: %w[SUITABLE UNSUITABLE])
    #                         .order(@date_source.to_sym)
    #                         .decorate
    #                 end
    #             end
    #             render_pdf
    #         end
    #    end
    # end

    def allocated_workers
        @start_date = params[:date_from].presence
        @end_date = params[:date_to].presence
        @date_source = params[:date_source]
        respond_to do |format|
            format.html do
                render "internal/doctors/allocated_workers/allocated_workers"
            end
            format.xlsx do
                @transactions =
                    @doctor
                    .transactions
                    .left_joins(:employer, :fw_job_type, :fw_country, :doctor).joins(employer: :state)
                    .select("transactions.*, employers.name as employer_name, employers.pic_name as employer_pic_name, employers.pic_phone as employer_pic_phone, job_types.name as fw_job_type_name, countries.name as fw_country_name, states.name as employer_state_name, doctors.code as doctor_code, doctors.name as doctor_name, doctors.clinic_name as doctor_clinic_name, case when transactions.registration_type = 1 then 'RENEWAL' else 'NEW' end as renewal")
                    .then { |transactions| transactions.send(:"#{@date_source}_between", @start_date, @end_date) }
                    .order(@date_source.to_sym)
                render xlsx: 'allocated_workers', filename: "Doctor-#{@doctor.code}-AllocatedForeignWorkers-#{DateTime.current.strftime("%Y%m%d%H%M%S")}.xlsx", template: "internal/doctors/allocated_workers/allocated_workers"
            end
       end
    end

    def suspension_history
        @headers = %w[# Date Action Reason]
        @activities = @doctor.suspension_activities

        respond_to do |format|
            format.html
            format.pdf { render_pdf }
            format.xlsx { render_xlsx }
        end
    end

    def coupling_history
        @lab_allocates = Allocate.where(:old_allocatable_type => 'Laboratory',:doctor_id => @doctor.id).where.not(:old_allocatable_id => nil).order('created_at ASC')
        @xray_allocates = Allocate.where(:old_allocatable_type => 'XrayFacility',:doctor_id => @doctor.id).where.not(:old_allocatable_id => nil).order('created_at ASC')
    end

    def summary_loading_statistic
        @previous_year = Time.now.prev_year
        @current_year = Time.now
    end

    def buy_biometric_device
        order = Order.create({
            customerable: @doctor,
            category: "DOCTOR_BIOMETRIC_DEVICE",
        })

        @biometric_fees.each do |fee|
            order.order_items.create({
                order_itemable: @doctor,
                fee_id: fee.id,
                amount: fee.amount,
            })
        end

        redirect_to edit_internal_order_path(order), notice: "Order (#{order.code}) is created, please proceed payment"
    end

    private

    def set_doctor
        @doctor = Doctor.find(params[:id])
        set_pairings
    end

    def set_pairings
        xray_pairing_ids = @doctor.xray_facility_pairing_options || ""
        laboratory_pairing_ids = @doctor.laboratory_pairing_options || ""
        @xray_facilities = XrayFacility.where(id: xray_pairing_ids.split(",")).includes(:state, :town)
        @laboratory_facilities = Laboratory.where(id: laboratory_pairing_ids.split(",")).includes(:state, :town)
    end

    def filtered_doctor
        Doctor
            .includes(:state)
            .includes(:town)
            .search_name(params[:name])
            .search_code(params[:code])
            .search_clinic_name(params[:clinic_name])
            .search_icno(params[:icno])
            .search_state(params[:state_id])
            .search_town(params[:town_id])
            .search_postcode(params[:postcode])
            .search_activated(params[:activated])
            .search_status(params[:status])
            .search_associated_lab(params[:laboratory_code])
            .search_associated_xray(params[:xray_facility_code])
            .search_service_provider_group(params[:service_provider_group_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def doctor_params
        params.require(:doctor).permit(:code, :name, :clinic_name, :company_name, :status, :approval_status, :icno, :title_id, :address1, :address2, :address3, :address4, :country_id, :state_id, :postcode, :town_id, :phone, :fax, :mobile, :email, :email_payment, :qualification, :apc_year, :apc_number, :has_doctor_association, :name_of_association, :renewal_agreement_date, :district_health_office_id, :has_xray, :has_selected_re_medical, :fp_device, :quota, :quota_used, :solo_clinic, :group_clinic, :clinic_id, :xray_facility_id, :laboratory_id, :nearest_xray_facility_id, :comment, :pairing_options, :male_rate, :female_rate, :bank_id, :bank_account_number, :bank_payment_id, :payment_method_id, :business_registration_number, :gender, :nationality_id, :race_id, :paid_biometric_device)
    end

    def doctor_approval_params
        params.require(:doctor).permit(:xray_facility_id, :laboratory_id)
    end

    def doctor_concur_params
        params.require(:doctor).permit(:xray_facility_id, :laboratory_id)
    end

    def render_pdf
        render pdf: action_name,
               template: "internal/doctors/#{action_name}/_pdf_template.html.haml",
               header: {
                   html: {
                       template: "internal/doctors/#{action_name}/pdf_template_header"
                   }
               },
               **default_pdf_options
    end

    def render_xlsx
       render xlsx: 'index', filename: "#{action_name.camelize}-#{DateTime.current.to_i}.xlsx",
              template: "internal/doctors/#{action_name}/index"
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
        @company_name = SystemConfiguration.find_by(code: 'COMPANY_NAME')&.value.try(:upcase)
    end

    def set_biometric_fees
        biometric_device_fee = Fee.find_by(code: "BIOMETRIC_DEVICE")
        biometric_admin_fee = Fee.find_by(code: "BIOMETRIC_ADMIN")
        @biometric_fees = []
        @biometric_fees << biometric_device_fee
        @biometric_fees << biometric_admin_fee
    end
end
