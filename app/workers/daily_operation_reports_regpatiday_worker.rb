# frozen_string_literal: true

# Daily ytd registration email worker for Operation Report
class DailyOperationReportsRegpatidayWorker
  include Sidekiq::Worker

  sidekiq_options queue: :mailers

  def perform
    send_daily_regpatiday_report_email
  rescue SmtpAddressBlankError => e
    Rails.logger.info "SmtpAddressBlankError: #{e.inspect}"
  end

  private

  def send_daily_regpatiday_report_email
    OperationReportMailer
      .daily_regpatiday_report
      .deliver_now
  end
end
