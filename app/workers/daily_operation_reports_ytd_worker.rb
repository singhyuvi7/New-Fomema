# frozen_string_literal: true

# Daily ytd registration email worker for Operation Report
class DailyOperationReportsYtdWorker
  include Sidekiq::Worker

  sidekiq_options queue: :mailers

  def perform
    daily_monthly_registration_report_email
  rescue SmtpAddressBlankError => e
    Rails.logger.info "SmtpAddressBlankError: #{e.inspect}"
  end

  private

  def daily_monthly_registration_report_email
    OperationReportMailer
      .with(date: Date.yesterday)
      .daily_monthly_registration_with_ytd
      .deliver_now
  end
end
