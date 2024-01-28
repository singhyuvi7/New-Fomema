module ReportsMohMonthlyMedical
    def fomema2a_reports(mailer_params = nil) # Breakdown by districts.
        @parameters = params || mailer_params
        excel_setup_options
        load_state_list
        filters_for_state_and_month("FOMEMA2A") and return
        load_disease_list
        state_id            = State.find_by(name: @state).id
        towns               = Town.where(state_id: state_id).pluck(:name).sort
        transactions        = TransactionCertifyStatic.where(certify_date: @start_date.beginning_of_day..@end_date.end_of_day, doc_state_id: state_id)
        worksheet1          = build_fomema_worksheet_jumlah(worksheet1, "FOMEMA 2A")
        worksheet1          = tally_disease_numbers(worksheet1, transactions, towns, :doctor_town)
        worksheet1          = append_fomema_worksheet_footer(worksheet1)
        @excel              << worksheet1
        set_fomema_worksheet_settings
        parse_output_format("FOMEMA2A#{ @state_list[@state] }#{ @date.strftime("%Y%m") }")
    end

    def fomema2b_reports(mailer_params = nil) # Breakdown by states.
        @parameters = params || mailer_params
        report_2b_format("FOMEMA 2B", "FOMEMA2BPUT")
    end

    def fomema2b_cumulative_reports(mailer_params = nil) # Cumulative, start date is from start of the year.
        @parameters = params || mailer_params
        report_2b_format("FOMEMA 2B CUM", "CUM_FOMEMA2BPUT")
    end

    def fomema3a_reports(mailer_params = nil) # Breakdown by state & job types.
        @parameters = params || mailer_params
        excel_setup_options
        load_state_list
        filters_for_state_and_month("FOMEMA3A") and return
        load_disease_list
        state_id            = State.find_by(name: @state).id
        @job_map            = JobType.job_types_bahasa
        transactions        = TransactionCertifyStatic.where(certify_date: @start_date.beginning_of_day..@end_date.end_of_day, doc_state_id: state_id)
        worksheet1          = build_fomema_worksheet_jumlah(worksheet1, "FOMEMA 3A")
        worksheet1          = tally_disease_numbers(worksheet1, transactions, @job_map, :job_type)
        worksheet1          = append_fomema_worksheet_footer(worksheet1)
        @excel              << worksheet1
        set_fomema_worksheet_settings
        parse_output_format("FOMEMA3A#{ @state_list[@state] }#{ @date.strftime("%Y%m") }")
    end

    def fomema3b_reports(mailer_params = nil) # Breakdown by job types in the country.
        @parameters = params || mailer_params
        report_3b_format("FOMEMA 3B", "FOMEMA3BPUT")
    end

    def fomema3b_cumulative_reports(mailer_params = nil) # Cumulative, start date is from start of the year.
        @parameters = params || mailer_params
        report_3b_format("FOMEMA 3B CUM", "CUM_FOMEMA3BPUT")
    end

    def fomema4b_reports(mailer_params = nil) # Breakdown by country of origin.
        @parameters = params || mailer_params
        report_4b_format("FOMEMA 4B", "FOMEMA4BPUT")
    end

    def fomema4b_cumulative_reports(mailer_params = nil) # Cumulative, start date is from start of the year.
        @parameters = params || mailer_params
        report_4b_format("FOMEMA 4B CUM", "CUM_FOMEMA4BPUT")
    end
