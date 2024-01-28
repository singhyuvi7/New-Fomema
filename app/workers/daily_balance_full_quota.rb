class DailyBalanceFullQuota < ActionController::Base
  include Sidekiq::Worker

  def perform(*args)

        @csv    = [["NO","STATE","DISTRICT","#OF CLINIC(ACTIVE)","BALANCE QUOTA(ACTIVE)"]]
        data = []

        data     = ActiveRecord::Base.connection.execute("select s.name as state,t.name as district,a.clinic_active,a.total_quota active_quota
                                                          from(
                                                          select s.id sid,tw.id tid,
                                                          (select count(1) from doctors d2 where d2.status='ACTIVE' and d2.state_id =s.id and d2.town_id =tw.id) Clinic_Active,
                                                          coalesce ((select sum(quota - quota_used + quota_modifier) from doctors d2 where d2.status='ACTIVE' and d2.state_id =s.id and d2.town_id =tw.id),0) total_quota
                                                          from transactions t
                                                          join doctors d on t.doctor_id =d.id
                                                          left join states s on d.state_id =s.id
                                                          left join towns tw on d.town_id = tw.id
                                                          where t.transaction_date>'01-jan-2023' and t.status not in('REJECTED','CANCELED')
                                                          group by s.id,tw.id
                                                          order by 1 ,2)a
                                                          left join states s on a.sid=s.id
                                                          left join towns t on a.tid=t.id
                                                          where a.total_quota <=  30");

        data.each {|row| @csv << row.values }

        if @csv.present? && @csv.count > 1  # Do not send if there is no data. First row is header, so the count must more than 1
            MspdMailer.with({
              email:          SystemConfiguration.find_by(code: 'MSPD_EMAIL')&.value,
              csv:            CSV.generate { |csv| @csv.map{ |row| csv << row } },
            }).daily_balance_full_quota.deliver_later
        end
    end
end