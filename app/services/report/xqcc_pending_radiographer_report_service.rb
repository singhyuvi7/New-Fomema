module Report
    class XqccPendingRadiographerReportService
        attr_reader :query_date, :radiographer

        def initialize(query_date, radiographer)
            @query_date         = query_date
            @radiographer       = radiographer
        end

        def self.headers
            [
                "NO", 
                "PICK-UP DATE", 
                "RADIOGRAPHER NAME", 
                "TOTAL"
            ]
        end

        def self.radiographers
            radiographer_ids = XrayReview.latest_record
                                .latest
                                .search_status("ASSIGN")
                                .map(&:radiographer_id)
                                .uniq
                                .compact

            User.where(id: radiographer_ids)
        end

        def result
            set_xqcc_pending_radiographer_report_data
        end

        private

        def set_xqcc_pending_radiographer_report_data
            XrayReview.search_status("ASSIGN")
                        .where(
                            created_at: @query_date.to_time.beginning_of_day..@query_date.to_time.end_of_day,
                            radiographer_id: @radiographer
                        )
        end
    end
end
