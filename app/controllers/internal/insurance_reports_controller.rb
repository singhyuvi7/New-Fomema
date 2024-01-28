class Internal::InsuranceReportsController < InternalController
    include ReportsFinance

    before_action -> { can_access?("INSURANCE_REPORTS") }

    def index
        @insurance = [
            { title: "Details Worker Insurance Report",     path: details_worker_insurance_internal_insurance_reports_path }
        ]

        @reports = [
            { title: "Insurance Reports",       reports: @insurance }
        ]

        render "shared/reports/index"
    end
private
    def parse_output_format(filename)
        respond_to do |format|
            format.html { @filename = filename; render "shared/reports/reports_preview_table"}
            format.csv { send_data CSV.generate {|csv| @csv.each {|row| csv << row}}, filename: "#{ filename }.csv" }
            format.xlsx { render template: 'shared/reports/excel_caxlsx_template', xlsx: "#{ filename }" }
        end
    end

    def set_date_time
        @date = DateTime.current.strftime('%d/%m/%Y')
        @time = DateTime.current.strftime('%H:%M:%S %p')
    end

    def pdf_margin
        {
            top: 50,
            left: 12,
            right: 12,
            bottom: 10,
        }
    end

    def default_pdf_options
        {
             layout: 'pdf.html',
             margin: pdf_margin,
             page_size: nil,
             page_height: '21cm',
             page_width: '29.7cm',
             dpi: '300'
        }
     end
end