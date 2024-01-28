module ReportsAppeal
    def medical_appeal # Automated.
        @csv        = [["STATUS", "WORKER CODE", "APPEAL ID", "WORKER NAME", "EXAM DATE", "CERTIFICATION DATE", "APPEAL DATE", "MODIFICATION DATE", "STATUS2", "DISEASES", "CURRENT STATUS", "OFFICER INCHARGE", "TAT", "14 DAYS"]]

        if params[:filter_date_start].present? && params[:filter_date_end].present?
            start_date          = params[:filter_date_start].to_date
            end_date            = params[:filter_date_end].to_date.tomorrow
            @csv.unshift        ["LIST OF APPEAL CASES FROM #{ start_date.strftime("%-d %B %Y") } UNTIL #{ end_date.yesterday.strftime("%-d %B %Y") }"]
            @extended_headers   = 2

            # Sorting based on CURRENT STATUS, then APPEAL ID (Technically should be date, but id is about the same.)
            appeals             = ActiveRecord::Base.connection.execute("select case when ma.result = 'SUCCESSFUL' then 0 when ma.result = 'CONDITIONAL_SUCESSFUL' then 1 when ma.result = 'UNSUCCESSFUL' then 2 when ma.result = 'CANCEL/CLOSE' then 3 else 4 end sorting_a, ma.id sorting_b,
                t.final_result, t.fw_code, ma.id, t.fw_name, to_char(t.medical_examination_date, 'DD/MM/YYYY') exam_date, to_char(t.certification_date, 'DD/MM/YYYY') certification_date,
                to_char(ma.created_at, 'DD/MM/YYYY') appeal_date, to_char(ma.completed_at, 'DD/MM/YYYY') modification_date, ma.status,
                case when cond.code = '3501' then 'HIV/AIDS'
                when cond.code = '3502' then 'TUBERCULOSIS'
                when cond.code = '3503' then 'MALARIA'
                when cond.code = '3504' then 'LEPROSY'
                when cond.code = '3505' then 'SYPHILIS'
                when cond.code = '3506' then 'HEPATITIS B'
                when cond.code = '3507' then 'CANCER'
                when cond.code = '3508' then 'EPILEPSY'
                when cond.code = '3509' then 'PSYCHIATRIC'
                when cond.code = '3514' then 'HYPERTENSION'
                when cond.code = '3515' then 'HEART DISEASE'
                when cond.code = '3516' then 'BRONCHIAL ASTHMA'
                when cond.code = '3517' then 'DIABETES MELLITUS'
                when cond.code = '3518' then 'PEPTIC ULCER'
                when cond.code = '3519' then 'KIDNEY DISEASE'
                when cond.code = '3510' then 'PREGNANT'
                when cond.code = '3512' then 'URINE OPIATES'
                when cond.code = '3511' then 'URINE CANNABIS'
                when cond.code = '3520' then 'OTHERS' end disease,
                case when ma.result is not null then ma.result else 'PENDING DECISION' end current_status,
                users.name oic
                from medical_appeals ma left join medical_appeal_conditions mac on mac.medical_appeal_id = ma.id
                join transactions t on t.id = ma.transaction_id
                left join conditions cond on cond.id = mac.condition_id
                left join users on users.id = ma.officer_in_charge_id
                where ma.created_at >= '#{ start_date }' and ma.created_at < '#{ end_date }'
                order by sorting_a, sorting_b")
        else
            appeals = []
        end

        appeals.each do |appeal|
            @csv << (appeal.values[2..-1] + [nil, nil])
        end

        @filter_options = [{ type: "date range", label: "Appeal Date" }]
        setting_csv_html_display_limit
        parse_output_format("Medical Appeal")
    end

    def type_of_diseases # Appeal data from start of year to end of previous month. sends at start of every month. Only closed appeal data.
        @filter_options     = [{ type: "month select", label: "Appeal Month" }]
        date                = params[:query_month].to_date if params[:query_month].present?
        parse_output_format("Types of Diseases") and return if date.blank?
        @year               = date.year
        @month              = date.strftime("%B")
        @start_date         = date.beginning_of_year
        @end_date           = date.end_of_month.tomorrow

        # Count by months.
            sorted_hash         = MedicalAppeal.where(created_at: @start_date...@end_of_month).select("concat(to_char(created_at, 'Mon'), ' ', registered_by_type) as type").map(&:type).group_count
            gp_amounts          = clean_out_array_by_month Date::ABBR_MONTHNAMES.compact.map {|month| sorted_hash["#{ month } Doctor"] }, date.month
            fomema_amounts      = clean_out_array_by_month Date::ABBR_MONTHNAMES.compact.map {|month| sorted_hash["#{ month } User"] }, date.month
            total_amounts       = clean_out_array_by_month 12.times.map {|i| (gp_amounts[i] || 0) + (fomema_amounts[i] || 0) }, date.month
            total_gp            = gp_amounts.compact.sum
            total_fomema        = fomema_amounts.compact.sum
            total_total         = total_amounts.compact.sum
            percentage_gp       = ((total_gp.to_f / (total_gp + total_fomema)) * 100).round(1)
            percentage_fomema   = ((total_fomema.to_f / (total_gp + total_fomema)) * 100).round(1)

            by_months = [
                ["Year", "Reg. by", Date::ABBR_MONTHNAMES.compact, "Total", "Percentage"].flatten,
                [@year, "GP", gp_amounts, total_gp, "#{ percentage_gp }%"].flatten,
                ["", "FOMEMA", fomema_amounts, total_fomema, "#{ percentage_fomema }%"].flatten,
                ["", "Total", total_amounts, total_total, "100.0%"].flatten
            ]

        # Total cases of the month.
            month_appeals       = MedicalAppeal.where(created_at: @end_date.last_month...@end_date).pluck(:transaction_id)
            first_appeals       = MedicalAppeal.where(transaction_id: month_appeals).pluck(:transaction_id, :id).sort.reverse.to_h.values # This will only return the first appeal.
            total_count         = month_appeals.size
            registered          = MedicalAppeal.where(id: first_appeals, created_at: @end_date.last_month...@end_date).count
            reappeals           = total_count - registered # Didnt get the right value?

            cases_type = [
                ["Case Registered", registered],
                ["Case Re-appeal", reappeals],
                ["Total Case (#{ @month } #{ @year })", total_count]
            ]

        # Breakdown types of cases.
            appeals                 = MedicalAppeal.select("concat(medical_appeal_conditions.condition_id, '_', medical_appeals.result) disease_key, count(*)").joins(:medical_appeal_conditions).where(status: "CLOSED", result: ["SUCCESSFUL", "UNSUCCESSFUL"], created_at: @end_date.last_month...@end_date).group(:disease_key)
            @total_types            = appeals.map {|appeal| [appeal.disease_key, appeal.count] }.to_h
            @total_types.default    = 0
            communicables           = map_conditions_to_rows(communicable_diseases_conditions)
            non_communicables       = map_conditions_to_rows(non_communicable_diseases_conditions)
            not_diseases            = map_conditions_to_rows(not_diseases_conditions)

            appeal_results = [
                ["APPEAL RESULTS (#{ @month } #{ @year })", Array.new(6, "")].flatten,
                ["UNSUITABLILITY", "SUCCESSFUL", "", "UNSUCCESSFUL", "", "TOTAL", ""],
                ["", "NO.", "%", "NO.", "%", "NO.", "%"]
            ]

            communicables_total     = ["Communicable Diseases", communicables.map(&:second).sum, "", communicables.map(&:fourth).sum, "", communicables.map(&:sixth).sum]
            non_communicables_total = ["Non Communicable Diseases", non_communicables.map(&:second).sum, "", non_communicables.map(&:fourth).sum, "", non_communicables.map(&:sixth).sum]
            not_diseases_total      = ["Conditions Not Diseases", not_diseases.map(&:second).sum, "", not_diseases.map(&:fourth).sum, "", not_diseases.map(&:sixth).sum]
            rows_of_total           = [communicables_total, non_communicables_total, not_diseases_total]
            grand_total             = ["TOTAL", rows_of_total.map(&:second).sum, "", rows_of_total.map(&:fourth).sum, "", rows_of_total.map(&:sixth).sum, "100%"]
            @grand_total_amount     = grand_total[5]
            [communicables, non_communicables, not_diseases, [communicables_total, non_communicables_total, not_diseases_total, grand_total]].each {|array| percentage_calculations(array)}

            appeal_results += communicables
            appeal_results << communicables_total
            appeal_results << Array.new(7, "")
            appeal_results += non_communicables
            appeal_results << non_communicables_total
            appeal_results << Array.new(7, "")
            appeal_results += not_diseases
            appeal_results << not_diseases_total
            appeal_results << Array.new(7, "")
            appeal_results << grand_total

        # Total types of cases.
            final_percentages =
                if @grand_total_amount > 0
                    [
                        "#{ "%g" % (communicables_total[5].to_f / @grand_total_amount * 100) }%",
                        "#{ "%g" % (non_communicables_total[5].to_f / @grand_total_amount * 100) }%",
                        "#{ "%g" % (not_diseases_total[5].to_f / @grand_total_amount * 100) }%"
                    ]
                else
                    ["0%"] *3
                end

            totals = [
                ["Type of Disease", "Successful", "Unsuccessful", "Percentage"],
                ["Communicable Diseases", communicables_total[1], communicables_total[3], final_percentages[0]],
                ["Non-communicable Diseases", non_communicables_total[1], non_communicables_total[3], final_percentages[1]],
                ["Condition Not Diseases", not_diseases_total[1], not_diseases_total[3], final_percentages[2]],
                ["Total", grand_total[1], grand_total[3], "100%"]
            ]

        @excel  = []

        @excel << by_months.map.with_index(0) do |row, index|
            { data: row, style: styling(border) * row.size }
        end

        @excel << cases_type

        @excel << appeal_results.map.with_index(0) do |row, index|
            { data: row, style: styling(border) * row.size }
        end

        @excel << totals.map.with_index(0) do |row, index|
            { data: row, style: styling(border) * row.size }
        end

        @worksheet_names    = ["Monthly Registrations", "Registered & Reappeal Cases", "Appeal Results", "Types of Diseases"]
        @merge_fields       = []
        @merge_fields       << ["A2:A4"]
        @merge_fields       << []
        @merge_fields       << ["A1:G1", "A2:A3", "B2:C2", "D2:E2", "F2:G2", "B4:C4", "D4:E4", "F4:G4", "A11:G11", "A23:G23", "A28:G28"]
        @merge_fields       << []
        parse_output_format("Types of Diseases")
    end

    # Query is daily, it wont affect speed too much.
    def cronjob_appeal # Send directly to Appeal team. Cases closed or cancelled. Based on approval date. Daily update.
        appeals = []

        if params[:query_date].present?
            date            = params[:query_date].to_date

            trans_ids       = MedicalAppeal.where(status: "CLOSED", completed_at: date.beginning_of_day...date.tomorrow)
                                .where.not(result: "CANCEL/CLOSE")
                                .pluck(:transaction_id)

            first_appeals   = MedicalAppeal.where(transaction_id: trans_ids).pluck(:transaction_id, :id).sort.reverse.to_h.values # This will only return the first appeal.

            appeals         = MedicalAppeal.where(id: first_appeals, status: "CLOSED", completed_at: date.beginning_of_day...date.tomorrow)
                                .where.not(result: "CANCEL/CLOSE")
                                .includes(transactionz: [employer: [:state, :town]]).order(:id)
        end

        @filter_options     = [{ type: "date", label: "Approval Date" }]
        csv_row_for_appeal_and_reappeal(appeals)
        parse_output_format("Appeal-#{ date&.strftime("%Y-%m-%d") }")
    end

    # Query is daily, it wont affect speed too much.
    def cronjob_reappeal
        appeals = []

        if params[:query_date].present?
            date            = params[:query_date].to_date

            trans_ids       = MedicalAppeal.where(status: "CLOSED", completed_at: date.beginning_of_day...date.tomorrow)
                                .where.not(result: "CANCEL/CLOSE")
                                .pluck(:transaction_id)

            first_appeals   = MedicalAppeal.where(transaction_id: trans_ids).pluck(:transaction_id, :id).sort.reverse.to_h.values # This will only return the first appeal.

            appeals         = MedicalAppeal.where(status: "CLOSED", completed_at: date.beginning_of_day...date.tomorrow)
                                .where.not(result: "CANCEL/CLOSE", id: first_appeals)
                                .includes(transactionz: [employer: [:state, :town]]).order(:id)
        end

        @filter_options     = [{ type: "date", label: "Approval Date" }]
        csv_row_for_appeal_and_reappeal(appeals)
        parse_output_format("Reappeal-#{ date&.strftime("%Y-%m-%d") }")
    end

    # Query is daily, it wont affect speed too much.
    def cronjob_reject_appeal
        @csv    = [["appealid", "fit_ind", "iscancelled", "appeal_status", "appeal_result", "trans_id", "bc_worker_code", "worker_name", "passport_no", "modification_date", "employer_name", "address1", "address2", "address3", "address4", "post_code", "district_name", "state_name", "doctor_name", "clinic_name", "doc_address1", "doc_address2", "doc_address3", "doc_address4", "doc_post_code", "doc_district_name", "doc_state_name"]]

        if params[:query_date].present?
            date        = params[:query_date].to_date
            appeals     = MedicalAppeal.where(result: "CANCEL/CLOSE", completed_at: date.beginning_of_day...date.tomorrow).includes(transactionz: [doctor: [:state, :town], employer: [:state, :town]]).order(:id)
        else
            appeals     = []
        end

        appeals.each do |appeal|
            transaction     = appeal.transactionz
            employer        = transaction&.employer
            doctor          = transaction&.doctor

            @csv << [
                appeal.id,
                transaction&.final_result,
                appeal.result == "CANCEL/CLOSE" ? "YES" : "NO",
                "CLOSED",
                "UNSUCCESSFUL",
                transaction&.code,
                transaction.fw_code,
                transaction.fw_name,
                transaction.fw_passport_number,
                appeal.completed_at? ? appeal.completed_at.strftime("%d/%m/%Y") : nil,
                employer.name,
                employer.address1,
                employer.address2,
                employer.address3,
                employer.address4,
                employer.postcode,
                employer.town&.name,
                employer.state&.name,
                doctor&.name,
                doctor&.clinic_name,
                doctor&.address1,
                doctor&.address2,
                doctor&.address3,
                doctor&.address4,
                doctor&.postcode,
                doctor&.town&.name,
                doctor&.state&.name
            ]
        end

        @filter_options = [{ type: "date", label: "Modification Date" }]
        setting_csv_html_display_limit
        parse_output_format("Reject Appeal-#{ date&.strftime("%Y-%m-%d") }")
    end

    def appeal_weekly_report # Please note, users have moved this to appeals index page. Just keep this here in case. 2021-01-08.
        worksheet       = [["#", "Appeal ID", "Worker Code", "Worker Name", "Doctor Code", "Exam Date", "Certification Date", "Amendment Date", "Appeal Date", "Appeal Status", "Officer in Charge", "Duration"]]
        where_builder   = []
        where_builder   << "ma.id = #{ params[:appeal_id].to_i }" if params[:appeal_id].present?
        where_builder   << "ma.created_at >= '#{ params[:appeal_date_start].to_date }'" if params[:appeal_date_start].present?
        where_builder   << "ma.created_at <= '#{ params[:appeal_date_end].to_date }'" if params[:appeal_date_end].present?

        if params[:doctor_code].present?
            doc_code        = ActiveRecord::Base.connection.quote("%#{ params[:doctor_code] }%")
            where_builder   << "(doctors.name ilike #{ doc_code } or doctors.code ilike #{ doc_code })"
        end

        if params[:worker_code].present?
            worker_code     = ActiveRecord::Base.connection.quote("%#{ params[:worker_code] }%")
            where_builder   << "(t.fw_name ilike #{ worker_code } or t.fw_code ilike #{ worker_code })"
        end

        if params[:mle1_code].present?
            mle1_code       = ActiveRecord::Base.connection.quote("%#{ params[:mle1_code] }%")
            where_builder   << "users.userable_type = 'Organization' and (users.name ilike #{ mle1_code } or users.code ilike #{ mle1_code })"
        end

        if params[:status].present?
            if params[:status] == "EXAMINATIONS_ONLY"
                where_builder   << "ma.status not in ('PENDING_APPROVAL', 'CLOSED')"
            else
                query_status    = ActiveRecord::Base.connection.quote(params[:status])
                where_builder   << "ma.status = #{ query_status }"
            end
        elsif params[:appeal_id].blank? && params[:worker_code].blank?
            where_builder       << "ma.status != 'CLOSED'"
        end

        where_query     = " where #{ where_builder.join(" and ") }" if where_builder.present?

        appeals         = ActiveRecord::Base.connection.execute("select ma.id, t.fw_code, t.fw_name, doctors.code, t.medical_examination_date, t.certification_date,
            case when t.medical_quarantine_release_date is not null and t.xray_quarantine_release_date is not null then greatest(t.medical_quarantine_release_date, t.xray_quarantine_release_date)
            when t.medical_quarantine_release_date is not null or t.xray_quarantine_release_date is not null then coalesce(t.medical_quarantine_release_date, t.xray_quarantine_release_date) end amendment_date,
            ma.created_at, ma.status, users.name,
            case when ma.status = 'CLOSED' then cast((ma.completed_at::date - ma.created_at::date) as integer) else cast((NOW()::date - ma.created_at::date) as integer) end duration
            from medical_appeals ma join transactions t on t.id = ma.transaction_id
            left join doctors on doctors.id = ma.doctor_id left join users on users.id = ma.officer_in_charge_id
            #{ where_query } order by ma.id")

        appeals.each.with_index(1) do |hash, index|
            worksheet << {
                data: [
                    index,
                    hash["id"],
                    hash["fw_code"],
                    hash["fw_name"],
                    hash["code"],
                    format_date(hash["medical_examination_date"]),
                    format_date(hash["certification_date"]),
                    format_date(hash["amendment_date"]),
                    format_date(hash["created_at"]),
                    MedicalAppeal::STATUSES[hash["status"]],
                    hash["name"],
                    hash["duration"]
                ],
                style: [{}] * 5 + styling(excel_date) * 4 + [{}] * 3,
                types: ([:string] * 8).insert(5, *[:date] * 4)
            }
        end

        @filter_options     = [
            { type: "text field",   label: "Appeal ID", field_name: :appeal_id, placeholder: "ID" },
            { type: "text field",   label: "Worker Name/Code", field_name: :worker_code, placeholder: "Worker" },
            { type: "text field",   label: "Doctor Name/Code", field_name: :doctor_code, placeholder: "Doctor" },
            { type: "select list",  label: "Status", list: {"Pending Appeals (Not including Approval or Closed Appeals)" => "EXAMINATIONS_ONLY"}.merge(MedicalAppeal::STATUSES.invert), field_name: :status, placeholder: "Select option" },
            { type: "date range",   label: "Appeal Date", field_name: :appeal_date },
            { type: "text field",   label: "Officer Name/Code", field_name: :mle1_code, placeholder: "Officer" }
        ]

        @excel              = [worksheet]
        setting_html_display_limit(worksheet)
        parse_output_format("Appeal Weekly Report")
    end
private
    def csv_row_for_appeal_and_reappeal(appeals)
        @csv            = [["appealid", "fit_ind", "iscancelled", "appeal_status", "appeal_result", "approval_result", "approval_status", "trans_id", "bc_worker_code", "worker_name", "passport_no", "approval_date", "employer_name", "address1", "address2", "address3", "address4", "post_code", "district_name", "state_name", "appeal_type"]]

        appeals.each do |appeal|
            transaction     = appeal.transactionz
            employer        = transaction&.employer

            appeal_type =
                case [transaction.final_result, appeal.result]
                when ["SUITABLE", "SUCCESSFUL"]
                    "SA"
                when ["UNSUITABLE", "UNSUCCESSFUL"]
                    "UA"
                when ["UNSUITABLE", "SUCCESSFUL"]
                    "FTU-S"
                when ["SUITABLE", "UNSUCCESSFUL"]
                    "FTU-US"
                end

            @csv << [
                appeal.id,
                transaction.final_result,
                appeal.result == "CANCEL/CLOSE" ? "YES" : "NO",
                appeal.status,
                appeal.result,
                appeal.result,
                "APPROVED",
                transaction.code,
                transaction.fw_code,
                transaction.fw_name,
                transaction.fw_passport_number,
                appeal.completed_at? ? appeal.completed_at.strftime("%d/%m/%Y") : nil,
                employer&.name,
                employer&.address1,
                employer&.address2,
                employer&.address3,
                employer&.address4,
                employer&.postcode,
                employer&.town&.name,
                employer&.state&.name,
                appeal_type
            ]
        end

        setting_csv_html_display_limit
    end

    # Must be it's own method, otherwise rails will query this over and over when used in loops.
    def diseases_condition_ids
        Condition.where(code: Condition.medical_certification_conditions.except("5501", "5502").keys).pluck(:code, :id).to_h
    end

    def communicable_diseases_conditions
        code_to_id_hash = diseases_condition_ids

        {
            "3502" => "TB",
            "3506" => "HEPATITIS",
            "3505" => "SEXUALLY TRANSMITTED DISEASE",
            "3501" => "HIV",
            "3503" => "MALARIA",
            "3504" => "LEPROSY",
        }.transform_keys {|key| code_to_id_hash[key] }
    end

    def non_communicable_diseases_conditions
        code_to_id_hash = diseases_condition_ids

        {
            "3509" => "PSYCHIATRIC ILLNESS",
            "3508" => "EPILEPSY",
            "3507" => "CANCER",
            "3516" => "BRONCHIAL ASTHMA",
            "3517" => "DIABETES MELLITUS",
            "3515" => "HEART DISEASE",
            "3514" => "HYPERTENSION",
            "3519" => "KIDNEY DISEASE",
            "3518" => "PEPTIC ULCER",
            "3520" => "OTHERS"
        }.transform_keys {|key| code_to_id_hash[key] }
    end

    def not_diseases_conditions
        code_to_id_hash = diseases_condition_ids

        {
            "3510" => "PREGNANT",
            "3511" => "URINE CANNABIS",
            "3512" => "URINE OPIATES"
        }.transform_keys {|key| code_to_id_hash[key] }
    end

    def map_conditions_to_rows(hash)
        hash.map do |key, title|
            row = [title, @total_types["#{ key }_SUCCESSFUL"], "", @total_types["#{ key }_UNSUCCESSFUL"], ""]
            row << row[1] + row[3]
            row
        end
    end

    def percentage_calculations(array)
        array.each do |row|
            if row[5] > 0
                row[2] = "#{ "%g" % (row[1].to_f / row[5] * 100) }%"
                row[4] = "#{ "%g" % (row[3].to_f / row[5] * 100) }%"
            else
                row[2] = "0%"
                row[4] = "0%"
            end

            if @grand_total_amount > 0
                row[6] = "#{ "%g" % (row[5].to_f / @grand_total_amount * 100) }%"
            else
                row[6] = "0%"
            end
        end
    end

    def clean_out_array_by_month(array, limit)
        array.map.with_index(0) do |val, index|
            if index < limit
                val ? val : 0
            else
                nil
            end
        end
    end
end