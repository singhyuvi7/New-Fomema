# frozen_string_literal: true

# collection of interim daily email worker for Operation Report
class BatchDailyOperationReportsInterimWorker
  include Sidekiq::Worker

  def perform
    # perform delivery worker at 11am, 1pm, 3pm, 5pm, 7pm
    time_slots.each do |time|
      DailyOperationReportsInterimWorker.perform_at(time)
    end
  end

  private

  def time_slots
    %w[11:00 13:00 15:00 17:00 19:00].map do |time_slot|
      hour, min = time_slot.split(':').map(&:to_i)
      Time.current.change(hour: hour, min: min, sec: 0)
    end
  end
end
