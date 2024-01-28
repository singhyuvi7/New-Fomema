module ReportsMedicalWrongTransmissions
    def wrong_transmission_doctor
        transmissions_query(:doctor)
    end

    def wrong_transmission_lab
        transmissions_query(:lab)
    end

    def wrong_transmission_xray
        transmissions_query(:xray)
    end

private
    def transmissions_query(type)
        ta_query    = []
        tru_query   = []
        tr_query    = []

        if params[:filter_date_start].present? && params[:filter_date_end].present?
            start_date  = params[:filter_date_start].to_date
            end_date    = params[:filter_date_end].to_date.tomorrow
            ta_query    << "ta.approval_at >= '#{ start_date }' and ta.approval_at < '#{ end_date }'"
            tru_query   << "tru.created_at >= '#{ start_date }' and tru.created_at < '#{ end_date }'"
            tr_query    << "tr.created_at >= '#{ start_date }' and tr.created_at < '#{ end_date }'"
        end

        if params[:sp_code].present?
            provider_query  = "provider.code = #{ ActiveRecord::Base.connection.quote params[:sp_code] }"
            ta_query        << provider_query
            tru_query       << provider_query
            tr_query        << provider_query
        end

        case type
        when :doctor
            provider_select = "concat(provider.code, ' - ', provider.clinic_name)"
            provider_join   = "doctors provider on provider.id = t.doctor_id"
            reversion_type  = "Examination Date"
        when :lab
            provider_select = "concat(provider.code, ' - ', provider.name)"
            provider_join   = "laboratories provider on provider.id = t.laboratory_id"
            reversion_type  = "LaboratoryExamination"
        when :xray
            provider_select = "concat(provider.code, ' - ', provider.name)"
            provider_join   = "xray_facilities provider on provider.id = t.xray_facility_id"
            reversion_type  = "XrayExamination"
        end

        worksheet       = [["No", "Date", "Code & Name Of Service Providers", "Issues", "Worker Name", "Worker Code", "Transaction Code", "Cases", "Updated By"]]
        transmissions   = []

        if ta_query.present?
            transmissions   = ActiveRecord::Base.connection.execute("(select ta.approval_at as date, #{ provider_select } provider, ta.amendment_reason issues, t.fw_name, t.fw_code, t.code, 'AMENDED' cases, u.username
                from transaction_amendments ta join transactions t on t.id = ta.transaction_id join #{ provider_join } join users u on u.id = ta.updated_by
                where ta.wrong_transmission_#{ type } = 't' and ta.approval_status = 'CONCURRED' and #{ ta_query.join(" and ") }
                union all
                select tru.created_at as date, #{ provider_select } provider, tru.amendment_reason issues, t.fw_name, t.fw_code, t.code, 'UPDATED' cases, u.username
                from transaction_result_updates tru join transactions t on t.id = tru.transaction_id join #{ provider_join } join users u on u.id = tru.updated_by
                where tru.wrong_transmission_#{ type } = 't' and #{ tru_query.join(" and ") }
                union all
                select tr.created_at as date, #{ provider_select } provider, tr.issues issues, t.fw_name, t.fw_code, t.code, 'DELETED' cases, u.username
                from transaction_reversions tr join transactions t on t.id = tr.transaction_id join #{ provider_join } join users u on u.id = tr.updated_by
                where tr.exam_type = '#{ reversion_type }' and #{ tr_query.join(" and ") }) order by date")
        end

        transmissions.each.with_index(1) do |row, index|
            worksheet << {
                data: [
                    index,
                    format_date(row["date"]),
                    row.values[1..-1]
                ].flatten,
                style: [{}] * 1 + styling(excel_date) + [{}] * 6,
                types: ([:string] * 7).insert(1, *[:date] * 1)
            }
        end

        @filter_options = [{ type: "date range",   label: "Date Range" }]
        @filter_options << { type: "text field",   label: "SP Code", field_name: :sp_code, placeholder: "Code" } if params[:controller] == "internal/mspd_reports"
        setting_html_display_limit(worksheet)
        parse_output_format("wrong_transmission_report_for_#{ type }")
    end
end