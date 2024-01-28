module ReportsCronjob
    include ReportsIT

    def daily_afisid

        report_cronjob_emails = ReportCronjob.find_by_report_name('daily_afisid_report').try(:report_cronjob_emails)

        if !report_cronjob_emails.blank?
            generate_afisid_report_data

            recipient_main = report_cronjob_emails.where(:recipient_type => 'main').pluck(:email)
            recipient_cc = report_cronjob_emails.where(:recipient_type => 'cc').pluck(:email)
            ReportMailer.with({
                    recipient: recipient_main,
                    cc: recipient_cc,
                    now: @now,
                    current_year: @current_year,
                    last_year: @last_year,
                    afis_id_by_month_current_year: @afis_id_by_month_current_year,
                    afis_id_by_month_last_year: @afis_id_by_month_last_year,
                    afis_id_by_state_current_year: @afis_id_by_state_current_year,
                    afis_id_by_state_last_year: @afis_id_by_state_last_year
            }).afisid_report.deliver_later
        end
    end

    def daily_biometric

        report_cronjob_emails = ReportCronjob.find_by_report_name('daily_biometric_report').try(:report_cronjob_emails)

        if !report_cronjob_emails.blank?
            generate_biometric_report_data

            recipient_main = report_cronjob_emails.where(:recipient_type => 'main').pluck(:email)
            recipient_cc = report_cronjob_emails.where(:recipient_type => 'cc').pluck(:email)
            ReportMailer.with({
                    recipient: recipient_main,
                    cc: recipient_cc,
                    now: @now,
                    start_date_of_system: @start_date_of_system,
                    report_end_date: @report_end_date,
                    current_year: @current_year,
                    last_year: @last_year,
                    daily_biometrics: @daily_biometrics,
                    biometric_start_to_current: @biometric_start_to_current,
                    biometric_by_month_current_year: @biometric_by_month_current_year,
                    biometric_by_month_last_year: @biometric_by_month_last_year,
            }).biometric_report.deliver_later
        end
    end

    def daily_myimms_error_report

        report_cronjob_emails = ReportCronjob.find_by_report_name('daily_myimms_error_report').try(:report_cronjob_emails)

        if !report_cronjob_emails.blank?
            current_datetime    = DateTime.now.strftime('%d/%m/%Y %I:%M %p')
            myimms_errors       = Report::MyimmsErrorReportService.new(Time.now).csv_result

            recipient_main = report_cronjob_emails.where(:recipient_type => 'main').pluck(:email)
            recipient_cc = report_cronjob_emails.where(:recipient_type => 'cc').pluck(:email)

            if myimms_errors.present? # Do not send if there is no myimms error
                ReportMailer.with({
                    recipient:      recipient_main,
                    cc:             recipient_cc,
                    curr_datetime:  current_datetime,
                    headers:        Report::MyimmsErrorReportService.headers,
                    csv:            CSV.generate { |csv| myimms_errors.map{ |row| csv << row } }
                }).myimms_report.deliver_later
            end
        end

    end
    
    def daily_refund_payment_failed_reminder
        report_cronjob_emails = ReportCronjob.find_by_report_name('daily_refund_payment_failed_reminder').try(:report_cronjob_emails)
        reminder = SystemConfiguration.get('REFUND_PAYMENT_FAILED_REMINDER_DAYS').to_i

        if !report_cronjob_emails.blank?
            failed_date = reminder.days.ago.strftime("%d/%m/%Y") #DateTime.now.strftime('%d/%m/%Y %I:%M %p')
            failed_refunds = Report::DailyRefundPaymentFailedService.new(reminder.days.ago).csv_result

            recipient_main = report_cronjob_emails.where(:recipient_type => 'main').pluck(:email)
            recipient_cc = report_cronjob_emails.where(:recipient_type => 'cc').pluck(:email)

            if failed_refunds.present? && failed_refunds.count > 1  # Do not send if there is no payment failed. First row is header, so the count must more than 1
                ReportMailer.with({
                    recipient: recipient_main,
                    cc: recipient_cc,
                    failed_date: failed_date,
                    headers: Report::DailyRefundPaymentFailedService.headers,
                    csv: CSV.generate { |csv| failed_refunds.map{ |row| csv << row } }
                }).refund_payment_failed_reminder.deliver_now
            end
        end
    end
end