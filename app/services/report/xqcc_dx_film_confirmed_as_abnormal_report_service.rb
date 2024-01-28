module Report
  class XqccDxFilmConfirmedAsAbnormalReportService
    attr_reader :start_date, :end_date, :status

    def initialize(start_date, end_date, status)
        @query_date = start_date.to_time.beginning_of_day..end_date.to_time.end_of_day
        @status     = status == "IQA" ? PcrPool::CASE_TYPES["XQCC_REVIEW_IQA"] : PcrPool::CASE_TYPES["XQCC_REVIEW_SUSPICIOUS"]
    end

    def self.headers
        [
            "Transaction ID",
            "PCR Code",
            "PCR Name",
            "Worker Code",
            "Worker Name",
            "Xray Code",
            "Xray Name",
            "PCR Comments",
            "PCR Impression",
            "Radiographer Name",
        ]
    end

    def result
        set_dx_film_confirmed_as_abnormal_data
    end


    private

    def set_dx_film_confirmed_as_abnormal_data
        PcrPool.joins(
                :picked_up_by_user,
                :transactionz,
                transactionz: [
                    :xray_facility,
                    :foreign_worker,
                    :pcr_review,
                    :xray_review,
                ]
            )
            .where(
                picked_up_at:   @query_date,
                case_type:      @status
            )
            .select(
                "transactions.code trans_id",
                "users.code pcr_code",
                "users.name pcr_name",
                "foreign_workers.code worker_code",
                "foreign_workers.name worker_name",
                "xray_facilities.code xray_code",
                "xray_facilities.name xray_name",
                "pcr_reviews.comment pcr_comment",
                "pcr_reviews.result pcr_impression",
                "xray_reviews.radiographer_id",
            )
    end

  end
end
