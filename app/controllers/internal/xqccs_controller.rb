class Internal::XqccsController < InternalController
    before_action :set_transaction, only: [:merts_result, :xqcc_movement]

    has_scope :xray_ref_number, only: [:filter_xray_examinations]
    has_scope :transaction_code, only: [:filter_xray_examinations]
    has_scope :worker_code, only: [:filter_xray_examinations]

    def merts_result_index
        foreign_worker_id       = params[:foreign_worker_id]
        @foreign_worker         = ForeignWorker.find(foreign_worker_id)
        @transactions           = Transaction.where(foreign_worker_id: foreign_worker_id)
                                    .where.not(certification_date: nil)
                                    .except_transaction_id(params[:except_transaction_id])
                                    .page(params[:page])
                                    .per(get_per)
    end

    def merts_result
        @previous_xqcc_pd   = XrayPendingDecision.joins(:transactionz).where(status: "TRANSMITTED", transactions: { foreign_worker_id: @transaction.foreign_worker_id}).includes(:transactionz).order(id: :desc)
        @amendments         = @transaction.transaction_amendments.includes(:user, :approved_by).order(id: :desc)
    end

    def filter_xray_examinations
        review_status = params[:review_status] || 'REVIEWED'

        if params[:selected_identical_ids].blank?
            selected_identical_ids = []
        else
            selected_identical_ids = JSON.parse(params[:selected_identical_ids])
            selected_identical_ids = selected_identical_ids.map { |string| string.to_i }
        end
        @xray_reviews = XrayReview.where(radiographer_id: current_user.id).search_status(review_status)
        .where.not(id: selected_identical_ids)

        if !params[:transaction_id].blank?
            @xray_reviews = @xray_reviews.where.not(transaction_id: params[:transaction_id])
        end

        if !params[:transaction_code].blank?
            @xray_reviews = @xray_reviews.where("exists (select 1 from transactions where xray_reviews.transaction_id = transactions.id and transactions.code = ?)", params[:transaction_code].strip)
        end

        if !params[:batch].blank?
            @xray_reviews = @xray_reviews.where(batch_id: params[:batch].to_i)
        end

        if !params[:result].blank?
            @xray_reviews = @xray_reviews.where(result: params[:result])
        end

        @xray_reviews = @xray_reviews.order(created_at: 'desc')
        .all

        render "/internal/xqccs/shared/filter_xray_examinations", layout: false
    end

    def filter_xray_examination_comparisons
        @transactions = Transaction.where.not(id: params[:current_transaction_id])
        .where(foreign_worker_id: params[:foreign_worker_id])
        .order(created_at: 'desc')
        .all

        render "/internal/xqccs/shared/filter_xray_examination_comparisons", layout: false
    end

    def default_xray_facility_id(transaction)
        selected_xray_facility_id = transaction.xray_facility_id
        xray_retake = XrayRetake.where(transaction_id: transaction.id).first

        unless xray_retake.nil?
            selected_xray_facility_id = xray_retake.xray_facility_id
        end

        return selected_xray_facility_id
    end

    def movement_index
        if params[:search].blank?
            flash.now[:error] = "Filter criteria is needed"
            @transactions = []
            render :movement_index and return
        end

        transaction_ids         = XrayRetake.where(code: params[:transaction_code]).pluck(:transaction_id) if params[:transaction_code].present?
        transaction_constructor = transaction_ids.present? ? Transaction.where(id: transaction_ids) : Transaction.search_code(params[:transaction_code])

        @transactions = transaction_constructor.includes(:xray_review, :xray_retake)
        .search_foreign_worker_code(params[:worker_code])
        .search_foreign_worker_passport(params[:passport_no])
        .order(transaction_date: :desc)
        .order(xray_transmit_date: :desc)   # purposely add this to solve the slowness due to limit in the query
        .page(params[:page])
        .per(get_per)
    end

    def xqcc_movement
        @xray_pending_review    = XrayPendingReview.where(transaction_id: @transaction.id).first
        @xray_review            = XrayReview.where(transaction_id: @transaction.id).first
        @pcr_review             = PcrReview.where(transaction_id: @transaction.id).first
        @xray_pending_decision  = XrayPendingDecision.where(transaction_id: @transaction.id).first

        @have_completed_xqcc_retake = false
        @have_completed_pcr_retake  = false

        @xray_retake = XrayRetake.where(transaction_id: @transaction.id).first

        if @xray_review.present?
            @have_completed_xqcc_retake = helpers.have_completed_retake(@xray_review.transactionz)
        end

        if @xray_pending_review.present?
            comparison_ids = Array(@xray_pending_review.xray_pending_review_compares.pluck(:transaction_id))
            @audit_comparison_transactions = Transaction.where(id: comparison_ids)
        end

        @xqcc_movements = @transaction.digital_xray_movements.order(created_at: :asc)
        @amendments     = @transaction.transaction_amendments.includes(:user, :approved_by).order(id: :desc)
    end
private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
        @transaction = Transaction.includes(:xray_examination).find(params[:transaction_id])
    end
end