module HomeDashboardStatistics
    def doctor_dashboard_statistics
        session.delete(:doctor_dashboard_stat) if session[:doctor_dashboard_stat_expiry].blank? || session[:doctor_dashboard_stat_expiry] < Time.now

        if session[:doctor_dashboard_stat].blank?
            start_date      = Date.today.beginning_of_year
            end_date        = start_date.next_year
            stats           = doctor__yearly_certifications(start_date, end_date)
            stats.merge!(doctor_quota)
            stats[:pending] = Transaction.where(doctor_id: current_user.userable_id, status: "CERTIFICATION").where("expired_at >= current_date").count
            session[:doctor_dashboard_stat] = stats
            session[:doctor_dashboard_stat_expiry] = Time.now + 5.minutes
        else
            stats           = session[:doctor_dashboard_stat]
        end

        @yearly_stats   = [
            { title: "Certification within 24 hours",   data: stats[:within_24],    color: "success",    icon: "fas fa-chart-pie" },
            { title: "Certification after 24 hours",    data: stats[:after_24],     color: "danger",     icon: "fas fa-chart-pie" },
            { title: "Total foreign workers certified", data: stats[:total],        color: "primary",    icon: "fas fa-chart-line" }
        ]

        @daily_stats    = [
            { title: "Pending for certification",       data: stats[:pending],      color: "warning", icon: "fas fa-clipboard-list" }
        ]

        today = Date.today
        date        = today.end_of_quarter
        quarter_date = date.strftime("#{ date.day.ordinalize } %B %Y")
        @doctor_quota    = [
            { title: "Available quota until #{quarter_date}:",   data: stats[:quota],      color: "info", icon: "fa fa-user-md" }
        ]

        @last_refresh   = session[:doctor_dashboard_stat_expiry] - 5.minutes
        render layout: false
    end

    def doctor__yearly_certifications(start_date, end_date)
        results = ActiveRecord::Base.connection.execute("select count(*) total, sum(case when (certification_date - laboratory_transmit_date < INTERVAL '1' day) or (certification_date - xray_transmit_date < INTERVAL '1' day) then 1 else 0 end) within_24 from transactions where doctor_id = #{ current_user.userable_id } and certification_date >= '#{ start_date }' and certification_date < '#{ end_date }'").first
        results.transform_values! {|value| value.present? ? value : 0 }
        { within_24: results["within_24"], after_24: results["total"] - results["within_24"], total: results["total"] }
    end

    def doctor_quota
        results = ActiveRecord::Base.connection.execute("select quota - quota_used + quota_modifier  as quota from doctors where id = #{ current_user.userable_id }").first
        results.transform_values! {|value| value.present? ? value : 0 }
        { quota: results["quota"] }
    end

    def laboratory_dashboard_statistics
        session.delete(:lab_dashboard_stat) if session[:lab_dashboard_stat_expiry].blank? || session[:lab_dashboard_stat_expiry] < Time.now

        if session[:lab_dashboard_stat].blank?
            start_date      = Date.today.beginning_of_year
            end_date        = start_date.next_year
            stats           = lab__yearly_transmissions(start_date, end_date)
            stats[:pending] = Transaction.where(laboratory_id: current_user.userable_id, status: "EXAMINATION", laboratory_transmit_date: nil).count
            session[:lab_dashboard_stat] = stats
            session[:lab_dashboard_stat_expiry] = Time.now + 5.minutes
        else
            stats           = session[:lab_dashboard_stat]
        end

        @yearly_stats   = [
            { title: "Lab result transmission within 72 hours", data: stats[:within_72],    color: "success",    icon: "fas fa-chart-pie" },
            { title: "Lab result transmission after 72 hours",  data: stats[:after_72],     color: "danger",     icon: "fas fa-chart-pie" },
            { title: "Total results transmitted",               data: stats[:total],        color: "primary",    icon: "fas fa-chart-line" }
        ]

        @daily_stats    = [
            { title: "Pending for results transmission",        data: stats[:pending],      color: "warning", icon: "fas fa-clipboard-list" }
        ]

        @last_refresh   = session[:lab_dashboard_stat_expiry] - 5.minutes
        render :doctor_dashboard_statistics, layout: false
    end

    def lab__yearly_transmissions(start_date, end_date)
        results = ActiveRecord::Base.connection.execute("select count(*) total, sum(case when laboratory_transmit_date - medical_examination_date < INTERVAL '3' day then 1 else 0 end) within_72 from transactions where laboratory_id = #{ current_user.userable_id } and laboratory_transmit_date >= '#{ start_date }' and laboratory_transmit_date < '#{ end_date }'").first
        results.transform_values! {|value| value.present? ? value : 0 }
        { within_72: results["within_72"], after_72: results["total"] - results["within_72"], total: results["total"] }
    end

    def xray_facility_dashboard_statistics
        session.delete(:xray_dashboard_stat) if session[:xray_dashboard_stat_expiry].blank? || session[:xray_dashboard_stat_expiry] < Time.now

        if session[:xray_dashboard_stat].blank?
            start_date      = Date.today.beginning_of_year
            end_date        = start_date.next_year
            stats           = xray__yearly_transmissions(start_date, end_date)
            stats.merge!(xray__pending_cases)
            session[:xray_dashboard_stat] = stats
            session[:xray_dashboard_stat_expiry] = Time.now + 5.minutes
        else
            stats           = session[:xray_dashboard_stat]
        end

        @yearly_stats   = [
            { title: "X-ray result transmission within 24 hours",   data: stats[:within_24],    color: "success",    icon: "fas fa-chart-pie" },
            { title: "X-ray result transmission after 24 hours",    data: stats[:after_24],     color: "danger",     icon: "fas fa-chart-pie" },
            { title: "Total results transmitted",                   data: stats[:total],        color: "primary",    icon: "fas fa-chart-line" }
        ]

        @radio_stats   = [
            { title: "X-ray result transmission within 48 hours",   data: stats[:radio_within_48],  color: "success",    icon: "fas fa-chart-pie" },
            { title: "X-ray result transmission after 48 hours",    data: stats[:radio_after_48],   color: "danger",     icon: "fas fa-chart-pie" },
            { title: "Total results transmitted",                   data: stats[:radio_total],      color: "primary",    icon: "fas fa-chart-line" }
        ]

        @daily_stats    = [
            { title: "Pending for chest x-ray transmission",    data: stats[:self_pending],     color: "warning", icon: "fas fa-pen-alt" },
            { title: "Pending report from radiologist",         data: stats[:radio_pending],    color: "warning", icon: "fas fa-clipboard-list" },
            { title: "Pending for acknowledgement",             data: stats[:acknowledge],      color: "warning", icon: "fas fa-clipboard-check" }
        ]

        @last_refresh   = session[:xray_dashboard_stat_expiry] - 5.minutes
        render layout: false
    end

    def xray__yearly_transmissions(start_date, end_date)
        results = ActiveRecord::Base.connection.execute("select count(*) total, "\
            "sum(case when t.xray_reporter_type = 'SELF' then 1 else 0 end) total_self_report, "\
            "sum(case when t.xray_reporter_type = 'SELF' and xray_transmit_date - xe.xray_taken_date < INTERVAL '1' day then 1 else 0 end) self_within_24, "\
            "sum(case when t.xray_reporter_type = 'RADIOLOGIST' then 1 else 0 end) total_radio_report, "\
            "sum(case when t.xray_reporter_type = 'RADIOLOGIST' and xray_transmit_date - xe.xray_taken_date < INTERVAL '2' day then 1 else 0 end) radio_within_48 "\
            "from transactions t join xray_examinations xe on t.id = xe.sourceable_id and xe.sourceable_type = 'Transaction' "\
            "where t.xray_facility_id = #{ current_user.userable_id } and t.xray_transmit_date >= '#{ start_date }' and t.xray_transmit_date < '#{ end_date }'").first
        results.transform_values! {|value| value.present? ? value : 0 }

        {
            total:              results["total_self_report"],
            within_24:          results["self_within_24"],
            after_24:           results["total_self_report"] - results["self_within_24"],
            radio_total:        results["total_radio_report"],
            radio_within_48:    results["radio_within_48"],
            radio_after_48:     results["total_radio_report"] - results["radio_within_48"]
        }
    end

    def xray__pending_cases
        results = ActiveRecord::Base.connection.execute("select count(*) total, "\
            "sum(case when t.xray_reporter_type = 'SELF' or t.xray_reporter_type is null then 1 else 0 end) self_pending, "\
            "sum(case when t.xray_reporter_type = 'RADIOLOGIST' and xe.radiologist_transmitted_at is null then 1 else 0 end) radio_pending, "\
            "sum(case when t.xray_reporter_type = 'RADIOLOGIST' and xe.radiologist_transmitted_at is not null then 1 else 0 end) acknowledge "\
            "from transactions t join xray_examinations xe on t.id = xe.sourceable_id and xe.sourceable_type = 'Transaction' "\
            "where t.xray_facility_id = 604 and status = 'EXAMINATION' and t.xray_transmit_date is null and xe.xray_taken_date is not null ").first
        results.transform_values! {|value| value.present? ? value : 0 }

        {
            self_pending: results["self_pending"],
            radio_pending: results["radio_pending"],
            acknowledge: results["acknowledge"]
        }
    end

    def employer_dashboard_statistics
        session.delete(:employer_dashboard_stat) if session[:employer_dashboard_stat_expiry].blank? || session[:employer_dashboard_stat_expiry] < Time.now

        if session[:employer_dashboard_stat].blank?
            stats = pending_payment
            stats.merge!(pending_clinic)
            session[:employer_dashboard_stat] = stats
            session[:employer_dashboard_stat_expiry] = Time.now + 5.minutes
        else
            stats           = session[:employer_dashboard_stat]
        end
        @payment_stats   = [
            { title: "Pending for payment for past #{ SystemConfiguration.find_by(code: "STAT_PENDING_ORDER_MONTHS").value.to_i} months", data: stats[:total],    color: "info",    icon: "fa fa-credit-card" },
        ]

        @clinic_stats    = [
            { title: "Pending for clinic selection for past #{ SystemConfiguration.find_by(code: "TRANSACTION_EXPIRY_DAYS").value.to_i} days", data: stats[:clinic],  color: "info", icon: "fa fa-medkit" }
        ]
        @last_refresh   = session[:employer_dashboard_stat_expiry] - 5.minutes
        render layout: false
    end

    def pending_payment
        results = ActiveRecord::Base.connection.execute("select count(*) total from orders where customerable_id= #{ current_user.userable_id } and status not in ('FAILED','CANCELLED','PAID','REJECTED') and category in ('TRANSACTION_REGISTRATION','INSURANCE_PURCHASE','FOREIGN_WORKER_GENDER_AMENDMENT') and created_at >= current_date - interval '#{ SystemConfiguration.find_by(code: "STAT_PENDING_ORDER_MONTHS").value.to_i} months'").first
        results.transform_values! {|value| value.present? ? value : 0 }
        {total: results["total"] }
    end
    def pending_clinic
        results = ActiveRecord::Base.connection.execute("select count(*) clinic from transactions where status in ('NEW') and transaction_date >= current_date - interval '#{ SystemConfiguration.find_by(code: "TRANSACTION_EXPIRY_DAYS").value.to_i} days' and employer_id=#{ current_user.userable_id } and doctor_id is null").first
        results.transform_values! {|value| value.present? ? value : 0 }
        { clinic: results["clinic"] }
    end
end