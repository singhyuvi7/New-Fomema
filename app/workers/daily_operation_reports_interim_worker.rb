# frozen_string_literal: true

# Interim Daily email worker for Operation Report
class DailyOperationReportsInterimWorker
  include Sidekiq::Worker

  sidekiq_options queue: :mailers

  def perform
    OperationReportMailer
      .with(query_date: Date.current)
      .daily_branch_registration_interim
      .deliver_now
  rescue SmtpAddressBlankError => e
    Rails.logger.info "SmtpAddressBlankError: #{e.inspect}"
  end
end
