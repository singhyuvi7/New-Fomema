class Internal::PcrReviewsController < InternalController
    before_action :set_pcr_review, only: [:show, :edit, :update]

    before_action -> { can_access?("VIEW_PCR_REVIEW") }, only: [:index]
    before_action -> { can_access?("EDIT_PCR_REVIEW") }, only: [:edit, :update]

    def index
        if params[:transaction_code].present? || params[:worker_code].present? || params[:passport_number].present?
            from_transactions   = PcrReview.transaction_code(params[:transaction_code]).worker_code(params[:worker_code]).passport_number(params[:passport_number])
            from_appeals        = PcrReview.appeal_transaction_code(params[:transaction_code]).appeal_worker_code(params[:worker_code]).appeal_passport_number(params[:passport_number])
            reviews             = PcrReview.where(id: (from_transactions + from_appeals).uniq.sort)
        else
            reviews             = PcrReview
        end

        @pcr_reviews = reviews.latest
        .user_review_pcr_case(current_user.id, params[:review_status])
        .page(params[:page])
        .per(get_per)
    end

    def show
    end

    def edit
        # redirect_to internal_pcr_review_path(@pcr_review.id) and return if @pcr_review.status == "TRANSMITTED"
        if @pcr_review.medical_appeal_id?
            @xray_retakes       = []
            @can_retake         = false
        else
            @can_retake = @transaction.xray_retakes.count == 0

            if @can_retake && @transaction.xray_review_id?
                @must_retake = @transaction.xray_review.result.eql?("IDENTICAL")
            end

            @belong_mandatory = @pcr_review.belong_is_mandatory?
        end
    end

    def update
        redirect_to internal_pcr_review_path(@pcr_review.id), warning: "PCR Review was TRANSMITTED, no update allowed." and return if @pcr_review.status == "TRANSMITTED"
        pcr_review_data     = pcr_review_params
        transaction_data    = {}

        # Do not use ActiveRecord::Base.transaction, it will work with callbacks after_save or after_commit, but saved_changes & previous_changes methods will stop working.
        ActiveRecord::Base.transaction do
            if @pcr_review.medical_appeal_id?
                @pcr_review.update(pcr_review_data.merge(status: "TRANSMITTED", transmitted_at: Time.now))
                @pcr_review.submit_movement("AUDIT", "Appeals - Audit Status: #{pcr_review_data[:result]}")
                @appeal = @pcr_review.medical_appeal
                retake  = @appeal.current_xray_retake
                retake.update(status: "CLOSED", completed_at: Time.now)
                @appeal.update(pcr_result: pcr_review_data[:result])
                flash[:notice] = "#{ retake.code } #{ pcr_review_data[:result] == "REPEAT" ? "retake xray requested" : "is successfully released" }"
            else
                # sync pcr_review_details
                condition_codes = []
                params[:pcr_review_detail].each do |code, val|
                    condition_codes << code if ["Y"].include?(val)
                end
                conditions = Condition.where(code: condition_codes)
                conditions.each do |condition|
                    pcr_review_detail = @pcr_review.pcr_review_details.where(condition_id: condition.id).first_or_create
                    pcr_review_detail.update({
                        text_value: params[:pcr_review_detail][condition.code]
                    })
                end
                @pcr_review.pcr_review_details.where.not(condition_id: conditions.pluck(:id)).destroy_all
                # /sync pcr_review_details
                # sync pcr_review_comments
                condition_codes = []
                params[:pcr_review_comment].each do |code, val|
                    condition_codes << code if !val.blank?
                end
                conditions = Condition.where(code: condition_codes)
                conditions.each do |condition|
                    pcr_review_comment = @pcr_review.pcr_review_comments.where(condition_id: condition.id).first_or_create
                    pcr_review_comment.update({
                        comment: params[:pcr_review_comment][condition.code]
                    })
                end
                @pcr_review.pcr_review_comments.where.not(condition_id: conditions.pluck(:id)).destroy_all
                # /sync pcr_review_comments

                case pcr_review_data[:result].downcase
                when "retake"
                    @pcr_review.update(pcr_review_data.merge({
                        status: "PCR_RETAKE"
                    }))

                    # create retake request
                    xray_retake = @pcr_review.create_retake_request

                    transaction_data[:xray_status] = "PCR_RETAKE"
                    transaction_data[:xray_retake_id] = xray_retake.id

                    # create retake request for all identical case
                    if @pcr_review.transactionz.xray_review_id? && @pcr_review.transactionz.xray_review.result == "IDENTICAL"
                        @pcr_review.transactionz.xray_review.xqcc_review_identicals
                        .select("distinct xray_reviews.transaction_id")
                        .joins("join xray_reviews on xqcc_review_identicals.identical_xray_review_id = xray_reviews.id")
                        .where("not exists (select 1 from xray_retakes where xray_retakes.transaction_id = xray_reviews.transaction_id and xray_retakes.status not in ('REJECTED'))").each do |rec|
                            identical_transaction = Transaction.find(rec.transaction_id)
                            identical_xray_retake = XrayRetake.create({
                                requestable: @pcr_review,
                                transaction_id: identical_transaction.id,
                                xray_facility_id: identical_transaction.xray_facility_id,
                                xray_film_type: identical_transaction.xray_film_type,
                                status: "DRAFT"
                            })
                        end
                    end

                    @pcr_review.submit_movement('RETAKE-REQUEST', "Retake Requested")
                    flash[:notice] = "PCR Review for #{@transaction.code} is successfully saved. Please fill up the RETAKE form"
                    @redirect_to = draft_internal_xray_retake_path(xray_retake)
                else
                    @pcr_review.update(pcr_review_data.merge({
                        status: "TRANSMITTED",
                        transmitted_at: Time.now
                    }))
                    @pcr_review.create_activity key: 'pcr_review.reviewed_on', owner: current_user



                    # XQCC review process

                    # if has requested additional pcr report, always submit to XQCC Pending Decision
                    #if @transaction.xray_pending_decisions.where(decision: "PCR").where(approval_decision: "APPROVE").count > 0
                    # This what user said Any cases comes from pending review or pending decision must return to pending review and pending decision back after reviewed by radiographer or audited by PCR
                    if @transaction.xray_pending_decision_id? || @transaction.xray_pending_review_id? || @transaction.xray_examination.result != pcr_review_data[:result] || @transaction.xray_film_type.eql?("ANALOG")
                        pending_decision_data = @transaction.copy_doctor_medical_examination
                        .merge({
                            transaction_id: @transaction.id,
                            status: "XQCC_PENDING_DECISION",
                            sourceable: @pcr_review
                        })
                        xray_pending_decision = XrayPendingDecision.create(pending_decision_data)

                        transaction_data[:xray_status] = "XQCC_PENDING_DECISION"
                        transaction_data[:xray_pending_decision_id] = xray_pending_decision.id

                        if @transaction.xray_examination.result != pcr_review_data[:result]
                            @transaction.xqcc_quarantine_reasons.where({
                                quarantine_reason: QuarantineReason.find_by(code: '10008')
                            }).first_or_create
                        end

                        flash[:notice] = "PCR Review for #{@transaction.code} is successfully submitted to XQCC Pending Decision"
                    # if same result, CERTIFIED
                    elsif @transaction.xray_examination.result == pcr_review_data[:result]
                        transaction_data[:xray_status] = "CERTIFIED"
                        transaction_data[:xray_result] = pcr_review_data[:result] == "NORMAL" ? "SUITABLE" : "UNSUITABLE"

                        # If doctor certified suitable with xray abnormal,PCR confirmed abnormal and transaction not in pending decision
                        # add transaction to pending decision for MLE to tick condition & unsuitable reason
                        if @transaction.doctor_examination&.suitability == "SUITABLE" && @transaction.xray_examination.result == "ABNORMAL" && !@transaction.xray_pending_decision.present?
                            pending_decision_data = @transaction.copy_doctor_medical_examination
                            .merge({
                                transaction_id: @transaction.id,
                                status: "XQCC_PENDING_DECISION",
                                sourceable: @transaction.doctor_examination
                            })
                            xray_pending_decision = XrayPendingDecision.create(pending_decision_data)
                            transaction_data[:xray_status] = "XQCC_PENDING_DECISION"
                            transaction_data[:xray_result] = nil
                            transaction_data[:xray_pending_decision_id] = xray_pending_decision.id
                        end

                        flash[:notice] = "PCR Review for #{@transaction.code} is successfully released"
                    end

                    @pcr_review.submit_movement("AUDIT", "Audit Status: #{pcr_review_data[:result]}")
                    @redirect_to = pickup_internal_pcr_pools_path
                end
                # /result is not RETAKE

                @transaction.update!(transaction_data) if transaction_data.count > 0
            end
        end
        # /db-transaction

        redirect_to @redirect_to || pickup_internal_pcr_pools_path
    end

    private
    def set_pcr_review
        @pcr_review     = PcrReview.find(params[:id])
        @transaction    = @pcr_review.medical_appeal_id? ? @pcr_review.medical_appeal.transactionz : @pcr_review.transactionz
    end

    def pcr_review_params
        params.require(:pcr_review).permit(:belong, :belong_comment, :status, :comment, :result)
    end
end
