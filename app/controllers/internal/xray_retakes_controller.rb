class Internal::XrayRetakesController < InternalController
    before_action :set_xray_retake, only: [:draft, :draft_update, :approval, :approval_update]

    before_action -> { can_access?("PCR_XRAY_RETAKE") }, only: [:pcr]
    before_action -> { can_access?("XQCC_XRAY_RETAKE") }, only: [:xqcc]
    before_action -> { can_access?("PCR_APPROVAL_XRAY_RETAKE", "XQCC_APPROVAL_XRAY_RETAKE") }, only: [:approval, :approval_update]

    def pcr
        params[:per] = 100 if params[:per].blank?

        @xray_retakes = XrayRetake.latest
        .search_pcr_retake
        .search_status(params[:retake_status])
        .transaction_code(params[:transaction_code])
        .worker_code(params[:worker_code])
        .passport_number(params[:passport_number])
        .request_start(params[:request_start])
        .request_end(params[:request_end])
        .xray_code(params[:xray_code])
        .search_retake_reason_id(params[:retake_reason_id])
        .search_approval_start(params[:approval_start])
        .search_approval_end(params[:approval_end])
        .search_retake_xray_code(params[:retake_xray_code])
        .search_pcr_id(params[:pcr_id])
        .page(params[:page])
        .per(get_per)

        @retake_review_type = "PcrReview"

        respond_to do |format|
            format.html do
                @xray_retakes = @xray_retakes.page(params[:page]).per(get_per)
            end
            format.xlsx do
                render xlsx: 'index', filename: "xray_retake-#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx"
            end
            # format.json { render json: @xray_retakes }
        end
    end

    def xqcc
        params[:per] = 100 if params[:per].blank?

        @xray_retakes = XrayRetake.latest
        .search_xqcc_retake
        .search_status(params[:retake_status])
        .transaction_code(params[:transaction_code])
        .worker_code(params[:worker_code])
        .passport_number(params[:passport_number])
        .request_start(params[:request_start])
        .request_end(params[:request_end])
        .xray_code(params[:xray_code])
        .search_retake_reason_id(params[:retake_reason_id])
        .search_approval_start(params[:approval_start])
        .search_approval_end(params[:approval_end])
        .search_retake_xray_code(params[:retake_xray_code])
        .search_radiographer_id(params[:radiographer_id])
        .page(params[:page])
        .per(get_per)

        @retake_review_type = "XrayReview"

        respond_to do |format|
            format.html do
                @xray_retakes = @xray_retakes.page(params[:page]).per(get_per)
            end
            format.xlsx do
                render xlsx: 'index', filename: "xray_retake-#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx"
            end
            format.json { render json: @xray_retakes }
        end
    end

    def draft
        case @xray_retake.requestable_type
        when "PcrReview"
            @xray_facilities = XrayFacility.select("id", "name || ' (' || code || ')' as label").where(status: "ACTIVE").order(:label)
        when "XrayReview"
            @xray_facilities = XrayFacility.select("id", "name || ' (' || code || ')' as label").where(status: "ACTIVE").order(:label)
        end
    end

    def draft_update
        # Do not use ActiveRecord::Base.transaction, it will work with callbacks after_save or after_commit, but saved_changes & previous_changes methods will stop working.
        # ActiveRecord::Base.transaction do

            retake_data = xray_retake_params
            retake_data[:status] = 'APPROVAL'
            @xray_retake.update(retake_data)

            case @xray_retake.requestable_type
            when "PcrReview"
                @retake_approval_label = "PCR Retake Approval"
                @xray_retake.create_activity key: 'pcr_retake.created_on', owner: current_user
                @redirect_to = internal_pcr_reviews_path

            when "XrayReview"
                @retake_approval_label = "X-Ray Retake Approval"
                @xray_retake.create_activity key: 'xqcc_retake.created_on', owner: current_user
                @redirect_to = internal_xray_reviews_path
            end

            @xray_retake.submit_movement('RETAKE-REQUEST', "Retake Request Confirmed")

        # end
        # /db-transaction

        redirect_to @redirect_to, notice: "Retake request for #{@transaction.code} is successfully submitted for #{@retake_approval_label}" and return
    end

    def approval
        if @xray_retake.created_by == current_user.id
            redirect_to @xray_retake.index_path || internal_root_path, error: "You are not allowed to perform approval for request from yourself" and return
        end

        case @xray_retake.requestable_type
        when "XrayReview"
        when "PcrReview"
            @pcrs = User.where(status: "ACTIVE").where.not(id: @xray_retake.requestable.pcr_id).search_permission("PICKUP_PCR_POOL").order(:name)
        end
    end

    def approval_update
        redirect_to @xray_retake.index_path, error: "X-Ray Retake is not pending for approval" and return if @xray_retake.status != "APPROVAL"

        XrayRetake.transaction do
            approval_data = xray_retake_approval_params
            approval_data[:approval_by] = current_user.id
            approval_data[:approved_at] = Time.now

            @xray_retake.create_activity key: 'pcr_retake_approval.reviewed_on', owner: current_user

            flash[:notices] = []

            case approval_data[:approval_decision].downcase
            when "approve"
                approval_data[:status] = 'APPROVED'
                @xray_retake.update(approval_data.except(:reassign_to_pcr_id))
                flash[:notices] << "X-Ray Retake for #{@transaction.code} is successfully APPROVED"
                @xray_retake.transactionz.update({
                    xray_retake_id: @xray_retake.id
                })

                # pcr_reviews might have multiple retake request, each for different identical transaction, including itself's transaction
                # only proceed next step when all xray retake request is processed
                if @xray_retake.requestable_type == "PcrReview"
                    if @xray_retake.requestable.xray_retakes.where(status: ["DRAFT", "APPROVAL"]).count == 0
                        master_xray_retake = @xray_retake.requestable.xray_retakes.where(transaction_id: @xray_retake.requestable.transaction_id).first
                        case master_xray_retake.approval_decision
                        when "APPROVE"
                        when "REJECT"
                            # close current pcr_review and create new one to continue review process
                            master_xray_retake.requestable.update({
                                status: "TRANSMITTED"
                            })
                            pcr_review = PcrReview.create({
                                transaction_id: master_xray_retake.transaction_id,
                                case_type: master_xray_retake.requestable.case_type,
                                status: "PCR_REVIEW",
                                pcr_id: master_xray_retake.reassign_to_pcr_id
                            })
                            master_xray_retake.transactionz.update({
                                xray_status: "PCR_REVIEW",
                                pcr_review_id: pcr_review.id
                            })
                            flash[:notices] << "PCR Review for #{master_xray_retake.transactionz.code} is successfully REJECTED and REASSIGN"
                        end
                    end
                end

                @xray_retake.submit_movement('RETAKE-REQUEST-APPROVAL', "Retake Approved")

            when "reject"
                approval_data[:status] = 'REJECTED'
                @xray_retake.update(approval_data.except(:xray_facility_id))

                case @xray_retake.requestable_type
                when "PcrReview"
                    # pcr_reviews might have multiple retake request, each for different identical transaction, including itself's transaction
                    # only proceed next step when all xray retake request is processed
                    if @xray_retake.requestable.xray_retakes.where(status: ["DRAFT", "APPROVAL"]).count == 0
                        master_xray_retake = @xray_retake.requestable.xray_retakes.where(transaction_id: @xray_retake.requestable.transaction_id).first
                        case master_xray_retake.approval_decision
                        when "APPROVE"
                        when "REJECT"
                            # close current pcr_review and create new one to continue review process
                            master_xray_retake.requestable.update({
                                status: "TRANSMITTED"
                            })
                            pcr_review = PcrReview.create({
                                transaction_id: master_xray_retake.transaction_id,
                                case_type: master_xray_retake.requestable.case_type,
                                status: "PCR_REVIEW",
                                pcr_id: master_xray_retake.reassign_to_pcr_id
                            })
                            master_xray_retake.transactionz.update({
                                xray_status: "PCR_REVIEW",
                                pcr_review_id: pcr_review.id
                            })
                            flash[:notices] << "PCR Review for #{master_xray_retake.transactionz.code} is successfully REJECTED and REASSIGN"
                        end
                    end
                    flash[:notices] << "X-Ray Retake for #{@transaction.code} is successfully REJECTED"
                when "XrayReview"
                    # continue review process
                    @xray_retake.requestable.update({
                        status: "XQCC_REVIEW"
                    })
                    @xray_retake.transactionz.update({
                        xray_status: "XQCC_REVIEW"
                    })
                    flash[:notices] << "X-Ray Retake for #{@transaction.code} is successfully REJECTED"
                end

                @xray_retake.submit_movement('RETAKE-REQUEST-APPROVAL', "Retake Rejected")
            else
                flash[:notices] << "Invalid decision"
            end
        end
        # /db-transaction

        redirect_to @xray_retake.index_path and return
    end

    private
    def xray_retake_params
        params.require(:xray_retake).permit(:xray_facility_id, :retake_reason_id, :comment)
    end

    def xray_retake_approval_params
        params.require(:xray_retake).permit(:xray_facility_id, :approval_decision, :approval_comment, :reassign_to_pcr_id)
    end

    def set_xray_retake
        @xray_retake = XrayRetake.find(params[:id])
        @transaction = @xray_retake.transactionz
    end
end
