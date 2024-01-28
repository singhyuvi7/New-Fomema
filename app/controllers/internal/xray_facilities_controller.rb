class Internal::XrayFacilitiesController < InternalController
    include Approvalable
    include ServiceProviderDocument
    include ValidateUserable

    before_action :set_xray_facility, only: [:show, :edit, :draft, :cancel, :update, :destroy, :approval, :approval_update, :concur, :concur_update, :approval_letter, :registration_invoice, :activate, :bulk_reallocate, :bulk_reallocate_update, :operation_hours, :change_address_approval, :registration_letter, :allocated_workers, :suspension_history, :summary_loading_statistic, :license_expiry_amendment_logs, :buy_biometric_device]
    before_action :set_date_time, only: %i[suspension_history]
    before_action -> { validate_user_email?(@xray_facility, params[:xray_facility][:email]) }, only: [:update]
    before_action -> { validate_email_with_plus_sign(params[:xray_facility][:email]) }, only: [:create, :update]
    before_action :set_company_name, only: %i[suspension_history]
    before_action :set_biometric_fees, only: %i[buy_biometric_device]

    before_action -> { can_access?("VIEW_XRAY_FACILITY") }, only: [:index, :show]
    before_action -> { can_access?("EDIT_FINANCE_INFO_XRAY_FACILITY", "EDIT_NON_FINANCE_INFO_XRAY_FACILITY") }, only: [:edit, :update]
    before_action -> { can_access?("DELETE_XRAY_FACILITY") }, only: [:destroy]
    before_action -> { can_access?("MSPD_REPORTS") }, only: [:suspension_history, :summary_loading_statistic]

    # GET /xray_facilities
    # GET /xray_facilities.json
    def index
        if params[:cookied_path] == "y" && session[:cookied_xray_facility_approval_path].present?
            redirect_to "#{ request.path }?#{ session[:cookied_xray_facility_approval_path] }" and return
        elsif ["APPROVAL", "APPROVAL2", "TO_ACTIVATE"].include?(params[:status])
            session[:cookied_xray_facility_approval_path] = request.url.split("?")[1].gsub("cookied_path=y", "")
        end

        respond_to do |format|
            format.html do
                @xray_facilities = filtered_facility.order('updated_at DESC').page(params[:page]).per(get_per)
            end
            format.xlsx do
                @pairs = {
                    code: "XRAY_CODE",
                    title_name: "TITLE",
                    name: "XRAY_NAME",
                    created_at: "CREATION_DATE",
                    license_holder_name: "LICENSE_HOLDER_NAME",
                    company_name: "COMPANY_NAME",
                    icno: "ICNO",
                    business_registration_number: "BUSINESS_REGISTRATION_NUMBER",
                    nationality: "NATIONALITY",
                    gender: "GENDER",
                    race: "RACE",
                    displayed_address: "ADDRESS",
                    town_name: "TOWN_NAME",
                    postcode: "POSTCODE",
                    state_name: "STATE_NAME",
                    radiologist_operated: "RADIOOPERATED",
                    radiologist_name: "RADIOLOGIST_NAME",
                    fp_device: "FP_DEVICE",
                    phone: "PHONE",
                    fax: "FAX",
                    mobile: "MOBILE",
                    email: "EMAIL",
                    status: "STATUS",
                    status_reason_display: "STATUS_REASON",
                    status_comment: "STATUS_COMMENT",
                    film_type: "XRAY_TYPE",
                    qualification: "QUALIFICATION",
                    xray_license_number: "XRAY_LICENSE_NUMBER",
                    xray_file_number: "XRAY_FILE_NUMBER",
                    xray_license_tujuan: "XRAY_LICENSE_TUJUAN",
                    xray_license_expiry_date: "XRAY_LICENSE_EXPIRY_DATE",
                    moh_license_status: "MOH_LICENSE_STATUS",
                    apc_number: "APC_NUMBER",
                    apc_year: "APC_YEAR",
                    has_doctor_association:"DOCTOR_ASSOCIATION",
                    name_of_association:"NAME_OF_ASSOCIATION",
                    has_selected_re_medical: "SELECTED_FOR_RE_MEDICAL",
                    renewal_agreement_date: "RENEWAL_AGREEMENT_DATE",
                    district_health_office_name: "DISTRICT_HEALTH_OFFICE_NAME",
                    activated_at: "ACTIVATED_AT",
                    service_provider_group_name: "SERVICE_PROVIDER_GROUP",
                    doctors_count: "TOTAL_CLINIC",
                    active_doctors_count: "ACTIVE_CLINIC_ASSOCIATES",
                    total_worker_allocated: "TOTAL_WORKER_ALLOCATED",
                    total_fw_two_year_ago: "TOTAL_FW_#{2.year.ago.year}",
                    total_fw_one_year_ago: "TOTAL_FW_#{1.year.ago.year}",
                }
                if has_permission?("VIEW_FINANCE_INFO_XRAY_FACILITY")
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
                @xray_facilities = XrayFacilityDecorator.decorate_collection filtered_facility
                render xlsx: 'index', filename: "XrayFacilities-#{DateTime.current.to_i}.xlsx"
            end
            format.json do
                @xray_facilities = filtered_facility.order('updated_at DESC')
            end
        end
    end

    # GET /xray_facilities/1
    # GET /xray_facilities/1.json
    def show
    end

    # GET /xray_facilities/new
    def new
        male_rate =
        female_rate =
        @xray_facility = XrayFacility.new({
            fp_device: 0,
            male_rate: SystemConfiguration.find_by(code: "XRAY_FACILITY_DEFAULT_MALE_RATE").try(:value),
            female_rate: SystemConfiguration.find_by(code: "XRAY_FACILITY_DEFAULT_FEMALE_RATE").try(:value),
            payment_method_id: PaymentMethod.find_by(code: "OUT_CASHORDER").try(:id),
            # digital_xray_provider_id: DigitalXrayProvider.find_by(code: "FTES").try(:id),
            xray_fac_flag: false,
            radiologist_operated: false,
        })
    end

    # POST /xray_facilities
    # POST /xray_facilities.json
    def create
        data = {
            male_rate: SystemConfiguration.find_by(code: "XRAY_FACILITY_DEFAULT_MALE_RATE").try(:value),
            female_rate: SystemConfiguration.find_by(code: "XRAY_FACILITY_DEFAULT_FEMALE_RATE").try(:value),
            payment_method_id: PaymentMethod.find_by(code: "OUT_CASHORDER").try(:id),
            film_type: "DIGITAL",
            # digital_xray_provider_id: DigitalXrayProvider.find_by(code: "FTES").try(:id)
        }.merge(xray_facility_params).merge({
            status: "INACTIVE",
            associations: params[:xray_facility][:has_doctor_association].to_s.downcase == 'true' ? {association: params[:xray_facility][:associations]} : nil,
            xray_license_purposes_id: {xray_license_purposes_id: params[:xray_facility][:xray_license_purposes_id]},
        })
        data["icno"] = data["icno"].gsub(/[^0-9A-Za-z]/, '') if !data["icno"].nil?
        if data['company_name'].blank?
            data["bank_payment_id"] = data["icno"] if data["bank_payment_id"].blank?
        else
            data["bank_payment_id"] = data["business_registration_number"] if data["bank_payment_id"].blank?
        end

        @xray_facility = XrayFacility.new(data)
        # if (User.where("email ilike ?", @xray_facility.email).count > 0)
        #     @xray_facility.errors.add(:email, "not available")
        #     render :new and return
        # end

        @xray_facility.save
        OperatingHour.create({operating_hourable: @xray_facility})

        notice = ""

        case params[:submit]
        when 'Save draft'
            save_ok = approval_new_request(@xray_facility, category: "XRAY_FACILITY_REGISTRATION", draft: true)
            notice = "X-Ray Facility saved as draft."
        when 'Submit for approval'
            save_ok = approval_new_request(@xray_facility, category: "XRAY_FACILITY_REGISTRATION")
            notice = "New X-Ray Facility request created."
        end

        respond_to do |format|
            if save_ok
                format.html { redirect_to internal_xray_facilities_path, notice: notice }
                format.json { render :show, status: :created, location: @xray_facility }
            else
                format.html { render :new }
                format.json { render json: @xray_facility.errors, status: :unprocessable_entity }
            end
        end
    end

    # GET /xray_facilities/1/edit
    def edit
    end

    # PATCH/PUT /xray_facilities/1
    # PATCH/PUT /xray_facilities/1.json
    def update
        data = xray_facility_params
        if !(params[:xray_facility][:xray_license_purposes_id]).nil?
            data = xray_facility_params.merge({
                associations: params[:xray_facility][:has_doctor_association].to_s.downcase == 'true' ? {association: params[:xray_facility][:associations]} : nil,
                xray_license_purposes_id: {xray_license_purposes_id: params[:xray_facility][:xray_license_purposes_id]},
            })
        end
        data["icno"] = data["icno"].gsub(/[^0-9A-Za-z]/, '') if !data["icno"].nil?

        @xray_facility.assign_attributes(data)
        case params[:submit]
        when 'Save draft'
            update_draft
        when 'Submit for approval'
            if ["address1", "address2", "address3", "address4", "state_id", "town_id", "postcode"].any? { |key| @xray_facility.changes.key?(key) } && params[:fee_id].blank?
                @xray_facility.errors.add(:base, "Fee is required")
                render :edit and return
            end
            update_approval
        end

        if params[:remove_uploaded_file].present?
            ids = params[:remove_uploaded_file].split(",")
            @xray_facility.uploads.where(id: ids).destroy_all
        end

        redirect_to @redirect_to || internal_xray_facilities_path
    end

    def update_draft
        if @xray_facility.changes.count == 0
            flash[:error] = "No changes detected"
            @redirect_to = internal_xray_facilities_path
        else
            approval_update_request(@xray_facility, category: "XRAY_FACILITY_AMENDMENT", draft: true, additional_information: params[:fee_id] ? {fee_id: params[:fee_id]} : false)
            # @redirect_to = draft_internal_xray_facility_path @xray_facility
        end
    end

    def update_approval
        # if @xray_facility.changes.count == 0
        #     flash[:error] = "No changes detected"
        #     @redirect_to = internal_xray_facilities_path
        #     return
        # end

        approval_update_request(@xray_facility, category: case @xray_facility.approval_status
            when "NEW_REJECTED"
                "XRAY_FACILITY_REGISTRATION"
            else
                "XRAY_FACILITY_AMENDMENT"
            end, additional_information: params[:fee_id] ? {fee_id: params[:fee_id]} : false
        )
        flash[:notice] = "X-Ray Facility submitted for approval."

        @xray_facility.assign_attributes(@xray_facility.approval_item.params)
        if @xray_facility.approval_request.category == "XRAY_FACILITY_AMENDMENT" && ["address1", "address2", "address3", "address4", "state_id", "town_id", "postcode"].all? { |key| !@xray_facility.changes.key?(key) }
            approval_approve_request(@xray_facility)
            flash[:notice] = "X-Ray Facility amendment auto-approved. If there's changes in email address, a confirmation email will be send out to verify the new email address."
        end

        @redirect_to = internal_xray_facilities_path
    end

    # DELETE /xray_facilities/1
    # DELETE /xray_facilities/1.json
    def destroy
        @xray_facility.destroy
        respond_to do |format|
            format.html { redirect_to internal_xray_facilities_url, notice: 'X-Ray Facility was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    # GET /xray_facilities/1/draft
    def draft
        @xray_facility.assign_attributes(@xray_facility.approval_item.params)
    end

    def cancel
        begin
            approval_cancel_request(@xray_facility)
        rescue Exception => invalid
            flash.now[:error] = invalid.to_s
            redirect_to internal_xray_facilities_path and return
        end
        redirect_to internal_xray_facilities_path, notice: 'Request cancelled.'
    end

    # GET /xray_facilities/1/approval
    def approval
        @xray_facility.assign_attributes(@xray_facility.approval_item.params)
    end

    # PATCH/PUT /xray_facilities/1/approval
    # PATCH/PUT /xray_facilities/1/approval.json
    def approval_update
        @xray_facility.assign_attributes(xray_facility_approval_params)

        request_type = "X-Ray Facility"
        case @xray_facility.approval_request.category
        when "XRAY_FACILITY_REGISTRATION"
            request_type = "X-Ray Facility registration request"
        when "XRAY_FACILITY_AMENDMENT"
            request_type = "X-Ray Facility amendment request"
        when "XRAY_FACILITY_LICENSE_EXPIRY_AMENDMENT"
            request_type = "X-Ray Facility license expiry amendment request"
        end
        if approval_params[:decision] == 'APPROVE'
            notice = 'X-Ray Facility is approved.'
            if @xray_facility.approval_request.category == "XRAY_FACILITY_LICENSE_EXPIRY_AMENDMENT"
                approval_approve_request(@xray_facility, comment: params[:approval][:comment])
            else
                approval_approve_request(@xray_facility, comment: params[:approval][:comment], final_approval: approval_get_approval_tier(@xray_facility.approval_status) == 2)
            end
            send_new_facility_registered_email if request_type == "X-Ray Facility registration request"
        elsif approval_params[:decision] == 'REJECT'
            notice = 'X-Ray Facility is rejected.'
            approval_reject_request(@xray_facility, comment: params[:approval][:comment])
            send_license_expiry_rejected_email if request_type == "X-Ray Facility license expiry amendment request"
        elsif approval_params[:decision] == 'REVERT'
            notice = 'X-Ray Facility is reverted.'
            approval_revert_request(@xray_facility, comment: params[:approval][:comment])
            send_license_expiry_rejected_email if request_type == "X-Ray Facility license expiry amendment request"
        end
        redirect_to internal_xray_facilities_path(status: "APPROVAL", cookied_path: "y"), notice: notice
    end

    # GET /xray_facilities/1/concur
    def concur
        @xray_facility.assign_attributes(@xray_facility.approval_item.params)
    end

    # PATCH/PUT /xray_facilities/1/concur
    # PATCH/PUT /xray_facilities/1/concur.json
    def concur_update
        @xray_facility.assign_attributes(@xray_facility.approval_item.params)

        case @xray_facility.approval_request.category
        when "XRAY_FACILITY_REGISTRATION"
            fee = Fee.find_by(code: "XRAY_FACILITY_REGISTRATION")
            order = Order.create({
                customerable: @xray_facility,
                category: "XRAY_FACILITY_REGISTRATION",
                date: Time.now,
                amount: fee.amount,
                status: "NEW"
            })
            order.order_items.create({
                order_itemable: @xray_facility,
                fee_id: fee.id,
                amount: fee.amount
            })
            @xray_facility.update_code
            flash[:notice] = "X-Ray Facility #{@xray_facility.code} concurred, order #{order.code} for X-Ray Facility registration is created"
            @redirect_to = internal_xray_facilities_path(status: "APPROVAL2", cookied_path: "y")
            approval_approve_request(@xray_facility, comment: params[:concur][:comment], record_update_attributes: {
                registration_approved_at: Time.now
            })
        when "XRAY_FACILITY_AMENDMENT"
            if ["address1", "address2", "address3", "address4", "state_id", "town_id", "postcode"].any? { |key| @xray_facility.changes.key?(key) }
                if @xray_facility.approval_request && @xray_facility.approval_request.try(:additional_information) && @xray_facility.approval_request.try(:additional_information).key?("fee_id") && !@xray_facility.approval_request.additional_information["fee_id"].blank?
                    fee = Fee.find(@xray_facility.approval_request.additional_information["fee_id"])
                else
                    fee = Fee.find_by(code: "XRAY_FACILITY_CHANGE_ADDRESS")
                end
                order = Order.create({
                    customerable: @xray_facility,
                    category: "XRAY_FACILITY_CHANGE_ADDRESS",
                    date: Time.now,
                    amount: fee.amount,
                    status: "NEW"
                })
                order.order_items.create({
                    order_itemable: @xray_facility,
                    fee_id: fee.id,
                    amount: fee.amount
                })
                if fee.amount > 0
                    flash[:notice] = "X-Ray Facility amendment concurred. Changes of address detected, order for xray facility amendment is created, please proceed to payment"
                    @redirect_to = edit_internal_order_path order
                else
                    order.update({
                        status: 'PAID',
                        paid_at: DateTime.now,
                        payment_method: PaymentMethod.find_by(code: "FOC")
                    })
                    flash[:notice] = "X-Ray Facility amendment concurred"
                    @redirect_to = internal_xray_facilities_path(status: "APPROVAL2", cookied_path: "y")
                end
                approval_approve_request(@xray_facility, comment: params[:concur][:comment])
            else
                flash[:notice] = "X-Ray Facility amendment concurred"
                @redirect_to = internal_xray_facilities_path(status: "APPROVAL2", cookied_path: "y")
                approval_approve_request(@xray_facility, comment: params[:concur][:comment])
            end
        end
        redirect_to @redirect_to || internal_xray_facilities_path(status: "APPROVAL2", cookied_path: "y")
    end

    def activate
        @xray_facility.activate
        @xray_facility.create_user if @xray_facility.user.blank?
        redirect_to internal_xray_facilities_path(status: "TO_ACTIVATE", cookied_path: "y"), notice: 'X-Ray Facility was activated.'
    end

    def bulk_reallocate
        render 'internal/xray_facilities/bulk_reallocate/edit'
    end

    def bulk_reallocate_update
        doctors = params[:doctors]
        doctors.each do |doctor|
            doctor = JSON.parse(doctor)
            if doctor['new_facility']
                clinic = Doctor.find_by(id: doctor['id'])
                clinic.xray_facility_id = doctor['new_facility'] ? doctor['new_facility']['id'] : @xray_facility.id
                clinic.save

                # Update transactions to the new xray if not certified, not cancelled, not rejected, not expired and no xray_examinations record
                t = Transaction.joins("LEFT OUTER JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id")
                .where(doctor_id: clinic.id, xray_facility_id: @xray_facility.id)
                .where("transactions.certification_date IS NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND expired_at > CURRENT_DATE")
                .where("xray_examinations.id IS NULL")
                .update(xray_facility_id: doctor['new_facility']['id'])

                # create targeted bulletins
                create_bulletin(doctor)

                transactions = Transaction.joins("LEFT OUTER JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id")
                .select("transactions.employer_id,transactions.doctor_id")
                .where(doctor_id: clinic.id, xray_facility_id: doctor['new_facility']['id'])
                .where("transactions.certification_date IS NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND expired_at > CURRENT_DATE")
                .where("xray_examinations.id IS NULL")
                .group("transactions.employer_id,transactions.doctor_id")

                transactions.each do |transaction|
                    create_bulletin_employer(doctor,transaction)
                end
            end
        end
        notice = 'Bulk Re-Allocation Saved Successfully'
        redirect_to internal_xray_facility_path, notice: notice
    end

    def create_bulletin(doctor)
        clinic = Doctor.find_by(id: doctor['id'])
        xray = XrayFacility.find_by(id: doctor['new_facility']['id'])

        clinic_address =  "</br>#{ clinic.address1 }" if !clinic.address1.blank?
        clinic_address << "</br>#{ clinic.address2 }" if !clinic.address2.blank?
        clinic_address << "</br>#{ clinic.address3 }" if !clinic.address3.blank?
        clinic_address << "</br>#{ clinic.address4 }" if !clinic.address4.blank?
        clinic_address << "</br>#{ clinic.postcode } #{ Town.find_by(id: clinic.town_id).name }"
        clinic_address << "</br>#{ State.find_by(id: clinic.state_id).name }</br>"

        xray_address =  "</br>#{ xray.address1 }" if !xray.address1.blank?
        xray_address << "</br>#{ xray.address2 }" if !xray.address2.blank?
        xray_address << "</br>#{ xray.address3 }" if !xray.address3.blank?
        xray_address << "</br>#{ xray.address4 }" if !xray.address4.blank?
        xray_address << "</br>#{ xray.postcode } #{ Town.find_by(id: xray.town_id).name }"
        xray_address << "</br>#{ State.find_by(id: xray.state_id).name }</br>"

        doctor_content = "
        <p>Dear Dr #{clinic.name},</p>
        <p>Please be informed that you have been allocated to the following X-ray: </p>
        <p>
            <b>#{ xray.name } (#{ xray.code })</b>
            #{ xray_address }
            Phone: #{ xray.phone }
        </p>
        <p>However, this allocation may change from time to time and you would be informed accordingly. We seek your kind cooperation to refer the foreign workers to the appropriate facility which is also indicated in their FOMEMA's medical examination form.</p>
        <p>Thank you.</p>
        <p>Yours faithfully,</p>
        <p><b>Management of Service Providers Department</b></p>
        "

        xray_content = "
        <p>Dear PIC,</p>
        <p>Please be informed, the below clinic has been assigned to your X-ray clinic to carry out chest X-ray examinations.</p>
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
                title: "CHANGE OF X-RAY FACILITY",
                content: doctor_content,
                audienceable_type: "Doctor",
                audienceable_id: clinic.id,
            },{
                title: "ALLOCATION OF CLINIC",
                content: xray_content,
                audienceable_type: "XrayFacility",
                audienceable_id: xray.id,
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

    def create_bulletin_employer(doctor,transaction)
        employer = Employer.find_by(id: transaction.employer_id)
        xray = XrayFacility.find_by(id: doctor['new_facility']['id'])
        xray_old = XrayFacility.find_by(id: doctor['xray_facility_id'])

        xray_address =  "</br>#{ xray.address1 }" if !xray.address1.blank?
        xray_address << "</br>#{ xray.address2 }" if !xray.address2.blank?
        xray_address << "</br>#{ xray.address3 }" if !xray.address3.blank?
        xray_address << "</br>#{ xray.address4 }" if !xray.address4.blank?
        xray_address << "</br>#{ xray.postcode } #{ Town.find_by(id: xray.town_id).name }"
        xray_address << "</br>#{ State.find_by(id: xray.state_id).name }</br>"

        xray_address_old =  "</br>#{ xray_old.address1 }" if !xray_old.address1.blank?
        xray_address_old << "</br>#{ xray_old.address2 }" if !xray_old.address2.blank?
        xray_address_old << "</br>#{ xray_old.address3 }" if !xray_old.address3.blank?
        xray_address_old << "</br>#{ xray_old.address4 }" if !xray_old.address4.blank?
        xray_address_old << "</br>#{ xray_old.postcode } #{ Town.find_by(id: xray_old.town_id).name }"
        xray_address_old << "</br>#{ State.find_by(id: xray_old.state_id).name }</br>"

        employer_content = "
        <p>Dear Valued Customer,</p>
        <b>CHANGE OF X-RAY CLINIC</b>
        <hr>
        <p>Please be informed, that your worker(s) who were assigned at below X-ray clinic;</p>
        <p>
            <b><u>#{ xray_old.name } (#{ xray_old.code })</u></b>
            #{ xray_address_old }
            Phone: #{ xray_old.phone }
        </p>

        <p>has been re-assigned to the below X-ray clinic for the chest X-ray examination; </p>

        <p>
            <b><u>#{ xray.name } (#{ xray.code })</u></b>
            #{ xray_address }
            Phone: #{ xray.phone }
        </p>
        <p>The above notice is applicable for worker(s) who has yet to do chest X-ray examination. You are advised to:</p>
        <ul>
            <li>Set an appointment with this new X-ray clinic.</li>
            <li>Bring the original passport for chest X-ray examination.</li>
            <li>Bring EITHER the newly reprint of FOMEMA’s medical examination form (recommended) OR the previously printed form for chest X-ray examination.</li>
        </ul>
        <p>If you had any inquiry, please contact <u>cs@fomema.com.my</u> or WhatsApp to +603 – 2782 8777</p>
        <p>Thank You.</p>
        <p>Yours faithfully,</p>
        <p>Management of Service Providers Department</p>
        <p>FOMEMA Sdn. Bhd.</p>
        "

        bulletins = [
            {
                title: "CHANGE OF X-RAY FACILITY",
                content: employer_content,
                audienceable_type: "Employer",
                audienceable_id: employer.id,
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
            operating_hourable: @xray_facility
        })
    end

    def search_xray_facility
        @xray_facilities = XrayFacility.search_code(params[:code])
        .search_name(params[:name])
        .search_state(params[:state_id])
        .search_postcode(params[:postcode])
        .search_town(params[:town_id])

        respond_to do |format|
          format.json { render :json => @xray_facilities.to_json(:include => [:state, :town, :doctors]), status: :ok }
        end
    end

    def allocated_workers
        @start_date = params[:date_from].presence
        @end_date = params[:date_to].presence
        @date_source = params[:date_source]
        respond_to do |format|
            format.html do
                render "internal/xray_facilities/allocated_workers/allocated_workers"
            end
            format.xlsx do
                @transactions =
                    @xray_facility
                    .transactions
                    .left_joins(:employer, :fw_job_type, :fw_country, :xray_facility, :doctor).joins(employer: :state)
                    .select("transactions.*, employers.name as emp_name, employers.pic_name as emp_pic_name, employers.pic_phone as emp_pic_phone, job_types.name as fw_jt_name, countries.name as fw_cty_name, states.name as emp_state_name, xray_facilities.code as xray_facility_code, xray_facilities.name as xray_facility_name, xray_facilities.license_holder_name as xray_facility_license_holder_name, xray_facilities.company_name as xray_facility_company_name, case when transactions.registration_type = 1 then 'RENEWAL' else 'NEW' end as renewal, doctors.code doc_code, doctors.name doc_name")
                    .then { |transactions| transactions.send(:"#{@date_source}_between", @start_date, @end_date) }
                render xlsx: 'allocated_workers', filename: "XRay_Facility-#{@xray_facility.code}-AllocatedForeignWorkers-#{DateTime.current.strftime("%Y%m%d%H%M%S")}.xlsx", template: "internal/xray_facilities/allocated_workers/allocated_workers"
            end
       end
    end

    def suspension_history
        @headers = %w[# Date Action Reason]
        @activities = @xray_facility.suspension_activities

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

    def send_license_expiry_rejected_email
        XrayMailer.with({
            xray_facility: @xray_facility,
            comment: params[:approval][:comment],
        }).xray_license_expiry_rejected_email.deliver_later
    end

    def license_expiry_amendment_logs
        @amendments = XrayFacility.xray_license_approval_requests.where('xray_facilities.id = ?', @xray_facility.id)
        .select('approval_requests.id, approval_requests.created_at, approval_requests.approval_at,
        approval_requests.approval_decision, approval_requests.request_user_id, approval_requests.respond_user_id')
        .order('approval_requests.created_at desc').all
    end

    def send_new_facility_registered_email
        XrayMailer.with({
            xray_facility: @xray_facility,
        }).new_facility_registered_email.deliver_later
    end

    def buy_biometric_device
        order = Order.create({
            customerable: @xray_facility,
            category: "XRAY_FACILITY_BIOMETRIC_DEVICE",
        })

        @biometric_fees.each do |fee|
            order.order_items.create({
                order_itemable: @xray_facility,
                fee_id: fee.id,
                amount: fee.amount,
            })
        end

        redirect_to edit_internal_order_path(order), notice: "Order (#{order.code}) is created, please proceed payment"
    end

    private

    def set_xray_facility
        @xray_facility = XrayFacility.find(params[:id])
    end

    def xray_facility_params
        params.require(:xray_facility).permit(:name, :license_holder_name, :company_name, :address1, :address2, :address3, :address4, :country_id, :state_id, :postcode, :town_id, :phone, :fax, :email, :email_payment, :title_id, :icno, :mobile, :qualification, :status, :district_health_office_id, :xray_license_number, :xray_file_number, :xray_fac_flag, :xray_license_tujuan, :xray_license_expiry_date, :radiologist_operated, :radiologist_name, :apc_year, :apc_number, :has_doctor_association, :name_of_association, :renewal_agreement_date, :fp_device, :comment, :film_type, :male_rate, :female_rate, :bank_id, :bank_payment_id, :bank_account_number, :payment_method_id, :business_registration_number, :has_selected_re_medical, :gender, :nationality_id, :race_id, :paid_biometric_device)
    end

    def xray_facility_approval_params
        params.require(:xray_facility).permit()
    end

    def filtered_facility
        XrayFacility
            .includes(:state, :town)
            .search_code(params[:code])
            .search_name(params[:name])
            .search_license_holder_name(params[:license_holder_name])
            .search_state(params[:state_id])
            .search_postcode(params[:postcode])
            .search_town(params[:town_id])
            .search_status(params[:status])
            .search_activated(params[:activated])
            .search_icno(params[:icno])
            .search_service_provider_group(params[:service_provider_group_id])
    end

    def render_pdf
        render pdf: action_name,
               template: "internal/xray_facilities/#{action_name}/_pdf_template.html.haml",
               header: {
                   html: {
                       template: "internal/xray_facilities/#{action_name}/pdf_template_header"
                   }
               },
               **default_pdf_options
    end

    def render_xlsx
       render xlsx: 'index', filename: "#{action_name.camelize}-#{DateTime.current.to_i}.xlsx",
              template: "internal/xray_facilities/#{action_name}/index"
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

    def set_biometric_fees
        biometric_device_fee = Fee.find_by(code: "BIOMETRIC_DEVICE")
        biometric_admin_fee = Fee.find_by(code: "BIOMETRIC_ADMIN")
        @biometric_fees = []
        @biometric_fees << biometric_device_fee
        @biometric_fees << biometric_admin_fee
    end
end