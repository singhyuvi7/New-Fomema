# frozen_string_literal: true

# Operation Report Mailer
class OperationReportMailer < ApplicationMailer
  def daily_branch_registration
    @date = params[:date].presence || 1.day.ago.to_date.to_s
    @for_mail = true
    service = Report::DailyBranchRegistrationReportService.new(@date)
    @headers = service.headers
    if service.valid?
      @data, @certification_data, @registration_headers, @certification_headers = service.result
    end

    attributes = {
      report_name: 'daily_branch_registration_cronjob',
      subject: 'Foreign Workers Registration Report' # Changes requested by Tarmie - 2020-11-30
    }
    send_email_with_settings(attributes)
  end

  def daily_branch_registration_interim
    @date = params[:query_date].presence || DateTime.current
    @for_mail = true
    service = Report::DailyBranchRegistrationReportService.new(@date)
    @headers = service.headers
    if service.valid?
      @data, @certification_data, @registration_headers, @certification_headers = service.result
    end

    attributes = {
      report_name: 'daily_branch_registration_interim_cronjob',
      subject: 'Foreign Workers Registration Report (Interim)' # Changes requested by Tarmie - 2020-11-30
    }
    send_email_with_settings(attributes)
  end

  def daily_monthly_registration_with_ytd
    @date = params[:date].presence || 1.day.ago
    service = Report::DailyRegistrationDetailReportService.new(@date)
    if service.valid?
      @past_year, @current_year, @current_year_monthly, @current_month_daily, @branches_data, @branches, @cert_past_year, @cert_current_year, @cert_current_year_monthly, @cert_current_month_daily = service.result
    end

    attributes = {
      report_name: 'daily_monthly_registration_with_ytd_cronjob',
      # subject: 'Daily & Monthly Registration Report with YTD'
      subject: 'Foreign Workers Registration & Certification Report with YTD (Daily & Monthly)'
    }
    send_email_with_settings(attributes)
  end

  def daily_regpatiday_report
    start_date    = 1.day.ago.beginning_of_day
    end_date      = 1.day.ago.end_of_day
    @data         = Report::DailyRegpatidayReportService.new(start_date, end_date).result
    @headers      = ["TRANSDATE","BRANCH","TOTAL"]

    attributes = {
      report_name: 'regpatiday',
      subject: 'Daily Regpatiday Report'
    }

    send_email_with_settings(attributes)
  end

  private

  def send_email_with_settings(parameters = {})
    cron = ReportCronjob.find_by(report_name: parameters[:report_name])

    if cron.present?
        main_emails = cron.report_cronjob_emails.where(recipient_type: "main").pluck(:email)
        cc_emails   = cron.report_cronjob_emails.where(recipient_type: "cc").pluck(:email)
    else
        main_emails = []
        cc_emails   = []
    end

    raise SmtpAddressBlankError, 'SMTP To address may not be blank' if main_emails.blank?

    mail to: main_emails, cc: cc_emails, subject: parameters[:subject]
    ReportCronjobMailSent.create(report_cronjob_id: cron.id, main_recipients: main_emails, cc_recipients: cc_emails) if cron.present?
  end
end
