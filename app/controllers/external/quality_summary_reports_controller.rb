class External::QualitySummaryReportsController < ExternalController
    include ReportsXQCC
    #before_action :access_only_for_xray_or_radiologist
    #before_action :check_for_parameters, only: [:view]
    before_action -> { can_access?('VIEW_QUALITY_SUMMARY_REPORTS') }

    def index
    end
private
    def parse_output_format(filename)
        respond_to do |format|
            format.html { @filename = filename; render "shared/reports/reports_preview_table" }
            format.csv { send_data CSV.generate {|csv| @csv.each {|row| csv << row}}, filename: "#{ filename }.csv" }
            format.xlsx { render template: 'shared/reports/excel_caxlsx_template', xlsx: "#{ filename }" }
        end
    end

    def pdf_margin
        {
            top: 50,
            left: 12,
            right: 12,
            bottom: 10
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