private
    def report_2b_format(type, filename)
        excel_setup_options
        filters_for_month(filename) and return
        load_state_list
        load_disease_list
        transactions        = TransactionCertifyStatic.where(certify_date: @start_date.beginning_of_day..@end_date.end_of_day)
        worksheet1          = build_fomema_worksheet_jumlah(worksheet1, type)
        worksheet1          = tally_disease_numbers(worksheet1, transactions, @state_list.keys, :doctor_state)
        worksheet1          = append_fomema_worksheet_footer(worksheet1)
        @excel              << worksheet1
        set_fomema_worksheet_settings
        parse_output_format("#{ filename }#{ @date.strftime("%Y%m") }")
    end

    def report_3b_format(type, filename)
        excel_setup_options
        filters_for_month(filename) and return
        load_disease_list
        @job_map            = JobType.job_types_bahasa
        transactions        = TransactionCertifyStatic.where(certify_date: @start_date.beginning_of_day..@end_date.end_of_day)
        worksheet1          = build_fomema_worksheet_jumlah(worksheet1, type)
        worksheet1          = tally_disease_numbers(worksheet1, transactions, @job_map, :job_type)
        worksheet1          = append_fomema_worksheet_footer(worksheet1)
        @excel              << worksheet1
        set_fomema_worksheet_settings
        parse_output_format("#{ filename }#{ @date.strftime("%Y%m") }")
    end

    def report_4b_format(type, filename)
        excel_setup_options
        filters_for_month(filename) and return
        load_disease_list
        transactions        = TransactionCertifyStatic.where(certify_date: @start_date.beginning_of_day..@end_date.end_of_day)
        worksheet1          = build_fomema_worksheet_jumlah(worksheet1, type)
        worksheet1          = tally_disease_numbers(worksheet1, transactions, nil, :country)
        worksheet1          = append_fomema_worksheet_footer(worksheet1)
        @excel              << worksheet1
        set_fomema_worksheet_settings
        parse_output_format("#{ filename }#{ @date.strftime("%Y%m") }")
    end

    def load_state_list
        @state_list = {
            "JOHOR" => "JHR",
            "KEDAH" => "KDH",
            "KELANTAN" => "KEL",
            "KUALA LUMPUR" => "KUL",
            "LABUAN" => "SBH",
            "MELAKA" => "MLK",
            "NEGERI SEMBILAN" => "NEG",
            "PAHANG" => "PHG",
            "PERAK" => "PRK",
            "PERLIS" => "PLS",
            "PULAU PINANG" => "PNG",
            "PUTRAJAYA" => "PUT",
            "SELANGOR" => "SEL",
            "TERENGGANU" => "TRG"
        }
    end

    def load_disease_list
        @diseases       = [:examined, :unsuitable, :tb, :hepb, :std, :hiv, :pregnant, :opiates, :cannabis, :psych, :malaria, :epilepsy, :leprosy, :cancer, :others, :total]
        @disease_tally  = Hash.new(0)
    end

    def excel_setup_options
        @excel              = [[["No results"]]]
    end

    def filters_for_state_and_month(filename)
        @filter_options     = [
            { type: "month select", label: "Date" },
            { type: "select list", label: "State", list: @state_list.keys, field_name: :selected_state }
        ]

        if @parameters[:selected_state].blank? ^ @parameters[:query_month].blank?
            flash.now[:notice] = "Please select a #{ @parameters[:selected_state].blank? ? "state" : "month" }"
            parse_output_format(filename) and return true
        elsif @parameters[:selected_state].blank? && @parameters[:query_month].blank?
            parse_output_format(filename) and return true
        end

        @state              = @parameters[:selected_state]
        @date               = @parameters[:query_month].to_date
        @start_date         = @date.beginning_of_month
        @end_date           = @date.end_of_month
        @excel              = []
        return false
    end

    def filters_for_month(filename)
        @filter_options     = [
            { type: "month select", label: "Date" }
        ]

        if @parameters[:query_month].blank?
            flash.now[:notice] = "Please select a month"
            parse_output_format("FOMEMA2BPUT") and return true
        end

        @date       = @parameters[:query_month].to_date
        @start_date = filename.include?("CUM_") ? @date.beginning_of_year : @date.beginning_of_month
        @end_date   = @date.end_of_month
        @excel      = []
        return false
    end

    def build_fomema_worksheet_jumlah(worksheet, code) # This part is fast, it just sets the headers.
        area_type = case code
            when "FOMEMA 2A"
                "Kawasan"
            when "FOMEMA 2B", "FOMEMA 2B CUM"
                "Negeri"
            when "FOMEMA 3A"
                "Sektor dan Kawasan"
            when "FOMEMA 3B", "FOMEMA 3B CUM"
                "Sektor"
            when "FOMEMA 4B", "FOMEMA 4B CUM"
                "Negara Sumber"
            end

        worksheet   =  [["PEMERIKSAAN PERUBATAN PEKERJA ASING"]]
        worksheet   << ["LAPORAN BULANAN JUMLAH PEKERJA ASING DIPERIKSA, BILANGAN TIDAK SESUAI DAN PECAHAN BILANGAN TIDAK SESUAI MENGIKUT #{ area_type.upcase }, MALAYSIA, #{ @date.year }"]
        worksheet   << []

        if ["Kawasan", "Sektor dan Kawasan"].include? area_type
            worksheet   << ["Negeri :", @state]
        else
            worksheet   << []
        end

        worksheet   << ["Laporan :", "#{ @start_date.strftime("%d-%b-%y") } hingga #{ @end_date.strftime("%d-%b-%y") }"]
        worksheet   << ["Tarikh Laporan Disediakan : ", "#{ Date.today.strftime("%d-%b-%y") } (Data Sementara / Provisional Data)"]
        worksheet   << ["Laporan Disediakan Oleh :", "#{@company_name}"]
        worksheet   << ["Kod Laporan :", code.split(" CUM")[0]]
        worksheet   << []

        worksheet   << {
            data:   [area_type == "Sektor dan Kawasan" ? "Sektor" : area_type, "Jumlah Diperiksa", "Bil. Tidak Sesuai", "Pecahan Kes Tidak Sesuai Mengikut Sebab", Array.new(12), "Jumlah"].flatten,
            style:  styling(bold, border) * 17
        }

        worksheet   << {
            data:   [Array.new(3), "TB (X-Ray Dada Abnormal)", "Ujian HBsAg Reaktif", "Ujian VDRL & TPHA Positif", "Ujian HIV Elisa Reaktif", "Ujian Kehamilan Positif", "Urin Opiat Positif", "Urin Kanabis Positif", "Penyakit Psikiatri", "Malaria", "Epilepsi", "Kusta", "Kanser", "Lain-lain*", nil].flatten,
            style:  styling(bold, border) * 17
        }

        return worksheet
    end

    def tally_disease_numbers(worksheet, transactions, keys, association)
        case association
        when :doctor_town
            totals  = query_for_2a_cases(transactions, keys)
        when :doctor_state
            totals  = query_for_2b_cases(transactions, keys)
        when :job_type
            totals  = query_for_3_cases(transactions, keys)
        when :country
            totals  = query_for_4b_cases(transactions, keys)
        end

        # If the array is empty, it may return nil if we try to get by range.
        totalled    = totals.transpose[1..-1] || []

        # Merging it together as grand total, and inserting into the worksheet.
        grand_total = ["JUMLAH", totalled.map {|column| column.sum }].flatten

        (totals + [grand_total]).each do |row|
            worksheet   << {
                data:   row,
                style:  styling(bold, border) * 17
            }
        end

        return worksheet
    end

    def query_for_2a_cases(transactions, keys)
        breakdown           = transactions.select("doc_town_id, count(*) examined", summing_sql_selects).group(:doc_town_id)
        town_to_name_hash   = Town.pluck(:id, :name).to_h

        town_totals_hash    = breakdown.map do |transaction|
            [town_to_name_hash[transaction.doc_town_id], @diseases.map {|disease| transaction.try(disease) }]
        end.to_h

        town_totals_hash.default = [0] * 16
        keys.map {|town_name| [town_name, town_totals_hash[town_name]].flatten }
    end

    def query_for_2b_cases(transactions, keys)
        breakdown           = transactions.select("doc_state_id, count(*) examined", summing_sql_selects).group(:doc_state_id)
        state_to_name_hash  = State.pluck(:id, :name).to_h

        state_totals_hash   = breakdown.map do |transaction|
            [state_to_name_hash[transaction.doc_state_id], @diseases.map {|disease| transaction.try(disease) }]
        end.to_h

        state_totals_hash.default = [0] * 16
        keys.map {|state_name| [state_name, state_totals_hash[state_name]].flatten }
    end

    def query_for_3_cases(transactions, keys)
        breakdown           = transactions.select("job_type, count(*) examined", summing_sql_selects).group(:job_type)

        job_totals_hash   = breakdown.map do |transaction|
            [transaction.job_type, @diseases.map {|disease| transaction.try(disease) }]
        end.to_h

        job_totals_hash.default = [0] * 16
        keys.map {|english, malay| [malay, job_totals_hash[english]].flatten }
    end

    def query_for_4b_cases(transactions, keys)
        breakdown               = transactions.select("country_id, count(*) examined", summing_sql_selects).group(:country_id)
        country_to_name_hash    = Country.pluck(:id, :name).to_h

        country_totals_hash     = breakdown.map do |transaction|
            [country_to_name_hash[transaction.country_id], @diseases.map {|disease| transaction.try(disease) }].flatten
        end.sort
    end

    def summing_sql_selects
        "sum(case when result = 'UNSUITABLE' and tcupi_ind = 'N' then 1 else 0 end) unsuitable,
            sum(case when result = 'UNSUITABLE' and tcupi_ind = 'N' then tuberculosis else 0 end) tb,
            sum(case when result = 'UNSUITABLE' and tcupi_ind = 'N' then hepatitis else 0 end) hepb,
            sum(case when result = 'UNSUITABLE' and tcupi_ind = 'N' then std else 0 end) std,
            sum(case when result = 'UNSUITABLE' and tcupi_ind = 'N' then hiv else 0 end) hiv,
            sum(case when result = 'UNSUITABLE' and tcupi_ind = 'N' then pregnant else 0 end) pregnant,
            sum(case when result = 'UNSUITABLE' and tcupi_ind = 'N' then opiates else 0 end) opiates,
            sum(case when result = 'UNSUITABLE' and tcupi_ind = 'N' then cannabis else 0 end) cannabis,
            sum(case when result = 'UNSUITABLE' and tcupi_ind = 'N' then psychiatric_disorder else 0 end) psych,
            sum(case when result = 'UNSUITABLE' and tcupi_ind = 'N' then malaria else 0 end) malaria,
            sum(case when result = 'UNSUITABLE' and tcupi_ind = 'N' then epilepsy else 0 end) epilepsy,
            sum(case when result = 'UNSUITABLE' and tcupi_ind = 'N' then leprosy else 0 end) leprosy,
            sum(case when result = 'UNSUITABLE' and tcupi_ind = 'N' then cancer else 0 end) cancer,
            sum(case when result = 'UNSUITABLE' and tcupi_ind = 'N' then other + hypertension + heart_diseases + bronchial_asthma + diabetes_mellitus + peptic_ulcer + kidney_diseases else 0 end) as others,
            sum(case when result = 'UNSUITABLE' and tcupi_ind = 'N' then tuberculosis + hepatitis + std + hiv + pregnant + opiates + cannabis + psychiatric_disorder + malaria + epilepsy + leprosy + cancer + other + hypertension + heart_diseases + bronchial_asthma + diabetes_mellitus + peptic_ulcer + kidney_diseases else 0 end) as total"
    end

    def append_fomema_worksheet_footer(worksheet)
        worksheet   << []
        worksheet   << ["Nota:"]
        worksheet   << ["1. Status pemeriksaan pekerja asing mungkin akan berubah dari masa ke semasa disebabkan oleh proses operasi."]
        worksheet   << ["2. Seorang pekerja boleh mempunyai lebih daripada satu sebab tidak sesuai."]
        worksheet   << ["3. *Lain-lain merangkumi penyakit kategori 2 seperti darah tinggi, kencing manis, penyakit jantung, penyakit ginjal dsb."]
        return worksheet
    end

    def set_fomema_worksheet_settings
        # Name of sheet.
        @worksheet_names        = ["Jumlah"]

        # Fields that are merged.
        @merge_fields           = []
        worksheet1_merge_fields = ["A10:A11", "B10:B11", "C10:C11", "Q10:Q11", "D10:P10"]
        @merge_fields           << worksheet1_merge_fields

        # Width of each column.
        @column_widths          = []
        worksheet1_widths       = [24, 17, 16, 25, 18, 20, 21, 16, 18, 16, 15, 6, 7, 9, 8]
        @column_widths          << worksheet1_widths

        if check_format_html
            @extended_headers   = 3

            # This is to specify which rows, and columns will need to be extended. -1 is the last row, of the body content. Please note, anything that is labelled as headers by @extended_headers will be omitted as body content. Please view reports_preview_table.html.erb for all the available options. :fill option merges all the columns on the right side with the current one. Please note, the logic only caters for 1 :fill per row.
            # The key is the row index, starting from 0 and the arrays represent the size of each columns for that row.
            # The row index counts from the first line of the array, which includes the headers. So count accordingly.
            # nil or empty strings will be automatically removed when checking the logic of column sizes.
            # For example, [1, 2, 3, nil, ""] will be collapsed to [1, 2, 3] if you use the @extended_customs for this array's row index.
            @extended_customs   = {
                3 => [3, :fill],
                4 => [3, :fill],
                5 => [3, :fill],
                6 => [3, :fill],
                7 => [3, :fill],
                8 => [:fill],
                9 => [1, 1, 1, 13, 1],
                -1 => [:fill],
                -2 => [:fill],
                -3 => [:fill],
                -4 => [:fill],
                -5 => [:fill]
            }
        end
    end
end