module ProfileInfoCheck
    def pending_profile_update?(employer)
        @incomplete = false
        @employer = employer
        check_profile_info
    end

    def check_profile_info
        if @employer.employer_type_id == 1 #individual
            incomplete_profile_info = true if @employer.approval_status == 'UPDATE_PENDING_APPROVAL' || @employer.ic_passport_number&.strip.blank? || @employer.ic_passport_number.nil?
        elsif @employer.employer_type_id == 2 #company
            incomplete_profile_info = true if @employer.approval_status == 'UPDATE_PENDING_APPROVAL' || @employer.business_registration_number&.strip.blank? || @employer.business_registration_number.nil?
        end

        if incomplete_profile_info
            @incomplete = true
            if site == "PORTAL"
                msg = "Profile details incomplete. Please update your profile before proceeding."
            else
                msg = "Kindly update ROC Number/IC or Passport Number."
            end
            flash[:error] = msg
            redirect_to (request.env["HTTP_REFERER"] || internal_root_path) and return
        end
    end
end