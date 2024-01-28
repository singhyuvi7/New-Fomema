class SageTestsController < InternalController
    include Sage
    include DailyCollection
    include DailyRevenue
    include DailyVoidCollection
    include DailyRevenueBatch

    before_action -> { can_access?("PUSH_COLLECTION_DATA_TO_SAGE")}, only: [:daily_collection]
    before_action -> { can_access?("PUSH_VOID_COLLECTION_DATA_TO_SAGE")}, only: [:daily_void_collection]
    before_action -> { can_access?("PUSH_REVENUE_DATA_TO_SAGE")}, only: [:daily_revenue, :daily_revenue_batch]

    def daily_collection

        if params[:date].blank?
            render plain: 'Date is required' and return
        end
        begin
            date = params[:date].to_date
        rescue
            render plain: 'Date entered invalid' and return
        end

        @utc_time_format = "T00:00:00.000Z"
        @current = date

        collection

        render json: 'done' and return
    end

    ## daily revenue
    def daily_revenue
        if params[:date].blank?
            render plain: 'Date is required' and return
        end
        begin
            date = params[:date].to_date
        rescue
            render plain: 'Date entered invalid' and return
        end

        @utc_time_format = "T00:00:00.000Z"
        @current = date

        revenue

        render json: 'done' and return
    end

    # daily revenue for a range - ONE revenue only and the journal date will be on the day run this job
    # use to recognize revenue for the previous expired transactions
    def daily_revenue_batch
        if params[:start].blank? || params[:end].blank?
            render plain: 'Date is required' and return
        end
        begin
            start_date = params[:start].to_date
            end_date = params[:end].to_date
        rescue
            render plain: 'Date entered invalid' and return
        end

        @utc_time_format = "T00:00:00.000Z"
        @start_date = start_date
        @end_date = end_date
        @current = Time.now.strftime('%Y-%m-%d').to_s.to_date

        revenue_batch

        render json: 'done' and return
    end

    ## daily void collection
    def daily_void_collection

        if params[:date].blank?
            render plain: 'Date is required' and return
        end
        begin
            date = params[:date].to_date
        rescue
            render plain: 'Date entered invalid' and return
        end

        @utc_time_format = "T00:00:00.000Z"
        @current = date

        void_collection

        render json: 'Done' and return
    end
end
# /class