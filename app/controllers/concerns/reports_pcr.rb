# frozen_string_literal: true

# PCR reports module
module ReportsPCR
    extend ActiveSupport::Concern

    included do
        before_action :set_date_time, only: %i[pcr_quality_summary]
        before_action :set_company_name, only: %i[pcr_audit_summary]
    end

    def pcr_audit_summary
        @headers = ['No', 'Report Date', 'X-Ray Code', 'X-Ray Name', 'Count']
        # NOTE: FOMEMA PCR users migrated from old system. Not supported by current system

        # SELECT um.uuid,rm.RADIOLOGIST_CODE,rm.RADIOLOGIST_NAME,um.DISPLAYNAME FROM  nios1.USER_master UM
        # JOIN nios1.RADIOLOGIST_MASTER rm ON um.uuid=rm.nios_uuid
        # WHERE rm.STATUS_CODE='Y' AND rm.IS_PCR='Y' AND rm.nios_uuid IS NOT NULL AND um.STATUS='Y';
        fomema_pcr_ids = Radiologist.where.not(user_id: nil).active.pluck(:user_id).uniq.compact
        @users = User.where(id: fomema_pcr_ids).active

        if params[:date_from].present? && params[:date_to].present?
            user_id = has_permission?('PCR_AUDIT_SUMMARY_REPORT_INDIVIDUAL') ? current_user.id : params[:pcr_user_id]


            @data = PcrReview.select("pcr_reviews.transmitted_at::date as transmit_date, xray_facilities.id xray_facility_id,  xray_facilities.code xray_facility_code, xray_facilities.name xray_facility_name, count(distinct pcr_reviews.id) pcr_review_count")
            .joins("left join medical_appeals on pcr_reviews.medical_appeal_id = medical_appeals.id
            left join transactions on pcr_reviews.transaction_id = transactions.id
            left join xray_facilities on transactions.xray_facility_id = xray_facilities.id or medical_appeals.xray_facility_id = xray_facilities.id")
            .where("pcr_reviews.pcr_id = ? and pcr_reviews.status = ? and pcr_reviews.result != ? and pcr_reviews.transmitted_at between ? and ?", user_id, 'TRANSMITTED', 'RETAKE', params[:date_from].to_date.beginning_of_day, params[:date_to].to_date.end_of_day)
            .group("pcr_reviews.transmitted_at::date, xray_facilities.id,  xray_facilities.code, xray_facilities.name")
            .order("transmit_date asc")

            @user = has_permission?('PCR_AUDIT_SUMMARY_REPORT_INDIVIDUAL') ? current_user : User.find_by(id: user_id)
            @radiologist = @user.userable

            # service = Report::PcrAuditSummaryService.new(params[:date_from], params[:date_to], params[:pcr_user_code], user_id)
            # if service.valid?
            #     @data = service.result
            #     @user = service.pcr_user
            #     @radiologist = service.radiologist
            # else
            #     return redirect_to pcr_audit_summary_internal_pcr_reports_path, notice: 'Invalid input or user not found'
            # end
        end

        respond_to do |format|
            format.html { render_pcr_html }
            format.xlsx { render_pcr_xlsx }
            format.pdf { render_pcr_pdf }
        end
    end

    def xqcc_pending_audit_pcr_report
        @csv        = [Report::XqccPendingAuditPcrReportService.headers]
        query_date  = params[:query_date]

        if query_date.present?
            data      = Report::XqccPendingAuditPcrReportService.new(query_date).result

            data.each do |d|
                @csv << [
                    d.abnormal_films,
                    d.suspicious,
                    d.identical,
                    d.iqa,
                    d.wrongly_transmitted,
                    d.pending,
                    d.appeal,
                    (d.abnormal_films + d.suspicious + d.identical + d.iqa + d.wrongly_transmitted + d.pending + d.appeal)
                ]
            end
        end

        if check_format_html
            headers_footers ||= 1
            total_size      = @csv.size - headers_footers
            @csv            = @csv.first(500 + headers_footers)
            showing_size    = @csv.size - headers_footers
            @displayed_size = "Showing #{ showing_size } out of #{ total_size } rows"
        end

        @filter_options = [{ type: "date", label: "Date" }]
        parse_output_format('XQCC Pending Audit PCR Report')
    end

    private

    def render_pcr_html
        render "internal/reports/pcr/#{action_name}/index"
    end

    def render_pcr_xlsx
        render xlsx: 'index', filename: "#{action_name.camelize}-#{DateTime.current.to_i}.xlsx",
            template: "internal/reports/pcr/#{action_name}/index"
    end

    def render_pcr_pdf
        @pdf = true
        render pdf: action_name,
            template: "internal/reports/pcr/#{action_name}/_pdf_template.html.haml",
            header: {
                html: {
                    template: "internal/reports/pcr/#{action_name}/pdf_template_header"
                }
            },
            layout: 'pdf_bootstrap.html',
            viewport_size: '1280x1024',
            margin: {
                top: 15,
                left: 12,
                right: 12,
                bottom: 10,
            },
            page_size: 'A4',
            page_height: '29.7cm',
            page_width: '21cm',
            dpi: '300',
            default_header: false
    end

    def set_date_time
        @date = DateTime.current.strftime('%d/%m/%Y')
        @time = DateTime.current.strftime('%H:%M:%S %p')
    end

    def set_company_name
        @company_name = SystemConfiguration.get('COMPANY_NAME')
    end

    def check_format_html # need to keep this here for the mailers
        begin
            # Can't run presence check on request. So only way is to rescue a request from email.
            response = request&.format == "html"
        rescue
            response = false
        end
        response
    end
end
