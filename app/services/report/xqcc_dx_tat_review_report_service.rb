module Report
    class XqccDxTatReviewReportService
        include ReportsPrivateMethods

        attr_reader :query_year, :query_month

        def initialize(query_year = nil, query_month = nil)
            @query_year         = query_year
            @query_month        = query_month

            if @query_month.present?
                @date           = "#{@query_month} 1, #{@query_year}".to_time
                @query_date     = @date.beginning_of_month..@date.end_of_month
            else
                @date           = "Jan 1, #{@query_year}".to_time
                @query_date     = @date.beginning_of_year..@date.end_of_year
            end
        end

        def worksheet
            worksheet_1 = []
            worksheet_1 << {
              data: XqccDxTatReviewReportService.headers, 
              style: styling(bold, font("Calibri"), border("028001")) * 32
            }
        end

        def self.headers
            [
                "Month",
                "Total Review < 72 hours",
                "Total Review > 72 hours",
                "Total Digital X-ray Pending",
                "Grand Total"
            ]
        end

        def result
            worksheet   = XqccDxTatReviewReportService.new.worksheet

            if query_month.present?
                data = set_dx_tat_review_data[0]

                worksheet << [
                    @date.strftime("%B %Y"),
                    data.less_than_72.to_i,
                    data.more_than_72.to_i,
                    data.pending.to_i,
                    data.less_than_72.to_i + data.more_than_72.to_i + data.pending.to_i
                ]
            else
                data = set_dx_tat_review_data

                data.each do |d|
                    worksheet << [
                        d.transmitted_date.to_time.strftime("%B %Y"),
                        d.less_than_72.to_i,
                        d.more_than_72.to_i,
                        d.pending.to_i,
                        d.less_than_72.to_i + d.more_than_72.to_i + d.pending.to_i
                    ] 
                end
            end

            worksheet
        end

        private

        def set_dx_tat_review_data
            transactions = Transaction.left_joins(:xray_review)
                .where("certification_date >= '#{@date - 6.months}'")
                .where(xray_reviews: { transmitted_at: @query_date })

            if @query_month.present?
                transactions.select(report_field_query)    
            else
                transactions.select(
                    report_field_query, 
                    "date_trunc('month', xray_reviews.transmitted_at) as transmitted_date"
                )
                .group("date_trunc('month', xray_reviews.transmitted_at)")
                .order("transmitted_date")
            end
        end

        def report_field_query
            "
                sum(case when (select count(*) from (select EXTRACT(DOW FROM s.d::date) as dd from generate_series( xray_reviews.transmitted_at::timestamp, transactions.certification_date::timestamp,'1 hours' ) AS s(d)) transactions where dd not in(0,6)) < 72 then 1 else 0 end ) less_than_72, 
                sum(case when (select count(*) from (select EXTRACT(DOW FROM s.d::date) as dd from generate_series( xray_reviews.transmitted_at::timestamp, transactions.certification_date::timestamp,'1 hours' ) AS s(d)) transactions where dd not in(0,6)) >= 72 then 1  else 0 end ) more_than_72,
                count(case when case_type = 'XQCC_PENDING_REVIEW_XQCC_POOL' then 1 end) as pending
            "
        end
    
    end
end
