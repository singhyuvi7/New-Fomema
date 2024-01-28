class ReportMailer < ApplicationMailer
  default template_path: 'internal/reports/cronjob/mailer', from: ENV["EMAIL_FROM"] || ENV["EMAIL_USERNAME"] || "uat@fomema.com.my"
  
  def myimms_report
    @current_datetime   = params[:curr_datetime]
    @headers            = params[:headers]
    csv                 = params[:csv]
    @myimms_errors      = Report::MyimmsErrorReportService.new(Time.now).result

    attachments["Myimms Error Report.csv"] = { mime_type: 'text/csv', content: csv }
    mail(to: params[:recipient], cc: params[:cc], subject: "MyIMMS Error Report")
  end

  def afisid_report
    @now = params[:now]
    @start_date_of_system = params[:start_date_of_system]
    @current_year = params[:current_year]
    @last_year = params[:last_year]

    @afis_id_by_month_current_year = params[:afis_id_by_month_current_year]
    @afis_id_by_month_last_year = params[:afis_id_by_month_last_year]
    @afis_id_by_state_current_year = params[:afis_id_by_state_current_year]
    @afis_id_by_state_last_year = params[:afis_id_by_state_last_year]

    mail(to: params[:recipient], cc: params[:cc], subject: "Daily AFIS Id Report")
  end

  def biometric_report
    @now = params[:now]
    @start_date_of_system = params[:start_date_of_system]
    @current_year = params[:current_year]
    @last_year = params[:last_year]
    @report_end_date = params[:report_end_date]

    @daily_biometrics = params[:daily_biometrics]
    @biometric_start_to_current = params[:biometric_start_to_current]
    @biometric_by_month_current_year = params[:biometric_by_month_current_year]
    @biometric_by_month_last_year = params[:biometric_by_month_last_year]

    mail(to: params[:recipient], cc: params[:cc], subject: "Daily Biometric Report")
  end

  def refund_payment_failed_reminder
    @failed_date = params[:failed_date]
    @headers = params[:headers]
    csv = params[:csv]
    reminder = SystemConfiguration.get('REFUND_PAYMENT_FAILED_REMINDER_DAYS').to_i
    @failed_refunds = Report::DailyRefundPaymentFailedService.new(reminder.days.ago).result

    attachments["Refund Payment Failed #{reminder.days.ago.strftime("%d/%m/%y")}.csv"] = { mime_type: 'text/csv', content: csv }
    mail(to: params[:recipient], cc: params[:cc], subject: "Refund Payment Failed Reminder")
  end
end
