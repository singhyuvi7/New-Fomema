class Internal::PcrPoolsController < InternalController
    before_action -> { can_access?("PICKUP_PCR_POOL") }, only: [:pickup, :pickup_update]
    before_action -> { can_access?("REASSIGN_PCR_POOL") }, only: [:reassign, :reassign_update]

    def pickup
        @can_pickup = false
        @pool_count = PcrPool.pending.not_same_appeal(current_user)
        .not_same_radiologist(Radiologist.where(user_id: current_user.id).first&.id)
        .count
        @active_case = PcrReview.user_current_pcr_case(current_user.id).first
        @xray_retake_draft = XrayRetake.where(created_by: current_user.id).where(status: "DRAFT").first
        @can_pickup = true if @pool_count > 0 && @active_case.nil? && @xray_retake_draft.nil?
    end

    def pickup_update
        # PcrPool.transaction do
            # pickup only one PCR case at one time
            pcr_pool = PcrPool.pending.not_same_appeal(current_user)
            .not_same_radiologist(Radiologist.where(user_id: current_user.id).first&.id)
            .order(:created_at).first
            redirect_to pickup_internal_pcr_pools_path, warning: "Failed to pickup any case." and return if pcr_pool.nil?

            # update transaction
            pcr_review = pcr_pool.pickup_pcr(current_user.id)
            pcr_pool.submit_movement('PICKED-UP', 'PCR Picked Up')
            pcr_pool.create_activity key: 'pcr_pool.pickedup_on', owner: current_user
            redirect_to edit_internal_pcr_review_path(pcr_review.id), notice: "PCR case was successfully picked up" and return
        # end
    end

    def reassign
        redirect_to internal_transactions_path, error: "Transaction ID is required!" and return if !params.include?(:transaction_id)
        @transaction = Transaction.find(params[:transaction_id])
        redirect_to internal_transactions_path, error: "Transaction is not in PCR Pool or PCR Review" and return if !["PCR_POOL", "PCR_REVIEW", "PCR_RETAKE"].include?(@transaction.xray_status)

        if ["PCR_REVIEW", "PCR_RETAKE"].include?(@transaction.xray_status)
            @picked_up_by = @transaction&.pcr_review&.pcr_id
        end
    end

    def reassign_update
        redirect_to internal_transactions_path, error: "Transaction ID is required!" and return if !params.include?(:transaction_id)
        @transaction = Transaction.find(params[:transaction_id])
        redirect_to internal_transactions_path, error: "Transaction is not in PCR Pool or PCR Review" and return if !["PCR_POOL", "PCR_REVIEW", "PCR_RETAKE"].include?(@transaction.xray_status)

        @transaction.transaction do
            if ["PCR_REVIEW", "PCR_RETAKE"].include?(@transaction.xray_status) && @transaction.pcr_review_id?
                @transaction.pcr_review.update({
                    pcr_id: params[:reassign_to]
                })
                @transaction.pcr_review.submit_movement('REASSIGNED', 'PCR Reassigned')
            elsif @transaction.xray_status == 'PCR_POOL' && (@pcr_pool = @transaction.pcr_pools.where(status: "PCR_POOL").last)
                @pcr_pool.pickup_pcr(params[:reassign_to])
                @pcr_pool.submit_movement('REASSIGNED', 'PCR Reassigned')
                @pcr_pool.create_activity key: 'pcr_pool.reassigned', owner: current_user
            else
                redirect_to internal_transaction_path(@transaction), error: "Invalid reassign request." and return
            end
        end
        # /db-transaction

        redirect_to internal_transaction_path(@transaction), notice: "Reassigned"
    end

    private
    def set_pcr_pool
        @pcr_pool = PcrPool.find(params[:id])
    end
end
