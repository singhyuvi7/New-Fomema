class ServiceProviderGroupWorker
  include Sidekiq::Worker

  def perform
    schedules = SpGroupSchedule.where(scheduled_date: Time.now.strftime('%F'))
    
    schedules.each do |schedule|
      today = Date.today
      sp_id = schedule.sp_schedulable_id
      sp_type = schedule.sp_schedulable_type
      group_id = schedule.service_provider_group_id

      if group_id.present?
        
        history = SpGroupHistory.new
        history.service_providable_id = sp_id
        history.service_providable_type = sp_type
        history.service_provider_group_id = group_id
        history.join_date = today
        history.save

      else
        # exit group
        history = SpGroupHistory
        .where(:service_providable_id => sp_id, :service_providable_type => sp_type)
        .where(exit_date: nil).order("created_at").last
        
        if history.present?
          history.update({
            exit_date: today
          })
        else
          history = SpGroupHistory.new
          history.service_providable_id = sp_id
          history.service_providable_type = sp_type
          history.service_provider_group_id = schedule.sp_schedulable.service_provider_group_id
          history.exit_date = today
          history.save
        end
      end
      
      # update sp table
      schedule.sp_schedulable.update({
        service_provider_group_id: schedule.service_provider_group_id
      })
    end
  end
end
