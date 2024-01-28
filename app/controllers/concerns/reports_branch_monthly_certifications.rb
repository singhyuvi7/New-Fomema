module ReportsBranchMonthlyCertifications
    def branch_monthly_status
        worksheet = [data: ["CERTIFICATION BY MONTHS STATUS"], style: styling(bold)]

        if params[:query_month].present?
            date            = params[:query_month].to_date
            end_date        = date.next_month
            start_date      = end_date - 3.years
            timestamp       = "_#{ date.strftime("%B_%Y") }"
            month_list      = 36.times.map {|i| (start_date + i.months).strftime("%Y-%m") }
            final_month     = month_list.last
            all_totals      = []
            year            = nil

            transactions    = ActiveRecord::Base.connection.execute("select to_char(t.certification_date, 'YYYY-MM') as month,
                sum(case when de.suitability = 'SUITABLE' then 1 else 0 end) as suitable,
                sum(case when de.suitability = 'UNSUITABLE' then 1 else 0 end) as unsuitable,
                count(*) total
                from transactions t join doctor_examinations de on de.transaction_id = t.id
                where de.transmitted_at is not null and t.certification_date >= '#{ start_date }' and t.certification_date < '#{ end_date }'
                group by month order by month")
        else
            month_list      = []
        end

        month_list.each do |year_month|
            hash            = transactions.find {|hash| hash["month"] == year_month }
            parsed_date     = "#{ year_month }-01".to_date
            parsed_month    = parsed_date.strftime("%^B")

            if year != parsed_date.year
                year = parsed_date.year
                worksheet << [""]

                worksheet << {
                    data: ["YEAR #{ year }"],
                    style: styling(bold)
                }

                worksheet << {
                    data: ["MONTH", "SUITABLE", "UNSUITABLE", "TOTAL"],
                    style: styling(bold, border) + styling(bold, border(:t, :b)) * 2 + styling(bold, border)
                }
            end

            if hash.blank?
                worksheet << {
                    data: [parsed_month] + [0] * 3,
                    style: styling(border(:l, :r)) + [{}] * 2 + styling(border(:l, :r))
                }
            else
                row_total   = hash.values[1..-1]
                all_totals  << row_total

                worksheet << {
                    data: [parsed_month] + row_total,
                    style: styling(border(:l, :r)) + [{}] * 2 + styling(border(:l, :r))
                }
            end

            if parsed_month == "DECEMBER" || final_month == year_month
                summation = all_totals.blank? ? [0] * 3 : all_totals.transpose.map(&:sum)

                worksheet << {
                    data: ["TOTAL"] + summation,
                    style: styling(border) + styling(border(:t, :b)) * 2 + styling(border)
                }

                all_totals = []
            end
        end

        @column_widths  = []
        @column_widths  << [28] + [18] * 8 + [25, 18, 18, 22, 22] + [18] * 7
        @filter_options = [{ type: "month select", label: "Registration Month" }]
        setting_html_display_limit(worksheet)
        parse_output_format("branch_monthly_status#{ timestamp }")
    end

    def branch_monthly_diseases
        worksheet = [data: ["CERTIFICATION BY MONTHS (BY DISEASES)"], style: styling(bold)]

        if request&.format == "html"
            worksheet << []
            worksheet << []
        end

        if params[:query_month].present?
            date            = params[:query_month].to_date
            end_date        = date.next_month
            start_date      = end_date - 3.years
            timestamp       = "_#{ date.strftime("%B_%Y") }"
            month_list      = 36.times.map {|i| (start_date + i.months).strftime("%Y-%m") }
            date_ranges     = month_list.group_by {|date| date.split("-")[0] }
            start_and_end   = date_ranges.values.map {|array| [array.first, array.last]}

            start_and_end.each.with_index do |array, index|
                if request&.format == "html"
                    worksheet << [:next_table]
                elsif index > 0
                    worksheet << []
                    worksheet << []
                end

                start_cert  = "#{ array[0] }-01"
                end_cert    = "#{ array[1] }-01".to_date.next_month
                year        = start_cert.split("-")[0]

                transactions    = ActiveRecord::Base.connection.execute("
                    with rows as (
                        select month, sum(hiv) hiv, sum(tb) tb, sum(malaria) malaria, sum(leprosy) leprosy, sum(std) std,
                        sum(hepb) hepb, sum(cancer) cancer, sum(epilepsy) epilepsy, sum(psych_ill) psych_ill,
                        sum(hypertension) hypertension, sum(heart_disease) heart_disease, sum(ashtma) ashtma,
                        sum(diabetes) diabetes, sum(peptic_ulcer) peptic_ulcer, sum(kidney_disease) kidney_disease,
                        sum(pregnancy) pregnancy, sum(opiates) opiates, sum(cannabis) cannabis, sum(others) as others
                        from (
                            select to_char(t.certification_date, 'YYYY-MM') as month,
                            sum(case when cond.code = '3501' then 1 else 0 end) hiv,
                            sum(case when cond.code = '3502' then 1 else 0 end) tb,
                            sum(case when cond.code = '3503' then 1 else 0 end) malaria,
                            sum(case when cond.code = '3504' then 1 else 0 end) leprosy,
                            sum(case when cond.code = '3505' then 1 else 0 end) std,
                            sum(case when cond.code = '3506' then 1 else 0 end) hepb,
                            sum(case when cond.code = '3507' then 1 else 0 end) cancer,
                            sum(case when cond.code = '3508' then 1 else 0 end) epilepsy,
                            sum(case when cond.code = '3509' then 1 else 0 end) psych_ill,
                            sum(case when cond.code = '3514' then 1 else 0 end) hypertension,
                            sum(case when cond.code = '3515' then 1 else 0 end) heart_disease,
                            sum(case when cond.code = '3516' then 1 else 0 end) ashtma,
                            sum(case when cond.code = '3517' then 1 else 0 end) diabetes,
                            sum(case when cond.code = '3518' then 1 else 0 end) peptic_ulcer,
                            sum(case when cond.code = '3519' then 1 else 0 end) kidney_disease,
                            sum(case when cond.code = '3510' then 1 else 0 end) pregnancy,
                            sum(case when cond.code = '3512' then 1 else 0 end) opiates,
                            sum(case when cond.code = '3511' then 1 else 0 end) cannabis,
                            sum(case when cond.code = '3520' then 1 else 0 end) as others
                            from transactions t join medical_examination_details med on med.transaction_id = t.id
                            join conditions cond on cond.id = med.condition_id
                            where cond.code in ('3501', '3502', '3503', '3504', '3505', '3506', '3507', '3508', '3509', '3514',
                            '3515', '3516', '3517', '3518', '3519', '3510', '3512', '3511', '3520')
                            and med.deleted_at is null and final_result = 'UNSUITABLE'
                            and t.certification_date >= '#{ start_cert }' and t.certification_date < '#{ end_cert }'
                            group by month
                            union all
                            select to_char(t.certification_date, 'YYYY-MM') as month,
                            sum(case when cond.code = '3501' then 1 else 0 end) hiv,
                            sum(case when cond.code = '3502' then 1 else 0 end) tb,
                            sum(case when cond.code = '3503' then 1 else 0 end) malaria,
                            sum(case when cond.code = '3504' then 1 else 0 end) leprosy,
                            sum(case when cond.code = '3505' then 1 else 0 end) std,
                            sum(case when cond.code = '3506' then 1 else 0 end) hepb,
                            sum(case when cond.code = '3507' then 1 else 0 end) cancer,
                            sum(case when cond.code = '3508' then 1 else 0 end) epilepsy,
                            sum(case when cond.code = '3509' then 1 else 0 end) psych_ill,
                            sum(case when cond.code = '3514' then 1 else 0 end) hypertension,
                            sum(case when cond.code = '3515' then 1 else 0 end) heart_disease,
                            sum(case when cond.code = '3516' then 1 else 0 end) ashtma,
                            sum(case when cond.code = '3517' then 1 else 0 end) diabetes,
                            sum(case when cond.code = '3518' then 1 else 0 end) peptic_ulcer,
                            sum(case when cond.code = '3519' then 1 else 0 end) kidney_disease,
                            sum(case when cond.code = '3510' then 1 else 0 end) pregnancy,
                            sum(case when cond.code = '3512' then 1 else 0 end) opiates,
                            sum(case when cond.code = '3511' then 1 else 0 end) cannabis,
                            sum(case when cond.code = '3520' then 1 else 0 end) as others
                            from transactions t join doctor_examination_details ded on ded.transaction_id = t.id
                            left join medical_examinations me on me.transaction_id = t.id
                            join conditions cond on cond.id = ded.condition_id
                            where cond.code in ('3501', '3502', '3503', '3504', '3505', '3506', '3507', '3508', '3509', '3514',
                            '3515', '3516', '3517', '3518', '3519', '3510', '3512', '3511', '3520')
                            and ded.deleted_at is null and me.id is null and final_result = 'UNSUITABLE'
                            and t.certification_date >= '#{ start_cert }' and t.certification_date < '#{ end_cert }'
                            group by month
                        ) a group by month order by month
                    ),

                    row_total as (
                      select *, hiv + tb + malaria + leprosy + std + hepb + cancer + epilepsy + psych_ill + hypertension +
                      heart_disease + ashtma + diabetes + peptic_ulcer + kidney_disease + pregnancy + opiates + cannabis + others as subtotal from rows
                    )

                    /* Leave this commented, can be used in psql previewer to show total.
                    select * from row_total
                    union all
                    select 'TOTAL', sum(hiv), sum(tb), sum(malaria), sum(leprosy), sum(std), sum(hepb), sum(cancer), sum(epilepsy),
                    sum(psych_ill), sum(hypertension), sum(heart_disease), sum(ashtma), sum(diabetes), sum(peptic_ulcer),
                    sum(kidney_disease), sum(pregnancy), sum(opiates), sum(cannabis), sum(others), sum(subtotal)
                    from row_total
                    */

                    select * from row_total")

                worksheet << {
                    data: ["YEAR #{ year }"],
                    style: styling(bold)
                }

                worksheet << {
                    data: ["MONTH", "HIV/AIDS", "TUBERCULOSIS", "MALARIA", "LEPROSY", "SYPHILIS", "HEPATITIS B", "CANCER", "EPILEPSY", "PSYCHIATRIC ILLNESS", "HYPERTENSION", "HEART DISEASE", "BRONCHIAL ASTHMA", "DIABETES MELLITUS", "PEPTIC ULCER", "KIDNEY DISEASE", "PREGNANT", "URINE OPIATES", "URINE CANNABIS", "OTHERS", "TOTAL"],
                    style: styling(bold, border) + styling(bold, border(:t, :b)) * 19 + styling(bold, border)
                }

                rows = date_ranges[year].map do |year_month|
                    row = transactions.find {|row| row["month"] == year_month }
                    row.present? ? row.values : ([year_month] + [0] * 20)
                end

                rows << ["TOTAL"] + rows.map {|row| row[1..-1].map(&:to_i) }.transpose.map(&:sum)

                rows.each do |row|
                    row_style =
                        if row[0] == "TOTAL"
                            month_parsing = "TOTAL"
                            styling(border) + styling(border(:t, :b)) * 19 + styling(border)
                        else
                            month_parsing = "#{ row[0] }-01".to_date.strftime("%^B")
                            styling(border(:l, :r)) + [{}] * 19 + styling(border(:l, :r))
                        end

                    worksheet << {
                        data: [month_parsing] + row[1..-1],
                        style: row_style
                    }
                end
            end
        end

        @column_widths      = []
        @column_widths      << [28] + [18] * 8 + [25, 18, 18, 22, 22] + [18] * 7
        @filter_options     = [{ type: "month select", label: "Registration Month" }]
        setting_html_display_limit(worksheet)
        @extended_headers   = 2
        @displayed_size     = nil
        parse_output_format("branch_monthly_diseases#{ timestamp }")
    end

    def branch_monthly_country_status
        worksheet = [data: ["CERTIFICATION BY COUNTRY STATUS"], style: styling(bold)]

        if params[:selected_year].present?
            date            = "#{ params[:selected_year] }-01-01".to_date
            end_date        = date.next_year
            start_date      = end_date - 3.years
            timestamp       = "_#{ date.year }"
            year_list       = 3.times.map {|i| (start_date + i.years).year }
            final_year      = year_list.last
            all_totals      = []

            transactions    = ActiveRecord::Base.connection.execute("select to_char(t.certification_date, 'YYYY')::integer as year,
                countries.name,
                sum(case when de.suitability = 'SUITABLE' then 1 else 0 end) as suitable,
                sum(case when de.suitability = 'UNSUITABLE' then 1 else 0 end) as unsuitable,
                count(*)
                from transactions t join doctor_examinations de on de.transaction_id = t.id
                join countries on countries.id = t.fw_country_id
                where de.transmitted_at is not null and t.certification_date >= '#{ start_date }' and t.certification_date < '#{ end_date }'
                group by year, name order by year, name")
        else
            year_list       = []
        end

        year_list.each do |year|
            rows        = transactions.select {|hash| hash["year"] == year }
            all_totals  = []

            worksheet << [""]

            worksheet << {
                data: ["YEAR #{ year }"],
                style: styling(bold)
            }

            worksheet << {
                data: ["COUNTRY", "SUITABLE", "UNSUITABLE", "TOTAL"],
                style: styling(bold, border) + styling(bold, border(:t, :b)) * 2 + styling(bold, border)
            }

            rows.each do |row|
                row_total   = row.values[2..-1]
                all_totals  << row_total

                worksheet << {
                    data: row.values[1..-1],
                    style: styling(border(:l, :r)) + [{}] * 2 + styling(border(:l, :r))
                }
            end

            summation = all_totals.present? ? all_totals.transpose.map(&:sum) : [0] * 3

            worksheet << {
                data: ["TOTAL"] + summation,
                style: styling(border) + styling(border(:t, :b)) * 2 + styling(border)
            }
        end

        @column_widths  = []
        @column_widths  << [28] + [18] * 3
        @filter_options = [{ type: "select list", label: "Year", list: (2000..Date.today.year), field_name: :selected_year }]
        setting_html_display_limit(worksheet)
        parse_output_format("branch_monthly_country_status#{ timestamp }")
    end

    def pati_certification_monthly_diseases
        worksheet = [
            data: ["CERTIFICATION (PATI) BY MONTHS (BY DISEASES)"],
            style: styling(bold)
        ]

        if params[:query_month].present?
            date                = params[:query_month].to_date
            end_date            = date.next_month
            start_date          = end_date - 3.years
            timestamp           = "_#{ date.strftime("%B_%Y") }"
            month_list          = 36.times.map {|i| (start_date + i.months).strftime("%Y-%m") }
            final_month         = month_list.last
            all_totals          = []
            year                = nil

            transactions        = ActiveRecord::Base.connection.execute("select to_char(t.certification_date, 'YYYY-MM') as month,
                sum(case when cond.code = '3501' then 1 else 0 end) hiv,
                sum(case when cond.code = '3502' then 1 else 0 end) tb,
                sum(case when cond.code = '3503' then 1 else 0 end) malaria,
                sum(case when cond.code = '3504' then 1 else 0 end) leprosy,
                sum(case when cond.code = '3505' then 1 else 0 end) std,
                sum(case when cond.code = '3506' then 1 else 0 end) hepb,
                sum(case when cond.code = '3507' then 1 else 0 end) cancer,
                sum(case when cond.code = '3508' then 1 else 0 end) epilepsy,
                sum(case when cond.code = '3509' then 1 else 0 end) psych_ill,
                sum(case when cond.code = '3514' then 1 else 0 end) hypertension,
                sum(case when cond.code = '3515' then 1 else 0 end) heart_disease,
                sum(case when cond.code = '3516' then 1 else 0 end) ashtma,
                sum(case when cond.code = '3517' then 1 else 0 end) diabetes,
                sum(case when cond.code = '3518' then 1 else 0 end) peptic_ulcer,
                sum(case when cond.code = '3519' then 1 else 0 end) kidney_disease,
                sum(case when cond.code = '3510' then 1 else 0 end) pregnancy,
                sum(case when cond.code = '3512' then 1 else 0 end) opiates,
                sum(case when cond.code = '3511' then 1 else 0 end) cannabis,
                sum(case when cond.code = '3520' then 1 else 0 end) as others
                from transactions t join doctor_examination_details ded on ded.transaction_id = t.id
                join conditions cond on cond.id = ded.condition_id
                where cond.code in ('3501', '3502', '3503', '3504', '3505', '3506', '3507', '3508', '3509', '3514',
                '3515', '3516', '3517', '3518', '3519', '3510', '3512', '3511', '3520')
                and ded.deleted_at is null and t.certification_date >= '#{ start_date }' and t.certification_date < '#{ end_date }'
                and t.fw_pati = true group by month order by month")
        else
            month_list          = []
        end

        month_list.each do |year_month|
            hash            = transactions.find {|hash| hash["month"] == year_month }
            parsed_date     = "#{ year_month }-01".to_date
            parsed_month    = parsed_date.strftime("%^B")

            if year != parsed_date.year
                year = parsed_date.year
                worksheet << [""]

                worksheet << {
                    data: ["YEAR #{ year }"],
                    style: styling(bold)
                }

                worksheet << {
                    data: ["MONTH", "HIV/AIDS", "TUBERCULOSIS", "MALARIA", "LEPROSY", "SYPHILIS", "HEPATITIS B", "CANCER", "EPILEPSY", "PSYCHIATRIC ILLNESS", "HYPERTENSION", "HEART DISEASE", "BRONCHIAL ASTHMA", "DIABETES MELLITUS", "PEPTIC ULCER", "KIDNEY DISEASE", "PREGNANT", "URINE OPIATES", "URINE CANNABIS", "OTHERS", "TOTAL"],
                    style: styling(bold, border) + styling(bold, border(:t, :b)) * 19 + styling(bold, border)
                }
            end

            if hash.blank?
                worksheet << {
                    data: [parsed_month] + [0] * 20,
                    style: styling(border(:l, :r)) + [{}] * 19 + styling(border(:l, :r))
                }
            else
                count       = hash.values[1..-1]
                row_total   = count + [count.sum]
                all_totals  << row_total

                worksheet << {
                    data: [parsed_month] + row_total,
                    style: styling(border(:l, :r)) + [{}] * 19 + styling(border(:l, :r))
                }
            end

            if parsed_month == "DECEMBER" || final_month == year_month
                summation = all_totals.blank? ? [0] * 20 : all_totals.transpose.map(&:sum)

                worksheet << {
                    data: ["TOTAL"] + summation,
                    style: styling(border) + styling(border(:t, :b)) * 19 + styling(border)
                }

                all_totals = []
            end
        end

        @column_widths  = []
        @column_widths  << [28] + [18] * 8 + [25, 18, 18, 22, 22] + [18] * 7
        @filter_options = [{ type: "month select", label: "Registration Month" }]
        setting_html_display_limit(worksheet)
        parse_output_format("pati_certification_monthly_diseases#{ timestamp }")
    end
end