module ReportsXqccRadiographers
    def radiographer_monthly_summary_report
        worksheet   = [
            data: ["Radiographer Monthly Summary Report"],
            style: styling(bold)
        ]

        reviews             = []
        all_totals          = []
        @extended_headers   = 1

        if params[:query_month].present?
            start_date  = params[:query_month].to_date
            end_date    = start_date.next_month
            timestamp   = start_date.strftime("_%m-%Y")

            worksheet   = [
                data: ["Radiographer Monthly Summary Report for the month #{ start_date.strftime("%m-%Y") }"],
                style: styling(bold)
            ]

            reviews     = ActiveRecord::Base.connection.execute("select xr.transmitted_at::date date, users.username as name, count(*)
                from xray_reviews xr join users on users.id = xr.radiographer_id
                where xr.status = 'TRANSMITTED' and  xr.transmitted_at >= '#{ start_date }' and xr.transmitted_at < '#{ end_date }'
                group by date, users.username order by date, users.username")
        end

        if reviews.present?
            @extended_headers   = 2
            users               = reviews.map {|hash| hash["name"] }.uniq.sort.sort_by {|name| name == "NOREPLY" ? 1 : 0 }
            total_users         = users.size
            renamed_users       = users.map {|name| name == "NOREPLY" ? "Radiologist Released" : name }

            worksheet << {
                data: [""] + renamed_users + ["Total"],
                style: styling(bold, border) + styling(bold, border(:t, :b)) * total_users + styling(bold, border)
            }

            (start_date...end_date).each do |date|
                selected_rows   = reviews.select {|hash| hash["date"] == date.to_s }
                next if selected_rows.blank?

                user_values = users.map do |user_name|
                    value_row = selected_rows.find {|hash| hash["name"] == user_name }
                    value_row ? value_row["count"] : 0
                end

                all_totals << user_values + [user_values.sum]

                worksheet << {
                    data: [date.strftime("%d-%m-%Y")] + user_values + [user_values.sum],
                    style: styling(border(:l, :r)) + [{}] * total_users + styling(border(:l, :r))
                }
            end

            grand_total = all_totals.present? ? all_totals.transpose.map(&:sum) : [0] * (total_users + 1)

            worksheet << {
                data: ["Grand Total"] + grand_total,
                style: styling(bold, border) + styling(bold, border(:t, :b)) * total_users + styling(bold, border)
            }
        end

        if check_format_html
            headers_footers = 1
            total_size      = worksheet.size - headers_footers
            worksheet       = worksheet.first(500 + headers_footers)
            showing_size    = worksheet.size - headers_footers
            @displayed_size = "Showing #{ showing_size } out of #{ total_size } rows"
        end

        @excel          = [worksheet]
        @column_widths  = []
        @column_widths  << [13]
        @filter_options = [{ type: "month select", label: "Selected Month" }]
        parse_output_format("radiographer_monthly_summary_report#{ timestamp }")
    end

    def weekly_radiographer_receive_review_auto_release
        worksheet   = [data: ["WEEKLY RADIOGRAPHER RECEIVE, REVIEW AND AUTO RELEASE REPORT"], style: styling(bold)]

        if params[:filter_date_start].present? && params[:filter_date_end].present?
            start_date  = params[:filter_date_start].to_date
            end_date    = params[:filter_date_end].to_date.tomorrow
            all_totals  = []
            timestamp   = "_#{ params[:filter_date_start] }_to_#{ params[:filter_date_end] }"

            worksheet << {
                data: ["DATE", "RECEIVED", "REVIEWED", "AUTO RELEASED"],
                style: styling(border, bold) + styling(border(:t, :b), bold) * 2 + styling(border(:t, :b, :r), bold)
            }

            rows        = ActiveRecord::Base.connection.execute("select unioned.date,
                sum(unioned.receive) receive, sum(unioned.review) review, sum(unioned.auto_release) auto_release
                from (
                    select t.xray_transmit_date::date date, count(*) receive, 0 review, 0 auto_release from transactions t
                    where t.xray_transmit_date >= '#{ start_date }' and t.xray_transmit_date < '#{ end_date }'
                    group by date
                    union all
                    select xr.transmitted_at::date date, 0 receive, count(*) review, 0 auto_release from xray_reviews xr
                    where xr.transmitted_at >= '#{ start_date }' and xr.transmitted_at < '#{ end_date }'
                    group by date
                    union all
                    select xp.picked_up_at::date date, 0 receive, 0 review, count(1) auto_release
                    from xqcc_pools xp join users u on xp.picked_up_by = u.id
                    where u.email ilike 'noreply@fomema.com.my' and xp.picked_up_at >= '#{ start_date }' and xp.picked_up_at < '#{ end_date }'
                    group by date
                ) unioned group by unioned.date order by unioned.date")
        else
            rows        = []
        end

        rows.each do |row|
            values      = row.values[1..-1].map(&:to_i)
            all_totals  << values

            worksheet   << {
                data: [row["date"]] + values,
                style: styling(border(:l, :r)) + [{}] * 2 + styling(border(:r))
            }
        end

        if rows.present?
            grand_total = all_totals.present? ? all_totals.transpose.map(&:sum) : [0, 0, 0]

            worksheet << {
                data: ["TOTAL"] + grand_total,
                style: styling(border, bold) + styling(border(:t, :b), bold) * 2 + styling(border(:t, :b, :r), bold)
            }
        end

        @column_widths  = []
        @column_widths  << [22] + [16] * 3
        @filter_options = [{ type: "date range", label: "Date Range" }]
        setting_html_display_limit(worksheet)
        parse_output_format("weekly_radiographer_receive_review_auto_release#{ timestamp }")
    end
end