class Internal::XrayPendingDecisionsController < InternalController
    before_action :set_xray_pending_decision, only: [:edit, :update, :show, :approval, :approval_update, :destroy]
    before_action -> { can_access?("VIEW_XQCC_PENDING_DECISION") }, only: [:index, :show]
    before_action -> { can_access?("EDIT_XQCC_PENDING_DECISION") }, only: [:edit, :update]
    before_action -> { can_access?("VIEW_APPROVAL_XQCC_PENDING_DECISION") }, only: [:approval_index]
    before_action -> { can_access?("EDIT_APPROVAL_XQCC_PENDING_DECISION") }, only: [:approval, :approval_update]

    def index
        params[:per] = 100 if params[:per].blank?

        @xray_pending_decisions = XrayPendingDecision.latest_record.left_outer_joins(:xray_review).left_outer_joins(:pcr_review)
        .select("xray_pending_decisions.*", "xray_reviews.status xray_review_status", "pcr_reviews.status pcr_review_status")
        .latest
        .search_status(params[:review_status] || "XQCC_PENDING_DECISION")
        .transaction_code(params[:transaction_code])
        .worker_code(params[:worker_code])
        .passport_number(params[:passport_number])
        .certify_start(params[:certify_start])
        .certify_end(params[:certify_end])
        .page(params[:page])
        .per(get_per)
    end

    def edit
        # @can_pcr = @xray_pending_decision.transactionz.xray_pending_decisions.where.not(id: @xray_pending_decision.id).where(decision: "PCR").count < 2
        @can_pcr = true
    end

    def update
        # Do not use ActiveRecord::Base.transaction, it will work with callbacks after_save or after_commit, but saved_changes & previous_changes methods will stop working.
        # ActiveRecord::Base.transaction do
            # Seed Unsuitable Reasons. Have to use a different method, because of the location of the form.
            xray_reason_ids = params[:unsuitable_reason_ids_in_xray] || ""
            reason_ids      = xray_reason_ids.split(",")
            other_reasons   = UnsuitableReason.other_reasons.pluck(:id) # This is so that only xqcc related reasons are updated.
            @transaction.transaction_unsuitable_reasons.where.not(unsuitable_reason_id: [reason_ids + other_reasons]).destroy_all

            reason_ids.each do |reason_id|
                reason = TransactionUnsuitableReason.with_deleted.find_or_initialize_by(transaction_id: @transaction.id, unsuitable_reason_id: reason_id)
                reason.created_by_system ||= false
                reason.assign_attributes(deleted_at: nil)
                reason.save
            end

            xray_pending_decision_data = xray_pending_decision_params
            transaction_data = {
                xray_status: "XQCC_PENDING_DECISION_APPROVAL"
            }

            @xray_pending_decision.update(xray_pending_decision_data.merge({
                status: "XQCC_PENDING_DECISION_APPROVAL",
                reviewed_by: current_user.id,
                reviewed_at: Time.now
            }))
            @xray_pending_decision.create_activity key: 'pending_decision.reviewed_on', owner: current_user
            @xray_pending_decision.submit_movement('DECISION', "DECISION Status: #{xray_pending_decision_data[:decision]}")

            # update transaction
            @transaction.update(transaction_data) if transaction_data.count > 0

            flash[:notice] = "XQCC Pending Decision for #{@transaction.code} is successfully submitted for approval"
        # end
        # /db-transaction

        redirect_to internal_xray_pending_decisions_path and return
    end

    def show
    end

    def destroy
    end

    def approval_index
        params[:per] = 100 if params[:per].blank?

        @xray_pending_decisions = XrayPendingDecision.latest
        .search_status("XQCC_PENDING_DECISION_APPROVAL")
        .transaction_code(params[:transaction_code])
        .worker_code(params[:worker_code])
        .passport_number(params[:passport_number])
        .certify_start(params[:certify_start])
        .certify_end(params[:certify_end])
        .page(params[:page])
        .per(get_per)
    end

    def approval
    end

    def approval_update
        # Do not use ActiveRecord::Base.transaction, it will work with callbacks after_save or after_commit, but saved_changes & previous_changes methods will stop working.
        # ActiveRecord::Base.transaction do
            xray_pending_decision_data = xray_pending_decision_approval_params
            transaction_data = {}

            @xray_pending_decision.update(xray_pending_decision_data.merge({
                approval_by: current_user.id,
                transmitted_at: Time.now,
                status: "TRANSMITTED"
            }))

            @xray_pending_decision.create_activity key: 'pending_decision_approval.reviewed_on', owner: current_user

            case xray_pending_decision_data[:approval_decision]
            when "APPROVE"
                @xray_pending_decision.submit_movement('APPROVAL', "Approval Status: APPROVED")

                case @xray_pending_decision.decision
                when "PCR"
                    pcr_review = PcrReview.create({
                        transaction_id: @xray_pending_decision.transaction_id,
                        case_type: "XQCC_PENDING_DECISION_PCR",
                        status: 'PCR_REVIEW',
                        pcr_id: @xray_pending_decision.pcr_id
                    })
                    transaction_data[:pcr_review_id] = pcr_review.id
                    transaction_data[:xray_status] = "PCR_REVIEW"
                    flash[:notice] = "XQCC Pending Decision for #{@transaction.code} is successfully submitted for Additional PCR Report"
                else
                    transaction_data[:xray_result] = @xray_pending_decision.decision
                    transaction_data[:xray_status] = "CERTIFIED"
                    flash[:notice] = "XQCC Pending Decision for #{@transaction.code} is successfully transmitted"

                    condition_tb = Condition.where(code: ["3502"]).pluck(:id)
                    condition_follow_up = Condition.where(code: ["5001", "5002", "5003", "5004", "5005"]).pluck(:id)
                    count_condition = @transaction.doctor_examination_details.where.not(condition_id: condition_follow_up).count
                    condition_not_follow_up = @transaction.doctor_examination_details.where.not(condition_id: condition_follow_up)

                    medical_history         = DoctorExamination.find(@transaction.doctor_examination.id).check_medical_history ? "NO" : "YES"
                    # This is called THIRD CONCURRENCE.
                    # If the transaction did not have a medical review (pr/tcupi) but pending decision certifies as SUITABLE (this is because when in MERTS, GP says SUITABLE but in Xray exam the results is ABNORMAL, it will go into PCR Review -> Pending Decision), then add a medical PR to the transaction.
                    if @xray_pending_decision.decision == "SUITABLE" && @transaction.doctor_examination&.suitability == "UNSUITABLE" && @transaction.latest_medical_review.blank?
                        if count_condition == 1 && @transaction.doctor_examination&.result == "NORMAL" && !has_other_abnormality? && @transaction.laboratory_examination&.result == "NORMAL" && @transaction.doctor_examination_details.where(condition_id: condition_tb).exists?
                            # If condition only one and condition = TB ,doctor normal,lab normal and dont have other abnormality.
                            @transaction.update(medical_result: "SUITABLE")
                        elsif @transaction.laboratory_examination&.result == "NORMAL" && @transaction.doctor_examination&.result == "ABNORMAL" && medical_history == "YES" && !has_other_abnormality?
                            #if lab normal,dont have other abnormality,doctor abnormal because doctor tick yes medical history exclude TB, LEPROSY, PSYCHIATRIC ILLNESS, EPILEPSY & CANCER
                            @transaction.update(medical_result: "SUITABLE")
                        elsif @transaction.doctor_examination&.result == "NORMAL" && @transaction.laboratory_examination&.result == "NORMAL" && !has_other_abnormality? && condition_not_follow_up.exists?
                            # If other condition or condition more than one, doctor normal, lab normal and dont have other abnormality
                            @transaction.update(medical_status: "NEW", medical_pr_source: "XQCC", status: "REVIEW")
                            quarantine_reason = QuarantineReason.find_by(code: "10013")
                            TransactionQuarantineReason.find_or_create_by(transaction_id: @transaction.id, quarantine_reason_id: quarantine_reason.id)
                        end
                    end
                end
            when "REJECT"
                @xray_pending_decision.submit_movement('APPROVAL', "Approval Status: REJECTED")

                new_xray_pending_decision_data = @xray_pending_decision.transactionz.copy_doctor_medical_examination
                .merge({
                    transaction_id: @transaction.id,
                    status: "XQCC_PENDING_DECISION",
                    sourceable: @xray_pending_decision
                })
                xray_pending_decision = XrayPendingDecision.create(new_xray_pending_decision_data)
                transaction_data[:xray_status] = "XQCC_PENDING_DECISION_REJECTED"
                transaction_data[:xray_pending_decision_id] = xray_pending_decision.id
                flash[:notice] = "XQCC Pending Decision for #{@transaction.code} is successfully rejected"
            end

            @xray_pending_decision.transactionz.update(transaction_data) if transaction_data.count > 0
        # end
        # /db-transaction

        redirect_to @redirect_to || approval_internal_xray_pending_decisions_path
    end

    private
    def set_xray_pending_decision
        @xray_pending_decision = XrayPendingDecision.find(params[:id])
        @transaction = @xray_pending_decision.transactionz
    end

    def has_other_abnormality?
        return true if @transaction.doctor_examination&.physical_blood_pressure_systolic && @transaction.doctor_examination.physical_blood_pressure_systolic >= 140
        return true if @transaction.doctor_examination&.physical_blood_pressure_diastolic && @transaction.doctor_examination.physical_blood_pressure_diastolic >= 90
    end

    def xray_pending_decision_params
        params.require(:xray_pending_decision).permit(:decision, :comment, :condition_tuberculosis, :condition_other, :condition_heart_diseases, :pcr_id)
    end

    def xray_pending_decision_approval_params
        params.require(:xray_pending_decision).permit(:approval_decision, :approval_comment)
    end
end
