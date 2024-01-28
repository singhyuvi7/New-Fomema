class Internal::SystemConfigurationsController < InternalController
    before_action :set_system_configurations, except: [:system]
    before_action :set_system_field, only:[:system, :system_edit]

    before_action -> { can_access?("VIEW_SYSTEM_CONFIGURATION") }, only: [:system]
    before_action -> { can_access?("EDIT_SYSTEM_CONFIGURATION") }, only: [:system_edit, :system_update]
    before_action -> { can_access?("APPROVAL_SYSTEM_CONFIGURATION") }, only: [:system_approval, :system_approval_update]
    before_action -> { can_access?("VIEW_XQCC_SYSTEM_CONFIGURATION") }, only: [:xqcc]
    before_action -> { can_access?("EDIT_XQCC_SYSTEM_CONFIGURATION") }, only: [:xqcc_edit, :xqcc_update]
    before_action -> { can_access?("APPROVAL_XQCC_SYSTEM_CONFIGURATION") }, only: [:xqcc_approval, :xqcc_approval_update]
    before_action -> { can_access?("VIEW_FINANCE_SYSTEM_CONFIGURATION") }, only: [:finance]
    before_action -> { can_access?("EDIT_FINANCE_SYSTEM_CONFIGURATION") }, only: [:finance_edit, :finance_update]

    def system
        set_system_configurations(*SystemConfiguration::CODES)
    end

    def system_edit
        set_system_configurations(*SystemConfiguration::CODES)
    end

    def system_update
        set_system_configurations(*SystemConfiguration::CODES)
        update_count = 0

        ## check value that should be numeric
        params[:system_configuration].each do |k,v|
            ## value that should be numeric
            if ['LAST_X_DAYS_TO_UPDATE_TRANSACTION'].include?(k)
                if v.to_i.to_s != v
                    flash[:error] = "#{k} value have to be an integer"
                    redirect_to (request.env["HTTP_REFERER"] || system_internal_system_configurations_path) and return
                end
            end
        end

        params[:system_configuration].each do |k,v|
            sc = SystemConfiguration.find_by(code: k)
            if sc.value != v
                sc.update({
                    new_value: v,
                    request_at: Time.now,
                    request_by: current_user.id,
                    decision: nil
                })
                update_count = update_count + 1
            end
        end
        redirect_to system_internal_system_configurations_path, notice: update_count > 0 ? "Configuration submitted for approval" : "No changes"
    end

    def system_approval
        set_system_configurations(*SystemConfiguration::CODES)
    end

    def system_approval_update
        set_system_configurations(*SystemConfiguration::CODES)

        case params[:decision]
        when "APPROVE"
            @pending_approvals.each do |sc|
                sc.update({
                    value: sc.new_value,
                    new_value: nil,
                    decision: params[:decision],
                    approval_at: Time.now,
                    approval_by: current_user.id
                })
            end
            notice = "System configuration change request approved"
        when "REJECT"
            @pending_approvals.each do |sc|
                sc.update({
                    new_value: nil,
                    decision: params[:decision],
                    approval_at: Time.now,
                    approval_by: current_user.id
                })
            end
            notice = "System configuration change request rejected"
        end
        redirect_to system_internal_system_configurations_path, notice: notice
    end

    def xqcc
        set_system_configurations(*SystemConfiguration::XQCCS)
    end

    def xqcc_edit
        set_system_configurations(*SystemConfiguration::XQCCS)
    end

    def xqcc_update
        set_system_configurations(*SystemConfiguration::XQCCS)
        params[:system_configuration].each do |k,v|
            SystemConfiguration.find_by(code: k).update({
                value: v,
                request_at: Time.now,
                request_by: current_user.id,
                approval_at: Time.now,
                approval_by: current_user.id
            })
        end
        redirect_to xqcc_internal_system_configurations_path, notice: "Configuration saved"
    end

=begin
    def xqcc_update
        set_system_configurations(*SystemConfiguration::XQCCS)
        update_count = 0
        params[:system_configuration].each do |k,v|
            sc = SystemConfiguration.find_by(code: k)
            if sc.value != v
                sc.update({
                    new_value: v,
                    request_at: Time.now,
                    request_by: current_user.id,
                    decision: nil
                })
                update_count = update_count + 1
            end
        end
        redirect_to xqcc_internal_system_configurations_path, notice: update_count > 0 ? "Configuration submitted for approval" : "No changes"
    end
