class Internal::XrayPendingReviewsController < InternalController
    before_action :set_xray_pending_review, only: [:show, :edit, :update]

    before_action -> { can_access?("VIEW_XQCC_PENDING_REVIEW") }, only: [:index, :show]
    before_action -> { can_access?("EDIT_XQCC_PENDING_REVIEW") }, only: [:edit, :update]

    def index
        params[:per] = 100 if params[:per].blank?

        @xray_pending_reviews = XrayPendingReview.joins(:transactionz).left_outer_joins(:xray_review).left_outer_joins(:pcr_review)
        .select("xray_pending_reviews.*", "xray_reviews.status xray_review_status", "pcr_reviews.status pcr_review_status")
        .latest_record
        .latest
        .search_status(params[:review_status] || "PENDING")
        .search_indicator(params[:indicator])
        .transaction_code(params[:transaction_code])
        .worker_code(params[:worker_code])
        .passport_number(params[:passport_number])
        .certify_start(params[:certify_start])
        .certify_end(params[:certify_end])
        .page(params[:page])
        .per(get_per)
    end

    def show
    end

    def edit
        # redirect_to internal_xray_pending_reviews_path and return if @xray_pending_review.status.eql?("TRANSMITTED")
    end

    def update
        redirect_to internal_xray_pending_reviews_path and return if @xray_pending_review.status.eql?("TRANSMITTED")
        @xray_pending_review.transaction do
            xray_pending_review_data = xray_pending_review_params.merge({
                status: "TRANSMITTED",
                reviewed_by: current_user.id,
                transmitted_at: Time.now
            })

            @xray_pending_review.update(xray_pending_review_data)
            if @xray_pending_review.is_audit_comparison.eql?("YES") && params.key?(:xray_pending_review_compare) && params[:xray_pending_review_compare].key?(:transaction_id)
                @xray_pending_review.sync_compares(params[:xray_pending_review_compare][:transaction_id])
            end

            notice = ""
            case params[:xray_pending_review][:decision]
            when "RADIOGRAPHER_REVIEW"
                xqcc_pool_data = {
                    transaction_id: @xray_pending_review.transaction_id,
                    case_type: 'XQCC_PENDING_REVIEW_XQCC_POOL',
                    status: 'XQCC_POOL',
                    source: 'PENDING_REVIEW',
                    sourceable: @xray_pending_review
                }
                # xqcc_pool = XqccPool.find_or_create_by(xqcc_pool_data)
                xqcc_pool = XqccPool.create(xqcc_pool_data)
                @transaction.update({
                    xray_status: 'XQCC_POOL'
                })
                notice = "#{@transaction.code} is successfully submitted to XQCC Pool"

            when "PCR_AUDIT"
                pcr_pool_data = {
                    transaction_id: @xray_pending_review.transaction_id,
                    case_type: 'XQCC_PENDING_REVIEW_PCR_POOL',
                    status: 'PCR_POOL',
                    source: 'PENDING_REVIEW',
                    sourceable: @xray_pending_review
                }
                # pcr_pool = PcrPool.find_or_create_by(pcr_pool_data)
                pcr_pool = PcrPool.create(pcr_pool_data)
                @transaction.update({
                    xray_status: 'PCR_POOL'
                })
                notice = "#{@transaction.code} is successfully submitted to PCR Pool"

            when "MANUAL_AUDIT"
                xray_pending_decision_data = {
                    transaction_id: @xray_pending_review.transaction_id,
                    status: 'XQCC_PENDING_DECISION',
                    sourceable: @xray_pending_review
                }
                xray_pending_decision = XrayPendingDecision.create(xray_pending_decision_data)
                @transaction.update({
                    xray_pending_decision_id: xray_pending_decision.id,
                    xray_status: "XQCC_PENDING_DECISION"
                })
                notice = "#{@transaction.code} is successfully submitted to Pending Decision"
            end

            redirect_to internal_xray_pending_reviews_path, notice: notice
        end
        # /db-transaction
    end

    def filter_compares
        exclude_ids = [params[:current_transaction_id]]
        if params[:selected_transaction_ids].present?
            params[:selected_transaction_ids].each do |selected_transaction_id|
                exclude_ids << selected_transaction_id
            end
        end
        @transactions = Transaction.search_code(params[:transaction_code])
        .search_fw_code(params[:worker_code])
        .where.not(id: exclude_ids)
        .limit(10)

        render "internal/xray_pending_reviews/filter_compares", layout: false
    end

    private
    def set_xray_pending_review
        @xray_pending_review = XrayPendingReview.find(params[:id])
        @transaction = @xray_pending_review.transactionz
    end

    def xray_pending_review_params
        params.require(:xray_pending_review).permit(:comment, :is_audit_comparison, :decision)
    end
end
