module Report
  class XqccDailyDispatchListReportService
    attr_reader :start_date, :end_date

    def initialize(start_date, end_date)
        @query_date = start_date.to_time.beginning_of_day..end_date.to_time.end_of_day
    end

    def result
        set_xqcc_daily_dispatch_list_data        
    end

    
    private

    def set_xqcc_daily_dispatch_list_data
        data = XrayDispatch.joins(:creator)
                .where(created_at: @query_date)
                .select(
                    :received_date, 
                    :received_count, 
                    "users.name as staff_name"
                )
    end

  end
end
