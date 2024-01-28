# frozen_string_literal: true

# Daily email worker for Operation Report
class DailyOperationReportsWorker
  include Sidekiq::Worker

  sidekiq_options queue: :mailers

  def perform
    daily_branch_registration_email
  rescue SmtpAddressBlankError => e
    Rails.logger.info "SmtpAddressBlankError: #{e.inspect}"
  end

  private

  def daily_branch_registration_email
    OperationReportMailer
      .with(date: Date.yesterday)
      .daily_branch_registration
      .deliver_now
  end
end
