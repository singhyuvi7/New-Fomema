module ReportsMedicalMonthlyStat
    def med_monthly_stat_appeal # Automated, sent to IT team at the start of every month. Includes data from start of year to the end of last month.
        worksheet   = [["OFFICER_INCHARGE", "TRANS_ID", "BC_WORKER_CODE", "APPEALID", "WORKER_NAME", "COUNTRY_NAME", "EXAM_DATE", "CERTIFY_DATE", "APPEAL_DATE", "MODIFICATION_DATE", "STATE_NAME", "REASON", "CANCEL", "STATUS", "CURRENT_STATUS", "REGISTERED_BY", "IS_MOH"]]
        appeals     = []

        if params[:filter_date_start].present? && params[:filter_date_end].present?
            start_date  = params[:filter_date_start].to_date
            end_date    = params[:filter_date_end].to_date.tomorrow

            appeals     = ActiveRecord::Base.connection.execute("select officer.name, t.code, t.fw_code, ma.id, t.fw_name, countries.name country_name, t.medical_examination_date,
                t.certification_date, ma.created_at, ma.completed_at, states.name state_name,
                case when conditions.code = '3501' then 'HIV/AIDS'
                when conditions.code = '3502' then 'TUBERCULOSIS'
                when conditions.code = '3503' then 'MALARIA'
                when conditions.code = '3504' then 'LEPROSY'
                when conditions.code = '3505' then 'SYPHILIS'
                when conditions.code = '3506' then 'HEPATITIS B'
                when conditions.code = '3507' then 'CANCER'
                when conditions.code = '3508' then 'EPILEPSY'
                when conditions.code = '3509' then 'PSYCHIATRIC'
                when conditions.code = '3514' then 'HYPERTENSION'
                when conditions.code = '3515' then 'HEART DISEASE'
                when conditions.code = '3516' then 'BRONCHIAL ASTHMA'
                when conditions.code = '3517' then 'DIABETES MELLITUS'
                when conditions.code = '3518' then 'PEPTIC ULCER'
                when conditions.code = '3519' then 'KIDNEY DISEASE'
                when conditions.code = '3510' then 'PREGNANT'
                when conditions.code = '3511' then 'URINE CANNABIS'
                when conditions.code = '3512' then 'URINE OPIATES'
                when conditions.code = '3520' then 'OTHERS' end reason,
                case when ma.result = 'CANCEL/CLOSE' then 'YES' else 'NO' end cancelled, ma.status,
                case when ma.result is not null then ma.result else 'PENDING' end result,
                case when ma.registered_by_type = 'User' then 'FOMEMA'
                else ma.registered_by_type end registered_by_type,
                case when ma.is_moh then 'YES' else 'NO' end is_moh
                from medical_appeals ma left join users officer on officer.id = ma.officer_in_charge_id
                join transactions t on t.id = ma.transaction_id
                left join countries on countries.id = t.fw_country_id
                left join doctors on doctors.id = t.doctor_id
                left join states on doctors.state_id = states.id
                left join medical_appeal_conditions mac on mac.medical_appeal_id = ma.id
                left join conditions on conditions.id = mac.condition_id
                where ma.created_at >= '#{ start_date }' and ma.created_at < '#{ end_date }'
                order by ma.id, reason")
        end

        appeals.each do |hash|
            worksheet << {
                data: [
                    hash["name"],
                    hash["code"],
                    hash["fw_code"],
                    hash["id"],
                    hash["fw_name"],
                    hash["country_name"],
                    format_date(hash["medical_examination_date"]),
                    format_date(hash["certification_date"]),
                    format_date(hash["created_at"]),
                    format_date(hash["completed_at"]),
                    hash["state_name"],
                    hash["reason"],
                    hash["cancelled"],
                    hash["status"],
                    hash["result"],
                    hash["registered_by_type"],
                    hash["is_moh"],
                ],
                style: [{}] * 6 + styling(excel_date) * 4 + [{}] * 6,
                types: ([:string] * 12).insert(6, *[:date] * 4)
            }
        end

        @filter_options = [{ type: "date range", label: "Appeal Date" }]
        setting_html_display_limit(worksheet)
        parse_output_format("med_monthly_stat_appeal")
    end

    def med_monthly_stat_pr # Should be for PR that have been released.
        worksheet   = [["DOCTOR_CODE", "DOCTOR_NAME", "CLINIC_NAME", "WORKER_CODE", "WORKER_NAME", "PASSPORT_NO", "COUNTRY_NAME", "DOCTOR_STATE_CODE", "CERTIFICATION_DATE", "DOC_STATUS", "INSP_STATUS", "CURRENT_STATUS", "QRTN_FWDOC_STATUS", "QRTN_SOURCE", "DATE_CAPTURED","DATE_RELEASED"]]
        reviews     = []

        if params[:filter_date_start].present? && params[:filter_date_end].present?
            start_date  = params[:filter_date_start].to_date
            end_date    = params[:filter_date_end].to_date.tomorrow

            reviews     = ActiveRecord::Base.connection.execute("select doctors.code, doctors.name, doctors.clinic_name, t.fw_code, t.fw_name,
                t.fw_passport_number, countries.name country_name, states.name state_name, t.certification_date,
                me.suitability, mr.medical_mle1_decision, t.final_result, medical_mle2_decision, t.medical_pr_source, t.medical_pr_source, mr.created_at ,mr.medical_mle1_decision_at
                from medical_reviews mr join transactions t on mr.transaction_id = t.id left join countries on t.fw_country_id = countries.id
                left join medical_examinations me on me.transaction_id = t.id left join doctors on doctors.id = t.doctor_id
                left join states on doctors.state_id = states.id
                where t.certification_date >= '#{ start_date }' and t.certification_date < '#{ end_date }'
                and medical_mle1_decision is not null
                order by t.id asc")
        end

        reviews.each do |hash|
            worksheet << {
                data: [
                    hash["code"],
                    hash["name"],
                    hash["clinic_name"],
                    hash["fw_code"],
                    hash["fw_name"],
                    hash["fw_passport_number"],
                    hash["country_name"],
                    hash["state_name"],
                    format_date(hash["certification_date"]),
                    hash["suitability"],
                    hash["medical_mle1_decision"],
                    hash["final_result"],
                    hash["medical_mle2_decision"],
                    "From #{ hash["medical_pr_source"] }",
                    format_date(hash["created_at"]),
                    format_date(hash["medical_mle1_decision_at"])
                ],
                style: [{}] * 8 + styling(excel_date) + [{}] * 5,
                types: ([:string] * 13).insert(8, :date)
            }
        end

        @filter_options = [{ type: "date range", label: "Certification Date" }]
        setting_html_display_limit(worksheet)
        parse_output_format("med_monthly_stat_pr")
    end

    def med_monthly_stat_tcupi # Should only be for TCUPI that have been released.
        worksheet           = [["TRANS_ID", "FW_CODE", "CERTIFY_DATE", "TCUPI_DATE", "CLOSE_DATE", "TYPES", "MLE", "CERT_TCUPI", "CERT_CL", "TCUPI_CL", "TAT"]]
        monitoring_codes    = ["10000", "10001", "10002", "10003", "10006", "10007", "10009"]
        tcupis              = []

        if params[:filter_date_start].present? && params[:filter_date_end].present?
            start_date              = params[:filter_date_start].to_date
            end_date                = params[:filter_date_end].to_date.tomorrow

            latest_tcupis           = ActiveRecord::Base.connection.execute("select t.id, max(tr.id) tcupi_id
                from tcupi_reviews tr join transactions t on tr.transaction_id = t.id
                where t.certification_date >= '#{ start_date }' and t.certification_date < '#{ end_date }'
                and medical_mle2_decision_at is not null group by t.id")

            tcupi_ids               = latest_tcupis.map {|hash| hash["tcupi_id"] }.join(", ")

            tcupis                  = if tcupi_ids.present?
                ActiveRecord::Base.connection.execute("select tr.id tcupi_id, t.id, t.code, t.fw_code,
                    t.certification_date, tr.medical_mle2_decision_at, t.tcupi_date, users.name
                    from tcupi_reviews tr join transactions t on tr.transaction_id = t.id left join users on users.id = tr.medical_mle1_id
                    where tr.id in (#{ tcupi_ids }) order by tcupi_date")
            else
                []
            end

            transaction_ids         = tcupis.map {|hash| hash["id"] }.join(", ")



            t_quarantine_reasons    = if transaction_ids.present?
                ActiveRecord::Base.connection.execute("select tqr.transaction_id, array_agg(qr.code)
                    from transaction_quarantine_reasons tqr join quarantine_reasons qr on tqr.quarantine_reason_id = qr.id
                    where tqr.transaction_id in (#{ transaction_ids }) group by tqr.transaction_id")
            else
                []
            end

            tqr_hash_map            = t_quarantine_reasons.map {|hash| [hash["transaction_id"], hash["array_agg"].delete("{}").split(",")] }.to_h
        end

        tcupis.each do |hash|
            types       = (monitoring_codes & tqr_hash_map[hash["id"]]).present? ? "MONITORING" : "QUARANTINE"
            cert_tcupi  = (hash["tcupi_date"] - hash["certification_date"]).to_i / 86400 if hash["tcupi_date"] && hash["certification_date"]
            cert_cl     = (hash["medical_mle2_decision_at"] - hash["certification_date"]).to_i / 86400 if hash["medical_mle2_decision_at"] && hash["certification_date"]
            tcupi_cl    = (hash["medical_mle2_decision_at"] - hash["tcupi_date"]).to_i / 86400 if hash["medical_mle2_decision_at"] && hash["tcupi_date"]
            tat         = tcupi_cl.present? ? tcupi_cl >= 31 ? "YES" : "NO" : nil

            worksheet << {
                data: [
                    hash["code"],
                    hash["fw_code"],
                    format_date(hash["certification_date"]),
                    format_date(hash["tcupi_date"]),
                    format_date(hash["medical_mle2_decision_at"]),
                    types,
                    hash["name"],
                    cert_tcupi,
                    cert_cl,
                    tcupi_cl,
                    tat
                ],
                style: [{}] * 2 + styling(excel_date) * 3 + [{}] * 6,
                types: ([:string] * 8).insert(2, *[:date] * 3)
            }
        end

        @filter_options = [{ type: "date range", label: "Certification Date" }]
        setting_html_display_limit(worksheet)
        parse_output_format("med_monthly_stat_tcupi")
    end

    def med_monthly_stat_reuse_passport
        worksheet       = [["WORKER_CODE", "PASSPORT", "COUNTRY", "WORKER_NAME", "REGISTRATION_DATE", "CERTIFY_DATE", "CURRENT_FIT_STATUS", "BRANCH", "DEC", "SEX", "ARRIVAL_DATE"]]
        transactions    = []

        if params[:filter_date_start].present? && params[:filter_date_end].present?
            start_date      = params[:filter_date_start].to_date
            end_date        = params[:filter_date_end].to_date.tomorrow

            transactions    = ActiveRecord::Base.connection.execute("select t.fw_code, t.fw_passport_number,
                countries.name country_name, t.fw_name, t.transaction_date, t.certification_date, t.final_result,
                case when organizations.id is not null then organizations.code when users.userable_type = 'Employer' then 'PT' end branch,
                case when organizations.id is not null then users.name when users.userable_type = 'Employer' then 'ADMIN' end as dec,
                case when t.fw_gender = 'M' then 'MALE' when t.fw_gender = 'F' then 'FEMALE' end gender, fw.arrival_date
                from transactions t join transaction_quarantine_reasons tqr on tqr.transaction_id = t.id
                join quarantine_reasons qr on qr.id = tqr.quarantine_reason_id
                left join foreign_workers fw on fw.id = t.foreign_worker_id
                left join countries on countries.id = t.fw_country_id
                left join users on users.id = t.created_by
                left join organizations on users.userable_type = 'Organization' and organizations.id = users.userable_id
                where t.certification_date >= '#{ start_date }' and t.certification_date < '#{ end_date }'
                and qr.code = '10006' and t.final_result is not null
                order by t.transaction_date, branch, dec")
        end

        transactions.each do |transaction|
            worksheet << {
                data: [
                    transaction["fw_code"],
                    transaction["fw_passport_number"],
                    transaction["country_name"],
                    transaction["fw_name"],
                    format_date(transaction["transaction_date"]),
                    format_date(transaction["certification_date"]),
                    transaction["final_result"],
                    transaction["branch"],
                    transaction["dec"],
                    transaction["gender"],
                    format_date(transaction["arrival_date"]),
                ],
                style: [{}] * 4 + styling(excel_date) * 2 + [{}] * 4 + styling(excel_date),
                types: ([:string] * 8).insert(4, *[:date] * 2).insert(10, :date)
            }
        end

        @filter_options = [{ type: "date range", label: "Certification Date" }]
        setting_html_display_limit(worksheet)
        parse_output_format("med_monthly_stat_reuse_passport")
    end

    def med_monthly_stat_unfit_reason
        worksheet   = [["TRANS_ID", "BC_WORKER_CODE", "UNFIT_REASON"]]
        rows        = []

        if params[:filter_date_start].present? && params[:filter_date_end].present?
            start_date  = params[:filter_date_start].to_date
            end_date    = params[:filter_date_end].to_date.tomorrow

            # Notes about this query:
            # 1. Have to separate into 2 queries, then union (please note that union is like union all, except that it removes duplicate rows).
            # 2. Need to separate the queries because to get the conditions, you have to look for it at medical_examination_details first. If there are none, then only look at doctor_examination_details.
            # 3. If you look at the second query, you can see that "me.id is null" is in the where clause.

            rows        = ActiveRecord::Base.connection.execute("(select t.code, t.fw_code,
                case when conditions.code = '3501' then 'HIV/AIDS'
                when conditions.code = '3502' then 'TUBERCULOSIS'
                when conditions.code = '3503' then 'MALARIA'
                when conditions.code = '3504' then 'LEPROSY'
                when conditions.code = '3505' then 'SYPHILIS'
                when conditions.code = '3506' then 'HEPATITIS B'
                when conditions.code = '3507' then 'CANCER'
                when conditions.code = '3508' then 'EPILEPSY'
                when conditions.code = '3509' then 'PSYCHIATRIC'
                when conditions.code = '3514' then 'HYPERTENSION'
                when conditions.code = '3515' then 'HEART DISEASE'
                when conditions.code = '3516' then 'BRONCHIAL ASTHMA'
                when conditions.code = '3517' then 'DIABETES MELLITUS'
                when conditions.code = '3518' then 'PEPTIC ULCER'
                when conditions.code = '3519' then 'KIDNEY DISEASE'
                when conditions.code = '3510' then 'PREGNANT'
                when conditions.code = '3511' then 'URINE CANNABIS'
                when conditions.code = '3512' then 'URINE OPIATES'
                when conditions.code = '3520' then 'OTHERS' end reason
                from transactions t left join medical_examination_details med on med.transaction_id = t.id
                left join conditions on conditions.id = med.condition_id
                where t.certification_date >= '#{ start_date }' and t.certification_date < '#{ end_date }' and medical_status = 'CERTIFIED'
                and conditions.code in ('3501', '3502', '3503', '3504', '3505', '3506', '3507', '3508', '3509', '3510', '3511', '3512', '3514', '3515', '3516', '3517', '3518', '3519', '3520')
                union
                select t.code, t.fw_code,
                case when conditions.code = '3501' then 'HIV/AIDS'
                when conditions.code = '3502' then 'TUBERCULOSIS'
                when conditions.code = '3503' then 'MALARIA'
                when conditions.code = '3504' then 'LEPROSY'
                when conditions.code = '3505' then 'SYPHILIS'
                when conditions.code = '3506' then 'HEPATITIS B'
                when conditions.code = '3507' then 'CANCER'
                when conditions.code = '3508' then 'EPILEPSY'
                when conditions.code = '3509' then 'PSYCHIATRIC'
                when conditions.code = '3514' then 'HYPERTENSION'
                when conditions.code = '3515' then 'HEART DISEASE'
                when conditions.code = '3516' then 'BRONCHIAL ASTHMA'
                when conditions.code = '3517' then 'DIABETES MELLITUS'
                when conditions.code = '3518' then 'PEPTIC ULCER'
                when conditions.code = '3519' then 'KIDNEY DISEASE'
                when conditions.code = '3510' then 'PREGNANT'
                when conditions.code = '3511' then 'URINE CANNABIS'
                when conditions.code = '3512' then 'URINE OPIATES'
                when conditions.code = '3520' then 'OTHERS' end reason
                from transactions t left join doctor_examination_details ded on ded.transaction_id = t.id
                left join conditions on conditions.id = ded.condition_id
                left join medical_examinations me on me.transaction_id = t.id
                where t.certification_date >= '#{ start_date }' and t.certification_date < '#{ end_date }' and medical_status = 'CERTIFIED' and me.id is null
                and conditions.code in ('3501', '3502', '3503', '3504', '3505', '3506', '3507', '3508', '3509', '3510', '3511', '3512', '3514', '3515', '3516', '3517', '3518', '3519', '3520')
                ) order by code, reason")
        end

        rows.each do |hash|
            worksheet << [hash["code"], hash["fw_code"], hash["reason"]]
        end

        @filter_options = [{ type: "date range", label: "Certification Date" }]
        setting_html_display_limit(worksheet)
        parse_output_format("med_monthly_stat_unfit_reason")
    end
end