class External::HomeController < ExternalController
    include HomeDashboardStatistics
    before_action :check_duplicate_emp, only: [:dashboard]

    def dashboard
        @recent_bulletins = Bulletin.filter_date_and_audiences(current_user.userable_type, current_user.userable.id)
        .order(created_at: :desc)
        .limit(SystemConfiguration.find_by(code: "BULLETIN_RECENT").value)
        .all

        reminder_expired_date =
            case current_user.userable_type
            when "XrayFacility"
                today= Date.today
                XrayFacility.where("xray_license_expiry_date::timestamp - '2 month'::interval <= ? OR xray_license_expiry_date IS NULL",today).where(id: current_user.userable_id).count
            when "Laboratory"
            today= Date.today
            Laboratory.where("samm_expiry_date::timestamp - '2 month'::interval <= ? OR samm_expiry_date IS NULL",today).where(id: current_user.userable_id).count
            end

        if reminder_expired_date == 1
            message = ""
            flash[:notice_reminders] = message
        end

        check_roc_ic =
            case current_user.userable_type
            when "Employer"
                if current_user.userable.employer_type.name === 'INDIVIDUAL'
                    Employer.where("ic_passport_number IS NULL").where(id: current_user.userable_id).count
                elsif  current_user.userable.employer_type.name === 'COMPANY'
                    Employer.where("business_registration_number IS NULL").where(id: current_user.userable_id).count
                end
           end

        check_status_employer = Employer.where(approval_status: "UPDATE_PENDING_APPROVAL").where(id: current_user.userable_id).count

        if check_roc_ic == 1 && check_status_employer != 1
            message = "Hi <b>#{current_user.name}</b>,<br>Kindly update your particulars so that your information will be updated. <br>Click  <a href=#{external_profile_path}><button type='button' class='btn btn-primary'> <i class='fas fa-user-alt'></i> <b>Profile</b></button></a>  to update.".html_safe
            flash[:notice_to_employer] = message
        elsif check_status_employer == 1
            message = "Hi <b>#{current_user.name}</b>,<br>Your request to update Profile is pending for approval.".html_safe
            flash[:notice_to_employer] = message
        end

        check_sop_acknowledge =
            case current_user.userable_type
            when "Agency"
                Agency.where("sop_acknowledge is false").where(id: current_user.userable_id).count
            end

        if check_sop_acknowledge == 1
            message = "Hi #{current_user.name}.<br>Kindly read and acknowledge the Standard Operating Procedure.<br>Click  <a href=#{external_profile_path}><button type='button' class='btn btn-primary'> <i class='fas fa-user-alt'></i> <b>Profile</b></button></a>".html_safe
            flash[:notice_to_agency] = message
        end
        pending_appeals =
            case current_user.userable_type
            when "Doctor"
                MedicalAppeal.where(status: "EXAMINATION", doctor_id: current_user.userable_id, doctor_done_at: nil).count
            when "Laboratory"
                MedicalAppeal.where(status: "EXAMINATION", laboratory_id: current_user.userable_id, laboratory_done_at: nil).count
            when "XrayFacility"
                MedicalAppeal.where(status: "EXAMINATION", xray_facility_id: current_user.userable_id, xray_facility_done_at: nil).count
            when "Radiologist"
                MedicalAppeal.where(status: "EXAMINATION", radiologist_id: current_user.userable_id, radiologist_done_at: nil).count
            end

        if pending_appeals && pending_appeals > 0
            flash[:pending_appeal_message] = "You have #{ pending_appeals } appeal #{ "case".pluralize(pending_appeals) } to further investigate or examine."
        end

        pending_payments =
            case current_user.userable_type
            when "Agency"
                Order.where("status in (?) and category in (?) and customerable_id = ?", ['NEW', 'PENDING_PAYMENT'], ['AGENCY_REGISTRATION', 'AGENCY_RENEWAL'], current_user.userable.id).count
            end

        if pending_payments && pending_payments > 0
            flash[:notice] = "You have pending payment for agency registration/renewal. Please make payment."
            redirect_to external_orders_path
        end

        pending_notifiable_cases =
        case current_user.userable_type
        when "Doctor", "XrayFacility"
            AmendedNotifiableTransaction.where(notifiable_type: current_user.userable_type, notifiable_id: current_user.userable_id, notify_pkd_at: nil).count
        end

        if pending_notifiable_cases && pending_notifiable_cases > 0
            flash[:pending_notifiable_cases_message] = "You have notifiable case(s) to be notified to the nearest PKD. Kindly refer to the “Notifiable Cases” tab for further details."
        end
    end
private
    def check_duplicate_emp
        if current_user.userable_type == 'Employer'
            employer = current_user.userable
            # if Employer.where("id != ? and status = 'ACTIVE' and employer_type_id = ? and #{employer.primary_id_field} = ?", employer.id, employer.employer_type_id, employer.primary_id).count > 0
            #     cookies[:error] = "Duplicate employer account detected, please contact FOMEMA branch."
            #     sign_out_and_redirect(current_user)
            # end
            Employer.where("id != ? and status = 'ACTIVE' and employer_type_id = ? and #{employer.primary_id_field} = ?", employer.id, employer.employer_type_id, employer.primary_id).each do |e|
                e.status = 'INACTIVE'
                e.email = ''
                e.business_registration_number = ''
                e.ic_passport_number = ''
                e.save(validate: false)
                u = User.find_by(userable_id: e.id, userable_type: "Employer")
                u.status = 'INACTIVE'
                u.email = ''
                u.save(validate: false)
            end
        end
    end
end