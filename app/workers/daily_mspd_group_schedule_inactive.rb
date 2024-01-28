class DailyMspdGroupScheduleInactive < ActionController::Base
  include Sidekiq::Worker

  def perform(*args)

        @csv    = [["Group Name","Company Name","Code","Category","Doctor/Xray Code","Facility Name","Doctor Name/License Holder Name"]]
        data = []

        today= Date.today
        previous_month_date = (today - 1.month)

        data     = ActiveRecord::Base.connection.execute("select distinct spg.name,a.company_name,spg.code as group_code,a.status_scheduleable_type,a.code as service_provider_code,a.facilityName,a.PIC from (
                  select ss.status_scheduleable_type,
                  case when ss.status_scheduleable_type='Doctor' then d.company_name
                  when ss.status_scheduleable_type='XrayFacility' then xf.company_name end company_name,
                  case when ss.status_scheduleable_type='Doctor' then d.code
                  when ss.status_scheduleable_type='XrayFacility' then xf.code end code,
                  case when ss.status_scheduleable_type='Doctor' then d.clinic_name
                  when ss.status_scheduleable_type='XrayFacility' then xf.name end facilityName,
                  case when ss.status_scheduleable_type='Doctor' then d.name
                  when ss.status_scheduleable_type='XrayFacility' then xf.license_holder_name end PIC,
                  case when ss.status_scheduleable_type='Doctor' then d.service_provider_group_id
                  when ss.status_scheduleable_type='XrayFacility' then xf.service_provider_group_id end sp_group
                  from status_schedules ss
                  left join doctors d on ss.status_scheduleable_type='Doctor' and ss.status_scheduleable_id=d.id
                  left join xray_facilities xf on ss.status_scheduleable_type='XrayFacility' and ss.status_scheduleable_id=xf.id
                  where ss.from = '#{DateTime.now.beginning_of_day - SystemConfiguration.find_by(code: "MSPD_INACTIVE_GROUP_IN_X_DAYS").value.to_i.days}' and ss.status = 'INACTIVE' and ss.to is null
                  ) a
                  left join service_provider_groups spg on a.sp_group=spg.id
                  where a.sp_group is not null or (a.company_name is not null and  a. company_name != '');")

        data.each {|row| @csv << row.values }

        if @csv.present? && @csv.count > 1  # Do not send if there is no data. First row is header, so the count must more than 1
            MspdMailer.with({
              email:          SystemConfiguration.find_by(code: 'MSPD_EMAIL')&.value,
              csv:            CSV.generate { |csv| @csv.map{ |row| csv << row } },
              today: today,
              previous_month_date: previous_month_date
            }).group_schedule_inactive.deliver_later
        end
    end
end