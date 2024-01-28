module Report
    class XqccDailyBoxesStoreReportService
        attr_reader :filter_date_start, :filter_date_end


        def initialize(filter_date_start, filter_date_end)
            @query_date = filter_date_start.to_time.beginning_of_day..filter_date_end.to_time.end_of_day
        end

        def self.headers
            [
                "DATE", 
                "USER NAME", 
                "BOXES",
                "TYPE"
            ]
        end

        def result
            csv_result  = [XqccDailyBoxesStoreReportService.headers]
            data        = set_daily_boxes_store_data

            data.each do |d|
                csv_result << [
                    d.created_date,
                    d.username,
                    d.boxes,
                    set_current_types(d.id)
                ]
            end

            csv_result
        end


        private

        def set_daily_boxes_store_data
            XrayStorage.joins(:creator)
                        .where(created_at: @query_date)
                        .select(
                            "xray_storages.id",
                            "to_char(xray_storages.created_at, 'DD-MON-YY') created_date",
                            "users.username username",
                            "count(*) as boxes"
                        )
                        .group("created_date, username, xray_storages.id")
                        .order("created_date, username, xray_storages.id")
        end

        def set_current_types(id)
            XrayStorage.find(id).current_categories.join(", ")
        end

    end
end