=end

    def xqcc_approval
        set_system_configurations(*SystemConfiguration::XQCCS)
    end

    def xqcc_approval_update
        set_system_configurations(*SystemConfiguration::XQCCS)

        case params[:decision]
        when "APPROVE"
            @pending_approvals.each do |sc|
                sc.update({
                    value: sc.new_value,
                    new_value: nil,
                    decision: params[:decision],
                    approval_at: Time.now,
                    approval_by: current_user.id
                })
            end
            notice = "System configuration change request approved"
        when "REJECT"
            @pending_approvals.each do |sc|
                sc.update({
                    new_value: nil,
                    decision: params[:decision],
                    approval_at: Time.now,
                    approval_by: current_user.id
                })
            end
            notice = "System configuration change request rejected"
        end
        redirect_to xqcc_internal_system_configurations_path, notice: notice
    end

    def finance
        set_system_configurations(*SystemConfiguration::FINANCES)
    end

    def finance_edit
        set_system_configurations(*SystemConfiguration::FINANCES)
    end

    def finance_update
        set_system_configurations(*SystemConfiguration::FINANCES)
        params[:system_configuration].each do |k,v|
            SystemConfiguration.find_by(code: k).update({
                value: v,
                request_at: Time.now,
                request_by: current_user.id,
                approval_at: Time.now,
                approval_by: current_user.id
            })
        end
        redirect_to finance_internal_system_configurations_path, notice: "Configuration saved"
    end

    def update
        hasUpdate = 0
        new_config  = params.to_unsafe_h.select {|key, value| SystemConfiguration.pluck(:code).include?(key)}
        old_config  = SystemConfiguration.pluck(:code, :value)
        intersect   = new_config.to_a & old_config
        changes     = new_config.to_a - intersect

        changes.each do |key, value|
            SystemConfiguration.find_by(code: key).update(
                new_value: value, 
                request_by: current_user.id, 
                request_at: nil,
                approval_by: nil, 
                approval_at: nil
            )
        end

        flash[:notice] = "Request submitted for approval" if changes.size > 0
        redirect_to internal_system_configurations_path
    end

    def approval
        if @pending_approvals.length <= 0
            redirect_to internal_system_configurations_path
        end
    end

    def approval_update
        if params["decision"] == "APPROVE"
            @pending_approvals = SystemConfiguration.where.not(new_value: nil).all
            if ((has_permission? "APPROVAL_FINANCE_SYSTEM_CONFIGURATION") && !(has_permission? "APPROVAL_SYSTEM_CONFIGURATION"))
                @pending_approvals.where(code: SystemConfiguration::FINANCE ).each do |sc|
                sc.update({
                    decision: params["decision"],
                    value: sc.new_value,
                    new_value: nil,
                    approval_at: DateTime.now,
                    approval_by: current_user.id,
                })
                end
            elsif ((has_permission? "APPROVAL_SYSTEM_CONFIGURATION") && !(has_permission? "APPROVAL_FINANCE_SYSTEM_CONFIGURATION"))
                @pending_approvals.where.not(code: SystemConfiguration::FINANCE ).each do |sc|
                sc.update({
                    decision: params["decision"],
                    value: sc.new_value,
                    new_value: nil,
                    approval_at: DateTime.now,
                    approval_by: current_user.id,
                })
                end
            elsif ((has_permission? "APPROVAL_FINANCE_SYSTEM_CONFIGURATION") && (has_permission? "APPROVAL_SYSTEM_CONFIGURATION"))
                @pending_approvals.each do |sc|
                sc.update({
                    decision: params["decision"],
                    value: sc.new_value,
                    new_value: nil,
                    approval_at: DateTime.now,
                    approval_by: current_user.id,
                })
                end
            end
        elsif params["decision"] == "REJECT"
            @pending_approvals = SystemConfiguration.where.not(new_value: nil).all
            if ((has_permission? "APPROVAL_FINANCE_SYSTEM_CONFIGURATION") && !(has_permission? "APPROVAL_SYSTEM_CONFIGURATION"))
                @pending_approvals.where(code: SystemConfiguration::FINANCE ).each do |sc|
                sc.update({
                    decision: params["decision"],
                    new_value: nil,
                    approval_at: DateTime.now,
                    approval_by: current_user.id,
                })
                end
            elsif ((has_permission? "APPROVAL_SYSTEM_CONFIGURATION") && !(has_permission? "APPROVAL_FINANCE_SYSTEM_CONFIGURATION"))
                @pending_approvals.where.not(code: SystemConfiguration::FINANCE ).each do |sc|
                sc.update({
                    decision: params["decision"],
                    new_value: nil,
                    approval_at: DateTime.now,
                    approval_by: current_user.id,
                })
                end
            elsif ((has_permission? "APPROVAL_FINANCE_SYSTEM_CONFIGURATION") && (has_permission? "APPROVAL_SYSTEM_CONFIGURATION"))
                @pending_approvals.each do |sc|
                sc.update({
                    decision: params["decision"],
                    new_value: nil,
                    approval_at: DateTime.now,
                    approval_by: current_user.id,
                })
                end
            end
        end

        redirect_to internal_system_configurations_path
    end

    private
    def set_system_configurations(*codes)
        if codes.count > 0 
            records = SystemConfiguration.where("code in (?)", codes).all
            @pending_approvals = SystemConfiguration.where("code in (?) and new_value is not null", codes).all
        else
            records = SystemConfiguration.all
            @pending_approvals = SystemConfiguration.where("new_value is not null").all
        end
        @system_configurations = {}
        records.each do |r|
            @system_configurations[r.code] = r
        end
    end

    def set_system_field
        @basic_fields = ["COMPANY_NAME", "COMPANY_REGNO", "COMPANY_NAME_INVOICE", "COMPANY_REGNO_GLOBAL", "COMPANY_ADDR", "COMPANY_PHONE", "COMPANY_FAX", "REMARK_INVOICE"]
        @policy_fields = SystemConfiguration::CODES - @basic_fields
    end
end