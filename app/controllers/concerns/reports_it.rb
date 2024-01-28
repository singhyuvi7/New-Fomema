module ReportsIT
    def insurances 
        @csv = [[]]
        render template: "internal/reports/it/insurances/index.html"
    end

    def daily_getbiodata_report
        date = params[:date]

        hours = []
        default_hour_count = []
        @new_responses = []
        @total_cells = []
        responses = {}
        @column_hours = ["","", "","0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23",""]

        (0..23).each do |i|
            hours.push("#{i.to_s}.0")
            default_hour_count.push(0)
        end

        (0..27).each do |i|
            if i == 2
                @total_cells.push("Total")
            else
                @total_cells.push("")
            end
        end

        if date.present?
            date = date.to_date

            responses = BiodataResponse.select('DISTINCT ON (status_code,status_message,description) status_code,status_message,description').where.not(status_code: nil).where('created_at BETWEEN ? AND ?', date.beginning_of_day, date.end_of_day).order('status_message ASC, status_code ASC')
        end
        
        responses.each do |response|

            row = [response.status_code,response.status_message,response.description]
            hour_count = default_hour_count

            if date.present?
                data = BiodataResponse
                .select(Arel.sql('EXTRACT(HOUR from created_at)'))
                .where(:description => response.description)
                .where('created_at BETWEEN ? AND ?', date.beginning_of_day, date.end_of_day)
                .group(Arel.sql('EXTRACT(HOUR FROM created_at)'))
                .order(Arel.sql('EXTRACT(HOUR from created_at)'))
                .count

                data.each do |key,value|
                    index = hours.find_index(key.to_s)
                    hour_count = hour_count.each_with_index.map { |x,i| i == index ? value : x }
                end
            end

            total_count_per_error = hour_count.sum

            row += hour_count+[total_count_per_error]
            @new_responses << row
        end

        @total_cell_index = 2+@new_responses.count # title cell till (2) + total error count

        respond_to do |format|
            format.html { render "internal/reports/it/daily_getbiodata/index.html" }
            format.xlsx { render xlsx: "daily_getbiodata_report" , filename: "daily_getbiodata_report(#{date}).xlsx", template: 'internal/reports/it/daily_getbiodata/daily_getbiodata_report' }
        end

    end

    def daily_thumbprint_tested
        # only take the latest 
        service_provider = params[:service_provider] # Doctor or XrayFacility
        start_date = params[:start_date]
        end_date = params[:end_date]

        @sp = service_provider == Doctor.to_s ? 'Clinic' : 'Xray'

        @response_by_dates = []
        @response_by_states = []
        default_by_state = ['',0,0,0,0,0,0,0,0,0]
        total_by_date = 0
        below_threshold_code = BypassFingerprintReason.find_by(code: 'BT').try(:id)
        not_matching_code = BypassFingerprintReason.find_by(code: 'MNF').try(:id)

        titles = ['date','success','success_pct','bt','bt_pct','nm','nm_pct','others','others_pct','total']
        
        index_total = titles.find_index('total')
        states = State.select('id','name').order('name ASC').all

        if start_date.present? && end_date.present?
            @start_date = start_date.to_date
            @end_date = end_date.to_date

            trans = Transaction

            if service_provider == 'Doctor'
                response_by_states = trans.joins(:doctor)
                .joins("JOIN states ON doctors.state_id = states.id")
                .select("states.name as state,
                sum(case when doctor_fp_result = 1 then 1 else 0 end) as success_count,
                sum(case when doctor_fp_result != 1 and doctor_bypass_fingerprint_reason_id = #{below_threshold_code} then 1 else 0 end) as below_threshold_count,
                sum(case when doctor_fp_result != 1 and doctor_bypass_fingerprint_reason_id = #{not_matching_code} then 1 else 0 end) as not_matching_count,
                sum(case when doctor_fp_result != 1 and doctor_bypass_fingerprint_reason_id not in (#{not_matching_code},#{below_threshold_code}) then 1 else 0 end) as others_count")
                .where('worker_identity_confirmed = true and transactions.transaction_date BETWEEN ? AND ?', @start_date.beginning_of_day, @end_date.end_of_day)

                response_by_dates = trans.select("DATE(transactions.transaction_date) as trans_date,
                sum(case when doctor_fp_result = 1 then 1 else 0 end) as success_count,
                sum(case when doctor_fp_result != 1 and doctor_bypass_fingerprint_reason_id = #{below_threshold_code} then 1 else 0 end) as below_threshold_count,
                sum(case when doctor_fp_result != 1 and doctor_bypass_fingerprint_reason_id = #{not_matching_code} then 1 else 0 end) as not_matching_count,
                sum(case when doctor_fp_result != 1 and doctor_bypass_fingerprint_reason_id not in (#{not_matching_code},#{below_threshold_code}) then 1 else 0 end) as others_count")
                .where('worker_identity_confirmed = true and transactions.transaction_date BETWEEN ? AND ?', @start_date.beginning_of_day, @end_date.end_of_day)
            else
                response_by_states = trans.joins(:xray_facility)
                .joins("JOIN states ON xray_facilities.state_id = states.id")
                .select("states.name as state,
                sum(case when xray_fp_result = 1 then 1 else 0 end) as success_count,
                sum(case when xray_fp_result != 1 and xray_bypass_fingerprint_reason_id = #{below_threshold_code} then 1 else 0 end) as below_threshold_count,
                sum(case when xray_fp_result != 1 and xray_bypass_fingerprint_reason_id = #{not_matching_code} then 1 else 0 end) as not_matching_count,
                sum(case when xray_fp_result != 1 and xray_bypass_fingerprint_reason_id not in (#{not_matching_code},#{below_threshold_code}) then 1 else 0 end) as others_count")
                .where('xray_worker_identity_confirmed = true and transactions.transaction_date BETWEEN ? AND ?',  @start_date.beginning_of_day, @end_date.end_of_day)

                response_by_dates = trans.select("DATE(transactions.transaction_date) as trans_date,
                sum(case when xray_fp_result = 1 then 1 else 0 end) as success_count,
                sum(case when xray_fp_result != 1 and xray_bypass_fingerprint_reason_id = #{below_threshold_code} then 1 else 0 end) as below_threshold_count,
                sum(case when xray_fp_result != 1 and xray_bypass_fingerprint_reason_id = #{not_matching_code} then 1 else 0 end) as not_matching_count,
                sum(case when xray_fp_result != 1 and xray_bypass_fingerprint_reason_id not in (#{not_matching_code},#{below_threshold_code}) then 1 else 0 end) as others_count")
                .where('xray_worker_identity_confirmed = true and transactions.transaction_date BETWEEN ? AND ?',  @start_date.beginning_of_day, @end_date.end_of_day)
            end

            response_by_states = response_by_states.group('state')
            .order('state ASC')

            response_by_dates = response_by_dates.group('trans_date')

            response_by_states.each do |response_by_state|
                total = [response_by_state.success_count, response_by_state.below_threshold_count, response_by_state.not_matching_count, response_by_state.others_count].sum

                success_count_pct = calc_percentage(response_by_state.success_count,total)
                below_threshold_count_pct = calc_percentage(response_by_state.below_threshold_count,total)
                not_matching_count_pct = calc_percentage(response_by_state.not_matching_count,total)
                others_count_pct = calc_percentage(response_by_state.others_count,total)

                @response_by_states << [response_by_state.state, response_by_state.success_count, success_count_pct,response_by_state.below_threshold_count,below_threshold_count_pct, not_matching_count_pct, response_by_state.not_matching_count, response_by_state.others_count, others_count_pct, total]
            end

            response_by_dates.each do |response_by_date| 
                total = [response_by_date.success_count, response_by_date.below_threshold_count, response_by_date.not_matching_count, response_by_date.others_count].sum

                success_count_pct = calc_percentage(response_by_date.success_count,total)
                below_threshold_count_pct = calc_percentage(response_by_date.below_threshold_count,total)
                not_matching_count_pct = calc_percentage(response_by_date.not_matching_count,total)
                others_count_pct = calc_percentage(response_by_date.others_count,total)

                @response_by_dates << [response_by_date.trans_date.to_s, response_by_date.success_count, success_count_pct,response_by_date.below_threshold_count,below_threshold_count_pct, not_matching_count_pct, response_by_date.not_matching_count, response_by_date.others_count, others_count_pct, total]
            end

            ## total daily
            total_success_count = response_by_states.sum(&:success_count)
            total_below_threshold_count = response_by_states.sum(&:below_threshold_count)
            total_not_matching_count = response_by_states.sum(&:not_matching_count)
            total_others_count = response_by_states.sum(&:others_count)

            grand_total = [total_success_count, total_below_threshold_count, total_not_matching_count, total_others_count].sum
            total_success_count_pct = calc_percentage(total_success_count,grand_total)
            total_below_threshold_count_pct = calc_percentage(total_below_threshold_count,grand_total)
            total_not_matching_count_pct = calc_percentage(total_not_matching_count,grand_total)
            total_others_count_pct = calc_percentage(total_others_count,grand_total)
        end

        respond_to do |format|
            format.html { render "internal/reports/it/daily_fingerprint_tested/index.html" }
            format.xlsx { render xlsx: "thumbprint_tested_report" , filename: "thumbprint_tested_report.xlsx", template: 'internal/reports/it/daily_fingerprint_tested/thumbprint_tested_report' }
        end
    end

    def insurance_purchase
        start_date = params[:purchase_date_start]
        end_date = params[:purchase_date_end].to_date
        insurance_provider = params[:insurance_provider]

        if start_date.present?
            start_date = start_date.to_date.beginning_of_day
        end

        if end_date.present? 
            end_date = end_date.to_date.end_of_day
        end

        insurance_purchases = InsurancePurchase.includes(:employer).where(:created_at => start_date..end_date)

        if insurance_provider.present?
            insurance_purchases = insurance_purchases.where(:insurance_provider => insurance_provider)
        end

        # render json: insurance_purchases

        @csv            = [["No", "Batch ID", "Employer Code", "Worker Name", "Product Name","Start Date","End Date","Provider","Purchased Date"]]

        insurance_purchases.each.with_index(1) do |insurance_purchase, index|

            provider = ForeignWorker::INSURANCE.find { |insurance| insurance['ins_id'] == insurance_purchase.insurance_provider }

            @csv << [
                index,
                insurance_purchase.batch_id,
                insurance_purchase.employer.try(:code),
                insurance_purchase.fw_name,
                insurance_purchase.product_purchased,
                insurance_purchase.start_date,
                insurance_purchase.end_date,
                provider.present? ? provider['name'] : '',
                insurance_purchase.created_at? ? insurance_purchase.created_at.strftime("%F") : nil
            ]
        end

        insurance_render("insurance_purchase")
    end

    def summary_insurance_purchase
        start_date = params[:purchase_date_start]
        end_date = params[:purchase_date_end].to_date

        if start_date.present?
            start_date = start_date.to_date.beginning_of_day
        end

        if end_date.present? 
            end_date = end_date.to_date.end_of_day
        end


        insurances = ForeignWorker::INSURANCE
        header = ["Provider", "FWIG", "FWHS", "FWCS", "FWPA","Grand Total"]
        default_row = [0,0,0,0,0]
        @csv            = [header]
        total_fwig = 0
        total_fwhs = 0
        total_fwcs = 0
        total_fwpa = 0

        insurances.as_json.each{|insurance|

            row = default_row
            total = 0

            data = InsurancePurchase
            .select('product_purchased')
            .where(:insurance_provider => insurance['ins_id'])
            .where(:created_at => start_date..end_date)
            .group(:product_purchased)
            .count
            
            data.each do |key,value|
                index = header.find_index(key)
                if index.present?
                    row = row.each_with_index.map { |x,i| i == (index-1) ? value : x }
                    total += value

                    case key
                    when 'FWIG' 
                        total_fwig += value
                    when 'FWHS'
                        total_fwhs += value
                    when 'FWCS'
                        total_fwcs += value
                    when 'FWPA'
                        total_fwpa += value
                    end
                end
            end
            row[row.count-1] = total
            @csv << [insurance['name']]+row
        }

        grand_total_row = [total_fwig,total_fwhs,total_fwcs,total_fwpa]
        grand_total = grand_total_row.sum
        grand_total_row += [grand_total]
        @csv << ['Grand Total']+grand_total_row
        
        insurance_render("summary_insurance_purchase")
    end

    def insurance_purchased_daily
        start_date = params[:purchase_date_start]
        end_date = params[:purchase_date_end]

        header = ["Purchase Date", "TUNE", "QBE", "CHUBB","Grand Total"]
        @csv = [header]
        row_code = ['001','002','003','total']
        default_row = [0,0,0,0]
        total_tune = 0
        total_qbe = 0
        total_chubb = 0

        if start_date.present? && end_date.present?
            (start_date.to_date..end_date.to_date).each do |day|

                row = default_row
                total = 0

                data = InsurancePurchase
                .select('insurance_provider')
                .where(:created_at => day.beginning_of_day...day.end_of_day)
                .group(:insurance_provider)
                .count

                data.each do |key,value|
                    index = row_code.find_index(key)
                    if index.present?
                        row = row.each_with_index.map { |x,i| i == index ? value : x }
                        total += value

                        case key
                        when '001' 
                            total_tune += value
                        when '002'
                            total_qbe += value
                        when '003'
                            total_chubb += value
                        end
                    end
                end
                row[row.count-1] = total
                @csv << [day]+row
            end

            grand_total_row = [total_tune,total_qbe,total_chubb]
            grand_total = grand_total_row.sum
            grand_total_row += [grand_total]
            @csv << ['Grand Total']+grand_total_row
        end

        insurance_render("insurance_purchased_daily")
    end

    def daily_afisid_report
        generate_afisid_report_data

        respond_to do |format|
            format.html { render "internal/reports/it/daily_afisid_report/index.html" }
            format.xlsx { render xlsx: "daily_afisid_report" , filename: "Daily Get AFIS ID As Of #{@now.strftime("%d-%b-%Y %H:%M")}.xlsx", template: 'internal/reports/it/daily_afisid_report/daily_afisid_report' }
        end
    end

    def daily_biometric_report
        generate_biometric_report_data

        respond_to do |format|
            format.html { render "internal/reports/it/daily_biometric_report/index.html" }
            format.xlsx { render xlsx: "daily_biometric_report" , filename: "Daily Biometric Report As Of #{@now.strftime("%d-%b-%Y %H:%M")}.xlsx", template: 'internal/reports/it/daily_biometric_report/daily_biometric_report' }
        end
    end

    def generate_biometric_report_data

        @now = Time.now
        @report_end_date = Date.yesterday
        beginning_of_current_month = @report_end_date.beginning_of_month()
        @biometric_title = ['DATE','HAVE ID NORMAL','HAVE ID REKAB','HAVE ID','%','NO ID NORMAL','NO ID REKAB','NO ID','%','NO BIODATA NORMAL','NO BIODATA REKAB','NO BIODATA','%','TOTAL']
        @biometric_start_to_current_title = ['TOTAL','HAVE ID NORMAL','HAVE ID REKAB','HAVE ID','%','NO ID NORMAL','NO ID REKAB','NO ID','%','NO BIODATA NORMAL','NO BIODATA REKAB','NO BIODATA','%','TOTAL']
        @daily_biometrics = []
        total_have_id = 0
        total_no_id = 0
        total_no_biodata = 0
        total_have_id_normal = 0
        total_have_id_rekab = 0
        total_no_id_normal = 0
        total_no_id_rekab = 0
        total_no_biodata_normal = 0
        total_no_biodata_rekab = 0

        data = Transaction.with_biometric_count
        .where('transactions.transaction_date between ? and ? and (biodata_transactions.id = (SELECT MAX(id) FROM biodata_transactions temp_bt WHERE temp_bt.transaction_id = transactions.id) or biodata_transactions.id is null)',beginning_of_current_month.beginning_of_day, @report_end_date.end_of_day)
        .select("transactions.transaction_date::date as date")
        .group('transactions.transaction_date::date')
        .order('date ASC')

        total_have_id = data.sum(&:have_id)
        total_no_id = data.sum(&:no_id)
        total_no_biodata = data.sum(&:no_biodata)

        total_have_id_normal = data.sum(&:have_id_normal)
        total_have_id_rekab = data.sum(&:have_id_rekab)
        total_no_id_normal = data.sum(&:no_id_normal)
        total_no_id_rekab = data.sum(&:no_id_rekab)
        total_no_biodata_normal = data.sum(&:no_biodata_normal)
        total_no_biodata_rekab = data.sum(&:no_biodata_rekab)
        

        data.each do |datum|
            have_id_normal = datum.have_id_normal.to_i
            have_id_rekab = datum.have_id_rekab.to_i
            have_id = datum.have_id.to_i
            no_id_normal = datum.no_id_normal.to_i
            no_id_rekab = datum.no_id_rekab.to_i
            no_id = datum.no_id.to_i
            no_biodata_normal = datum.no_biodata_normal.to_i
            no_biodata_rekab = datum.no_biodata_rekab.to_i
            no_biodata = datum.no_biodata.to_i
            total = [have_id,no_id,no_biodata].sum

            # percentage
            have_id_percentage = calc_percentage(have_id,total)
            no_id_percentage = calc_percentage(no_id,total)
            no_biodata_percentage = calc_percentage(no_biodata,total)

            @daily_biometrics << [datum.date.to_date.strftime('%d-%b-%Y'),have_id_normal,have_id_rekab,have_id,have_id_percentage,no_id_normal,no_id_rekab,no_id,no_id_percentage,no_biodata_normal,no_biodata_rekab,no_biodata,no_biodata_percentage,total]
        end

        # grand total 
        grand_total = total_have_id+total_no_id+total_no_biodata
        total_have_id_percentage = calc_percentage(total_have_id,grand_total)
        total_no_id_percentage =  calc_percentage(total_no_id,grand_total)
        total_no_biodata_percentage = calc_percentage(total_no_biodata,grand_total)

        @daily_biometrics << ['TOTAL',total_have_id_normal,total_have_id_rekab,total_have_id,total_have_id_percentage,
        total_no_id_normal,total_no_id_rekab,total_no_id,total_no_id_percentage,
        total_no_biodata_normal,total_no_biodata_rekab, total_no_biodata,total_no_biodata_percentage,grand_total]
        # end

        # # biometric report - from start of the system till now
        @biometric_start_to_current = []
        @start_date_of_system = '2018-03-01'.to_date

        data = Transaction.with_biometric_count
        .where('transactions.transaction_date between ? and ? and (biodata_transactions.id = (SELECT MAX(id) FROM biodata_transactions temp_bt WHERE temp_bt.transaction_id = transactions.id) or biodata_transactions.id is null)',@start_date_of_system.beginning_of_day, @report_end_date.end_of_day)

        data = data.blank? ? {} : data[0]

        have_id_normal = data&.have_id_normal
        have_id_rekab = data&.have_id_rekab
        have_id = data&.have_id
        no_id_normal = data&.no_id_normal
        no_id_rekab = data&.no_id_rekab
        no_id = data&.no_id
        no_biodata_normal = data&.no_biodata_normal
        no_biodata_rekab = data&.no_biodata_rekab
        no_biodata = data&.no_biodata
        total = have_id+no_id+no_biodata

        have_id_percentage = calc_percentage(have_id,total)
        no_id_percentage = calc_percentage(no_id,total)
        no_biodata_percentage = calc_percentage(no_biodata,total)
        @biometric_start_to_current << ['TOTAL',have_id_normal,have_id_rekab,have_id,have_id_percentage,no_id_normal,no_id_rekab,no_id,no_id_percentage,no_biodata_normal,no_biodata_rekab,no_biodata,no_biodata_percentage,total]
        # # end 

        # biometric report - by month current year
        @biometric_by_month_current_year = []
        current_month = Date.today.month
        @current_year = Date.today.year
        total_have_id = 0
        total_no_id = 0
        total_no_biodata = 0
        total_have_id_normal = 0
        total_have_id_rekab = 0
        total_no_id_normal = 0
        total_no_id_rekab = 0
        total_no_biodata_normal = 0
        total_no_biodata_rekab = 0

        this_year_first_date = DateTime.now.beginning_of_year()

        this_year_data = Transaction.with_biometric_count
        .select("extract(month from coalesce(transactions.transaction_date)) as month")
        .where('transactions.transaction_date between ? and ? and (biodata_transactions.id = (SELECT MAX(id) FROM biodata_transactions temp_bt WHERE temp_bt.transaction_id = transactions.id) or biodata_transactions.id is null)',this_year_first_date, @report_end_date.end_of_day)
        .group('month')
        .order('month ASC')

        this_year_data.each do |data|
            have_id_normal = data&.have_id_normal || 0
            have_id_rekab = data&.have_id_rekab || 0
            have_id = data&.have_id || 0
            no_id_normal = data&.no_id_normal || 0
            no_id_rekab = data&.no_id_rekab || 0
            no_id = data&.no_id || 0
            no_biodata_normal = data&.no_biodata_normal || 0
            no_biodata_rekab = data&.no_biodata_rekab || 0
            no_biodata = data&.no_biodata || 0

            total = [have_id, no_id, no_biodata].sum
            total_have_id_normal += have_id_normal
            total_have_id_rekab += have_id_rekab
            total_have_id += have_id
            total_no_id_normal += no_id_normal
            total_no_id_rekab += no_id_rekab
            total_no_id += no_id
            total_no_biodata_normal += no_biodata_normal
            total_no_biodata_rekab += no_biodata_rekab
            total_no_biodata += no_biodata

            # percentage
            have_id_percentage = calc_percentage(have_id,total)
            no_id_percentage = calc_percentage(no_id,total)
            no_biodata_percentage = calc_percentage(no_biodata,total)

            @biometric_by_month_current_year << ["#{Date::ABBR_MONTHNAMES[data&.month]}-#{@current_year}",have_id_normal,have_id_rekab,have_id,have_id_percentage,no_id_normal,no_id_rekab,no_id,no_id_percentage,no_biodata_normal,no_biodata_rekab,no_biodata,no_biodata_percentage,total]
        end

        # grand total 
        grand_total = [total_have_id,total_no_id,total_no_biodata].sum
        total_have_id_percentage = calc_percentage(total_have_id,grand_total)
        total_no_id_percentage =  calc_percentage(total_no_id,grand_total)
        total_no_biodata_percentage = calc_percentage(total_no_biodata,grand_total)
        
        @biometric_by_month_current_year << ['TOTAL',total_have_id_normal,total_have_id_rekab,total_have_id,total_have_id_percentage,total_no_id_normal,total_no_id_rekab,total_no_id,total_no_id_percentage,total_no_biodata_normal,total_no_biodata_rekab,total_no_biodata,total_no_biodata_percentage,grand_total]
        # end

        # biometric report - by month last year
        @biometric_by_month_last_year = []
        @last_year = Date.today.last_year.year
        total_have_id = 0
        total_no_id = 0
        total_no_biodata = 0
        total_have_id_normal = 0
        total_have_id_rekab = 0
        total_no_id_normal = 0
        total_no_id_rekab = 0
        total_no_biodata_normal = 0
        total_no_biodata_rekab = 0

        last_year_first_date = DateTime.now.last_year.beginning_of_year()
        last_year_end_date = DateTime.now.last_year.end_of_year.end_of_day

        last_year_data = Transaction.with_biometric_count
        .select("extract(month from coalesce(transactions.transaction_date)) as month")
        .where('transactions.transaction_date between ? and ? and (biodata_transactions.id = (SELECT MAX(id) FROM biodata_transactions temp_bt WHERE temp_bt.transaction_id = transactions.id) or biodata_transactions.id is null)',last_year_first_date, last_year_end_date)
        .group('month')
        .order('month ASC')

        last_year_data.each do |data|
            have_id_normal = data&.have_id_normal || 0
            have_id_rekab = data&.have_id_rekab || 0
            have_id = data&.have_id || 0
            no_id_normal = data&.no_id_normal || 0
            no_id_rekab = data&.no_id_rekab || 0
            no_id = data&.no_id || 0
            no_biodata_normal = data&.no_biodata_normal || 0
            no_biodata_rekab = data&.no_biodata_rekab || 0
            no_biodata = data&.no_biodata || 0

            total = [have_id, no_id, no_biodata].sum
            total_have_id_normal += have_id_normal
            total_have_id_rekab += have_id_rekab
            total_have_id += have_id
            total_no_id_normal += no_id_normal
            total_no_id_rekab += no_id_rekab
            total_no_id += no_id
            total_no_biodata_normal += no_biodata_normal
            total_no_biodata_rekab += no_biodata_rekab
            total_no_biodata += no_biodata

            # percentage
            have_id_percentage = calc_percentage(have_id,total)
            no_id_percentage = calc_percentage(no_id,total)
            no_biodata_percentage = calc_percentage(no_biodata,total)

            @biometric_by_month_last_year << ["#{Date::ABBR_MONTHNAMES[data&.month]}-#{@last_year}",have_id_normal,have_id_rekab,have_id,have_id_percentage,no_id_normal,no_id_rekab,no_id,no_id_percentage,no_biodata_normal,no_biodata_rekab,no_biodata,no_biodata_percentage,total]
        end

        # grand total 
        grand_total = [total_have_id,total_no_id,total_no_biodata].sum
        total_have_id_percentage = calc_percentage(total_have_id,grand_total)
        total_no_id_percentage =  calc_percentage(total_no_id,grand_total)
        total_no_biodata_percentage = calc_percentage(total_no_biodata,grand_total)
        
        @biometric_by_month_last_year << ['TOTAL',total_have_id_normal,total_have_id_rekab,total_have_id,total_have_id_percentage,total_no_id_normal,total_no_id_rekab,total_no_id,total_no_id_percentage,total_no_biodata_normal,total_no_biodata_rekab,total_no_biodata,total_no_biodata_percentage,grand_total]
        # end
    end

    def generate_afisid_report_data
        @now = Time.now
        @current_year = Date.today.year
        @last_year = Date.today.last_year.year
        @afisid_title = ['DATE','DOCTOR','%','XRAY','%','BOTH','%','BELOW THRESHOLD','%','NOT MATCHING','%','TOTAL']
        @report_end_date = Date.yesterday
        beginning_of_current_month = @report_end_date.beginning_of_month()
        this_year_first_date = DateTime.now.beginning_of_year()

        # afis id tested by month current year
        @afis_id_by_month_current_year = []
        total_doc_success = 0
        total_xray_success = 0
        total_both_success = 0
        total_below_threshold = 0
        total_not_matching = 0

        current_year_data = Transaction.with_afis_id_count
        .select("extract(month from coalesce(transactions.transaction_date)) as month")
        .where('transactions.transaction_date between ? and ?',this_year_first_date, @report_end_date.end_of_day)
        .group('month')
        .order('month ASC')

        current_year_data.each do |data|
            doctor_count = data.doctor_count
            xray_count = data.xray_count
            both_count = data.both_count
            below_threshold_count = data.below_threshold_count
            not_matching_count = data.not_matching_count

            total = [doctor_count,xray_count,both_count,below_threshold_count,not_matching_count].sum

            if total > 0
                doctor_count_pct = calc_percentage(doctor_count,total)
                xray_count_pct = calc_percentage(xray_count,total)
                both_count_pct = calc_percentage(both_count,total)
                below_threshold_count_pct = calc_percentage(below_threshold_count,total)
                not_matching_count_pct = calc_percentage(not_matching_count,total)
    
                @afis_id_by_month_current_year << ["#{Date::ABBR_MONTHNAMES[data&.month]}-#{@current_year}",doctor_count,doctor_count_pct,xray_count,xray_count_pct,both_count,both_count_pct, below_threshold_count,below_threshold_count_pct, not_matching_count,not_matching_count_pct,total]
            end
        end

        ## grand total
        total_doctor_count = current_year_data.map(&:doctor_count).sum
        total_xray_count = current_year_data.map(&:xray_count).sum
        total_both_count = current_year_data.map(&:both_count).sum
        total_below_threshold_count_count = current_year_data.map(&:below_threshold_count).sum
        total_not_matching_count = current_year_data.map(&:not_matching_count).sum

        grand_total = [total_doctor_count,total_xray_count,total_both_count,total_below_threshold_count_count,total_not_matching_count].sum
        total_doctor_count_pct = calc_percentage(total_doctor_count,grand_total)
        total_xray_count_pct = calc_percentage(total_xray_count,grand_total)
        total_both_count_pct = calc_percentage(total_both_count,grand_total)
        total_below_threshold_count_pct = calc_percentage(total_below_threshold_count_count,grand_total)
        total_not_matching_count_pct = calc_percentage(total_not_matching_count,grand_total)

        @afis_id_by_month_current_year << ['TOTAL',total_doctor_count,total_doctor_count_pct,total_xray_count,total_xray_count_pct,total_both_count,total_both_count_pct, total_below_threshold_count_count,total_below_threshold_count_pct, total_not_matching_count,total_not_matching_count_pct,grand_total]
        ## end

        ## afis id tested by month last year
        @afis_id_by_month_last_year = []
        total_doc_success = 0
        total_xray_success = 0
        total_both_success = 0
        total_below_threshold = 0
        total_not_matching = 0

        last_year_first_date = DateTime.now.last_year.beginning_of_year()
        last_year_end_date = DateTime.now.last_year.end_of_year.end_of_day

        last_year_data = Transaction.with_afis_id_count
        .select("extract(month from coalesce(transactions.transaction_date)) as month")
        .where('transactions.transaction_date between ? and ?',last_year_first_date, last_year_end_date)
        .group('month')
        .order('month ASC')

        last_year_data.each do |data|
            doctor_count = data.doctor_count
            xray_count = data.xray_count
            both_count = data.both_count
            below_threshold_count = data.below_threshold_count
            not_matching_count = data.not_matching_count

            total = [doctor_count,xray_count,both_count,below_threshold_count,not_matching_count].sum

            if total > 0
                doctor_count_pct = calc_percentage(doctor_count,total)
                xray_count_pct = calc_percentage(xray_count,total)
                both_count_pct = calc_percentage(both_count,total)
                below_threshold_count_pct = calc_percentage(below_threshold_count,total)
                not_matching_count_pct = calc_percentage(not_matching_count,total)
    
                @afis_id_by_month_last_year << ["#{Date::ABBR_MONTHNAMES[data&.month]}-#{@last_year}",doctor_count,doctor_count_pct,xray_count,xray_count_pct,both_count,both_count_pct, below_threshold_count,below_threshold_count_pct, not_matching_count,not_matching_count_pct,total]
            end
        end

        ## grand total
        total_doctor_count = last_year_data.map(&:doctor_count).sum
        total_xray_count = last_year_data.map(&:xray_count).sum
        total_both_count = last_year_data.map(&:both_count).sum
        total_below_threshold_count_count = last_year_data.map(&:below_threshold_count).sum
        total_not_matching_count = last_year_data.map(&:not_matching_count).sum

        grand_total = [total_doctor_count,total_xray_count,total_both_count,total_below_threshold_count_count,total_not_matching_count].sum
        total_doctor_count_pct = calc_percentage(total_doctor_count,grand_total)
        total_xray_count_pct = calc_percentage(total_xray_count,grand_total)
        total_both_count_pct = calc_percentage(total_both_count,grand_total)
        total_below_threshold_count_pct = calc_percentage(total_below_threshold_count_count,grand_total)
        total_not_matching_count_pct = calc_percentage(total_not_matching_count,grand_total)

        @afis_id_by_month_last_year << ['TOTAL',total_doctor_count,total_doctor_count_pct,total_xray_count,total_xray_count_pct,total_both_count,total_both_count_pct, total_below_threshold_count_count,total_below_threshold_count_pct, total_not_matching_count,total_not_matching_count_pct,grand_total]
        ## end
        
        ## afis id tested by state this year
        @afis_id_by_state_current_year = []
        start_of_current_year = "$#{@current_year}-01-01".to_date

        total_doctor_count = 0
        total_xray_count = 0
        total_both_count = 0
        total_below_threshold_count_count = 0
        total_not_matching_count = 0

        current_year_state_data = Transaction.joins(:doctor).with_afis_id_count
        .select("doctors.state_id")
        .where('transactions.transaction_date between ? and ?',this_year_first_date, @report_end_date.end_of_day)
        .group('doctors.state_id')
        .order('doctors.state_id ASC')

        current_year_state_data.each do |data|

            state = State.find(data.state_id)

            if !data.blank?
                doctor_count = data.doctor_count
                xray_count = data.xray_count
                both_count = data.both_count
                below_threshold_count = data.below_threshold_count
                not_matching_count = data.not_matching_count

                total = [doctor_count,xray_count,both_count,below_threshold_count,not_matching_count].sum

                if total > 0
                    doctor_count_pct = calc_percentage(doctor_count,total)
                    xray_count_pct = calc_percentage(xray_count,total)
                    both_count_pct = calc_percentage(both_count,total)
                    below_threshold_count_pct = calc_percentage(below_threshold_count,total)
                    not_matching_count_pct = calc_percentage(not_matching_count,total)
        
                    @afis_id_by_state_current_year << [state.name,doctor_count,doctor_count_pct,xray_count,xray_count_pct,both_count,both_count_pct, below_threshold_count,below_threshold_count_pct, not_matching_count,not_matching_count_pct,total]
                end
            end
        end

        ## grand total
        total_doctor_count = current_year_state_data.map(&:doctor_count).sum
        total_xray_count = current_year_state_data.map(&:xray_count).sum
        total_both_count = current_year_state_data.map(&:both_count).sum
        total_below_threshold_count_count = current_year_state_data.map(&:below_threshold_count).sum
        total_not_matching_count = current_year_state_data.map(&:not_matching_count).sum

        grand_total = [total_doctor_count,total_xray_count,total_both_count,total_below_threshold_count_count,total_not_matching_count].sum
        total_doctor_count_pct = calc_percentage(total_doctor_count,grand_total)
        total_xray_count_pct = calc_percentage(total_xray_count,grand_total)
        total_both_count_pct = calc_percentage(total_both_count,grand_total)
        total_below_threshold_count_pct = calc_percentage(total_below_threshold_count_count,grand_total)
        total_not_matching_count_pct = calc_percentage(total_not_matching_count,grand_total)

        @afis_id_by_state_current_year << ['TOTAL',total_doctor_count,total_doctor_count_pct,total_xray_count,total_xray_count_pct,total_both_count,total_both_count_pct, total_below_threshold_count_count,total_below_threshold_count_pct, total_not_matching_count,total_not_matching_count_pct,grand_total]
        ## end

        ## afis id tested by state last year
        @afis_id_by_state_last_year = []
        start_of_last_year = "$#{@last_year}-01-01".to_date
        end_of_last_year = "#{@last_year}-12-31".to_date

        total_doctor_count = 0
        total_xray_count = 0
        total_both_count = 0
        total_below_threshold_count_count = 0
        total_not_matching_count = 0

        last_year_state_data = Transaction.joins(:doctor).with_afis_id_count
        .select("doctors.state_id")
        .where('transactions.transaction_date between ? and ?',last_year_first_date, last_year_end_date)
        .group('doctors.state_id')
        .order('doctors.state_id ASC')

        last_year_state_data.each do |data|

            state = State.find(data.state_id)

            if !data.blank?
                doctor_count = data.doctor_count
                xray_count = data.xray_count
                both_count = data.both_count
                below_threshold_count = data.below_threshold_count
                not_matching_count = data.not_matching_count

                total = [doctor_count,xray_count,both_count,below_threshold_count,not_matching_count].sum

                if total > 0
                    doctor_count_pct = calc_percentage(doctor_count,total)
                    xray_count_pct = calc_percentage(xray_count,total)
                    both_count_pct = calc_percentage(both_count,total)
                    below_threshold_count_pct = calc_percentage(below_threshold_count,total)
                    not_matching_count_pct = calc_percentage(not_matching_count,total)
        
                    @afis_id_by_state_last_year << [state.name,doctor_count,doctor_count_pct,xray_count,xray_count_pct,both_count,both_count_pct, below_threshold_count,below_threshold_count_pct, not_matching_count,not_matching_count_pct,total]
                end
            end
        end

        ## grand total
        total_doctor_count = last_year_state_data.map(&:doctor_count).sum
        total_xray_count = last_year_state_data.map(&:xray_count).sum
        total_both_count = last_year_state_data.map(&:both_count).sum
        total_below_threshold_count_count = last_year_state_data.map(&:below_threshold_count).sum
        total_not_matching_count = last_year_state_data.map(&:not_matching_count).sum

        grand_total = [total_doctor_count,total_xray_count,total_both_count,total_below_threshold_count_count,total_not_matching_count].sum
        total_doctor_count_pct = calc_percentage(total_doctor_count,grand_total)
        total_xray_count_pct = calc_percentage(total_xray_count,grand_total)
        total_both_count_pct = calc_percentage(total_both_count,grand_total)
        total_below_threshold_count_pct = calc_percentage(total_below_threshold_count_count,grand_total)
        total_not_matching_count_pct = calc_percentage(total_not_matching_count,grand_total)

        @afis_id_by_state_last_year << ['TOTAL',total_doctor_count,total_doctor_count_pct,total_xray_count,total_xray_count_pct,total_both_count,total_both_count_pct, total_below_threshold_count_count,total_below_threshold_count_pct, total_not_matching_count,total_not_matching_count_pct,grand_total]
    end

    def daily_myimms_error_report
        @csv = [Report::MyimmsErrorReportService.headers]
        @query_date = params[:query_date]

        if @query_date.present?
            @csv = Report::MyimmsErrorReportService.new(@query_date.to_datetime).csv_result
        end

        @filter_options = [{ type: "date", label: "Date" }]
        parse_output_format("Daily MYIMMS Error Report")
    end

private
    def insurance_render(filename)
        respond_to do |format|
            format.html { render "internal/reports/it/insurances/index.html" }
            format.csv { send_data CSV.generate {|csv| @csv.each {|row| csv << row}}, filename: "#{ filename }.csv" }
        end
    end

    def calc_percentage(value,total)
        return value == 0 ? value : (value.to_f/total*100).round(2)
    end
end