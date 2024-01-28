module ReportsXqccMisc
    def xqcc_result_release_pending_decision
        worksheet   = [data: ["XQCC Pending Result Release (Pending Decision)"], style: styling(bold) * 11]

        if params[:filter_date_start].present? && params[:filter_date_end].present?
            start_date          = params[:filter_date_start].to_date
            end_date            = params[:filter_date_end].to_date.tomorrow
            timestamp           = "_#{ params[:filter_date_start] }_to_#{ params[:filter_date_end] }"
            @extended_headers   = 2

            worksheet << {
                data: ["No.", "Transaction ID", "Worker Code", "Worker Name", "Registration Date", "Certify Date", "Doctor Certification", "Submitted By", "Submitted Date", "Pending Decision Review Date", "Duration"],
                style: styling(bold, border) * 11
            }

            rows        = ActiveRecord::Base.connection.execute("select t.code, t.fw_code, t.fw_name, t.transaction_date,
                t.certification_date, de.suitability, users.code user_code, xpd.created_at, xpd.reviewed_at,
                NOW()::date - xpd.created_at::date duration
                from xray_pending_decisions xpd left join users on users.id = xpd.created_by
                join transactions t on t.id = xpd.transaction_id
                left join doctor_examinations de on de.transaction_id = xpd.transaction_id
                where xpd.transmitted_at is null and xpd.created_at >= '#{ start_date }' and xpd.created_at < '#{ end_date }'
                order by xpd.created_at")
        else
            rows        = []
        end

        rows.each.with_index(1) do |row, index|
            worksheet   << {
                data: [
                    index,
                    row.values[0..2],
                    format_date(row["transaction_date"]),
                    format_date(row["certification_date"]),
                    row.values[5..6],
                    format_date(row["created_at"]),
                    format_date(row["reviewed_at"]),
                    row.values[9]
                ].flatten,
                style: styling(border(:l, :b)) + styling(border(:b)) * 3 + styling(border(:b), excel_date) * 2 + styling(border(:b)) * 2 + styling(border(:b), excel_date) * 2 + styling(border(:r, :b)),
                types: [:integer, :string, :string, :string, :date, :date, :string, :string, :date, :date, :integer]
            }
        end

        @column_widths  = []
        @column_widths  << [10] + [18] * 2 + [40] + [20] * 5 + [28] + [10]
        @merge_fields   = []
        @merge_fields   << ["A1:K1"]
        @filter_options = [{ type: "date range", label: "Date Range" }]
        setting_html_display_limit(worksheet)
        parse_output_format("xqcc_result_release_pending_decision#{ timestamp }")
    end

    def xqcc_result_release_amend_cases
        worksheet   = [data: ["XQCC Pending Result Release (Amend Cases)"], style: styling(bold) * 11]

        if params[:filter_date_start].present? && params[:filter_date_end].present?
            start_date          = params[:filter_date_start].to_date
            end_date            = params[:filter_date_end].to_date.tomorrow
            timestamp           = "_#{ params[:filter_date_start] }_to_#{ params[:filter_date_end] }"
            @extended_headers   = 2

            worksheet << {
                data: ["No.", "Transaction ID", "Worker Code", "Worker Name", "Registration Date", "Certify Date", "Doctor Certification", "Amended By", "Submitted Date", "Duration"],
                style: styling(bold, border) * 10
            }

            rows        = ActiveRecord::Base.connection.execute("select t.code, t.fw_code, t.fw_name, t.transaction_date,
                t.certification_date, de.suitability, users.code user_code, ta.created_at, NOW()::date - ta.created_at::date duration
                from transaction_amendments ta join users on users.id = ta.created_by
                join roles on roles.id = users.role_id
                join transactions t on t.id = ta.transaction_id
                left join doctor_examinations de on de.transaction_id = ta.transaction_id
                where ta.approval_at is null and ta.cancelled_at is null and roles.code ilike '%XQCC%'
                and ta.created_at >= '#{ start_date }' and ta.created_at < '#{ end_date }'
                order by ta.created_at")
        else
            rows        = []
        end

        rows.each.with_index(1) do |row, index|
            worksheet   << {
                data: [
                    index,
                    row.values[0..2],
                    format_date(row["transaction_date"]),
                    format_date(row["certification_date"]),
                    row.values[5..6],
                    format_date(row["created_at"]),
                    row.values[8]
                ].flatten,
                style: styling(border(:l, :b)) + styling(border(:b)) * 3 + styling(border(:b), excel_date) * 2 + styling(border(:b)) * 2 + styling(border(:b), excel_date) + styling(border(:r, :b)),
                types: [:integer, :string, :string, :string, :date, :date, :string, :string, :date, :integer]
            }
        end

        @column_widths  = []
        @column_widths  << [10] + [18] * 2 + [40] + [20] * 5 + [10]
        @merge_fields   = []
        @merge_fields   << ["A1:J1"]
        @filter_options = [{ type: "date range", label: "Date Range" }]
        setting_html_display_limit(worksheet)
        parse_output_format("xqcc_result_release_amend_cases#{ timestamp }")
    end

    def xqcc_amend_unsuitable_report
        @filter_options = [
            { type: "date range", label: "Date Range" },
            { type: "select list", label: "Disease Type", list: ["Tuberculosis", "Heart Disease", "Other"], field_name: :disease_type }
        ]

        if params[:disease_type].blank? && !["Tuberculosis", "Heart Disease", "Other"].include?(params[:disease_type])
            parse_output_format("xqcc_amend_unsuitable_report") and return
        end

        if params[:filter_date_start].present? && params[:filter_date_end].present?
            start_date          = params[:filter_date_start].to_date
            end_date            = params[:filter_date_end].to_date.tomorrow
            timestamp           = "_#{ params[:filter_date_start] }_to_#{ params[:filter_date_end] }"
            disease_map         = { "Tuberculosis" => :tuberculosis, "Heart Disease" => :heart_diseases, "Other" => :other }
            disease             = disease_map[params[:disease_type]]
            worksheet           = [data: ["Amended Unsuitable by XQCC (#{ params[:disease_type] })"], style: styling(bold) * 13]
            @extended_headers   = 2

            worksheet << {
                data: ["No.", "Transaction ID", "Worker Code", "Worker Name", "Passport Number", "Gender", "Country", "Job Type", "Employer Name", "Xray Code", "Xray Name", "Comment Date", "Comments"],
                style: styling(bold, border) * 13
            }

            rows        = ActiveRecord::Base.connection.execute("select t.code, t.fw_code, t.fw_name, t.fw_passport_number, t.fw_gender, countries.name,
                jt.name job_name, employers.name employer_name, xf.code xray_code, xf.name xray_name, xpd.reviewed_at, xpd.comment
                from xray_pending_decisions xpd join transactions t on t.id = xpd.transaction_id
                left join countries on countries.id = t.fw_country_id
                left join job_types jt on jt.id = t.fw_job_type_id
                left join employers on employers.id = t.employer_id
                left join xray_facilities xf on xf.id = t.xray_facility_id
                where xpd.decision = 'UNSUITABLE' and approval_decision = 'APPROVE' and xpd.condition_#{ disease } = 'YES'
                and xpd.transmitted_at >= '#{ start_date }' and xpd.transmitted_at < '#{ end_date }'
                order by xpd.transmitted_at")
        else
            worksheet   = [data: ["Amended Unsuitable by XQCC"], style: styling(bold) * 13]
            rows        = []
        end

        rows.each.with_index(1) do |row, index|
            worksheet   << {
                data: [index, row.values[0..-3], format_date(row["reviewed_at"]), row["comment"]].flatten,
                style: styling(border(:l, :b)) + styling(border(:b)) * 10 + styling(border(:b), excel_date) + styling(border(:r, :b)),
                types: [:integer] + [:string] * 10 + [:date] + [:string]
            }
        end

        @column_widths  = []
        @column_widths  << [10] + [18] * 2 + [40] + [18] * 4 + [40] + [18] + [40] + [18] + [60]
        @merge_fields   = []
        @merge_fields   << ["A1:L1"]
        setting_html_display_limit(worksheet)
        parse_output_format("xqcc_amend_unsuitable_report_#{ disease }#{ timestamp }")
    end

    def monthly_xqcc_programme_report
        worksheet   = [data: ["Monthly XQCC Programme Report"], style: styling(bold)]

        if params[:query_month].present?
            start_date  = params[:query_month].to_date
            end_date    = start_date.next_month
            worksheet   = [data: ["Allocation of Active GP based on types of x-ray"], style: styling(bold)]

            # Allocations
            worksheet   << {
                data: ["TYPE OF X-RAY ALLOCATION", "TOTAL", "PERCENTAGE (%)"],
                style: styling(bold, border(:l, :t, :b)) + styling(bold, border(:t, :b)) + styling(bold, border(:r, :t, :b))
            }

            allocations     = ActiveRecord::Base.connection.execute("select xf.film_type, count(1)
                from doctors d join xray_facilities xf on xf.id = d.xray_facility_id
                where d.status = 'ACTIVE' group by xf.film_type")

            total           = allocations.map {|hash| hash["count"] }.sum
            second_row      = 3

            allocations.each do |hash|
                second_row += 1
                percentage =  "%.1f" % ((hash["count"].to_f / total) * 100)

                worksheet   << {
                    data: hash.values + ["#{ percentage }%"],
                    style: styling(border(:l)) + [{}] + styling(border(:r))
                }
            end

            worksheet   << {
                data: ["TOTAL", total, "100.0%"],
                style: styling(bold, border(:l, :t, :b)) + styling(bold, border(:t, :b)) + styling(bold, border(:r, :t, :b))
            }

            if request&.format == "html"
                worksheet   << [:next_table]
            else
                worksheet   << []
                worksheet   << []
            end

            worksheet   << {
                data: ["Total number of x-ray facilities based on types of x-ray"],
                style: styling(bold)
            }

            worksheet   << {
                data: ["TYPE OF X-RAY FACILITIES", "ACTIVE", "TEMPORARY INACTIVE", "SUSPENDED", "TOTAL"],
                style: styling(bold, border(:l, :t, :b)) + styling(bold, border(:t, :b)) * 3 + styling(bold, border(:r, :t, :b))
            }

            xray_facilities = ActiveRecord::Base.connection.execute("select xf.film_type,
                sum(case when status='ACTIVE' then 1 else 0 end) active,
                sum(case when status='TEMPORARY_INACTIVE' then 1 else 0 end) temp_inactive,
                sum(case when status='INACTIVE'then 1 else 0 end) inactive, count(1)
                from xray_facilities xf group by xf.film_type")

            all_totals      = []
            third_row       = 2

            xray_facilities.each do |hash|
                all_totals << hash.values[1..-1]
                third_row += 1

                worksheet   << {
                    data: hash.values,
                    style: styling(border(:l)) + [{}] * 3 + styling(border(:r))
                }
            end

            worksheet   << {
                data: ["TOTAL"] + all_totals.transpose.map(&:sum),
                style: styling(bold, border(:l, :t, :b)) + styling(bold, border(:t, :b)) * 3 + styling(bold, border(:r, :t, :b))
            }

            if request&.format == "html"
                worksheet   << [:next_table]
            else
                worksheet   << []
                worksheet   << []
            end

            worksheet   << {
                data: ["Total number of films received based on type of x-ray for #{ start_date.strftime("%^B %Y") }"],
                style: styling(bold)
            }

            worksheet   << {
                data: ["TYPE OF FILM", "TOTAL", "PERCENTAGE (%)"],
                style: styling(bold, border(:l, :t, :b)) + styling(bold, border(:t, :b)) + styling(bold, border(:r, :t, :b))
            }

            films_received = ActiveRecord::Base.connection.execute("select xf.film_type, count(1)
                from transactions t join xray_facilities xf on xf.id = t.xray_facility_id
                and t.certification_date >='#{ start_date }' and t.certification_date < '#{ end_date }'
                and t.status not in ('CANCELLED','REJECTED')
                group by xf.film_type")

            total           = films_received.map {|hash| hash["count"] }.sum
            second_row      = 3

            films_received.each do |hash|
                second_row += 1
                percentage =  "%.1f" % ((hash["count"].to_f / total) * 100)

                worksheet   << {
                    data: hash.values + ["#{ percentage }%"],
                    style: styling(border(:l)) + [{}] + styling(border(:r))
                }
            end

            worksheet   << {
                data: ["TOTAL", total, "100.0%"],
                style: styling(bold, border(:l, :t, :b)) + styling(bold, border(:t, :b)) + styling(bold, border(:r, :t, :b))
            }

            timestamp   = "_#{ start_date.strftime("%^B_%Y") }"
            @merge_fields   = []
            second_row      += 3
            third_row       = second_row + third_row + 3
            @merge_fields   << ["A1:C1", "A#{ second_row }:E#{ second_row }", "A#{ third_row }:C#{ third_row }"]
            @column_widths  = []
            @column_widths  << [30] + [12] + [24] + [18] * 2
        end

        @filter_options     = [{ type: "month select", label: "Selected Month" }]
        setting_html_display_limit(worksheet)
        @displayed_size     = nil
        parse_output_format("monthly_xqcc_programme_report#{ timestamp }")
    end
end