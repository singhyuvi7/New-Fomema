class Internal::XqccPoolsController < InternalController
    before_action -> { can_access?("PICKUP_XQCC_POOL") }, only: [:pickup, :pickup_update]
    before_action -> { can_access?("REASSIGN_XQCC_POOL") }, only: [:reassign, :reassign_update]

    def pickup
        @can_pickup = false
        @pool_count = XqccPool.pending.digital.count
        @case_count = XrayReview.user_current_xqcc_case(current_user.id).count

        if @pool_count > 0 and @case_count == 0
            @can_pickup = true
        end
    end

    def pickup_update
        XqccPool.transaction do
            xqcc_batch = XqccBatch.create

            case SystemConfiguration.get("XQCC_PICKUPMETHOD")
            when "FACILITY"
                # list available facility
                oldest_xqcc_pool = XqccPool.pending.order(created_at: :asc).first
                unless oldest_xqcc_pool.nil?
                    xray_facility_id = oldest_xqcc_pool.transactionz.xray_facility_id
                    XqccPool.xray_facility_id(xray_facility_id).pending.where(reserved_by: nil).update_all(reserved_by: current_user.id)
                    xqcc_pools = XqccPool.xray_facility_id(xray_facility_id).pending.reserved(current_user.id)
                    pickup_count = 0
                    xqcc_pools.each do |xqcc_pool|
                        xqcc_pool.pickup_xqcc(xqcc_batch.id, current_user.id)
                        xqcc_pool.submit_movement('PICKED-UP', "Batch Id: #{xqcc_batch.id}")
                        xqcc_pool.create_activity key: 'xqcc_pool.pickedup_on', owner: current_user
                        pickup_count += 1
                    end
                    if pickup_count > 0
                        flash[:notice] = "#{pickup_count} XQCC case was successfully picked up"
                        @redirect_to = internal_xray_reviews_path(xray_status: 'XQCC_REVIEW')
                    else
                        flash[:error] = "Failed to pick up XQCC case"
                        @redirect_to = pickup_internal_xqcc_pools_path
                    end
                end

            when "FIFO"
                max_can_pickup = SystemConfiguration.get("XQCC_FIFO_BUNDLEASSIGN").to_i
                ActiveRecord::Base.connection.execute("with tbl as (select id, rank () over (order by created_at asc, id asc) rank from xqcc_pools where status = 'XQCC_POOL' and picked_up_by is null and reserved_by is null order by created_at asc, id asc limit #{max_can_pickup})
                update xqcc_pools set reserved_by = #{current_user.id} from tbl where xqcc_pools.id = tbl.id and tbl.rank <= #{max_can_pickup}")
                xqcc_pools = XqccPool.pending.reserved(current_user.id).order(created_at: :asc).limit(max_can_pickup)
                pickup_count = 0
                xqcc_pools.each do |xqcc_pool|
                    xqcc_pool.pickup_xqcc(xqcc_batch.id, current_user.id)
                    xqcc_pool.submit_movement('PICKED-UP', "Batch Id: #{xqcc_batch.id}")
                    xqcc_pool.create_activity key: 'xqcc_pool.pickedup_on', owner: current_user
                    pickup_count += 1
                end
                if pickup_count > 0
                    flash[:notice] = "#{pickup_count} XQCC case was successfully picked up"
                    @redirect_to = internal_xray_reviews_path(xray_status: 'XQCC_REVIEW')
                else
                    flash[:error] = "Failed to pick up XQCC case"
                    @redirect_to = pickup_internal_xqcc_pools_path
                end

            when "FIFO_CERTIFICATION"
                max_can_pickup = SystemConfiguration.get("XQCC_FIFO_BUNDLEASSIGN").to_i
                ActiveRecord::Base.connection.execute("with tbl as (
                    select xqcc_pools.id, xqcc_pools.created_at, transactions.certification_date,
                    rank () over (order by transactions.certification_date asc)
                    from xqcc_pools join transactions on xqcc_pools.transaction_id = transactions.id where xqcc_pools.status = 'XQCC_POOL'
                    and xqcc_pools.picked_up_by is null and reserved_by is null
                    order by transactions.certification_date asc, xqcc_pools.id asc limit #{max_can_pickup}
                )
                update xqcc_pools set reserved_by = #{current_user.id} from tbl where xqcc_pools.id = tbl.id and tbl.rank <= #{max_can_pickup}")
                xqcc_pools = XqccPool.joins(:transactionz).select("xqcc_pools.*, transactions.certification_date").pending.reserved(current_user.id).order("transactions.certification_date asc, xqcc_pools.id asc").limit(max_can_pickup).all
                pickup_count = 0
                xqcc_pools.each do |xqcc_pool|
                    xqcc_pool.pickup_xqcc(xqcc_batch.id, current_user.id)
                    xqcc_pool.submit_movement('PICKED-UP', "Batch Id: #{xqcc_batch.id}")
                    xqcc_pool.create_activity key: 'xqcc_pool.pickedup_on', owner: current_user
                    pickup_count += 1
                end
                if pickup_count > 0
                    flash[:notice] = "#{pickup_count} XQCC case was successfully picked up"
                    @redirect_to = internal_xray_reviews_path(xray_status: 'XQCC_REVIEW')
                else
                    flash[:error] = "Failed to pick up XQCC case"
                    @redirect_to = pickup_internal_xqcc_pools_path
                end

            when "MAID"
                max_can_pickup = SystemConfiguration.get("XQCC_MAID_BUNDLEASSIGN").to_i
                ActiveRecord::Base.connection.execute("with tbl as (
                    select xqcc_pools.id, xqcc_pools.created_at, case when transactions.fw_maid_online = 'PRAON' then 1 else 2 end maid_ordering,
                    rank () over (order by case when transactions.fw_maid_online = 'PRAON' then 1 else 2 end asc, xqcc_pools.created_at desc)
                    from xqcc_pools join transactions on xqcc_pools.transaction_id = transactions.id where xqcc_pools.status = 'XQCC_POOL'
                    and xqcc_pools.picked_up_by is null and reserved_by is null
                    order by maid_ordering asc, xqcc_pools.created_at asc, xqcc_pools.id asc limit #{max_can_pickup}
                )
                update xqcc_pools set reserved_by = #{current_user.id} from tbl where xqcc_pools.id = tbl.id and tbl.rank < #{max_can_pickup}")
                xqcc_pools = XqccPool.joins(:transactionz).select("xqcc_pools.*, transactions.fw_maid_online, case when transactions.fw_maid_online = 'PRAON' then 1 else 2 end ordering").pending.reserved(current_user.id).order("ordering asc, xqcc_pools.created_at desc").limit(max_can_pickup).all
                pickup_count = 0
                xqcc_pools.each do |xqcc_pool|
                    xqcc_pool.pickup_xqcc(xqcc_batch.id, current_user.id)
                    xqcc_pool.submit_movement('PICKED-UP', "Batch Id: #{xqcc_batch.id}")
                    xqcc_pool.create_activity key: 'xqcc_pool.pickedup_on', owner: current_user
                    pickup_count += 1
                end
                if pickup_count > 0
                    flash[:notice] = "#{pickup_count} XQCC case was successfully picked up"
                    @redirect_to = internal_xray_reviews_path(xray_status: 'XQCC_REVIEW')
                else
                    flash[:error] = "Failed to pick up XQCC case"
                    @redirect_to = pickup_internal_xqcc_pools_path
                end
            end
        end
        # /db-transaction

        redirect_to @redirect_to || internal_xray_reviews_path(xray_status: 'XQCC_REVIEW')
    end

    def reassign
        redirect_to internal_transactions_path, error: "Transaction ID is required!" and return if !params.include?(:transaction_id)
        @transaction = Transaction.find(params[:transaction_id])
        redirect_to internal_transactions_path, error: "Transaction is not in XQCC Pool or XQCC Review" and return if !["XQCC_POOL", "XQCC_REVIEW", "XQCC_RETAKE", "XQCC_ABORT"].include?(@transaction.xray_status)

        if ["XQCC_REVIEW", "XQCC_RETAKE", "XQCC_ABORT"].include?(@transaction.xray_status)
            @picked_up_by = @transaction.xray_review&.radiographer_id
        end
    end

    def reassign_update
        redirect_to internal_transactions_path, error: "Transaction ID is required!" and return if !params.include?(:transaction_id)
        @transaction = Transaction.find(params[:transaction_id])
        redirect_to internal_transactions_path, error: "Transaction is not in XQCC Pool or XQCC Review" and return if !["XQCC_POOL", "XQCC_REVIEW", "XQCC_RETAKE", "XQCC_ABORT"].include?(@transaction.xray_status)

        @transaction.transaction do
            if ["XQCC_REVIEW", "XQCC_RETAKE", "XQCC_ABORT"].include?(@transaction.xray_status) && @transaction.xray_review_id?
                @transaction.xray_review.update({
                    radiographer_id: params[:reassign_to]
                })
                @transaction.xray_review.submit_movement('REASSIGNED', 'XQCC Reassigned')
            elsif @transaction.xray_status == 'XQCC_POOL' && (@xqcc_pool = @transaction.xqcc_pools.where(status: "XQCC_POOL").last)
                xqcc_batch = XqccBatch.create
                @xqcc_pool.pickup_xqcc(xqcc_batch.id, params[:reassign_to])
                @xqcc_pool.submit_movement('REASSIGNED', 'XQCC Reassigned')
                @xqcc_pool.create_activity key: 'xqcc_pool.reassigned', owner: current_user
            else
                redirect_to internal_transaction_path(@transaction), error: "Invalid reassign request." and return
            end
        end
        # /db-transaction

        redirect_to internal_transaction_path(@transaction), notice: "Reassigned"
    end

    private
    def set_xqcc_pool
        @xqcc_pool = XqccPool.find(params[:id])
    end
end
