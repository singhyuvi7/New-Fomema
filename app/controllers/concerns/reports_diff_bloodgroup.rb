module ReportsDiffBloodgroup
    def different_blood_group_by_doctor
        generate_report_for_different_blood_groups("doctor")
    end

    def different_blood_group_by_lab
        generate_report_for_different_blood_groups("lab")
    end
private
    def generate_report_for_different_blood_groups(type)
        @data = Hash.new

        if params[:selected_year].present?
            start_date          = "#{ params[:selected_year] }-01-01".to_date
            end_date            = start_date.next_year
            timestamp           = "_year_#{ start_date.year }"
            time_placeholder    = " with Year #{start_date.year }"
            date_based_query    = "rdb.certification_date >= '#{ start_date }' and rdb.certification_date < '#{ end_date }'"
        end

        if params[:search_code].present?
            search_user             = ActiveRecord::Base.connection.quote("#{ params[:search_code] }")
            searched_placeholder    = " by (#{ params[:search_code] })"
            user_based_query        = "rdb.#{ type }_code_3 = #{ search_user }"
        end

        if date_based_query.present? || user_based_query.present?
            where_query = [date_based_query, user_based_query].compact.join(" and ")

            cases       = ActiveRecord::Base.connection.execute("select rdb.foreign_worker_code, rdb.foreign_worker_name,
                rdb.#{ type }_code_1 , rdb.blood_group_1,
                rdb.#{ type }_code_2 , rdb.blood_group_2,
                rdb.#{ type }_code_3 , rdb.blood_group_3
                from report_diff_bloodgroups rdb where #{ where_query }")

            @data[:header]      = "Different Blood Group Report#{ time_placeholder }#{ searched_placeholder }"

            worksheet           = [
                data: [@data[:header]],
                style: styling(bold)
            ]

            worksheet           << {
                data: ["No.", "Worker Code", "Name", "ME1", "", "ME2", "", "ME3", ""],
                style: styling(bold, border, align(:v, :h)) * 9
            }

            worksheet           << {
                data: ["", "", ""] + ["#{ type.capitalize } Code", "Blood Group"] * 3,
                style: styling(bold, border, align(:v, :h)) * 9
            }

            @extended_headers   = 3
        else
            cases               = []
            worksheet           = [["Different Blood Group Report"]]
        end

        # I have kept this here for reference, since this is the only pdf template for reports.
        # if params[:format] == "pdf"
        #     @company_name       = "FOMEMA SDN. BHD."
        #     @data[:date_today]  = Date.today.strftime("%d-%m-%Y")
        #     @data[:time_today]  = Time.now.strftime("%-l:%M:%S %p")
        #     @data[:user_type]   = type.capitalize
        #     @rows               = cases

        #     render pdf: "different_blood_group_by_#{ type }#{ timestamp }#{ searched_placeholder }",
        #         template: "/pdf_templates/diff_blood_group_report.html.erb",
        #         layout: "pdf.html",
        #         margin: {
        #             top: 14,
        #             left: 14,
        #             right: 14,
        #             bottom: 14,
        #         },
        #         page_size: nil,
        #         page_height: "21cm",
        #         page_width: "29.7cm",
        #         dpi: "300",
        #         show_as_html: params[:debug].present?,
        #         header: {
        #             html: {
        #                 template: '/pdf_templates/appeal_report_summary_header'
        #             }
        #         }
        # else
            # @download_format    = :pdf # This is to allow pdf download option.

            cases.each.with_index(1) do |row, index|
                worksheet << {
                    data: [index] + row.values,
                    style: styling(border(:l, :r)) + [{}] * 7 + styling(border(:r))
                }
            end

            if params[:format] == "xlsx"
                worksheet << {
                    data: [""] * 9,
                    style: styling(border(:t)) * 9
                }
            end

            @filter_options     = [
                { type: "select list",  label: "Year", list: (2012..Date.today.year), field_name: :selected_year },
                { type: "text field",   label: "#{ type.capitalize } Code", field_name: :search_code, placeholder: "Code" }
            ]

            setting_html_display_limit(worksheet)
            @merge_fields   = []
            @merge_fields   << ["A1:I1", "D2:E2", "F2:G2", "H2:I2", "A2:A3", "B2:B3", "C2:C3"]
            @column_widths  = []
            @column_widths  << [8, 16, 40] + [16] * 6
            parse_output_format("different_blood_group_by_#{ type }#{ timestamp }#{ searched_placeholder }")
        # end
    end
end