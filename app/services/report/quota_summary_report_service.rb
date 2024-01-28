module Report
    class QuotaSummaryReportService
        attr_reader :query_year

        def initialize(query_year)
            @query_start_date   = "Jan 1, #{query_year}".to_date
            @query_end_date     = "Jan 1, #{query_year}".to_date.end_of_year
        end

        def self.headers
            [
                "#", 
                "Allocation Quota Range", 
                "No. Of Doctors"
            ]
        end

        def self.quota_ranges
            [
                "0",
                "100",
                "200",
                "300",
                "400",
                "500",
                "600",
                "700",
                "800",
                "900",
                "1000",
                "Greater Than 1000"
            ]
        end

        def result
            data  = set_quota_summary_data
        end

        private

        def set_quota_summary_data
            ActiveRecord::Base.connection.execute("
                select sum(case when quota_used = 0 then 1 else 0 end) quota_0, 
                sum(case when quota_used > 0 and quota_used <= 100 then 1 else 0 end ) quota_100, 
                sum(case when quota_used > 100 and quota_used <= 200 then 1 else 0 end ) quota_200, 
                sum(case when quota_used > 200 and quota_used <= 300 then 1 else 0 end ) quota_300, 
                sum(case when quota_used > 300 and quota_used <= 400 then 1 else 0 end ) quota_400, 
                sum(case when quota_used > 400 and quota_used <= 500 then 1 else 0 end ) quota_500, 
                sum(case when quota_used > 500 and quota_used <= 600 then 1 else 0 end ) quota_600, 
                sum(case when quota_used > 600 and quota_used <= 700 then 1 else 0 end ) quota_700, 
                sum(case when quota_used > 700 and quota_used <= 800 then 1 else 0 end ) quota_800, 
                sum(case when quota_used > 800 and quota_used <= 900 then 1 else 0 end ) quota_900, 
                sum(case when quota_used > 900 and quota_used <= 1000 then 1 else 0 end ) quota_1000, 
                sum(case when quota_used > 1000 then 1 else 0 end ) quota_1000 
                from (select d.code doctor_code,
                    d.name doctor_name, 
                    d.clinic_name, 
                    d.status, 
                    s.name state_name,
                    ts.name town_name,
                    count(t.id) quota_used 
                    from doctors d 
                    left join (
                        select id, doctor_id from transactions where transaction_date >= '#{@query_start_date}' and transaction_date <= '#{@query_end_date}' and status not in ('CANCELLED', 'REJECTED')
                    ) t on d.id = t.doctor_id left join states s on d.state_id=s.id left join towns ts on d.town_id=ts.id where status in ('ACTIVE','TEMPORARY_INACTIVE') group by d.code, d.name, d.clinic_name , d.status, s.name, ts.name
                ) a;"
            )[0]
        end
    
    end
end
