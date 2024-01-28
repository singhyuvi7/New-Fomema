module ReportsXqccNonCompliance
    def daily_non_compliance_report
        @non_compliance_facilities  = []

        @filter_options             = [
            { type: "select list", label: "Year", list: (2010..Date.today.year).to_a.reverse, field_name: :selected_year },
            { type: "select list", label: "Month", list: Date::MONTHNAMES.compact, field_name: :selected_month },
        ]

        if params[:selected_year].present?
            if params[:selected_month].present?
                start_date  = "01-#{ params[:selected_month] }-#{ params[:selected_year] }".to_date
                end_date    = start_date.next_month
            else
                start_date  = "01-01-#{ params[:selected_year] }".to_date
                end_date    = start_date.next_year
            end

            @non_compliance_facilities = ActiveRecord::Base.connection.execute("
            select xf.id, xf.code, xf.name, s.name as state, xr_month, non_comply, total, round(percentage::numeric, 2) from (
                    select xray_facility_id, xr_month, non_comply, total, non_comply::float / total * 100 percentage from (
                        select xray_facility_id, xr_month, sum(non_comply) non_comply, sum(total) total from (
                            select t.xray_facility_id, to_char(xr.transmitted_at, 'mm') xr_month, count(distinct(xr.id)) non_comply, 0 total
                            from xray_reviews xr join transactions t on t.id = xr.transaction_id
                            left join xray_review_details xrd on xrd.xray_review_id = xr.id
                            join conditions on conditions.id = xrd.condition_id
                            where xrd.text_value = 'Y' and xr.transmitted_at >= '#{ start_date }' and xr.transmitted_at < '#{ end_date }'
                            and t.transaction_date >= '#{ start_date }'::date - '1 year'::interval and t.transaction_date < '#{ end_date }'
                            and conditions.code not in ('6101', '6128', '6102', '6103', '6104', '6106', '6107', '6108', '6141', '6142', '6115')
                            group by t.xray_facility_id, xr_month
                            union all
                            select t.xray_facility_id, to_char(xr.transmitted_at, 'mm') xr_month, 0 non_comply, count(1) total
                            from xray_reviews xr join transactions t on t.id = xr.transaction_id
                            where xr.transmitted_at >= '#{ start_date }' and xr.transmitted_at < '#{ end_date }'
                            and t.transaction_date >= '#{ start_date }'::date - '1 year'::interval and t.transaction_date < '#{ end_date }'
                            group by t.xray_facility_id, xr_month
                        ) a group by xray_facility_id, xr_month
                    ) b where non_comply > 0 and total > 0
                ) c join xray_facilities xf on xf.id = c.xray_facility_id
                join states s on xf.state_id=s.id
                where percentage > 15.0 order by state")

        elsif params[:commit] == "Filter"
            flash[:notice] = "Please select Year"
        end
        respond_to do |format|
            format.html { render_dailynon_html }
            format.xlsx { render_dailnon_xlsx }
        end
        
        #@filter_options = [{ type: "month select", label: "Selected Month" }]
        #parse_output_format("radiographer_monthly_summary_report#{ timestamp }")
    end

    def render_dailynon_html
        render "internal/xqcc_reports/daily_non_compliance_report"
    end

    def render_dailnon_xlsx
        render xlsx: 'index', filename: "#{action_name.camelize}.xlsx",
            template: "internal/xqcc_reports/index"
    end

    def daily_non_compliance_report_download
        queries             = []
        queries             << "ID" if params[:id].blank?
        queries             << "Date" if params[:month].blank?
        render json: "#{ queries.join(" and ") } cannot be blank" and return if queries.present?
        @start_date         = "01-#{ params[:month] }-#{ params[:year] }".to_date
        end_date            = @start_date.next_month
        @date_range         = (@start_date...end_date).map {|date| date.day }
        @user               = XrayFacility.find_by(id: params[:id])
        render json: "Could not find user by ID: #{ params[:id] }" and return if @user.blank?
        xray_submissions    = XrayReview.joins(:transactionz).where(transmitted_at: @start_date...end_date, transactions: { xray_facility_id: @user.id }).where.not(batch_id: nil).count
        total_reviews       = params[:total].to_i
        non_compliance      = params[:non_comply].to_i

        rows                = ActiveRecord::Base.connection.execute("select a.day, conditions.code, xray_film_type, a.count from (
            select to_char(xr.transmitted_at, 'DD')::integer as day, xrd.condition_id, t.xray_film_type, count(1)
            from xray_reviews xr join transactions t on t.id = xr.transaction_id
            left join xray_review_details xrd on xrd.xray_review_id = xr.id
            where xrd.text_value = 'Y' and xr.transmitted_at >= '#{ @start_date }' and xr.transmitted_at < '#{ end_date }'
            and t.xray_facility_id = #{ @user.id }
            group by day, condition_id, xray_film_type order by day, condition_id, xray_film_type
        ) a join conditions on conditions.id = a.condition_id
        where code not in ('6101', '6128', '6102', '6103', '6104', '6106', '6107', '6108', '6141', '6142', '6115')")

        taken_query         = ActiveRecord::Base.connection.execute("select
            sum(case when conditions.code = '6125' and a.text_value = 'G' then 1 end) taken_by_gp,
            sum(case when conditions.code = '6125' and a.text_value = 'C' then 1 end) taken_by_cr,
            sum(case when conditions.code = '6126' and a.text_value = 'G' then 1 end) reported_by_gp,
            sum(case when conditions.code = '6126' and a.text_value = 'C' then 1 end) reported_by_cr
            from (
                select xrd.condition_id, xrd.text_value
                from xray_reviews xr join xray_review_details xrd on xrd.xray_review_id = xr.id
                join transactions t on t.id = xr.transaction_id
                where xrd.text_value in ('G', 'C') and xr.transmitted_at >= '#{ @start_date }' and xr.transmitted_at < '#{ end_date }'
                and t.xray_facility_id = #{ @user.id }
            ) a join conditions on conditions.id = a.condition_id")

        compliance          = total_reviews - non_compliance
        @taken_reported_by  = taken_query.first
        @film_types         = rows.map {|hash| hash["xray_film_type"] }.uniq
        load_criteria_list
        all_rows            = []

        @data = @criteria.map do |code, label|
            value_map   = rows.select {|hash| hash["code"] == code }.map {|hash| [hash["day"], hash["count"]] }.to_h
            values      = @date_range.map {|day| value_map[day] }
            total       = values.compact.sum
            all_rows    << values.map {|value| value || 0 } + [total]
            [label] + values + [total == 0 ? nil : total]
        end

        @data           << ["Grand Total"] + all_rows.transpose.map(&:sum).map {|value| value == 0 ? nil : value }
        totals          = @data[0..-1].map {|row| [row[0], row[-1]] }
        compliance_per  = total_reviews == 0 ? "0.00" : "%.2f" % (100 * compliance.to_f / total_reviews)
        ncompliance_per = total_reviews == 0 ? "0.00" : "%.2f" % (100 * non_compliance.to_f / total_reviews)

        @totals = {
            compliant:                          "#{ compliance } (#{ compliance_per }%)",
            non_compliant:                      "#{ non_compliance } (#{ ncompliance_per }%)",
            total_reviews:                      total_reviews,
            submissions:                        xray_submissions,
            "Total ID"                          => summed_values(totals, "ID - "),
            "Total Processing Procedure"        => summed_values(totals, "Processing Procedure - "),
            "Total Positioning Technique"       => summed_values(totals, "Positioning Technique - "),
            "Total Exposure"                    => summed_values(totals, "Exposure - "),
            "Total Artifacts"                   => summed_values(totals, "Artifacts - "),
            "Total Superimposed"                => summed_values(totals, "Superimposed - "),
            "Total Blur"                        => summed_values(totals, "Blur - "),
            "Total Primary Anatomical Marker"   => summed_values(totals, "Primary Anatomical Marker - ")
        }

        @total_categories = ["Total ID", "Total Positioning Technique", "Total Exposure", "Total Artifacts", "Total Superimposed", "Total Blur", "Total Primary Anatomical Marker"]
        @total_categories.insert(1, "Total Processing Procedure") if @film_types.include?("ANALOG")

        render pdf: "daily_non_compliance_report_download",
        template: "/internal/xqcc_reports/daily_non_compliance_report_download.html.erb",
        layout: "pdf.html",
        show_as_html: params[:debug].present?,
        margin: {
            top: "1.5cm",
            left: "2cm",
            right: "2cm",
            bottom: "2cm",
        },
        page_size: nil,
        page_height: "21cm",
        page_width: "29.7cm",
        dpi: "300",
        footer: { font_size: 8, spacing: 3, right: "Page " "[page] of [topage]" }
    end
private
    def load_criteria_list
        @criteria = {
            # "6101" => "ID - Incomplete",
            "6133" => "ID - Incomplete - Clinic name",
            "6134" => "ID - Incomplete - Worker name",
            "6135" => "ID - Incomplete - Transaction ID",
            "6136" => "ID - Incomplete - X-Ray taken date",
            # "6128" => "ID - Wrong",
            "6137" => "ID - Wrong - Clinic name",
            "6138" => "ID - Wrong - Worker name",
            "6139" => "ID - Wrong - Transaction ID",
            "6140" => "ID - Wrong - X-Ray taken date",
        }

        if @film_types.include?("ANALOG")
            @criteria.merge!(
                # "6102" => "ID - Not Clear",
                "6152" => "ID - Not Clear - Blur",
                "6153" => "ID - Not Clear - Fog",
                "6154" => "ID - Not Clear - Dark",
                # "6103" => "ID - Not Printed",
                "6155" => "ID - Not Printed - Handwritten",
                "6156" => "ID - Not Printed - Sticker",
                # "6104" => "Processing Procedure - Chemical defect",
                "6157" => "Processing Procedure - Chemical defect - Weak chemical",
                "6158" => "Processing Procedure - Chemical defect - Discoloration",
                "6159" => "Processing Procedure - Chemical defect - Stain",
                "6160" => "Processing Procedure - Chemical defect - Water mark",
                "6105" => "Processing Procedure - Chemical defect - Poor agitation",
                # "6106" => "Processing Procedure - Marks of film",
                "6161" => "Processing Procedure - Marks of film - Film guide mark",
                "6162" => "Processing Procedure - Marks of film - Scratches",
                # "6107" => "Processing Procedure - Fog",
                "6163" => "Processing Procedure - Fog - Partial fog",
                "6164" => "Processing Procedure - Fog - Base fog",
                # "6108" => "Processing Procedure - Screen defect",
                "6165" => "Processing Procedure - Screen defect - Dirty screen",
                "6166" => "Processing Procedure - Screen defect - Spoilt screen"
            )
        end

        @criteria.merge!(
            # "6141" => "Positioning Technique - ROI Cutoff",
            "6110" => "Positioning Technique - ROI Cutoff - Apices cut",
            "6111" => "Positioning Technique - ROI Cutoff - Chest wall cut",
            "6112" => "Positioning Technique - ROI Cutoff - CPA cut",
            "6113" => "Positioning Technique - ROI not clearly visualized - Rotation",
            # "6142" => "Positioning Technique - ROI not clearly visualized",
            "6143" => "Positioning Technique - ROI not clearly visualized - Angulation",
            "6144" => "Positioning Technique - ROI not clearly visualized - ID obscure apex",
            # "6115" => "Positioning Technique - Collimation",
            "6145" => "Positioning Technique - Collimation - Poor collimation",
            "6146" => "Positioning Technique - Collimation - No collimation",
            "6109" => "Positioning Technique - Scapular not retracted",
            "6120" => "Positioning Technique - Poor inspiratory effort",
            "6117" => "Exposure - Overexposed",
            "6118" => "Exposure - Underexposed",
            "6119" => "Artifacts - Processing artifacts",
            "6131" => "Artifacts - Poor handling artifacts",
            "6147" => "Superimposed - Same thoracic cage",
            "6148" => "Superimposed - Different thoracic cage"
        )

        @criteria.merge!("6149" => "Primary Anatomical Marker - Wrong Placement") if @film_types.include?("DIGITAL")

        @criteria.merge!(
            "6150" => "Primary Anatomical Marker - Not available",
            "6121" => "Blur - Movement",
            "6132" => "Blur - Breathing",
        )

        @criteria.merge!("6130" => "Improper Report") if @film_types.include?("ANALOG")
        @criteria.merge!("6151" => "No Diagnostic Value")
    end

    def summed_values(array, title)
        array.map {|key, value| value if key.include?(title) }.compact.sum
    end
end