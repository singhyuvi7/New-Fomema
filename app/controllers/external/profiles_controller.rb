class External::ProfilesController < ExternalController
    include ValidateUserable
    include Approvalable
    include ApprovalAssignmentCheck
    include Watermark

    before_action :set_current_user_profile, :set_password_requirements #, only: []

    skip_before_action :check_password_expiry, only: [:password, :password_update]

    before_action -> { validate_user_email?(@user, params) }, only: [:profile_update]

    def profile
        case @user.userable_type
        when "Employer"
            ## main account
            @userable = @user.userable
            #added by hweeleng
            @employer_type = EmployerType.find_or_initialize_by({
                id: @userable.employer_type
            })
            #end
            render :profile_employer
        when "Doctor"
            @doctor = @user.userable
            @operating_hour = OperatingHour.find_or_initialize_by({
                operating_hourable: @doctor
            })
            render :profile_doctor
        when "Laboratory"
            @laboratory = @user.userable
            @operating_hour = OperatingHour.find_or_initialize_by({
                operating_hourable: @laboratory
            })
            render :profile_laboratory
        when "XrayFacility"
            @xray_facility = @user.userable
            @operating_hour = OperatingHour.find_or_initialize_by({
                operating_hourable: @xray_facility
            })
            render :profile_xray_facility
        when "Radiologist"
            @radiologist = @user.userable
            render :profile_radiologist
        when "Agency"
            @agency = @user.userable
            render :profile_agency
        end
    end

    def profile_employer
    end

    def profile_agency
    end

    def profile_doctor
    end

    def profile_laboratory
    end

    def profile_xray_facility
    end

    def profile_radiologist
    end

    def profile_update
        update_ok = @user.update(profile_user_params)
        message = "."
        if update_ok
            case @user.userable_type
            when "Employer"
                old_bank_id = @employer.bank_id
                old_bank_account_number = @employer.bank_account_number
                old_business_registration_number = @employer.business_registration_number
                old_ic_passport_number = @employer.ic_passport_number
                old_bank_payment_id = @employer.bank_payment_id

                @employer.assign_attributes(profile_employer_params)
                if (@employer.approval_status!="UPDATE_PENDING_APPROVAL" && ( @employer.ic_passport_number_changed? || @employer.business_registration_number_changed? ) && @employer.employer_amended_at.nil?)

                    approval_assigned_to("EMPLOYER_AMENDMENT")
                    @employer.assign_attributes(profile_employer_params.merge({
                        "employer_amended_at" => Time.now,
                    }))
                      # process file upload
                    if params[:employer][:uploads]
                        params[:employer][:uploads].each do |upload|
                            if (!upload[:category].nil? && !upload[:documents].nil?)
                                add_watermark(upload[:documents])
                                upl = @employer.uploads.create(category: upload[:category])
                                upl.documents.attach(upload[:documents])
                            end
                        end
                    end
                    update_employer = approval_update_request(@employer, category: "EMPLOYER_AMENDMENT", assigned_to_user_id: @assigned_to_user_id)
                    message = "and pending for approval."
                    @employer.update({
                        assigned_to: @assigned_to_user_id,
                    })
                else
                    update_employer = @user.employer_supplement_id.blank? ? @employer.update(profile_employer_params) : @employer.update(profile_employer_params)
                end

                if @employer.has_refund_with_failed_payment?
                    if (@employer.bank_id != old_bank_id || @employer.bank_account_number != old_bank_account_number || @employer.business_registration_number != old_business_registration_number || @employer.ic_passport_number != old_ic_passport_number || @employer.bank_payment_id != old_bank_payment_id)
                        Refund.search_employer_code(@employer.code).search_status("PAYMENT_FAILED").update(status: "PENDING_REPROCESS")
                        send_bank_detail_updated_email
                    end
                end

                if !update_employer
                    respond_to do |format|
                        format.html { render :profile_employer }
                        format.json { render json: @employer.errors, status: :unprocessable_entity }
                    end
                    return
                end
            when "Doctor"
                data = profile_doctor_params.merge({
                    associations: params[:doctor][:has_doctor_association].to_s.downcase == 'true' ? {association: params[:doctor][:associations]} : nil,
                })

                update_doc = @doctor.update(data)

                @operating_hour = OperatingHour.find_or_create_by({
                    operating_hourable: @doctor
                })

                if update_doc
                    @operating_hour.update(profile_operating_hour_params)
                else
                    respond_to do |format|
                        format.html { render :profile_doctor }
                        format.json { render json: @doctor.errors, status: :unprocessable_entity }
                    end
                    return
                end
            when "Laboratory"
                data = profile_laboratory_params
                if !params[:web_service_passphrase_clear_text].blank?
                    data[:web_service_passphrase] = Laboratory::passphrase_hash(params[:web_service_passphrase_clear_text])
                end
                update_lab = @laboratory.update(data)
                @operating_hour = OperatingHour.find_or_initialize_by({
                    operating_hourable: @laboratory
                })
                if update_lab
                    @operating_hour.update(profile_operating_hour_params)
                else
                    respond_to do |format|
                        format.html { render :profile_laboratory }
                        format.json { render json: @laboratory.errors, status: :unprocessable_entity }
                    end
                    return
                end
            when "XrayFacility"
                data = profile_xray_facility_params.merge({
                    associations: params[:xray_facility][:has_doctor_association].to_s.downcase == 'true' ? {association: params[:xray_facility][:associations]} : nil,
                    xray_license_purposes_id: {xray_license_purposes_id: params[:xray_facility][:xray_license_purposes_id]},
                })

                @xray_facility.assign_attributes(xray_license_expiry_date: params[:xray_facility][:xray_license_expiry_date])
                if @xray_facility.xray_license_expiry_date_changed?
                    approval_update_request(@xray_facility, category: "XRAY_FACILITY_LICENSE_EXPIRY_AMENDMENT", draft: false)
                end

                update_xray = @xray_facility.update(data)

                if params[:xray_facility][:uploads]
                    params[:xray_facility][:uploads].each do |upload|
                        if (!upload[:category].nil? && !upload[:documents].nil?)
                            add_watermark(upload[:documents])
                            upl = @xray_facility.uploads.create(category: upload[:category])
                            upl.documents.attach(upload[:documents])
                        end
                    end
                end

                @operating_hour = OperatingHour.find_or_initialize_by({
                    operating_hourable: @xray_facility
                })
                if update_xray
                    @operating_hour.update(profile_operating_hour_params)
                else
                    respond_to do |format|
                        format.html { render :profile_xray_facility }
                        format.json { render json: @xray_facility.errors, status: :unprocessable_entity }
                    end
                    return
                end

            when "Radiologist"
                update_radio = @radiologist.update(profile_radiologist_params)
                if !update_radio
                    respond_to do |format|
                        format.html { render :profile_radiologist }
                        format.json { render json: @radiologist.errors, status: :unprocessable_entity }
                    end
                    return
                end
            when "Agency"
                old_bank_id = @agency.bank_id
                old_bank_account_number = @agency.bank_account_number
                old_business_registration_number = @agency.business_registration_number
                old_bank_payment_id = @agency.bank_payment_id

                update_agency = @agency.update(profile_agency_params)

                if !update_agency
                    respond_to do |format|
                        format.html { render :profile_agency }
                        format.json { render json: @agency.errors, status: :unprocessable_entity }
                    end
                    return
                end
            end

            respond_to do |format|
                if update_ok
                    format.html { redirect_to external_profile_url, notice: "Profile was successfully updated "+message }
                    format.json { render :show, status: :ok, location: @user }
                else
                    format.html { render :profile }
                    format.json { render json: @user.errors, status: :unprocessable_entity }
                end
            end
        end
    end

    def password
        @password_requirements = current_user.password_requirements
    end

    def password_update
        respond_to do |format|
            if @user.update(password_params)
                sign_in(:external_user, @user, bypass: true)
                if @user.userable_type == 'Agency'
                     format.html { redirect_to external_profile_path, notice: 'Your password has been updated. You are now signed in.' }
                     # format.json { render :show, status: :ok, location: @user }
                else
                    format.html { redirect_to external_root_path, notice: 'Your password has been updated. You are now signed in.' }
                    # format.json { render :show, status: :ok, location: @user }
                end
            else
                format.html { render :password }
                # format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end

    def send_bank_detail_updated_email
        bank_name = Bank.find_by(id: @employer.bank_id)&.name
        RefundMailer.with({
            bank_name: bank_name,
            employer: @employer
        }).bank_detail_updated_email.deliver_later
    end

    private
    def set_current_user_profile
        @user = current_user
        set_userable
    end

    def set_password_requirements
        @password_requirements = current_user.password_requirements
    end

    def set_userable

        @userable = @user.userable

        case @user.userable_type
        when "Employer"
            # @employer = @user.userable
            @employer =  @user.employer_supplement_id.blank? ? @user.userable : @user.employer_supplement
        when "Doctor"
            @doctor = @user.userable
        when "Laboratory"
            @laboratory = @user.userable
        when "XrayFacility"
            @xray_facility = @user.userable
        when "Radiologist"
            @radiologist = @user.userable
        when "Agency"
            @agency = @user.userable
        end
    end

    def profile_user_params
        params.require(:user).permit(:name, :title_id)
    end

    def profile_employer_params
        params.require(:employer).permit(:address1, :address2, :address3, :address4, :town_id, :state_id, :postcode, :phone, :fax, :pic_name, :pic_phone, :bank_id, :bank_account_number, :bank_payment_id, :email, :business_registration_number, :ic_passport_number, :employer_amended_at, :assigned_to)
    end

    def profile_employer_supplement_params
        params.require(:employer_supplement).permit(:address1, :address2, :address3, :address4, :town_id, :state_id, :postcode, :phone, :fax, :pic_name, :pic_phone)
    end

    def profile_doctor_params
        params.require(:doctor).permit(:name, :address1, :address2, :address3, :address4, :postcode, :town_id, :state_id, :phone, :fax, :email, :email_payment, :district_health_office_id, :apc_year, :apc_number, :has_doctor_association, :membership_number, :name_of_association, :mobile, :title_id, :icno, :clinic_name, :gender, :nationality_id, :race_id)
    end

    def profile_laboratory_params
        params.require(:laboratory).permit(:name, :address1, :address2, :address3, :address4, :postcode, :town_id, :state_id, :phone, :fax, :email, :email_payment, :district_health_office_id, :pathologist_name, :pic_name, :pic_phone, :business_registration_number, :web_service_passphrase, :samm_accredited_since, :samm_expiry_date, :samm_number)
    end

    def profile_xray_facility_params
        params.require(:xray_facility).permit(:name, :address1, :address2, :address3, :address4, :postcode, :town_id, :state_id, :phone, :fax, :email, :email_payment, :district_health_office_id, :apc_year, :apc_number, :has_doctor_association, :membership_number, :name_of_association, :mobile, :title_id, :license_holder_name, :icno, :radiologist_operated, :radiologist_name, :gender, :nationality_id, :race_id, :xray_license_number, :xray_file_number, :xray_license_tujuan)
    end

    def profile_radiologist_params
        params.require(:radiologist).permit(:name, :address1, :address2, :address3, :address4, :postcode, :town_id, :state_id, :phone, :fax, :email, :district_health_office_id, :apc_year, :apc_number, :mobile, :title_id, :icno, :gender, :nationality_id, :race_id)
    end

    def profile_agency_params
        params.require(:agency).permit(:address1, :address2, :address3, :address4, :town_id, :state_id, :postcode, :phone, :pic_name, :pic_phone, :bank_id, :bank_account_number, :bank_payment_id, :title_id, :sop_acknowledge)
    end

    def password_params
        params.require(:user).permit(:password, :password_confirmation)
    end

    def profile_operating_hour_params
        params.require(:operating_hour).permit(:monday_is_close, :monday_is_24_hour, :monday_start,:monday_break_start,:monday_break_end, :monday_end, :monday_break, :tuesday_is_close, :tuesday_is_24_hour, :tuesday_start,:tuesday_break_start,:tuesday_break_end, :tuesday_end, :tuesday_break, :wednesday_is_close, :wednesday_is_24_hour, :wednesday_start,:wednesday_break_start,:wednesday_break_end, :wednesday_end, :wednesday_break, :thursday_is_close, :thursday_is_24_hour, :thursday_start,:thursday_break_start,:thursday_break_end, :thursday_end, :thursday_break, :friday_is_close, :friday_is_24_hour, :friday_start,:friday_break_start,:friday_break_end, :friday_end, :friday_break, :saturday_is_close, :saturday_is_24_hour, :saturday_start,:saturday_break_start,:saturday_break_end, :saturday_end, :saturday_break, :sunday_is_close, :sunday_is_24_hour, :sunday_start,:sunday_break_start,:sunday_break_end, :sunday_end, :sunday_break, :public_holiday_is_close, :public_holiday_is_24_hour, :public_holiday_start,:public_holiday_break_start,:public_holiday_break_end, :public_holiday_end, :public_holiday_break, :close_remark);
    end
end
