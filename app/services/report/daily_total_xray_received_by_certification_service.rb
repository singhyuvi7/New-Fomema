module Report
    class DailyTotalXrayReceivedByCertificationService < ApplicationController
        attr_reader :query_date

        def initialize(query_date)
            @query_date = query_date
        end

        def result
        	data = set_total_xray_received_by_certification_data

            [@query_date.to_time.strftime(get_standard_date_format), data.size, data.pending_total_certified.size]
        end

        private

        def set_total_xray_received_by_certification_data
            data = XqccPool.certification_date_between(@query_date.to_time.beginning_of_day, @query_date.to_time.end_of_day)
        end
    end
end
