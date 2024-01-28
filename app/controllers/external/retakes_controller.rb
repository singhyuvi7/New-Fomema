class External::RetakesController < ExternalController
    include XrayExaminationModule
    include Watermark
    include ApprovalAssignmentCheck

    before_action :set_xray_retake, only: [:edit, :update, :bypass_fingerprint, :bypass_fingerprint_update]
    before_action -> { can_access?("MEDICAL_EXAMINATION_TRANSACTION") }, only: [:index, :edit, :update]

    def index
        case current_user.userable_type
        when "XrayFacility"
            @xray_retakes   = XrayRetake.where(status: ["APPROVED", "COMPLETED"], xray_facility_id: current_user.userable_id)
                                .order(id: :desc).page(params[:page]).per(get_per)
        when "Radiologist"
            @xray_retakes   = XrayRetake.where(status: ["APPROVED", "COMPLETED"], radiologist_id: current_user.userable_id).includes(:xray_facility)
                                .order(id: :desc).page(params[:page]).per(get_per)
        end
    end

    def edit
        check_retry = xray_examination_instances(:xqcc_retakes)
        redirect_to check_retry[:url] and return if check_retry.class == Hash && check_retry[:error] == :xray_exam_page_retry
    end

    def update
        @xray_retake.transaction do
            @current_time   = Time.now
            @xray_exam      = @xray_retake.xray_examination

            # Reset XrayExamination if Radiologist aborts transaction.
            if params[:commit] == "Abort"
                @xray_exam.radiologist_aborted_at = @current_time
                @xray_exam.update(xray_default_parameters)
                @xray_exam.reset_all_details_and_comments
                flash[:sp_aborted]          = current_user.userable_type
                flash[:sp_aborted_worker]   = @transaction.fw_code
                redirect_to edit_external_retake_path(@xray_retake, aborted: "yes") and return
            end

            # Check if reporter type has been changed.
            original_radiologist    = @xray_retake.radiologist_id
            original_reporter       = @xray_retake.xray_reporter_type

            unless params[:xe_attributes].present? && params[:xe_attributes].to_unsafe_h.size == 2 && params[:xe_attributes][:xray_examination_not_done] == "YES"
                @xray_retake.assign_attributes(xray_examination_params)
            end

            # If Xray Facility selects a new radiologist or changes the reporter type.
            if original_radiologist != @xray_retake.radiologist_id || original_reporter != @xray_retake.xray_reporter_type
                @xray_exam.assign_attributes(xray_default_parameters)
                @xray_exam.reset_all_details_and_comments
            end

            if params[:xe_attributes].present?
                @xray_exam.assign_attributes(xe_attributes__regular_params)

                @xray_exam.save_examination_details_and_comments(
                    detail_fields:  xe_attributes__details,
                    comment_fields: xe_attributes__comments
                )
            end

            # Ensure radiologist id is nil if reporter_type is SELF.
            if @xray_retake.xray_reporter_type == "SELF" && @xray_retake.radiologist_id?
                @xray_retake.radiologist_id         = nil
                @xray_exam.radiologist_assigned_at  = nil
            end

            @xray_exam.radiologist_assigned_at      ||= @current_time if @xray_retake.radiologist_id?

            # If Xray facility changes radiologists.
            @xray_exam.radiologist_aborted_at       = nil if original_radiologist != @xray_retake.radiologist_id && original_reporter == @xray_retake.xray_reporter_type
            @xray_exam.radiologist_assigned_at      = @current_time if @xray_retake.radiologist_id? && original_radiologist != @xray_retake.radiologist_id
            @xray_exam.radiologist_saved_at         = @current_time if current_user.userable_type == "Radiologist" && @xray_retake.xray_reporter_type == "RADIOLOGIST"
            @xray_exam.result                       = @xray_exam.result_of_exam ? "ABNORMAL" : "NORMAL"

            # for skipping fingerprint verification
            @xray_retake.xray_fp_result             = 2 if @xray_retake.xray_fp_result.nil?


            if params[:commit] == "Save and Transmit"
                if current_user.userable_type == "Radiologist" && @xray_retake.xray_reporter_type == "RADIOLOGIST" && params[:visited_xray] == "true"
                    @xray_exam.radiologist_transmitted_at   = @current_time
                    flash[:sp_completed]                    = current_user.userable_type
                    flash[:sp_completed_worker]             = @transaction.fw_code
                    xray_movement_data                      = {status: "RETAKE-EXAMINATION-SAVED", description: "Retake Examination Saved"}
                elsif current_user.userable_type == "XrayFacility"
                    @xray_exam.transmitted_at               = @current_time
                    flash[:sp_completed]                    = current_user.userable_type
                    flash[:sp_completed_worker]             = @transaction.fw_code
                    @xray_retake.update(status: "COMPLETED", completed_at: Time.now)

                    # handle xray_retake's requestable flow
                    case @xray_retake.requestable_type
                    when "PcrReview"
                        # pcr_reviews might have multiple retake request, each for different identical transaction, including itself's transaction
                        # only proceed next step when all xray retake request is processed
                        if @xray_retake.requestable.xray_retakes.where(status: ["DRAFT", "APPROVAL", "APPROVED", "IN_PROGRESS"]).count == 0
                            master_xray_retake = @xray_retake.requestable.xray_retakes.where(transaction_id: @xray_retake.requestable.transaction_id).first
                            case master_xray_retake.approval_decision
                            when "APPROVE"
                                # close current pcr_review and create new one to continue review process
                                master_xray_retake.requestable.update(status: "TRANSMITTED")

                                pcr_review = PcrReview.create(
                                    transaction_id: master_xray_retake.transaction_id,
                                    case_type: master_xray_retake.requestable.case_type,
                                    status: "PCR_REVIEW",
                                    pcr_id: master_xray_retake.requestable.pcr_id
                                )

                                master_xray_retake.transactionz.update(xray_status: "PCR_REVIEW", pcr_review_id: pcr_review.id)
                            when "REJECT"
                            end
                        end
                    when "XrayReview"
                        @xray_retake.requestable.update(status: "XQCC_REVIEW", result: nil)
                        @xray_retake.transactionz.update(xray_status: "XQCC_REVIEW")
                    end

                    xray_movement_data = {status: "RETAKE-EXAMINATION-TRANSMITTED", description: "Retake Examination Transmitted"}
                end
                # /submit by xray facility
            # /save and transmit
            # save without transmit
            else
                xray_movement_data = {status: "RETAKE-EXAMINATION-SAVED", description: "Retake Examination Saved"}
            end
            # /save without transmit

            @xray_retake.save
            @xray_exam.save
            @xray_retake.submit_movement(xray_movement_data[:status], xray_movement_data[:description])
            redirect_to @redirect_to || edit_external_retake_path(@xray_retake, p_tab: params[:p_tab], tab: params[:tab])
        end
        # /db-transaction
    end

    def bypass_fingerprint
        redirect_to external_retakes_path and return if @xray_retake.blank?
        redirect_to external_retakes_path, notice: "Permission denied." and return if !has_permission?("CREATE_BYPASS_FINGERPRINT_REQUEST")
        redirect_to external_retakes_path, notice: "Bypass fingerprint request for #{@xray_retake.code} is pending for approval or approved." and return if !can_submit_bypass_fingerprint_request
    end

    def bypass_fingerprint_update
        redirect_to external_retakes_path and return if @xray_retake.blank?
        redirect_to external_retakes_path, notice: "Bypass fingerprint request for #{@xray_retake.code} is pending for approval or approved." and return if !can_submit_bypass_fingerprint_request

        case current_user.userable_type
        when "Doctor"
            category = "DOCTOR_TRANSACTION_BYPASS_FINGERPRINT"
        when "XrayFacility"
            category = "XRAY_TRANSACTION_BYPASS_FINGERPRINT"
        end

        if params[:transaction].present?
            params[:transaction][:uploads].each do |upload|
                if (!upload[:category].nil? && !upload[:documents].nil?)
                    add_watermark(upload[:documents])
                    upl = @transaction.uploads.create({
                        category: upload[:category],
                        remark: category,
                    })
                    upl.documents.attach(upload[:documents])
                end
            end

            approval_assigned_to("TRANSACTION_BYPASS_FINGERPRINT")

            @transaction.transaction_verify_docs.create({
                transaction_id: @transaction.id,
                category: category,
                status: "APPROVAL",
                additional_information: {
                    bypass_fingerprint_reason: params[:transaction_bypass_reason],
                    phone: params[:phone]
                },
                assigned_to: @assigned_to_user_id,
                submitted_by: current_user.id,
                submitted_at: Time.now,
                sourceable: @xray_retake
            })

            flash_add(:notices, "Bypass fingerprint request for #{@transaction.foreign_worker.name} (#{@transaction.foreign_worker.passport_number}) submitted and pending for approval.")
            redirect_to external_retakes_path and return if @xray_retake.code.start_with("99")
            redirect_to external_appeals_path and return if @xray_retake.code.start_with("88")
        end
    end
