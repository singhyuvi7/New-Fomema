module ReportsBranchPatiMonthly
    def pati_registration_monthly_country_by_month
        pati_registration_template_1(:country)
    end

    def pati_registration_monthly_branch_by_month
        pati_registration_template_1(:branch)
    end
private
    def pati_registration_template_1(type)
        case type
        when :country
            title   = "REGISTRATION (PATI) BY COUNTRY (BY MONTH)"
            column  = "countries.name"
            joining = "join countries on countries.id = t.fw_country_id"
        when :branch
            title   = "REGISTRATION (PATI) BY BRANCH / FOMEMA AGENT / WEB PORTAL (BY MONTH)"
            column  = "org.name"
            joining = "join organizations org on org.id = t.organization_id"
        end

        worksheet   = [data: [title], style: styling(bold)]

        if params[:selected_year].present?
            date            = "#{ params[:selected_year] }-01-01".to_date
            end_date        = date.next_year
            start_date      = end_date - 3.years
            timestamp       = "_#{ date.year }"
            year_list       = 3.times.map {|i| (start_date + i.years).year }.reverse
            final_year      = year_list.last
            all_totals      = []

            transactions    = ActiveRecord::Base.connection.execute("select to_char(t.transaction_date, 'YYYY')::integer as year,
                #{ column },
                sum(case when to_char(t.transaction_date, 'MM') = '01' then 1 else 0 end) jan,
                sum(case when to_char(t.transaction_date, 'MM') = '02' then 1 else 0 end) feb,
                sum(case when to_char(t.transaction_date, 'MM') = '03' then 1 else 0 end) mar,
                sum(case when to_char(t.transaction_date, 'MM') = '04' then 1 else 0 end) apr,
                sum(case when to_char(t.transaction_date, 'MM') = '05' then 1 else 0 end) may,
                sum(case when to_char(t.transaction_date, 'MM') = '06' then 1 else 0 end) jun,
                sum(case when to_char(t.transaction_date, 'MM') = '07' then 1 else 0 end) jul,
                sum(case when to_char(t.transaction_date, 'MM') = '08' then 1 else 0 end) aug,
                sum(case when to_char(t.transaction_date, 'MM') = '09' then 1 else 0 end) sep,
                sum(case when to_char(t.transaction_date, 'MM') = '10' then 1 else 0 end) oct,
                sum(case when to_char(t.transaction_date, 'MM') = '11' then 1 else 0 end) nov,
                sum(case when to_char(t.transaction_date, 'MM') = '12' then 1 else 0 end) as dec,
                count(*)
                from transactions t join doctor_examinations de on de.transaction_id = t.id
                #{ joining }
                where de.transmitted_at is not null and t.transaction_date >= '#{ start_date }' and t.transaction_date < '#{ end_date }' and t.fw_pati = true
                group by year, name order by year, name")
        else
            year_list       = []
        end

        year_list.each do |year|
            rows        = transactions.select {|hash| hash["year"] == year }
            all_totals  = []
            worksheet   << [""]
            worksheet   << {data: ["YEAR #{ year }"], style: styling(bold)}

            worksheet << {
                data: [type.upcase, "JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER", "TOTAL"],
                style: styling(bold, border) + styling(bold, border(:t, :b)) * 12 + styling(bold, border)
            }

            rows.each do |row|
                row_total   = row.values[2..-1]
                all_totals  << row_total

                worksheet << {
                    data: row.values[1..-1],
                    style: styling(border(:l, :r)) + [{}] * 12 + styling(border(:l, :r))
                }
            end

            summation = all_totals.present? ? all_totals.transpose.map(&:sum) : [0] * 13

            worksheet << {
                data: ["TOTAL"] + summation,
                style: styling(border) + styling(border(:t, :b)) * 12 + styling(border)
            }
        end

        @column_widths  = []
        @column_widths  << [28] + [18] * 3
        @filter_options = [{ type: "select list", label: "Year", list: (2000..Date.today.year), field_name: :selected_year }]
        setting_html_display_limit(worksheet)
        parse_output_format("pati_registration_monthly_#{ type }_by_month#{ timestamp }")
    end
end