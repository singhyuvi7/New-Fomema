module Report
  class XqccMonthlyXrayReceivedAndViewedReportService
    attr_reader :query_year, :query_month

    def initialize(query_year, query_month = nil)
        @query_year         = query_year
        @query_month        = query_month

        if query_month.present?
            @date           = "#{query_month} 1, #{query_year}".to_time
            @query_date     = @date.beginning_of_month..@date.end_of_month
        else
            @date           = "Jan 1, #{query_year}".to_time
            @query_date     = @date.beginning_of_year..@date.end_of_year
        end
    end

    def self.headers
        [
            "Date", 
            "Total X-ray Received", 
            "Total Viewed < 72 hours", 
            "Total Viewed > 72 hours"
        ]
    end

    def result
        csv = [Report::XqccMonthlyXrayReceivedAndViewedReportService.headers]
        
        if @query_month.present?
            data = total_viewed_data[0]

            csv << [
                @date.to_time.strftime("%^b-%Y"), 
                data.total_xray_received, 
                data.less_than_72, 
                data.more_than_72
            ]
        else
            data = total_viewed_data

            data.each do |d|
                csv << [
                    d.cert_date.to_time.strftime("%^b-%Y"),
                    d.total_xray_received, 
                    d.less_than_72, 
                    d.more_than_72
                ]
            end
        end

        csv
    end

    private

    def total_viewed_data
        if @query_month.present?
            Transaction.where(certification_date: @query_date)
                        .select(report_fields_query)
        else
            Transaction.where(certification_date: @query_date)
                        .select(
                            report_fields_query, 
                            "date_trunc('month', certification_date) as cert_date"
                        )
                        .group("date_trunc('month', certification_date)")
                        .order('cert_date')
        end
    end

    def report_fields_query
        "
            count(*) total_xray_received, 
            count(case when transaction_date - xray_transmit_date < INTERVAL '3' day then 1 end) less_than_72, 
            count(case when transaction_date - xray_transmit_date > INTERVAL '3' day then 1 end) more_than_72
        "
    end
    
  end
end
