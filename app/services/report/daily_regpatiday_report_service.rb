# frozen_string_literal: true

module Report
  # Daily branch registration report service
  class DailyRegpatidayReportService
    attr_reader :start_date, :end_date

    def initialize(start_date, end_date)
      @start_date 	= start_date.to_datetime.beginning_of_day
      @end_date 	= end_date.to_datetime.end_of_day
    end

    def result
    	set_transactions
    end

    private

    def set_transactions
      data 	= ActiveRecord::Base.connection.execute("select transaction_date::DATE, case when users.userable_type = 'Employer' then 'PORTAL' else org.name end branch, count(*) from transactions t left join users on t.created_by = users.id left join organizations org on users.userable_type = 'Organization' and users.userable_id = org.id where transaction_date >= '#{@start_date}' and transaction_date < '#{@end_date}' and fw_pati is true group by transaction_date::DATE, branch order by transaction_date desc, branch")
    end
    
  end
end
