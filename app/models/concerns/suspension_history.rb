# frozen_string_literal: true

# list status change suspension history
module SuspensionHistory
  extend ActiveSupport::Concern

  def suspension_activities
    status_schedules.order(:created_at).map { |status_schedule|
      status_schedule.format_suspension_history_data
    }
  end

  # private

  # def status_change_comment_mapping(status_audit)
  #   status_change = status_audit.audited_changes['status']
  #   reason = status_audit.audited_changes['status_reason']
  #   comment = status_audit.audited_changes['status_comment']

  #   [
  #     status_audit.created_at.strftime('%-d-%m-%Y'),
  #     suspension_history_action(status_change),
  #     suspension_history_reason(status_change, reason, comment)
  #   ]
  # end

  # def suspension_history_action(status_change)
  #   case status_change
  #   when Array
  #     return 'Lifted' if %w[ACTIVE].include? status_change.last
  #     return 'Suspended' if %w[INACTIVE TEMPORARY_INACTIVE].include? status_change.last
  #   else
  #     return 'Initial active' if %w[ACTIVE].include? status_change
  #     return 'Suspended' if %w[INACTIVE TEMPORARY_INACTIVE].include? status_change
  #   end
  # end

  # def suspension_history_reason(status_change, reason_change, comment_change)
  #   status = status_change.is_a?(Array) ? status_change.last : status_change
  #   reason = reason_change.is_a?(Array) ? reason_change.last : reason_change
  #   comment = comment_change.is_a?(Array) ? comment_change.last : comment_change

  #   [].tap do |result|
  #     result << self.class::STATUS_REASONS.dig(status, reason).presence
  #     result << comment.presence
  #   end.compact.join('. ')
  # end
end
