class External::ReportedCasesController < ExternalController
    before_action :access_only_for_xray_or_radiologist
    before_action :check_for_parameters, only: [:view]

    def index
        search_user_key     = [[current_user.userable_type == "Radiologist" ? "radiologist_id" : "xray_facility_id", current_user.userable_id]].to_h
        build_transactions  = Transaction.search_by_user_type(current_user)
                                .search_transaction_date_start(Date.today - 1.years)
        retakes             = XrayRetake.where(search_user_key)
                                .where(created_at: Date.today.last_year..Time.now)

        case current_user.userable_type
        when "XrayFacility"
            user_ids        = build_transactions.pluck(:radiologist_id).uniq + retakes.pluck(:radiologist_id).uniq
            list_of_users   = Radiologist.where(id: user_ids.compact)
        when "Radiologist"
            user_ids        = build_transactions.pluck(:xray_facility_id).uniq + retakes.pluck(:xray_facility_id).uniq
            list_of_users   = XrayFacility.where(id: user_ids.compact)
        end

        @dropdown_list      = list_of_users.pluck(:code, :name, :id).sort.map {|code, name, id| ["#{ code } - #{ name }", id] }
        @dropdown_list.unshift("All")
        @month_list         = []
        start_month         = Date.today - 1.year

        while start_month <= Date.today
            @month_list << start_month.strftime("%B %Y")
            start_month += 1.month
        end
    end

    def view
        case params[:selectable_period]
        when "previous day"
            date_range  = Date.yesterday...Date.today
            date        = Date.yesterday.strftime("%d-%m-%Y")
        when "previous months"
            month       = params[:selectable_month].to_date
            date_range  = month...month.next_month
            date        = month.strftime("%m-%Y")
        end

        search_user_key = [[current_user.userable_type == "Radiologist" ? "radiologist_id" : "xray_facility_id", current_user.userable_id]].to_h
        transactions    = Transaction.where(search_user_key)
                            .joins(:xray_examination).where(xray_examinations: { radiologist_transmitted_at: date_range })
        retakes         = XrayRetake.where(search_user_key)
                            .joins(:xray_examination).where(xray_examinations: { radiologist_transmitted_at: date_range })

        if params[:list_of_facilities] == "All"
            transactions    = transactions.pluck(:id)
            retakes         = retakes.pluck(:id)
        else
            case current_user.userable_type
            when "XrayFacility"
                transactions    = transactions.where(radiologist_id: @facility_chosen.id).pluck(:id)
                retakes         = retakes.where(radiologist_id: @facility_chosen.id).pluck(:id)
            when "Radiologist"
                transactions    = transactions.where(xray_facility_id: @facility_chosen.id).pluck(:id)
                retakes         = retakes.where(xray_facility_id: @facility_chosen.id).pluck(:id)
            end
        end

        t_exams         = XrayExamination.where(sourceable_type: "Transaction",  sourceable_id: transactions).includes(:sourceable)
        r_exams         = XrayExamination.where(sourceable_type: "XrayRetake",  sourceable_id: retakes).includes(:sourceable, :transactionz)
        facility_ids    = []
        @detailed_data  = []

        (t_exams + r_exams).each do |exam|
            next unless exam.radiologist_transmitted_at?
            transaction     = exam.sourceable_type == "Transaction" ? exam.sourceable : exam.transactionz
            facility_id     = current_user.userable_type == "Radiologist" ? exam.sourceable&.xray_facility_id : exam.sourceable&.radiologist_id
            facility_ids    << facility_id

            case params[:report_type]
            when "detailed"
                @detailed_data += [{
                    transaction_code: exam.sourceable&.code,
                    report_date: exam.radiologist_transmitted_at,
                    facility_id: facility_id,
                    worker_name: transaction.fw_name,
                    worker_code: transaction.fw_code,
                    status: exam&.result
                }]
            end
        end

        case current_user.userable_type
        when "XrayFacility"
            @facilities     = Radiologist.where(id: facility_ids.uniq.compact).pluck(:id, :code, :name)
        when "Radiologist"
            @facilities     = XrayFacility.where(id: facility_ids.uniq.compact).pluck(:id, :code, :name)
        end

        case params[:report_type]
        when "detailed"
            @detailed_data.map! do |hash|
                facility    = @facilities.find {|id, code, name| id == hash[:facility_id] }
                facility    ||= []
                hash[:facility_code] = facility[1]
                hash[:facility_name] = facility[2]
                hash
            end

            @detailed_data.sort_by! {|hash| hash[:report_date] }
            @detailed_data.reverse!
        when "summary"
            @summarized_data = facility_ids.group_count.map do |facility_id, count|
                facility    = @facilities.find {|id, code, name| id == facility_id }
                facility    ||= []
                hash        = {}
                hash[:facility_code]    = facility[1]
                hash[:facility_name]    = facility[2]
                hash[:count]            = count
                hash
            end

            @summarized_data.sort_by! {|hash| hash[:facility_name] }
        end

        @data = {
            date: date,
            date_today: Time.now.strftime("%d-%m-%Y"),
            time_today: Time.now.strftime("%H:%M:%S %p"),
            column3and4: current_user.userable_type == "Radiologist" ? "X-Ray" : "Radiologist"
        }

        render pdf: "#{ params[:report_type] }_xray_radiologist_reported_cases",
        template: "/pdf_templates/#{ params[:report_type] }_xray_radiologist_reported_cases.html.erb",
        layout: "pdf.html",
        margin: {
            top: 14,
            left: 14,
            right: 14,
            bottom: 14,
        },
        page_size: nil,
        page_height: "21cm",
        page_width: "29.7cm",
        dpi: "300",
        show_as_html: params[:debug].present?,
        header: {
            html: {
                template: '/pdf_templates/appeal_report_summary_header'
            }
        }
    end
private
    def access_only_for_xray_or_radiologist
        if current_user.blank? || !["XrayFacility", "Radiologist"].include?(current_user.userable_type) || !has_any_permission?("VIEW_MERTS_XRAY_TO_RADIOLOGIST_REPORTED_CASES", "VIEW_MERTS_RADIOLOGIST_TO_XRAY_REPORTED_CASES")
            redirect_to external_root_path, error: "You may not access this page."
        end
    end

    def check_for_parameters
        sliced_params = params.to_unsafe_h.slice(:list_of_facilities, :selectable_period, :report_type)

        if params[:list_of_facilities].blank?
            error = "Please select a #{ current_user.userable_type == "Radiologist" ? "X-Ray Facility" : "Radiologist" }."
        elsif params[:report_type].blank?
            error = "Please select a report type."
        elsif params[:selectable_period].blank?
            error = "Please select period."
        elsif params[:selectable_period] == "previous months" && params[:selectable_month].blank?
            error = "Please select a month."
        end

        redirect_to external_reported_cases_path(sliced_params), error: error and return if error.present?

        unless params[:list_of_facilities] == "All"
            case current_user.userable_type
            when "XrayFacility"
                @facility_chosen    = Radiologist.find_by(id: params[:list_of_facilities])
            when "Radiologist"
                @facility_chosen    = XrayFacility.find_by(id: params[:list_of_facilities])
            end

            if @facility_chosen.blank?
                redirect_to external_reported_cases_path(sliced_params), error: "Error: Chosen facility cannot be found. Please contact Fomema: code: #{ params[:list_of_facilities] }" and return
            end
        end
    end
end