module Report
    class XqccSummaryPendingReviewService
        attr_reader :query_date

        def initialize(query_date)
            @query_date_daily       = query_date.to_time.beginning_of_day..query_date.to_time.end_of_day
            @query_date_monthly     = query_date.to_time.beginning_of_month..query_date.to_time.end_of_month
        end

        def self.headers
            [
                "DATE",
                "TYPES OF CASES",
                "SOURCE OF CASES",
                "TOTAL OF CASES",
                "TOTAL AMENDED",
                "TOTAL CONCURRED"
            ]
        end

        def result
            [set_summary_pending_review_data(@query_date_daily), set_summary_pending_review_data(@query_date_monthly)]
        end

        private

        def set_summary_pending_review_data(query_date)
            XrayPendingReview.joins(transactionz: [:xray_pending_decision])
            .where(
                status: "TRANSMITTED",
                transmitted_at: query_date
            )
            .select(
                "count(case when xray_pending_reviews.decision = 'PCR_AUDIT' and quarantine_type in ('Q', 'P', 'X') and source = 'MERTS' then 1 end) quarantine_total_amended",
                "count(case when xray_pending_reviews.decision = 'PCR_AUDIT' and quarantine_type in ('Q', 'P', 'X') and source = 'MERTS' and xray_pending_decisions.approval_decision = 'APPROVE' then 1 end) quarantine_total_concurred", 
                "count(case when xray_pending_reviews.decision = 'PCR_AUDIT' and quarantine_type in ('M', 'U') and source = 'MERTS' then 1 end) monitoring_total_amended", 
                "count(case when xray_pending_reviews.decision = 'PCR_AUDIT' and quarantine_type in ('M', 'U') and source = 'MERTS' and xray_pending_decisions.approval_decision = 'APPROVE' then 1 end) monitoring_total_concurred"
            )[0]
        end
    end
end


