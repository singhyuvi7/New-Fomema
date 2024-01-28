# frozen_string_literal: true

module Internal
  # PCR reports controller
  class PcrReportsController < InternalController
    include ReportsPrivateMethods
    include ReportsPCR

    before_action -> { can_access?('PCR_REPORTS') }
    before_action :setting_extended_headers

    def index
      pcr_reports = [
        { title: 'PCR Audit Report', path: pcr_audit_summary_internal_pcr_reports_path },
        { title: 'XQCC Pending Audit PCR Report', path: xqcc_pending_audit_pcr_report_internal_pcr_reports_path },
      ]

      @reports = [
        { title: 'PCR Reports', reports: pcr_reports }
      ]
      render 'shared/reports/index'
    end

    private

    def parse_output_format(filename)
      respond_to do |format|
        format.html do
          @filename = filename
          render 'shared/reports/reports_preview_table'
        end
        format.csv { send_data CSV.generate { |csv| @csv.each { |row| csv << row } }, filename: "#{ filename }.csv" }
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
end
