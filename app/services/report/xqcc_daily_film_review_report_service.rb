module Report
  class XqccDailyFilmReviewReportService
    attr_reader :start_date, :end_date

    def initialize(start_date, end_date)
        @query_date = start_date.to_time.beginning_of_day..end_date.to_time.end_of_day
    end

    def self.headers
        [
            "DATE", 
            "USER ID", 
            "STATUS", 
            "TRANS ID", 
            "WORKER CODE", 
            "WORKER NAME", 
            "XRAY CODE", 
            "XRAY NAME"
        ]
    end

    def result
    	set_xqcc_daily_film_review_data
    end

    private

    def set_xqcc_daily_film_review_data
        data = Transaction.joins(
                    :foreign_worker, 
                    :xray_facility,
                    xray_review: [:radiographer]
                )
                .where(
                    xray_reviews: {created_at: @query_date},
                    xray_film_type: "ANALOG",
                    xray_status: "CERTIFIED"
                )
                .select(
                    :transaction_date, 
                    :xray_status, 
                    'users.name as user_id',
                    'transactions.code as trans_code', 
                    'foreign_workers.code as fw_code', 
                    'foreign_workers.name as fw_name', 
                    'xray_facilities.code as xf_code', 
                    'xray_facilities.name as xf_name'
                )
                .order(:transaction_date)
    end
    
  end
end
