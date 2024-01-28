module XrayExaminationModule
    def xray_examination_instances(type)
        @sourceable =
            case type
            when :transactions
                @transaction
            when :xqcc_retakes
                @xray_retake
            when :appeal_retakes
                @xray_retake = @appeal.current_xray_retake || XrayRetake.find_or_create_by(requestable: @appeal, status: "NEW", transaction_id: @appeal.transaction_id)
                @xray_retake.update(xray_facility_id: @appeal.xray_facility_id)
                @xray_retake
            end

        begin
            @xray_examination                   = XrayExamination.find_or_initialize_by(transaction_id: @transaction.id, sourceable: @sourceable)
            @xray_examination.xray_ref_number   ||= @sourceable.code
            @xray_examination.save unless @xray_examination.id?
        rescue ActiveRecord::RecordNotUnique # This is to prevent double save from happening.
            if [0, 1, 2, 3].include?(params[:try].to_i)
                try                 = params[:try].to_i
                try                 += 1
                append_parameters   = params.to_unsafe_h.except(:controller, :action).merge(try: try).to_param
                return { error: :xray_exam_page_retry, url: "#{ request.path }?#{ append_parameters }" }
            else
                raise ActiveRecord::RecordNotUnique
            end
        end

        @xray_examination.radiologist_aborted_at    = nil if params[:revert_abort].present?

        if current_user.userable_type == "Radiologist"
            if @sourceable.xray_reporter_type == "RADIOLOGIST"
                @xray_examination.radiologist_started_at    ||= Time.now if !@xray_examination.radiologist_aborted_at?
                @can_view_results                           = @sourceable.xray_worker_identity_confirmed?
            end

            @can_abort                                  = true
        elsif @sourceable.xray_worker_identity_confirmed?
            @can_view_results       =  @sourceable.xray_reporter_type == "SELF" || @xray_examination.radiologist_transmitted_at?
            @radiologist_started    =  @sourceable.xray_reporter_type != "SELF" && @xray_examination.radiologist_started_at?
        end

        @xray_examination.save
        @radiologist_started_info_page  = current_user.userable_type == "XrayFacility" && @radiologist_started
        readonly                        = (current_user.userable_type == "Radiologist" && @xray_examination.radiologist_transmitted_at?) || @xray_examination.transmitted_at?

        case type
        when :transactions
            film_type       = @sourceable.xray_film_type || current_user.userable.film_type
            @is_digital     = film_type == "DIGITAL"
            @form_url       = medical_examination_external_transactions_path(@sourceable)
            @revert_url     = medical_examination_external_transactions_path(@sourceable, revert_abort: "yes")
            @index_url      = external_transactions_path
            @header_label   = "Transaction"
            @can_xray_bypass = @transaction.xray_fp
            condition_tb = Condition.where(code: ["3502"]).pluck(:id)
            @notifiable_cases       = @transaction.amended_notifiable_transactions.where(condition_id: condition_tb, notifiable_type: "XrayFacility")
            @result_updates         = @transaction.transaction_result_updates.includes(:user).order(id: :desc)
            @amendments             = @transaction.transaction_amendments.where(approval_status: "CONCURRED").includes(:user, :approved_by).order(id: :desc)
            @xray_pending_decisions = @transaction.xray_pending_decisions.where(id: @transaction.xray_pending_decision_id)
            render "external/transactions/xray_examination#{ "_readonly" if readonly }"
        when :xqcc_retakes
            @is_digital     = true
            @form_url       = external_retake_path(@sourceable)
            @revert_url     = edit_external_retake_path(@sourceable, revert_abort: "yes")
            @index_url      = external_retakes_path
            @header_label   = "X-Ray Retake"
            @can_xray_bypass = @xray_retake.xray_fp
            render "external/transactions/xray_examination#{ "_readonly" if readonly }"
        when :appeal_retakes
            @is_digital     = true
            @form_url       = submit_xray_exam_external_appeal_path(@appeal.id)
            @revert_url     = external_appeal_path(@appeal, revert_abort: "yes")
            @index_url      = external_appeals_path
            @readonly       = readonly
            @can_xray_bypass = @xray_retake.xray_fp
            render "external/appeals/appeal_xray_examination.html.erb"
        end
    end
end