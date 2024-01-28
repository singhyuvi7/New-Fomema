# Preview all emails at http://localhost:3000/rails/mailers/medical_reports_mailer
class MedicalReportsMailerPreview < ActionMailer::Preview
    def a__medical_mail_report_for_unsuitable
        date = Date.today
        MedicalReportsMailer.with(filter_date_start: date - 5.months, filter_date_end: date).medical_mail_report_for_unsuitable
    end

    def b__medical_reports_monthly_medical_appeal
        MedicalReportsMailer.with(filter_date_start: (Date.today - 3.months), filter_date_end: Date.today).medical_reports_monthly_medical_appeal
    end

    def c__medical_reports_monthly_type_of_diseases
        MedicalReportsMailer.with(query_month: Date.today).medical_reports_monthly_type_of_diseases
    end

    def d__medical_reports_med_monthly_stat_appeal
        MedicalReportsMailer.with(filter_date_start: (Date.today - 3.months), filter_date_end: Date.today).medical_reports_med_monthly_stat_appeal
    end

    def e__medical_reports_med_monthly_stat_pr
        MedicalReportsMailer.with(filter_date_start: (Date.today - 3.months), filter_date_end: Date.today).medical_reports_med_monthly_stat_pr
    end

    def f__medical_reports_med_monthly_stat_tcupi
        MedicalReportsMailer.with(filter_date_start: (Date.today - 3.months), filter_date_end: Date.today).medical_reports_med_monthly_stat_tcupi
    end

    def g__medical_reports_med_monthly_stat_reuse_passport
        MedicalReportsMailer.with(filter_date_start: (Date.today - 3.months), filter_date_end: Date.today).medical_reports_med_monthly_stat_reuse_passport
    end

    def h__medical_reports_med_monthly_stat_unfit_reason
        MedicalReportsMailer.with(filter_date_start: (Date.today - 3.months), filter_date_end: Date.today).medical_reports_med_monthly_stat_unfit_reason
    end

    def i_medical_reports_weekly_cronjob_moh_weekly_email_report
        MedicalReportsMailer.with(filter_date_start: "2020-01-01", filter_date_end: "2020-08-31").medical_reports_weekly_cronjob_moh_weekly_email_report
    end
end