class Internal::XrayReviewsController < InternalController
    before_action :set_xray_review, only: [:show, :edit, :update]

    before_action -> { can_access?("VIEW_XQCC_REVIEW") }, only: [:index]
    before_action -> { can_access?("EDIT_XQCC_REVIEW") }, only: [:edit, :update]

    def index
        params[:per] = 100 if params[:per].blank?

        @xray_reviews = XrayReview.latest_record
        .latest
        .where(radiographer_id: current_user.id)
        .search_status(params[:review_status])
        .transaction_code(params[:transaction_code])
        .worker_code(params[:worker_code])
        .passport_number(params[:passport_number])
        .batch(params[:batch])
        .today_only
        .page(params[:page])
        .per(get_per)
    end

    def show
    end

    def edit
        @xray_retakes = @xray_review.transactionz.xray_retakes
        @can_retake = @xray_retakes.count == 0
        if @xray_review.transaction_id?
            @xray_reviews = XrayReview.where(transaction_id: @xray_review.transaction_id).where.not(id: @xray_review.id).order(:created_at)
            if @xray_reviews.count > 0
                @can_retake = false
            end
        end
        @xray_review.assign_attributes({
            result: "NORMAL"
        }) if @xray_review.result.nil?
    end

    def update
        redirect_to internal_xray_review_path(@xray_review), warning: "XQCC Review was TRANSMITTED, no update allowed." and return if @xray_review.status == 'TRANSMITTED'

        xray_review_data = xray_review_params
        transaction_data = {}

        # Do not use ActiveRecord::Base.transaction, it will work with callbacks after_save or after_commit, but saved_changes & previous_changes methods will stop working.
        ActiveRecord::Base.transaction do
            # sync xray_review_details
            condition_codes = []
            params[:xray_review_detail].each do |code, val|
                condition_codes << code if ["Y", "G", "C"].include?(val)
            end
            conditions = Condition.where(code: condition_codes)
            conditions.each do |condition|
                xray_review_detail = @xray_review.xray_review_details.where(condition_id: condition.id).first_or_create
                xray_review_detail.update({
                    text_value: params[:xray_review_detail][condition.code]
                })
            end
            @xray_review.xray_review_details.where.not(condition_id: conditions.pluck(:id)).destroy_all
            # /sync xray_review_details

            case xray_review_data[:result].downcase
            when "retake"
                @xray_review.update(xray_review_data.merge({
                    status: "XQCC_RETAKE"
                }))
                @xray_review.sync_xqcc_comments(params[:xray_review][:comments])

                # create retake request
                xray_retake = @xray_review.create_retake_request

                transaction_data[:xray_status] = "XQCC_RETAKE"
                transaction_data[:xray_retake_id] = xray_retake.id

                @xray_review.submit_movement('RETAKE-REQUEST', "Retake Requested")
                flash[:notice] = "XQCC Review for #{@transaction.code} is successfully saved. Please fill the RETAKE form"
                @redirect_to = draft_internal_xray_retake_path(xray_retake)

            when "abort"
                @xray_review.update(xray_review_data.merge({
                    status: "XQCC_ABORT"
                }))
                @xray_review.sync_xqcc_comments(params[:xray_review][:comments])

                transaction_data[:xray_status] = "XQCC_ABORT"

                @xray_review.submit_movement('REVIEW', "Review Status: #{xray_review_data[:result]}")
                flash[:notice] = "XQCC Review for #{@transaction.code} is successfully saved"

            when "normal"
                @xray_review.update(xray_review_data.merge({
                    status: 'TRANSMITTED',
                    transmitted_at: Time.now
                }))
                @xray_review.sync_xqcc_comments(params[:xray_review][:comments])
                @xray_review.create_activity key: 'xqcc_review.reviewed_on', owner: current_user

            else # suspicious, identical, wrongly transmitted
                @xray_review.update(xray_review_data.merge({
                    status: 'TRANSMITTED',
                    transmitted_at: Time.now
                }))

                pcr_pool_data = {
                    transaction_id: @xray_review.transaction_id,
                    case_type: "XQCC_REVIEW_#{@xray_review.result}",
                    status: 'PCR_POOL',
                    source: 'XQCC_REVIEW',
                    sourceable_type: XrayReview.to_s,
                    sourceable_id: @xray_review.id
                }
                pcr_pool = PcrPool.find_or_create_by(pcr_pool_data)

                @xray_review.sync_xqcc_comments(params[:xray_review][:comments])
                @xray_review.submit_movement('REVIEW', "Review Status: #{xray_review_data[:result]}")
                @xray_review.create_activity key: 'xqcc_review.reviewed_on', owner: current_user

                transaction_data[:xray_status] = 'PCR_POOL'

                flash[:notice] = "XQCC Review for #{@transaction.code} is successfully submitted to PCR Pool"

                # if identical, store the identical ids
                if xray_review_data[:result].downcase == 'identical'
                    if params[:xqcc_review_identical].present? && params[:xqcc_review_identical][:identical_xray_review_id].present?
                        @xray_review.sync_identicals(params[:xqcc_review_identical][:identical_xray_review_id])
                    else
                        @xray_review.sync_identicals([])
                    end
                end
            end

            if xray_review_data[:result].downcase != 'retake' && xray_review_data[:result].downcase != 'abort'
                #checking iqa for case normal,suspicious, identical, wrongly transmitted
                iqa_total = SystemConfiguration.get("XQCC_IQA").to_i
                iqa_next_sequence = XrayReview.next_iqa_sequence
                # for each iqa total cases, 1 case will go to PCR as Internal Quality Audit (IQA)
                if iqa_next_sequence % iqa_total == 0
                    if xray_review_data[:result].downcase == 'normal'
                        #checking if case more than iqa total
                        radiologist = User.system_user
                        today = Date.today
                        totalnormalIqa=XrayReview.where("transmitted_at >= ? and is_iqa='Y'",today).count
                        totalnotnormal = XrayReview.where("transmitted_at >= ?",today).where.not(result: "NORMAL").count
                        totalIQA= totalnormalIqa + totalnotnormal
                        totalviewfilm = XrayReview.where("transmitted_at >= ? and radiographer_id not in (select id from users where username =?)", today,radiologist.username).count
                        if totalviewfilm.zero?
                            total = 0
                        else
                            total = (totalIQA.to_f/ totalviewfilm.to_f) * 100
                        end
                        compare_iqa = 1.to_f / iqa_total.to_f * 100

                        if total.round(2) >= compare_iqa.round(2)
                            #skip iqa
                            @xray_review.submit_movement('REVIEW', 'Review Status: NORMAL')
                            # update transaction
                            transaction_data[:xray_status] = 'CERTIFIED'
                            transaction_data[:xray_result] = 'SUITABLE'
                            flash[:notice] = "XQCC Review for #{@transaction.code} is successfully reviewed"
                        else
                            @xray_review.submit_movement('REVIEW', 'Review Status: NORMAL IQA')
                            # create PCR iqa case
                            pcr_pool_data = {
                                transaction_id: @xray_review.transaction_id,
                                case_type: 'XQCC_REVIEW_IQA',
                                status: 'PCR_POOL',
                                source: 'XQCC_REVIEW',
                                sourceable_type: XrayReview.to_s,
                                sourceable_id: @xray_review.id
                            }
                            pcr_pool = PcrPool.find_or_create_by(pcr_pool_data)
                            @xray_review.update({
                                is_iqa: "Y"
                            })
                            # update transaction
                            transaction_data[:xray_status] = 'PCR_POOL'
                            flash[:notice] = "XQCC Review for #{@transaction.code} submit to PCR Pool for Internal Quality Audit"
                        end
                    end
                else
                    #notiqa
                    if xray_review_data[:result].downcase == 'normal'
                        @xray_review.submit_movement('REVIEW', 'Review Status: NORMAL')
                        # update transaction
                        transaction_data[:xray_status] = 'CERTIFIED'
                        transaction_data[:xray_result] = 'SUITABLE'
                        flash[:notice] = "XQCC Review for #{@transaction.code} is successfully reviewed"
                    end
                end
            end

            @transaction.update!(transaction_data) if transaction_data.count > 0
        end
        # /db-transaction

        redirect_to @redirect_to || internal_xray_reviews_path
    end

    def filter_identicals
        review_status = params[:review_status] || 'REVIEWED'

        if params[:selected_identical_ids].blank?
            selected_identical_ids = []
        else
            selected_identical_ids = JSON.parse(params[:selected_identical_ids])
            selected_identical_ids = selected_identical_ids.map { |string| string.to_i }
        end
        @xray_reviews = XrayReview.where(radiographer_id: current_user.id).search_status(review_status)
        .where.not(id: selected_identical_ids)
        .where("transmitted_at >= ?", Time.now.strftime("%Y-%m-%d")).where("transmitted_at < ?", Date.tomorrow.strftime("%Y-%m-%d"))

        @xray_reviews = @xray_reviews.where.not(transaction_id: params[:transaction_id]) if !params[:transaction_id].blank?
        @xray_reviews = @xray_reviews.where("exists (select 1 from transactions where xray_reviews.transaction_id = transactions.id and transactions.code = ?)", params[:transaction_code].strip) if !params[:transaction_code].blank?
        @xray_reviews = @xray_reviews.where(batch_id: params[:batch].to_i) if !params[:batch].blank?
        @xray_reviews = @xray_reviews.where(result: params[:result]) if !params[:result].blank?

        @xray_reviews = @xray_reviews.order(created_at: 'desc')
        .all

        render "internal/xray_reviews/filter_identicals", layout: false
    end

    def bulk_physical_review
    end

    def bulk_physical_review_update
        transaction_codes_arr = bulk_physical_review_params[:transaction_codes]

        redirect_to bulk_physical_review_internal_xray_reviews_path, error: "Invalid transaction" and return if transaction_codes_arr.blank?

        Transaction.transaction do
            flash[:errors] = []
            flash[:notices] = []

            transaction_codes_arr.each do |transaction_code|
                transaction_code = transaction_code.strip
                transaction = Transaction.where(code: transaction_code).first

                if !transaction
                    flash[:errors] << "#{transaction_code} not found"
                    next
                end

                if !transaction.xray_film_type.eql?("ANALOG")
                    flash[:errors] << "#{transaction_code} is not analog film"
                    next
                end

                if !transaction.status.eql?("CERTIFIED")
                    flash[:errors] << "#{transaction_code} is not certified"
                    next
                end

                if XrayDispatchItem.where(transaction_id: transaction.id).count == 0
                    flash[:errors] << "#{transaction_code} is not yet received"
                    next
                end

                case bulk_physical_review_params[:result]
                when "NORMAL"
                    # create xray_review
                    xray_review = XrayReview.create({
                        transaction_id: transaction.id,
                        case_type: 'XRAY_EXAMINATION_NORMAL',
                        result: bulk_physical_review_params[:result],
                        status: 'TRANSMITTED',
                        transmitted_at: Time.now,
                        radiographer_id: current_user.id
                    })

                    # update transaction
                    transaction.update({
                        xray_review_id: xray_review.id,
                        xray_status: 'CERTIFIED',
                        xray_result: 'SUITABLE'
                    })

                    flash[:notices] << "XQCC Review for #{transaction_code} submitted as normal"

                when "SUSPICIOUS"
                    assign_to = bulk_physical_review_params[:assign_to]

                    # create xray_review
                    xray_review = XrayReview.create({
                        transaction_id: transaction.id,
                        case_type: 'XQCC_REVIEW_SUSPICIOUS',
                        result: bulk_physical_review_params[:result],
                        status: 'TRANSMITTED',
                        transmitted_at: Time.now,
                        radiographer_id: current_user.id
                    })

                    # create pcr_review
                    pcr_review = PcrReview.create({
                        transaction_id: transaction.id,
                        case_type: 'XQCC_REVIEW_SUSPICIOUS',
                        result: bulk_physical_review_params[:result],
                        status: 'PCR_REVIEW',
                        pcr_id: assign_to
                    })

                    # update transaction
                    transaction.update({
                        status: 'REVIEW',
                        xray_status: 'PCR_REVIEW',
                        xray_review_id: xray_review.id,
                        pcr_review_id: pcr_review.id
                    })

                    flash[:notices] << "XQCC Review for #{transaction_code} submitted as suspicious"

                when "IQA"
                    assign_to = bulk_physical_review_params[:assign_to]

                    # create xray_review
                    xray_review = XrayReview.create({
                        transaction_id: transaction.id,
                        case_type: 'XRAY_EXAMINATION_NORMAL',
                        result: "NORMAL",
                        status: 'TRANSMITTED',
                        transmitted_at: Time.now,
                        radiographer_id: current_user.id,
                        is_iqa: "Y"
                    })

                    # create pcr_review
                    pcr_review = PcrReview.create({
                        transaction_id: transaction.id,
                        case_type: 'XQCC_REVIEW_IQA',
                        result: bulk_physical_review_params[:result],
                        status: 'PCR_REVIEW',
                        pcr_id: assign_to
                    })

                    # update transaction
                    transaction.update({
                        status: 'REVIEW',
                        xray_status: 'PCR_REVIEW',
                        xray_review_id: xray_review.id,
                        pcr_review_id: pcr_review.id
                    })

                    flash[:notices] << "XQCC Review for #{transaction_code} submitted as IQA"

                end
            end
            # /loop transaction
        end
        # /db-transaction

        redirect_to internal_xray_reviews_path and return
    end
    # /bulk_physical_review_update

    private
    def set_xray_review
        @xray_review = XrayReview.find(params[:id])
        @transaction = @xray_review.transactionz
    end

    def xray_review_params
        params.require(:xray_review).permit(:result)
    end

    def bulk_physical_review_params
        params.require(:bulk_physical_review).permit(:result, :assign_to, :transaction_codes => [])
    end
end
