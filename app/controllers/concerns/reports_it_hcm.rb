module ReportsItHcm
    def total_workers_registered_by_branch
        worksheet   = [data: ["Total Workers Registered By Branch Users"], style: styling(bold)]

        # If dates are selected but branch is blank.
        if params[:filter_date_start].present? && params[:filter_date_end].present? && params[:branch_id].blank?
            flash.now[:notice] = "Please select a branch"
        end

        if params[:filter_date_start].present? && params[:filter_date_end].present? && params[:branch_id].present?
            start_date  = params[:filter_date_start].to_date
            end_date    = params[:filter_date_end].to_date.tomorrow
            branch_id   = params[:branch_id].to_i
            all_totals  = []
            timestamp   = "_#{ params[:filter_date_start] }_to_#{ params[:filter_date_end] }"

            users       = ActiveRecord::Base.connection.execute("select a.user_code, a.date,
                sum(a.registration) registration, sum(a.errors) errors from (
                select users.code user_code, fa.created_at::date date,
                0 registration, count(distinct(fwar.id)) errors
                from fw_amendments fa
                join foreign_worker_amendment_reasons fwar on fwar.foreign_worker_id = fa.foreign_worker_id
                join transactions t on t.foreign_worker_id = fa.foreign_worker_id and t.transaction_date > fa.created_at - INTERVAL '6 MONTHS'
                join amendment_reasons ar on ar.id = fwar.amendment_reason_id
                join foreign_workers fw on fw.id = fa.foreign_worker_id
                join users on users.id = fw.created_by
                join approval_items ai on ai.id = fa.approval_item_id
                join approval_requests arq on arq.id = ai.request_id
                where fa.created_at >= '#{ start_date }' and fa.created_at < '#{ end_date }'
                and users.code != 'ADMIN' and users.userable_type = 'Organization' and arq.approval_at is not null and ar.code = 'INPUT_ERROR' and fw.organization_id = #{ branch_id }
                group by user_code, date
                union all
                select users.code user_code, t.transaction_date::date date,
                count(*) registration, 0 errors
                from transactions t
                join users on users.id = t.created_by
                where t.transaction_date >= '#{ start_date }' and t.transaction_date < '#{ end_date }'
                and users.code != 'ADMIN' and users.userable_type = 'Organization' and t.organization_id = #{ branch_id }
                group by user_code, date) a
                group by user_code, date order by user_code, date")
        end

        if users.to_a.present?
            all_users   = users.map {|hash| hash["user_code"] }.uniq.sort
            all_dates   = users.map {|hash| hash["date"] }.uniq.sort
            sizing      = all_users.size * 2

            worksheet << {
                data: ["Date Registered", "Staff Name"] + [""] * (sizing - 1),
                style: styling(bold, border, align(:v, :h, :w), bg_color("a6a6a6")) * (sizing + 1)
            }

            worksheet << {
                data: [""] + all_users.map {|user| [user, ""] }.flatten,
                style: styling(bold, border, align(:v, :h, :w), bg_color("a6a6a6")) * (sizing + 1)
            }

            worksheet << {
                data: [""] + all_users.map {|user| ["Registration", "Error"] }.flatten,
                style: styling(bold, border, align(:v, :h, :w), bg_color("a6a6a6")) * (sizing + 1)
            }

            all_dates.each do |date|
                selected_rows   = users.select {|hash| hash["date"] == date }
                values_for_row  = []

                all_users.each do |user_code|
                    singular_row    = selected_rows.find {|hash| hash["user_code"] == user_code }
                    values          = singular_row.present? ? singular_row.values[2..-1] : [0, 0]
                    values_for_row  << values[0].to_i
                    values_for_row  << values[1].to_i
                end

                all_totals << values_for_row.map(&:to_i)

                worksheet << {
                    data: [date] + values_for_row,
                    style: styling(border(:l, :r), align(:h)) + ([styling(align(:h)), styling(border(:r), align(:h))] * all_users.size).flatten
                }
            end

            worksheet << {
                data: ["Total"] + all_totals.transpose.map(&:sum),
                style: styling(border, align(:h)) + ([styling(border(:t, :b), align(:h)), styling(border(:t, :b, :r), align(:h))] * all_users.size).flatten
            }

            alphabets       = ("A".."Z").to_a
            all_columns     = (sizing + 1).times.map {|i| prefix = (i / 26) - 1; [prefix < 0 ? nil : alphabets[prefix], alphabets[i % 26]].join }
            merge_options   = ["A1:#{ all_columns.last }1", "B2:#{ all_columns.last }2", "A2:A4"]
            merge_options   += all_users.size.times.map {|i| "#{ all_columns[i * 2 + 1] }3:#{ all_columns[i * 2 + 2] }3" }
            @merge_fields   = []
            @merge_fields   << merge_options
            @column_widths  = []
            @column_widths  << [18] + [13] * sizing
        end

        @filter_options = [
            { type: "date range", label: "Registration Date" },
            { type: "select list", label: "Branch", list: branch_query_options, field_name: :branch_id }
        ]

        setting_html_display_limit(worksheet)
        parse_output_format("total_workers_registered_by_branch#{ timestamp }")
    end

    def number_of_errors
        worksheet   = [data: ["Number Of Errors"], style: styling(bold)]

        # If dates are selected but branch is blank.
        if params[:filter_date_start].present? && params[:filter_date_end].present? && params[:branch_id].blank?
            flash.now[:notice] = "Please select a branch"
        end

        if params[:filter_date_start].present? && params[:filter_date_end].present? && params[:branch_id].present?
            start_date  = params[:filter_date_start].to_date
            end_date    = params[:filter_date_end].to_date.tomorrow
            branch_id   = params[:branch_id].to_i
            all_totals  = []
            timestamp   = "_#{ params[:filter_date_start] }_to_#{ params[:filter_date_end] }"

            users       = ActiveRecord::Base.connection.execute("select users.code,
                count(distinct(case when fad.field = 'name' then fad.id else null end)) as name,
                count(distinct(case when fad.field = 'date_of_birth' then fad.id else null end)) dob,
                count(distinct(case when fad.field = 'passport_number' then fad.id else null end)) passport,
                count(distinct(case when fad.field = 'country_id' then fad.id else null end)) country,
                count(distinct(case when fad.field = 'gender' then fad.id else null end)) as gender
                from fw_amendments fa
                join fw_amendment_details fad on fad.fw_amendment_id = fa.id
                join foreign_worker_amendment_reasons fwar on fwar.foreign_worker_id = fa.foreign_worker_id
                join transactions t on t.foreign_worker_id = fa.foreign_worker_id and t.transaction_date > fa.created_at - INTERVAL '6 MONTHS'
                join amendment_reasons ar on ar.id = fwar.amendment_reason_id
                join foreign_workers fw on fw.id = fa.foreign_worker_id
                join users on users.id = fw.created_by
                join approval_items ai on ai.id = fa.approval_item_id
                join approval_requests arq on arq.id = ai.request_id
                where fa.created_at >= '#{ start_date }' and fa.created_at < '#{ end_date }'
                and arq.approval_at is not null and users.code != 'ADMIN' and users.userable_type = 'Organization' and ar.code = 'INPUT_ERROR'
                and fw.organization_id = #{ branch_id }
                group by users.code")
        end

        if users.to_a.present?
            all_users   = users.map {|hash| hash["code"] }.uniq.sort
            sizing      = all_users.size
            categories  = ["name", "dob", "passport", "country", "gender"]
            labels      = ["Name", "Date Of Birth", "Passport No.", "Country Of Origin", "Gender"]

            worksheet << {
                data: ["Type / Of Errors / Staff Name", "Staff Name"] + [""] * (sizing - 1),
                style: styling(bold, border, align(:v, :h, :w), bg_color("e6b8b7")) * (sizing + 1)
            }

            worksheet << {
                data: [""] + all_users,
                style: styling(bold, border, align(:v, :h, :w), bg_color("e6b8b7")) * (sizing + 1)
            }

            worksheet << {
                data: ["FW's Information"],
                style: styling(bold, border, align(:v, :h, :w), bg_color("a6a6a6")) * (sizing + 1)
            }

            all_rows    = all_users.map do |user_code|
                selected_row    = users.find {|hash| hash["code"] == user_code }

                categories.map do |category|
                    value = selected_row[category]
                    value == 0 ? nil : value
                end
            end

            all_rows.transpose.each.with_index(0) do |row, index|
                all_totals << row.map {|value| value || 0 }

                worksheet << {
                    data: [labels[index]] + row,
                    style: styling(border(:l, :r), align(:h)) + styling(align(:h)) * (sizing - 1) + styling(border(:r))
                }
            end

            worksheet << {
                data: ["Total"] + all_totals.transpose.map(&:sum),
                style: styling(border, align(:h)) + styling(border(:t, :b), align(:h)) * (sizing - 1) + styling(border(:t, :r, :b), align(:h))
            }

            alphabets       = ("A".."Z").to_a
            all_columns     = (sizing + 1).times.map {|i| prefix = (i / 26) - 1; [prefix < 0 ? nil : alphabets[prefix], alphabets[i % 26]].join }
            @merge_fields   = []
            @merge_fields   << ["A1:#{ all_columns.last }1", "A2:A3", "B2:#{ all_columns.last }2", "A4:#{ all_columns.last }4"]
            @column_widths  = []
            @column_widths  << [18] + [20] * sizing
        end

        @filter_options = [
            { type: "date range", label: "Amendment Date" },
            { type: "select list", label: "Branch", list: branch_query_options, field_name: :branch_id }
        ]

        setting_html_display_limit(worksheet)
        parse_output_format("hcm_number_of_errors#{ timestamp }")
    end
private
    def branch_query_options
        CustomQueryOption.find_by(name: "HCM Report Branch List").query_options
    end
end