module AgencySopAcknowledgeCheck
    def agency_sop_acknowledge_check?(agency)
        @incomplete = false
        @agency = agency
        check_sop_acknowledge
    end

    def check_sop_acknowledge

        incomplete_sop_check = true if @agency.sop_acknowledge.blank? && @agency&.user&.role&.code == 'AGENCY'

        if incomplete_sop_check
            @incomplete = true
            if site == "PORTAL"
                msg = "Kindly read and acknowledge the Standard Operating Procedure. Click  <a href=#{external_profile_path}><button type='button' class='btn btn-primary'> <i class='fas fa-user-alt'></i> <b>Profile</b></button></a>".html_safe
            end
            flash[:error] = msg
            redirect_to (request.env["HTTP_REFERER"] || internal_root_path) and return
        end
    end
end