private
    def set_xray_retake
        @xray_retake = XrayRetake.find(params[:id])
        @transaction = @xray_retake.transactionz
    end

    def xray_examination_params
        params[:transaction].slice(:xray_worker_identity_confirmed, :xray_film_type, :xray_reporter_type, :radiologist_id).to_unsafe_h
    end

    def xe_attributes__regular_params
        params[:xe_attributes].slice(:xray_examination_not_done, :xray_taken_date, :xray_ref_number).to_unsafe_h
    end

    def xe_attributes__details
        params[:xe_attributes].slice(:thoracic_cage, :heart_shape_and_size, :lung_fields, :mediastinum_and_hila, :pleura_hemidiaphragms_costopherenic_angles, :focal_lesion, :other_findings).to_unsafe_h
    end

    def xe_attributes__comments
        params[:xe_attributes].slice(:thoracic_cage_comment, :heart_shape_and_size_comment, :lung_fields_comment, :mediastinum_and_hila_comment, :pleura_hemidiaphragms_costopherenic_angles_comment, :focal_lesion_comment, :other_findings_comment, :impression).to_unsafe_h
    end

    def xray_default_parameters
        default_parameters = [:xray_examination_not_done, :xray_taken_date, :xray_ref_number, :result, :radiologist_started_at, :radiologist_saved_at].map {|key| [key, nil]}.to_h
    end

    def can_submit_bypass_fingerprint_request
        allow_bypass = false

        case current_user.userable_type
        when "XrayFacility"
            allow_bypass = TransactionVerifyDoc.where(transaction_id: @transaction.id, sourceable: @xray_retake, category: 'XRAY_TRANSACTION_BYPASS_FINGERPRINT', status: ['APPROVAL', 'APPROVED']).count == 0
            allow_bypass = allow_bypass && @xray_retake.xray_bypass_fingerprint_date.blank?
        end
        return allow_bypass
    end
end
