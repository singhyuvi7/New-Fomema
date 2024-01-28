module Report
  class XqccPendingAuditPcrReportService
    attr_reader :query_date

    def initialize(query_date)
        @query_date = query_date.to_datetime.beginning_of_day..query_date.to_datetime.end_of_day
    end

    def self.headers
        [
            "ABNORMAL", 
            "SUSPICIOUS", 
            "IDENTICAL", 
            "IQA", 
            "WRONGLY TRANSMITTED", 
            "PENDING REVIEW",
            "APPEAL",
            "SUBTOTAL"
        ]
    end

    def result
    	set_xqcc_pending_audit_pcr_report_data
    end

    private

    def set_xqcc_pending_audit_pcr_report_data
        data 	= PcrPool.where(created_at: @query_date)
                    .select(
                        "count(case when pcr_pools.case_type = 'XRAY_EXAMINATION_ABNORMAL' then 1 end) as abnormal_films",
                        "count(case when pcr_pools.case_type = 'XQCC_REVIEW_SUSPICIOUS' then 1 end) as suspicious",
                        "count(case when pcr_pools.case_type = 'XQCC_REVIEW_IDENTICAL' then 1 end) as identical",
                        "count(case when pcr_pools.case_type = 'XQCC_REVIEW_IQA' then 1 end) as iqa",
                        "count(case when pcr_pools.case_type = 'XQCC_REVIEW_WRONGLY_TRANSMITTED' then 1 end) as wrongly_transmitted",
                        "count(case when pcr_pools.case_type = 'XQCC_PENDING_REVIEW_PCR_POOL' then 1 end) as pending",
                        "count(case when pcr_pools.case_type = 'XRAY_APPEAL_NORMAL' then 1 end) as appeal"
                    )
    end
    
  end
end
