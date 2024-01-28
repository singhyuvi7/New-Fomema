module ReportsMedical
    def it_send_mail_for_unsuitable # it stands for IT (as in Information Technology). This one is manual download.
        @csv    = [["Date", "Total Send"]]
        letters = []

        if params[:filter_date_start].present? && params[:filter_date_end].present?
            start_date  = params[:filter_date_start].to_date
            end_date    = params[:filter_date_end].to_date.tomorrow

            letters     = ActiveRecord::Base.connection.execute("select to_char(created_at, 'DD/MM/YYYY') as date, count(*)
                from unsuitable_letter_sents
                where created_at >= '#{ start_date }' and created_at < '#{ end_date }'
                group by date order by date")
        end

        letters.each {|row| @csv << row.values }
        @filter_options = [{ type: "date range", label: "Date Range" }]
        setting_csv_html_display_limit
        parse_output_format("it_send_mail_for_unsuitable")
    end

    # Currently getting from release date, but in moh notifications index is from final result date. Need to confirm.
    def cronjob_moh_weekly_email_report # Sends an email to MOH. I assume it sends to FOMEMA IT first, then they will forward to MOH.
        worksheet = [data: ["Report Date: #{ Time.now.strftime("%d-%^b-%Y %H:%M") }"], style: styling(bold)]

        if params[:filter_date_start].present? && params[:filter_date_end].present?
            @start_date         = params[:filter_date_start].to_date
            @end_date           = params[:filter_date_end].to_date.tomorrow
            @extended_headers   = 5
            worksheet           << []

            worksheet << {
                data: ["Notification of Communicable Diseases Released from #{ @start_date.strftime("%d-%^b-%Y") } to #{ @end_date.yesterday.strftime("%d-%^b-%Y") }"],
                style: styling(bold)
            }

            worksheet << []

            worksheet << {
                data: ["STATE", "HEPATITIS B", "TB", "HIV", "LEPROSY", "SYPHILIS", "MALARIA", "TOTAL"],
                style: styling(bold, bg_color("fef0d5"), border) * 8
            }

            notifications   = ActiveRecord::Base.connection.execute("select states.name,
                sum(case when mn.disease = 'HEPB' then 1 else 0 end) hepb,
                sum(case when mn.disease = 'TB' then 1 else 0 end) tb,
                sum(case when mn.disease = 'HIV' then 1 else 0 end) hiv,
                sum(case when mn.disease = 'LEPROSY' then 1 else 0 end) leprosy,
                sum(case when mn.disease = 'SYPHILIS' then 1 else 0 end) syphilis,
                sum(case when mn.disease = 'MALARIA' then 1 else 0 end) malaria,
                sum(1) total
                from moh_notification_checks mnc join moh_notifications mn on mnc.transaction_id = mn.transaction_id
                join transactions t on t.id = mn.transaction_id
                join doctors on doctors.id = t.doctor_id
                join states on states.id = doctors.state_id
                where mnc.final_result = 'UNSUITABLE' and mnc.final_result_date >= '#{ @start_date }' and mnc.final_result_date < '#{ @end_date }' and mn.release_flag = 'Y'
                group by states.name order by states.name")

            diseases_by_states = notifications.map do |row|
                worksheet << row.values
                row.values
            end

            totals  = (1..7).map {|index| diseases_by_states.map {|row| row[index] }.sum }

            worksheet << {
                data: ["[TOTAL]"] + totals,
                style: styling(border, bg_color("fef0d5")) * 8
            }
        end

        @column_widths      = []
        @column_widths      << [20, nil, nil, nil, nil, nil, nil, nil]
        @merge_fields       = []
        @merge_fields       << ["A1:H1", "A2:H2"]
        @filter_options     = [{ type: "date range", label: "Date Range" }]
        setting_html_display_limit(worksheet)
        parse_output_format("cronjob_moh_weekly_email_report")
    end

    def cronjob_moh_weekly_system_report_by_state # JIM send date is -> myimms_transactions.status = 1 & created_at date
        load_state_list

        @filter_options     = [
            { type: "select list", label: "Year", list: (2012..Date.today.year), field_name: :selected_year },
            { type: "select list", label: "Week From", list: (1..53), field_name: :selected_week_from },
            { type: "select list", label: "Week To", list: (1..53), field_name: :selected_week_to },
            { type: "select list", label: "State", list: @state_list.keys, field_name: :selected_state }
        ]

        if params[:selected_year].blank?
            flash.now[:notice] = "Please select a year"
            parse_output_format("FOMEMA1") and return
        elsif params[:selected_week_from].blank?
            flash.now[:notice] = "Please select a week from"
            parse_output_format("FOMEMA1") and return
        elsif params[:selected_week_to].blank?
            flash.now[:notice] = "Please select a week to"
            parse_output_format("FOMEMA1") and return
        elsif params[:selected_state].blank?
            flash.now[:notice] = "Please select a state"
            parse_output_format("FOMEMA1") and return
        end

        @selected_state     = params[:selected_state]
        @selected_week_from = params[:selected_week_from].to_i
        @selected_week_to   = params[:selected_week_to].to_i
        @selected_year      = params[:selected_year].to_i
        @state              = @state_list[@selected_state]
        state_record        = State.find_by(name: @selected_state)
        start_of_year       = "01-01-#{ @selected_year }".to_date.beginning_of_year
        end_of_year         = "01-01-#{ @selected_year }".to_date.end_of_year
        first_saturday      = start_of_year.wday == 6 ? start_of_year : start_of_year + (6 - start_of_year.wday).days
        @end_date           = first_saturday + (@selected_week_to - 1).weeks
        @start_date         = first_saturday + (@selected_week_from - 1).weeks - 6.days
        displayed_range     = "#{ @start_date.strftime("%d-%b-%Y") } - #{ @end_date.strftime("%d-%b-%Y") } (Week From #{ @selected_week_from.to_s.rjust(2, "0") } to #{ @selected_week_to.to_s.rjust(2, "0") } - #{ @selected_state })"
        @extended_headers   = 4
        worksheet           = []

        worksheet << {
            data: ["Notification of Communicable Diseases of FOMEMA Cases for #{ displayed_range }"],
            style: styling(bold, font("Calibri"))
        }

        worksheet << []
        worksheet << []

        worksheet << {
            data: ["No", "Worker Name", "Passport No", "Worker Code", "Country", "Gender", "Job Type", "Employer Name", "Employer Address 1", "Employer Address 2", "Employer Address 3", "Employer Address 4", "Employer Postcode", "Employer Area", "Employer Phone",
            "Clinic Name", "Clinic Address 1", "Clinic Address 2", "Clinic Address 3", "Clinic Address 4", "Clinic Postcode", "Clinic Area", "Clinic Phone",
            "X-Ray Name", "X-Ray Address 1", "X-Ray Address 2", "X-Ray Address 3", "X-Ray Address 4", "X-Ray Postcode", "X-Ray Area", "X-Ray Phone",
            "D.O.B", "Age", "Arrival Date", "Exam Date", "Certify Date", "Disease", "JIM Send Date", "Amended by Fomema", "PCR Comment", "PLKS", "Email Sent Date"],
            style: styling(bold, font("Calibri"), bg_color("FFFFCC"), border("028001")) * 42
        }

        list = ActiveRecord::Base.connection.execute("select distinct on (fw.code ,mn.disease) fw.name, fw.passport_number, fw.code, countries.name country, fw.gender,
            jt.name job_type, emp.name emp_name, emp.address1 emp_add_1, emp.address2 emp_add_2, emp.address3 emp_add_3,
            emp.address4 emp_add_4, emp.postcode emp_postcode, emp_town.name emp_town, emp.phone emp_phone,
            doc.clinic_name as clinic_name,
            doc.address1 as doc_add_1,
            doc.address2 as doc_add_2,
            doc.address3 as doc_add_3,
            doc.address4 as doc_add_4,
            doc.postcode as doc_postcode,
            doc_town.name as doc_town,
            doc.phone as doc_phone,
            case when mn.disease = 'TB' then xray.name else 'N/A' end xray_clinic_name,
            case when mn.disease = 'TB' then xray.address1 else 'N/A' end xray_add_1,
            case when mn.disease = 'TB' then xray.address2 else 'N/A' end xray_add_2,
            case when mn.disease = 'TB' then xray.address3 else 'N/A' end xray_add_3,
            case when mn.disease = 'TB' then xray.address4 else 'N/A' end xray_add_4,
            case when mn.disease = 'TB' then xray.postcode else 'N/A' end xray_postcode,
            case when mn.disease = 'TB' then xray_town.name else 'N/A' end xray_town,
            case when mn.disease = 'TB' then xray.phone else 'N/A' end xray_phone,
            to_char(fw.date_of_birth, 'DD-MON-YY') dob, cast(DATE_PART('year', AGE(NOW(), fw.date_of_birth)) as integer) age,
            to_char(fw.arrival_date, 'DD-MON-YY') arrival_date, to_char(t.medical_examination_date, 'DD-MON-YY') exam_date,
            case when mn.quarantine_release_date is not null then to_char(mn.quarantine_release_date, 'DD-MON-YY') else to_char(t.certification_date, 'DD-MON-YY') end certify_date,
            mn.disease, case when mt.status = '1' then to_char(mt.created_at, 'DD-MON-YY') end jim_send_date,
            case when de.suitability = t.final_result then 'N' else 'Y' end amended,
            case when xpd.comment is not null and mn.disease = 'TB' then xpd.comment when xpd.comment is null and mn.disease = 'TB' then (select prc.comment from pcr_reviews pr, pcr_review_comments prc where pr.id = prc.pcr_review_id and t.id = pr.transaction_id order by pr.id desc limit 1) end pcr_comment,
            t.fw_plks_number,
            to_char(ant.email_sent_at, 'DD-MON-YY') email_sent_at
            from moh_notification_checks mnc join moh_notifications mn on mnc.transaction_id = mn.transaction_id
            join transactions t on t.id = mn.transaction_id
            join doctors on doctors.id = t.doctor_id
            left join foreign_workers fw on fw.id = t.foreign_worker_id
            left join countries on countries.id = fw.country_id
            left join job_types jt on jt.id = fw.job_type_id
            left join employers emp on emp.id = t.employer_id
            left join towns emp_town on emp_town.id = emp.town_id
            left join doctors doc on doc.id = t.doctor_id
            left join towns doc_town on doc_town.id = doc.town_id
            left join xray_facilities xray on xray.id = t.xray_facility_id
            left join towns xray_town on xray_town.id = xray.town_id
            left join doctor_examinations de on de.transaction_id = t.id
            left join myimms_transactions mt on mt.transaction_id = t.id
            left join amended_notifiable_transactions ant on ant.transaction_id = t.id and ant.disease = mn.disease
            left join xray_pending_decisions xpd on xpd.transaction_id = t.id and xpd.decision='UNSUITABLE'
            where mnc.final_result = 'UNSUITABLE' and mnc.final_result_date >= '#{ @start_date }' and mnc.final_result_date < '#{ @end_date + 1.days }'
            and mn.release_flag = 'Y' and doctors.state_id = #{ state_record.id }
            order by fw.code ,mn.disease, doc.clinic_name asc")

        list.each.with_index(1) do |row, index|
            worksheet << {
                data: [index] + row.values,
                style: styling(font("Calibri"), border("028001")) * 42
            }
        end

        @column_widths  = []
        @column_widths  << [6, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
        @merge_fields   = []
        @merge_fields   << ["A1:AP1"]
        setting_html_display_limit(worksheet)
        parse_output_format("FOMEMA1#{ @state_list[@selected_state] }#{ @selected_year }W#{ @selected_week }")
    end

    def email_of_repatriation_notice # it stands for IT (as in Information Technology). This one is manual download.
        @csv            = [["No", "Worker Code", "Worker Name", "Certification Date", "Final Result Date", "Final Result Amendment Date", "Email Sent Date", "Employer Email"]]
        letters         = []
        where_query     = []

        if params[:filter_date_start].present? && params[:filter_date_end].present?
            start_date  = params[:filter_date_start].to_date
            end_date    = params[:filter_date_end].to_date.tomorrow
            where_query << "uls.created_at >= '#{ start_date }' and uls.created_at < '#{ end_date }'"
        end

        if params[:worker_code].present?
            where_query << "t.fw_code = #{ ActiveRecord::Base.connection.quote params[:worker_code] }"
        end

        if where_query.present?
            letters     = ActiveRecord::Base.connection.execute("select uls.id, t.fw_code, t.fw_name, to_char(t.certification_date, 'DD/MM/YYYY') certification_date, to_char(t.final_result_date, 'DD/MM/YYYY') final_result_date, to_char(ta.approval_at, 'DD/MM/YYYY') amend_date, to_char(uls.created_at, 'DD/MM/YYYY') send_date, uls.email from unsuitable_letter_sents uls join transactions t on t.id = uls.transaction_id left join transaction_amendments ta on ta.transaction_id = t.id and ta.approval_status = 'CONCURRED' and ta.new_status = 'UNSUITABLE' where #{ where_query.join(" and ") } order by id")
        end

        letters.each.with_index(1) do |row, index|
            @csv << [index, row.values[1..-1]].flatten
        end

        if check_format_html
            headers_footers ||= 1
            total_size      = @csv.size - headers_footers
            @csv            = @csv.first(500 + headers_footers)
            showing_size    = @csv.size - headers_footers
            @displayed_size = "Showing #{ showing_size } out of #{ total_size } rows"
        end

        # Need to include text search, need to wait for another branch to be deployed first.
        @filter_options = [
            { type: "date range", label: "Date Range" },
            { type: "text field",   label: "Worker Code", field_name: :worker_code, placeholder: "Code" }
        ]

        parse_output_format("email_of_repatriation_notice_to_employer")
    end

    def report_unfit_notice
        @csv            = [["No", "Worker Code", "Worker Name", "Certification Date","Doctor Code", "X-Ray Code","Doctor State","Employer State","Employer Email","Email Sent Date","Unsuitable Condition","Unsuitable Reason","Status","Appeal Status"]]
        letters         = []
        where_query     = []

        if params[:filter_date_start].present? && params[:filter_date_end].present?
            start_date  = params[:filter_date_start].to_date
            end_date    = params[:filter_date_end].to_date.tomorrow
            where_query << "t.certification_date >= '#{ start_date }' and t.certification_date < '#{ end_date }'"
        end

        if params[:status_type].present?
            status_map         = { "Allow Appeal" => :APPEAL_REMINDER, "Not Allow Appeal" => :FINAL_RESULT }
            status             = status_map[params[:status_type]]
            where_query << "uls.send_type like '%#{status}%'"
        end

        if where_query.present?
            letters     = ActiveRecord::Base.connection.execute("select t.id,t.fw_code as worker_code,t.fw_name as worker_name ,to_char(t.certification_date, 'DD/MM/YYYY') certification_date,d.code doctorCode,xf.code xray_code,sd.name doctorState,se.name employerState,
            e.email employerEmail,to_char(uls.created_at, 'DD/MM/YYYY') sendDateEmail,
            case when (select count(*) from medical_examination_details med2 where med2.transaction_id = t.id)= 0 then
            (select string_agg(c.description ,' , ')as description from doctor_examination_details ded left join conditions c on c.id = ded.condition_id where ded.transaction_id = t.id and c.code in ('3502','3506','3505','3501','3503','3504','3509','3508',
            '3507','3516','3517','3515','3514','3519','3518','3520','3510','3511','3512')group by ded.transaction_id)
            when (select count(*) from medical_examination_details med2 where med2.transaction_id = t.id) > 0 then
            (select string_agg(c.description ,' , ')as description from medical_examination_details ded left join conditions c on c.id = ded.condition_id where ded.transaction_id = t.id and c.code in ('3502','3506','3505','3501','3503','3504','3509','3508',
            '3507','3516','3517','3515','3514','3519','3518','3520','3510','3511','3512')group by ded.transaction_id) end UnsuitableCondition,
             string_agg(ur.reason_en,' ')as unsuitableEN ,'Allow Appeal' STATUS,case when (select count(1) from medical_appeals ma where ma.transaction_id=t.id) >= 1 then 'Register Appeal' else 'No Appeal' end appeal_status
            from transactions t
            join doctors d on t.doctor_id = d.id
                join states sd on d.state_id =sd.id
            join xray_facilities xf on t.xray_facility_id =xf.id
            join employers e on t.employer_id =e.id
                 join states se on e.state_id =se.id
            join unsuitable_letter_sents uls on t.id=uls.transaction_id and uls.send_type ='APPEAL_REMINDER'
            join transaction_unsuitable_reasons tur on tur.transaction_id = t.id
            join unsuitable_reasons ur on ur.id = tur.unsuitable_reason_id
            where #{ where_query.join(" and ") }
            group by t.id,t.fw_code,t.fw_name ,t.certification_date,d.code,xf.code,sd.name ,se.name ,e.email ,uls.created_at
            union
            select t.id,t.fw_code as worker_code,t.fw_name as worker_name,to_char(t.certification_date, 'DD/MM/YYYY') certification_date,d.code doctorCode,xf.code,sd.name doctorState,se.name employerState,
            e.email employerEmail,to_char(uls.created_at, 'DD/MM/YYYY') sendDateEmail,
            case when (select count(*) from medical_examination_details med2 where med2.transaction_id = t.id)= 0 then
                    (select string_agg(c.description ,' , ')as description from doctor_examination_details ded left join conditions c on c.id = ded.condition_id where ded.transaction_id = t.id and c.code in ('3502','3506','3505','3501','3503','3504','3509','3508',
                    '3507','3516','3517','3515','3514','3519','3518','3520','3510','3511','3512')group by ded.transaction_id)
                    when (select count(*) from medical_examination_details med2 where med2.transaction_id = t.id) > 0 then
                    (select string_agg(c.description ,' , ')as description from medical_examination_details ded left join conditions c on c.id = ded.condition_id where ded.transaction_id = t.id and c.code in ('3502','3506','3505','3501','3503','3504','3509','3508',
                    '3507','3516','3517','3515','3514','3519','3518','3520','3510','3511','3512')group by ded.transaction_id) end UnsuitableCondition,
            string_agg(ur.reason_en,' ')as unsuitableEN ,'Not Allow Appeal' STATUS,case when (select count(1) from medical_appeals ma where ma.transaction_id=t.id) >= 1 then 'Register Appeal' else 'No Appeal' end appeal_status
            from transactions t
            join doctors d on t.doctor_id = d.id
                join states sd on d.state_id =sd.id
            join xray_facilities xf on t.xray_facility_id =xf.id
            join employers e on t.employer_id =e.id
                join states se on e.state_id =se.id
            join unsuitable_letter_sents uls on t.id=uls.transaction_id and uls.send_type ='FINAL_RESULT'
            join transaction_unsuitable_reasons tur on tur.transaction_id = t.id
            join unsuitable_reasons ur on ur.id = tur.unsuitable_reason_id
            where #{ where_query.join(" and ") }
            and t.id not in (select transaction_id from unsuitable_letter_sents uls2 where uls2.send_type ='APPEAL_REMINDER')
            group by t.id,t.fw_code,t.fw_name ,t.certification_date,d.code,xf.code,sd.name ,se.name ,e.email ,uls.created_at")
        end

        letters.each.with_index(1) do |row, index|
            @csv << [index, row.values[1..-1]].flatten
        end

        if check_format_html
            headers_footers ||= 1
            total_size      = @csv.size - headers_footers
            @csv            = @csv.first(500 + headers_footers)
            showing_size    = @csv.size - headers_footers
            @displayed_size = "Showing #{ showing_size } out of #{ total_size } rows"
        end

        @filter_options = [
            { type: "date range", label: "Date Range" },
            { type: "select list", label: "Status", list: ["Allow Appeal", "Not Allow Appeal"], field_name: :status_type }
        ]

        parse_output_format("Report Unfit Notice To Employer")
    end

    def  report_review_qa
        @csv            = [["No", "Certification Date", "Pending Review", "QA Count","Accurate Count", "Accurate %","Inaccurate Count","Inaccurate %"]]
        letters         = []
        where_query     = []

        if params[:filter_date_start].present? && params[:filter_date_end].present?
            start_date  = params[:filter_date_start].to_date
            end_date    = params[:filter_date_end].to_date.tomorrow
            where_query << "t.certification_date >= '#{ start_date }' and t.certification_date < '#{ end_date }'"
        end

        if where_query.present?
            letters     = ActiveRecord::Base.connection.execute("Select  0 id,to_char(t.certification_date,'DD/MM/YYYY') as date,
                                                                count(1) as total_pending,
                                                                sum(case when is_qa=true then 1 else 0 end) as total_qa,
                                                                sum(case when qa_status='ACCURATE' then 1 else 0 end)as accurate,
                                                                (round(100*sum(case when qa_status='ACCURATE' then 1 else 0 end) / NULLIF(sum(case when is_qa=true then 1 else 0 end),0))) as total_acc,
                                                                sum(case when qa_status='INACCURATE' then 1 else 0 end)as inaccurate,
                                                                (round(100*sum(case when qa_status='INACCURATE' then 1 else 0 end) / NULLIF(sum(case when is_qa=true then 1 else 0 end),0))) as total_inacc
                                                                from transactions t,medical_reviews mr
                                                                where t.id=mr.transaction_id
                                                                and #{ where_query.join(" and ") }
                                                                group by to_char(t.certification_date, 'DD/MM/YYYY')
                                                                order by to_char(t.certification_date,'DD/MM/YYYY') desc")
        end

        letters.each.with_index(1) do |row, index|
            @csv << [index, row.values[1..-1]].flatten
        end

        if check_format_html
            headers_footers ||= 1
            total_size      = @csv.size - headers_footers
            @csv            = @csv.first(500 + headers_footers)
            showing_size    = @csv.size - headers_footers
            @displayed_size = "Showing #{ showing_size } out of #{ total_size } rows"
        end

        @filter_options = [
            { type: "date range", label: "Date Range" },
        ]

        parse_output_format("Report Review QA")
    end

private
    def load_state_list
        @state_list = {
            "JOHOR"             => "JHR",
            "KEDAH"             => "KDH",
            "KELANTAN"          => "KEL",
            "KUALA LUMPUR"      => "KUL",
            "LABUAN"            => "SBH",
            "MELAKA"            => "MLK",
            "NEGERI SEMBILAN"   => "NEG",
            "PAHANG"            => "PHG",
            "PERAK"             => "PRK",
            "PERLIS"            => "PLS",
            "PULAU PINANG"      => "PNG",
            "PUTRAJAYA"         => "PUT",
            "SELANGOR"          => "SEL",
            "TERENGGANU"        => "TRG"
        }
    end
end