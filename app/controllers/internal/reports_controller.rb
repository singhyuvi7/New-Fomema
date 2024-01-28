class Internal::ReportsController < InternalController
    include ReportsFinance
    include ReportsMSPD
    include ReportsCronjob
    include ReportSettings

    def index
        if on_development?
            @sample_list = [
                { title: "CSV Sample (development only)", path: csv_sample_internal_reports_path, download: csv_sample_internal_reports_path(format: "csv") },
                { title: "Excel Sample (development only)", path: excel_sample_internal_reports_path, download: excel_sample_internal_reports_path(format: "xlsx") }
            ]
        else
            @sample_list = []
        end

        @list = []
        @excelList = []

        @pdfList =[]
    end

    def excel_sample
        # github    - https://github.com/caxlsx/caxlsx_rails
        # template  - /views/shared/reports/excel_caxlsx_template.xlsx.axlsx

        worksheet_1 = [
            ["Row 1 Column 1", "Row 1 Column 2", "Row 1 Column 3"],
            {
                data: ["Row 2 Bolded With Border", "Row 2 Column 2", "Row 2 Column 3"],
                style: [{ b: true, border: { style: :thin, color: "00000000" }}] * 3
            },
            ["Row 3 Column 1", "Row 3 Column 2", "Row 3 Column 3"],
        ]

        worksheet_2 = [
            ["Row 1 Column 1", "Row 1 Column 2"],
            ["Merging Row 2 Columns 1 & 2"]
        ]

        @excel              = []
        @excel              << worksheet_1
        @excel              << worksheet_2

        # Worksheet names, if null, defaults to "Worksheet #{ Number }".
        @worksheet_names    = ["Sample Worksheet 1 Alpha", "Sample Worksheet 2 Beta"]

        # Options to merge fields together.
        worksheet_2_merge   = ["A2:B2"]
        @merge_fields       = []
        @merge_fields       << [] # Worksheet 1 with no merge options.
        @merge_fields       << worksheet_2_merge

        # Width of each column.
        @column_widths          = []
        worksheet1_widths       = [30, 15, 18]
        worksheet2_widths       = [30, 20]
        @column_widths          << worksheet1_widths
        @column_widths          << worksheet2_widths

        parse_output_format("Sample Filename")
    end

    # Instructions.
    # Make your own action and add under resources :reports, collection blocks.
    # Include your csv file in the list under the index action.
    def csv_sample
        # Important note, never start the CSV file with ID.
        # It will confuse the format of the downloaded csv file as SYLK file format when opening in excel viewers.
        # If you need to use ID, be more specific, like Transaction ID.

        @csv            = [["Transaction ID", "Doctor", "Foreign Worker", "Status", "Transaction Date"]] # These are headers.
        transactions    = Transaction.limit(20).order(:id).includes(:doctor, :foreign_worker)

        transactions.each do |transaction|
            @csv << [
                transaction.id,
                transaction.doctor.try(:name),
                transaction.fw_name,
                transaction.status,
                transaction.transaction_date? ? transaction.transaction_date.strftime("%F") : nil
            ]
        end

        parse_output_format("Sample Filename")
    end

    def finance_demo
        @reports = [
            [1, 'Summary Draft Collection (NIOS)', summary_draft_collection_internal_finance_reports_path],
            [2, 'Summary Worker Certification', summary_worker_certification_internal_finance_reports_path],
            [3, 'Summary Worker Registration', summary_worker_registration_internal_finance_reports_path],
            [4, 'Summary Misc Icome', summary_misc_income_internal_finance_reports_path],
            [5, 'Portal Transaction Listing', portal_transactions_internal_finance_reports_path],
            [6, 'Cert Service Provider Summary', [['doctor', summary_doctor_certification_internal_finance_reports_path], ['laboratory', summary_laboratory_certification_internal_finance_reports_path], ['xray', summary_xray_certification_internal_finance_reports_path]]],
            [7, 'Cert Service Provider Details', [['doctor', doctor_certification_details_internal_finance_reports_path], ['laboratory', laboratory_certification_details_internal_finance_reports_path], ['xray', xray_certification_details_internal_finance_reports_path]]],
            [8, 'Cert X-Ray Not Done', xray_not_done_certifications_internal_finance_reports_path],
            [9, 'SP Payment Mode Statistic', sp_payment_mode_statistic_internal_finance_reports_path],
            [11, 'Service Provider - Manual Payment Listing (Master), Payment Listing (Viewer) (Proddbmon)', internal_manual_payment_view_transactions_path],
            [12, 'Lab Report', laboratory_certification_by_gender_internal_finance_reports_path],
        ]
    end

    def mspd_demo
        doctor = Doctor.first
        laboratory = Laboratory.first
        xray_facility = XrayFacility.first
        @reports = [
            [6, 'Suspension history', [["doctor-#{doctor.code.presence || doctor.id}", suspension_history_internal_doctor_path(doctor, format: :pdf)], ["laboratory-#{laboratory.code.presence || laboratory.id}", suspension_history_internal_laboratory_path(laboratory, format: :pdf)], ["xray-#{xray_facility.code.presence || xray_facility.id}", suspension_history_internal_xray_facility_path(xray_facility, format: :pdf)]]],
            [10, 'Worker block send to JIM', worker_block_send_to_jim_internal_mspd_reports_path],
            [11, 'New registration doctor', list_doc_register_internal_mspd_reports_path],
            [12, 'New registration X-ray', list_xray_register_internal_mspd_reports_path],
            [13, 'New registration lab', list_lab_register_internal_mspd_reports_path],
            [14, 'List of Worker (details) by doctor', [["doctor-#{doctor.code}", workers_internal_doctor_path(doctor)]]],
            [15, 'List of suspended doctor', suspended_doctors_internal_mspd_reports_path],
            [16, 'Report generated from proddbmon', [['doctors->export', internal_doctors_path], ['laboratories->export', internal_laboratories_path]]],
            [17, 'Delay transmission (X-ray & Lab)', [['laboratory delay', lab_delay_transmission_internal_mspd_reports_path], ['xray delay', xray_delay_transmission_internal_mspd_reports_path]]],
            [18, 'List of allocated workers to doctor', [["doctor-#{doctor.code}", allocated_workers_internal_doctor_path(doctor)]]],
            [19, 'List of GP (active + Temp.Suspended)', [['doctors->export', internal_doctors_path]]],
            [20, 'List of Lab (active + Temp.Suspended)', [['laboratories->export', internal_laboratories_path]]],
            [21, 'List of Xray (active + Temp.Suspended)', [['xray facilities->export', internal_xray_facilities_path]]],
            [22, 'List of GP Delay', [["doctor-#{doctor.code}", transactions_internal_doctor_path(doctor)]]],
            [23, 'List of Lab Delay', [["laboratory-#{laboratory.code}", transactions_internal_laboratory_path(laboratory)]]],
            [24, 'List of XRay Delay', [["xray facility-#{xray_facility.code}", transactions_internal_xray_facility_path(xray_facility)]]],
            [25, 'FW Registration list', foreign_worker_registrations_internal_mspd_reports_path],
            [26, 'To Get GP Unutilized Quota', gp_unutilized_quota_internal_mspd_reports_path],
            [27, 'Raw data of MCLX table', mclx_report_internal_mspd_reports_path],
            [28, 'List of Unsuitable FW', unsuitable_foreign_workers_internal_mspd_reports_path],
            [29, 'MOH Monthly (Cumulative) Report'],
            [30, 'WEEKLY RADIOGRAPHER RECEIVE, REVIEW AND AUTO RELEASE REPORT', radiographer_report_internal_mspd_reports_path]
        ]
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