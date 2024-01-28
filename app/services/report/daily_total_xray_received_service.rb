module Report
    class DailyTotalXrayReceivedService < ApplicationController
        attr_reader :query_date

        def initialize(query_date)
            @query_date   = query_date
        end

        def result
        	data   = set_total_xray_received_data

            [@query_date.to_time.strftime(get_standard_date_format), data.size, data.pending_total_certified.size, data.pending_reported.size]
        end

        private

        def set_total_xray_received_data
            data   = XqccPool.date_between(@query_date.to_time.beginning_of_day, @query_date.to_time.end_of_day)
        end
    end
end
