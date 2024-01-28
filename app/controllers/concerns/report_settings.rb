module ReportSettings
    def retrieve_settings
        @report     = ReportCronjob.with_deleted.find_or_initialize_by(report_name: params[:report_name])
        emails      = @report.report_cronjob_emails
        main_emails = emails.to_a.select(&:is_main?).map(&:email).sort
        cc_emails   = emails.to_a.select(&:is_cc?).map(&:email).sort
        render json: { main: main_emails, cc: cc_emails }, status: :ok
    end

    def update_settings
        @report             = ReportCronjob.with_deleted.find_or_initialize_by(report_name: params[:report_name])
        @report.deleted_at  = nil
        @report.save
        main_emails         = params[:main_email] || []
        main_emails         = main_emails.select(&:present?).map(&:strip).map(&:downcase)
        cc_emails           = params[:cc_email] || []
        cc_emails           = cc_emails.select(&:present?).map(&:strip).map(&:downcase)

        {main: main_emails, cc: cc_emails}.each do |type, mails|
            @report.report_cronjob_emails.with_deleted.where(recipient_type: type).where.not(email: mails).update(deleted_at: Time.now)

            mails.each do |email|
                email       = ReportCronjobEmail.with_deleted.find_or_initialize_by(report_cronjob_id: @report.id, recipient_type: type, email: email)
                email.update(deleted_at: nil)
            end
        end

        redirect_to params[:redirect_url], notice: "Settings updated"
    end
end

# report_cronjob_id: nil, email: nil, recipient_type: nil, deleted_at: nil