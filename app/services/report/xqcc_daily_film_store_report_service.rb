module Report
    class XqccDailyFilmStoreReportService
        attr_reader :start_date, :end_date

        def initialize(start_date, end_date)
            @start_date = start_date.to_datetime.beginning_of_day
            @end_date   = end_date.to_datetime.end_of_day
        end

        def self.headers
            [
                "DATE", 
                "USER NAME", 
                "DETAILS", 
                "TYPE",
                "TOTAL"
            ]
        end

        def result
            csv     = [XqccDailyFilmStoreReportService.headers]
            data    = set_xqcc_daily_film_data

            data.each do |d|
                csv << [
                    d.date.to_datetime.strftime("%d-%b-%Y"), 
                    d.name, 
                    "BOX NO: #{d.box_id}", 
                    set_current_types(d.xs_id),
                    "NO OF FILMS: #{d.total}"
                ]
            end

            csv
        end

        private

        def set_xqcc_daily_film_data
            data 	= XrayStorage.joins(
                                    :creator, 
                                    :xray_storage_items
                                )
                                .where(created_at: start_date.to_time.beginning_of_day..end_date.to_time.end_of_day)
                                .select(
                                    'xray_storages.id as xs_id',
                                    'xray_storages.updated_at as date', 
                                    'xray_storages.code as box_id',
                                    'users.name as name', 
                                    'count(xray_storage_items) as total'
                                )
                                .group('date, name, xray_storages.code, xs_id')
        end

        def set_current_types(id)
            XrayStorage.find(id).current_categories.join(", ")
        end

    end
end
