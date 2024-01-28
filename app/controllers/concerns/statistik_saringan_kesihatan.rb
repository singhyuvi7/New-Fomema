module StatistikSaringanKesihatan
    def statistik_mengikut_sektor
        saringan_kesihatan_template_1(:sektor)
    end

    def statistik_mengikut_negeri
        saringan_kesihatan_template_1(:negeri)
    end

    def statistik_mengikut_negara_sumber
        saringan_kesihatan_template_1(:negara_sumber)
    end

    def statistik_mengikut_tahun
        year        = params[:filter_year].to_i if params[:filter_year].present?
        worksheet   = [data: ["STATISTIK SARINGAN KESIHATAN FOMEMA TERHADAP PEKERJA ASING TAHUN #{ year }"], style: styling(bold)]

        if year.present?
            worksheet   << {
                data: ["TAHUN", "JUMLAH DIPERIKSA", "SESUAI", "PEMBAHARUAN", "BARU", "TIDAK SESUAI", "PEMBAHARUAN", "BARU", "\% TIDAK SESUAI"],
                style: styling(bold, border) * 9
            }

            transactions = ActiveRecord::Base.connection.execute("
                select *, round(100 * unsuitable::numeric / count::numeric, 2) percentage from (
                    select to_char(t.certification_date, 'YYYY')::integer as year,
                    count(*),
                    sum(case when final_result = 'SUITABLE' then 1 else 0 end) suitable,
                    sum(case when (fw_plks_number not in ('0') or fw_plks_number is null) and final_result = 'SUITABLE' then 1 else 0 end) renewal_suitable,
                    sum(case when fw_plks_number ='0' and final_result = 'SUITABLE' then 1 else 0 end) new_reg_suitable,
                    sum(case when final_result = 'UNSUITABLE' then 1 else 0 end) unsuitable,
                    sum(case when (fw_plks_number not in ('0') or fw_plks_number is null) and final_result = 'UNSUITABLE' then 1 else 0 end) renewal_unsuitable,
                    sum(case when fw_plks_number = '0' and final_result = 'UNSUITABLE' then 1 else 0 end) new_reg_unsuitable
                    from transactions t
                    where t.certification_date >= '#{ year }-01-01' and t.certification_date < '#{ year + 1 }-01-01' and t.final_result is not null
                    group by year order by year
                ) a")

            # In case no data for that year.
            row         = transactions.to_a.first&.values || [year] + [0] * 7 + ["0.00"]

            worksheet   << {
                data: row,
                style: styling(border(:l, :r, :b)) * 9
            }

            @merge_fields   = []
            @merge_fields   << ["A1:I1"]
            @column_widths  = []
            @column_widths  << [9, 20] + [18] * 7
        else
            flash.now[:notice] = "Please select a year"
        end

        @filter_options = [{ type: "select list", label: "Year", list: 2019..Date.today.year, field_name: :filter_year }]
        setting_html_display_limit(worksheet)
        parse_output_format("statistik_mengikut_tahun_#{ year }")
    end

    def statistik_mengikut_sebab
        year        = params[:filter_year].to_i if params[:filter_year].present?
        worksheet   = [data: ["STATISTIK SARINGAN KESIHATAN FOMEMA TERHADAP PEKERJA ASING MENGIKUT SEBAB-SEBAB TAHUN #{ year }"], style: styling(bold)
        ]

        if year.present?
            worksheet << {
                data: ["TAHUN", "STATUS", "HIV/AIDS", "TIBI", "MALARIA", "KUSTA", "STD", "HEPATITIS", "KANSER", "EPILEPSY", "PSIKIATRI", "HYPERTENSI", "PENYAKIT JANTUNG", "ASMA", "DIABETIS", "ULSER PEPTIK", "PENYAKIT BUAH PINGGANG", "KEHAMILAN", "URIN KANABIS", "URIN OPIATES", "LAIN-LAIN", "JUMLAH"],
                style: styling(bold, border) * 22
            }

            transactions = ActiveRecord::Base.connection.execute("
                select year, renewal_status, sum(hiv) hiv, sum(tb) tb, sum(malaria) malaria, sum(leprosy) leprosy,
                sum(std) std, sum(hepb) hepb, sum(cancer) cancer, sum(epilepsy) epilepsy, sum(psych) psych,
                sum(hypertension) hypertension, sum(heart_disease) heart_disease, sum(asthma) asthma, sum(diabetes) diabetes,
                sum(peptic_ulcer) peptic_ulcer, sum(kidney_disease) kidney_disease, sum(pregnancy) pregnancy,
                sum(cannabis) cannabis, sum(opiates) opiates, sum(others) as others,
                sum(hiv + tb + malaria + leprosy + std + hepb + cancer + epilepsy + psych + hypertension + heart_disease +
                asthma + diabetes + peptic_ulcer + kidney_disease + pregnancy + cannabis + opiates + others) total from (
                    select to_char(t.certification_date, 'YYYY')::integer as year,
                    case when (fw_plks_number not in ('0') or fw_plks_number is null) then 'RENEWAL' else 'NEW' end renewal_status,
                    sum(case when conditions.code = '3501' then 1 else 0 end) as hiv,
                    sum(case when conditions.code = '3502' then 1 else 0 end) as tb,
                    sum(case when conditions.code = '3503' then 1 else 0 end) as malaria,
                    sum(case when conditions.code = '3504' then 1 else 0 end) as leprosy,
                    sum(case when conditions.code = '3505' then 1 else 0 end) as std,
                    sum(case when conditions.code = '3506' then 1 else 0 end) as hepb,
                    sum(case when conditions.code = '3507' then 1 else 0 end) as cancer,
                    sum(case when conditions.code = '3508' then 1 else 0 end) as epilepsy,
                    sum(case when conditions.code = '3509' then 1 else 0 end) as psych,
                    sum(case when conditions.code = '3514' then 1 else 0 end) as hypertension,
                    sum(case when conditions.code = '3515' then 1 else 0 end) as heart_disease,
                    sum(case when conditions.code = '3516' then 1 else 0 end) as asthma,
                    sum(case when conditions.code = '3517' then 1 else 0 end) as diabetes,
                    sum(case when conditions.code = '3518' then 1 else 0 end) as peptic_ulcer,
                    sum(case when conditions.code = '3519' then 1 else 0 end) as kidney_disease,
                    sum(case when conditions.code = '3510' then 1 else 0 end) as pregnancy,
                    sum(case when conditions.code = '3511' then 1 else 0 end) as cannabis,
                    sum(case when conditions.code = '3512' then 1 else 0 end) as opiates,
                    sum(case when conditions.code = '3520' then 1 else 0 end) as others
                    from transactions t left join medical_examination_details med on med.transaction_id = t.id
                    left join conditions on conditions.id = med.condition_id
                    where t.certification_date >= '#{ year }-01-01' and t.certification_date < '#{ year + 1 }-01-01'
                    and  t.final_result = 'UNSUITABLE'
                    and conditions.code in ('3501', '3502', '3503', '3504', '3505', '3506', '3507', '3508',
                    '3509', '3510', '3511', '3512', '3514', '3515', '3516', '3517', '3518', '3519', '3520')
                    group by year,renewal_status
                    union all
                    select to_char(t.certification_date, 'YYYY')::integer as year,
                    case when (fw_plks_number not in ('0') or fw_plks_number is null) then 'RENEWAL' else 'NEW' end renewal_status,
                    sum(case when conditions.code = '3501' then 1 else 0 end) as hiv,
                    sum(case when conditions.code = '3502' then 1 else 0 end) as tb,
                    sum(case when conditions.code = '3503' then 1 else 0 end) as malaria,
                    sum(case when conditions.code = '3504' then 1 else 0 end) as leprosy,
                    sum(case when conditions.code = '3505' then 1 else 0 end) as std,
                    sum(case when conditions.code = '3506' then 1 else 0 end) as hepb,
                    sum(case when conditions.code = '3507' then 1 else 0 end) as cancer,
                    sum(case when conditions.code = '3508' then 1 else 0 end) as epilepsy,
                    sum(case when conditions.code = '3509' then 1 else 0 end) as psych,
                    sum(case when conditions.code = '3514' then 1 else 0 end) as hypertension,
                    sum(case when conditions.code = '3515' then 1 else 0 end) as heart_disease,
                    sum(case when conditions.code = '3516' then 1 else 0 end) as asthma,
                    sum(case when conditions.code = '3517' then 1 else 0 end) as diabetes,
                    sum(case when conditions.code = '3518' then 1 else 0 end) as peptic_ulcer,
                    sum(case when conditions.code = '3519' then 1 else 0 end) as kidney_disease,
                    sum(case when conditions.code = '3510' then 1 else 0 end) as pregnancy,
                    sum(case when conditions.code = '3511' then 1 else 0 end) as cannabis,
                    sum(case when conditions.code = '3512' then 1 else 0 end) as opiates,
                    sum(case when conditions.code = '3520' then 1 else 0 end) as others
                    from transactions t left join doctor_examination_details ded on ded.transaction_id = t.id
                    left join conditions on conditions.id = ded.condition_id
                    left join medical_examinations me on me.transaction_id = t.id
                    where t.certification_date >= '#{ year }-01-01' and t.certification_date < '#{ year + 1 }-01-01'
                    and t.final_result = 'UNSUITABLE' and me.id is null
                    and conditions.code in ('3501', '3502', '3503', '3504', '3505', '3506', '3507', '3508',
                    '3509', '3510', '3511', '3512', '3514', '3515', '3516', '3517', '3518', '3519', '3520')
                    group by year, renewal_status
                ) a group by year, renewal_status")

            ["NEW", "RENEWAL"].each do |status_check|
                rows        = transactions.find {|hash| hash["renewal_status"] == status_check }
                values      = rows.present? ? rows.values[2..-1] : [0] * 20
                data_row    = [year, status_check] + values
                row_style   = status_check == "RENEWAL" ? [:l, :r, :b] : [:l, :r]

                worksheet   << {
                    data: data_row,
                    style: styling(border(*row_style)) * 22
                }
            end

            @merge_fields   = []
            @merge_fields   << ["A1:U1"]
            @column_widths  = []
            @column_widths  << [8, 11, 10, 5, 11, 8, 5, 12, 9, 11, 11, 15, 23, 7, 11, 16, 31, 14, 16, 17, 12, 11]
        else
            flash.now[:notice] = "Please select a year"
        end

        @filter_options = [{ type: "select list", label: "Year", list: 2019..Date.today.year, field_name: :filter_year }]
        setting_html_display_limit(worksheet)
        parse_output_format("statistik_mengikut_sebab_tahun_#{ year }")
    end
private
    def saringan_kesihatan_template_1(type)
        category    = type.to_s.titleize.upcase
        worksheet   = [data: ["STATISTIK SARINGAN KESIHATAN FOMEMA TERHADAP PEKERJA ASING MENGIKUT #{ category }"], style: styling(bold)]

        if params[:filter_date_start].present?
            start_date      = params[:filter_date_start].to_date

            if start_date.year < 2019
                flash.now[:notice]  = "Cannot select earlier than 2019"
                start_date      = nil
            end
        end

        if start_date.present? && params[:filter_date_end].present? && params[:query_type].present?
            end_date        = params[:filter_date_end].to_date.tomorrow
            timestamp       = "_#{ params[:filter_date_start] }_hingga_#{ params[:filter_date_end] }"
            all_totals      = []

            worksheet << {
                data: ["", "JUMLAH DIPERIKSA", "", "BIL. SESUAI", "", "BIL. TIDAK SESUAI", ""],
                style: styling(bold, border) * 7
            }

            worksheet << {
                data: [category, "BARU", "PEMBAHARUAN", "BARU", "PEMBAHARUAN", "BARU", "PEMBAHARUAN"],
                style: styling(bold, border) + ([styling(bold, border(:b, :t)), styling(bold, border(:b, :t, :r))] * 3).flatten
            }

            query_type      = params[:query_type].underscore.gsub(" ", "_")
            date_query      = "t.#{ query_type } >= '#{ start_date }' and t.#{ query_type } < '#{ end_date }'"

            joined_query    =
                case type
                when :sektor
                    "job_types query_table where t.fw_job_type_id = query_table.id and #{ date_query }"
                when :negeri
                    "doctors d, states query_table where t.doctor_id = d.id and d.state_id = query_table.id and #{ date_query }"
                when :negara_sumber
                    "countries query_table where t.fw_country_id = query_table.id and #{ date_query }"
                end

            report_query    = "
                with queried as (
                    select query_table.name as q_name,
                    sum(case when fw_plks_number = '0' then 1 else 0 end) new_reg,
                    sum(case when fw_plks_number not in ('0') or fw_plks_number is null then 1 else 0 end) renewal,
                    sum(case when fw_plks_number = '0' and final_result = 'SUITABLE' then 1 else 0 end) new_reg_suitable,
                    sum(case when (fw_plks_number not in ('0') or fw_plks_number is null) and final_result = 'SUITABLE' then 1 else 0 end) renewal_suitable,
                    sum(case when fw_plks_number = '0' and final_result = 'UNSUITABLE' then 1 else 0 end) new_reg_unsuitable,
                    sum(case when (fw_plks_number not in ('0') or fw_plks_number is null) and final_result = 'UNSUITABLE' then 1 else 0 end) renewal_unsuitable
                    from transactions t, #{ joined_query } and #{ date_query } and t.final_result is not null
                    group by q_name order by q_name
                )

                select * from queried
                union all
                select 'Total', coalesce(sum(new_reg), 0), coalesce(sum(renewal), 0), coalesce(sum(new_reg_suitable), 0),
                coalesce(sum(renewal_suitable), 0), coalesce(sum(new_reg_unsuitable), 0), coalesce(sum(renewal_unsuitable), 0)
                from queried"

            transactions    = ActiveRecord::Base.connection.execute(report_query)
        else
            transactions    = []
        end

        if type == :sektor
            sektor_bm_mapping = {
                "AGRICULTURE"   => "Pertanian",
                "CONSTRUCTION"  => "Pembinaan",
                "DOMESTIC"      => "Pembantu Rumah",
                "MANUFACTURING" => "Perkilangan",
                "PLANTATION"    => "Perladangan",
                "SERVICE"       => "Perkhidmatan",
                "MINING"        => "Perlombongan"
            }
        end

        transactions.each do |hash|
            all_totals  << hash.values[1..-1]

            insert_row =
                if type == :sektor && hash["q_name"] != "Total"
                    [sektor_bm_mapping[hash["q_name"]]] + hash.values[1..-1]
                else
                    hash.values
                end

            row_style =
                if hash["q_name"] == "Total"
                    styling(bold, border) + ([styling(bold, border(:b, :t)), styling(bold, border(:b, :t, :r))] * 3).flatten
                else
                    styling(border(:l, :r)) + ([{}, styling(border(:r))] * 3).flatten
                end

            worksheet   << { data: insert_row, style: row_style }
        end

        @merge_fields   = []
        @merge_fields   << ["A1:G1", "B2:C2", "D2:E2", "F2:G2"]
        @column_widths  = []
        @column_widths  << [28] + [18] * 6

        @filter_options = [
            { type: "select list", label: "Type", list: ["Transaction Date", "Certification Date"], field_name: :query_type },
            { type: "date range", label: "Date", min: "2019-01-01" }
        ]

        setting_html_display_limit(worksheet)
        parse_output_format("statistik_mengikut_#{ type }#{ timestamp }")
    end
end