module Report
  class RadiographerPendingReviewReportService
    attr_reader :start_date, :end_date, :radiographer_id

    def initialize(start_date, end_date, radiographer_id = nil)
        @start_date     = start_date.to_datetime.beginning_of_day
        @end_date       = end_date.to_datetime.end_of_day
        @radiographer   = User.find(radiographer_id) if radiographer_id.present?
    end

    def self.headers
        [
            "NO", 
            "X-RAY FACILITY CODE", 
            "X-RAY FACILITY NAME", 
            "BATCH ID", 
            "DATE OF PICK-UP", 
            "DATE OF X-RAY TAKEN", 
            "RADIOGRAPHER NAME", 
            "NO OF CASES"
        ]
    end

    def self.radiographers
        radiographer_ids    = XqccPool.pending.map(&:created_by).compact
        radiographers       = User.where(id: radiographer_ids).active

        radiographers
    end

    def result
    	set_radiographer_pending_review_data
    end

    private

    def set_radiographer_pending_review_data
        XrayReview.search_status("ASSIGN")
                    .includes(
                        :radiographer, 
                        :transactionz, 
                        transactionz: [
                            :transaction_detail, 
                            :xray_facility
                        ]
                    )
                    .where(
                        created_at: @start_date.to_time.beginning_of_day..@end_date.to_time.end_of_day
                    )
                    .group_by(&:radiographer_id)

    end
    
  end
end
