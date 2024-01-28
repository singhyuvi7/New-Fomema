# frozen_string_literal: true

# XQCC reports module
module ReportsXQCC
  extend ActiveSupport::Concern

  included do
    before_action :set_date_time, only: %i[xqcc_quality_summary
                                           merts_quality_summary]
    before_action :set_company_name, only: %i[radiographer_daily_summary]
  end

  def radiographer_daily_summary
    respond_to do |format|
      @headers = ['No', 'Batch Id', 'X-Ray Code', 'X-ray Facility Name', 'Total Image', 'Suspicious', 'Identical', 'Wrongly Transmitted', 'Normal', 'IQA', 'Compliance', 'Non-Compliance']
      @radiographers = User.where(id: XrayReview.pluck(:radiographer_id).compact.uniq).active

      if params[:date].present?
        service = Report::RadiographerDailySummaryReportService.new(params[:date], params[:radiographer_id])
        @data = service.result if service.valid?
      end

      format.html { render_xqcc_html }
      format.xlsx { render_xqcc_xlsx }
      format.pdf do
        render(
          pdf: action_name,
          template: "internal/reports/xqcc/#{action_name}/_pdf_template.html.haml",
          header: {
              html: {
                  template: "internal/reports/xqcc/#{action_name}/pdf_template_header"
              }
          },
          layout: 'pdf.html',
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
        )
      end
    end
  end

  def xqcc_quality_summary
    @year = params[:year].presence
    @xray_code = params[:xray_code].presence
    @film_type = params[:film_type].presence

    if @year.present? && @xray_code.present?
      service = Report::XqccQualitySummaryReportService.new(@xray_code, @year, @film_type)

      if service.valid?
        service.result
        @non_comply_data = service.non_comply_data
        @xqcc_data = service.xqcc_data
        @stats = service.stats
        @xray_facility = service.xray_facility.decorate
      end
    end

    respond_to do |format|
      format.html { render_xqcc_html }
      #format.xlsx { render_xqcc_xlsx }
      format.pdf do
        @pdf = true
        render  pdf: action_name,
                template: "internal/reports/xqcc/#{action_name}/_pdf_template.html.haml",
                header: {
                    html: {
                        template: "internal/reports/xqcc/#{action_name}/pdf_template_header"
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
                default_header: false,
                zoom: 0.8
      end
    end
  end

  def merts_quality_summary
    @year = params[:year].presence
    @xray_code = current_user.code
    @film_type = params[:film_type].presence

    if @year.present? && @xray_code.present?
      service = Report::XqccQualitySummaryReportService.new(@xray_code, @year, @film_type)

      if service.valid?
        service.result
        @non_comply_data = service.non_comply_data
        @xqcc_data = service.xqcc_data
        @stats = service.stats
        @xray_facility = service.xray_facility.decorate
      end
    end

    respond_to do |format|
      format.html { render_merts_html }
      format.xlsx { render_xqcc_xlsx }
      format.pdf do
        @pdf = true
        render  pdf: action_name,
                template: "external/quality_summary_reports/#{action_name}/_pdf_template.html.haml",
                header: {
                    html: {
                        template: "external/quality_summary_reports/#{action_name}/pdf_template_header"
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
                default_header: false,
                zoom: 0.8
      end
    end
  end

  def xqcc_daily_total_xray_received
    worksheet_1     = []
    query_date      = params[:query_date]

    worksheet_1     << {
      data: ["DATE", "TOTAL X-RAY RECEIVED", "PENDING PICKUP BY RADIOGRAPHER (Certified)", "PENDING PICKUP BY RADIOGRAPHER (Pending Certification)"],
      style: styling(bold, font("Calibri"), border("028001")) * 32
    }

    if query_date.present?
      worksheet_1   << Report::DailyTotalXrayReceivedService.new(query_date).result
    end

    @excel          = [worksheet_1]

    @filter_options = [{ type: "date", label: "Received Date" }]
    parse_output_format('XQCC Daily Total Received (By Received Date)')
  end

  def xqcc_daily_total_xray_received_by_certification
    worksheet_1     = []
    query_date      = params[:query_date]

    worksheet_1     << {
      data: ["CERTIFICATION DATE", "TOTAL X-RAY RECEIVED", "PENDING PICKUP BY RADIOGRAPHER"],
      style: styling(bold, font("Calibri"), border("028001")) * 32
    }

    if query_date.present?
      worksheet_1   << Report::DailyTotalXrayReceivedByCertificationService.new(query_date).result
    end

    @excel          = [worksheet_1]

    @filter_options = [{ type: "date", label: "Certification Date" }]
    parse_output_format('XQCC Daily Total Received (By Certification Date)')
  end

  def xqcc_digital_xray_certified
     @csv        = [["X-RAY STATUS", "TOTAL"]]

    if params[:filter_date_start].present? && params[:filter_date_end].present?
      start_date      = params[:filter_date_start].to_date
      end_date        = params[:filter_date_end].to_date.tomorrow
      data            = ActiveRecord::Base.connection.execute("select result, count(*) from xray_examinations xe left join transactions on xe.transaction_id = transactions.id where transactions.xray_film_type = 'DIGITAL' and xe.transmitted_at is not null and transmitted_at >= '#{start_date}' and transmitted_at <= '#{end_date}' group by xe.result")

      data.each do |d|
        @csv    << [d["result"], d["count"]]
      end
    end

    if check_format_html
      headers_footers ||= 1
      total_size      = @csv.size - headers_footers
      @csv            = @csv.first(500 + headers_footers)
      showing_size    = @csv.size - headers_footers
      @displayed_size = "Showing #{ showing_size } out of #{ total_size } rows"
    end

    @filter_options = [{ type: "date range", label: "Date Range" }]
    parse_output_format('XQCC Digital Xray - Certified')
  end

  def xqcc_daily_dispatch_list
    @csv            = [["RECEIVED DATE", "USER ID", "TOTAL RECEIVED"]]
    start_date      = params[:filter_date_start]
    end_date        = params[:filter_date_end]

    if start_date.present? && end_date.present?
      data  = Report::XqccDailyDispatchListReportService.new(start_date, end_date).result

      data.each do |d|
        @csv    << [d.received_date, d.staff_name, d.received_count]
      end
    end

    @filter_options = [{ type: "date range", label: "Date Range" }]
    parse_output_format("XQCC Daily Dispatch List")
  end

  def xqcc_daily_film_review
    @csv            = [Report::XqccDailyFilmReviewReportService.headers]
    start_date      = params[:filter_date_start]
    end_date        = params[:filter_date_end]

    if start_date.present? && end_date.present?
        data        = Report::XqccDailyFilmReviewReportService.new(start_date, end_date).result

        data.each do |d|
          @csv    << [d.transaction_date.strftime('%d-%^b-%Y'), d.user_id, d.xray_status == "CERTIFIED" ? "REVIEWED" : d.xray_status, d.trans_code, d.fw_code, d.fw_name, d.xf_code, d.xf_name]
        end
    end

    if check_format_html
      headers_footers ||= 1
      total_size      = @csv.size - headers_footers
      @csv            = @csv.first(500 + headers_footers)
      showing_size    = @csv.size - headers_footers
      @displayed_size = "Showing #{ showing_size } out of #{ total_size } rows"
    end

    @filter_options = [{ type: "date range", label: "Date Range" }]
    parse_output_format('Xqcc Daily Film Review')
  end

  def xqcc_pending_radiographer_report
    @headers          = Report::XqccPendingRadiographerReportService.headers
    @radiographers    = Report::XqccPendingRadiographerReportService.radiographers
    query_date        = params[:date]
    radiographer      = params[:uid]

    if query_date.present? && radiographer.present?
      @radiographer   = User.find(radiographer)
      @data           = Report::XqccPendingRadiographerReportService.new(query_date, radiographer).result
    end

    render_xqcc_html
  end

  def xqcc_monthly_xray_received_and_viewed
    @csv              = [Report::XqccMonthlyXrayReceivedAndViewedReportService.headers]
    query_year        = params[:selected_year]
    query_month       = params[:selected_month]

    if query_year.present?
      @csv = Report::XqccMonthlyXrayReceivedAndViewedReportService.new(query_year, query_month).result
    elsif query_month.present? && query_year.blank?
      flash[:error] = "Year cannot be blank."
      redirect_to request.path and return
    end

    @filter_options = [
      { type: "select list", label: "Year", list: Date.today.year.downto(2000), field_name: :selected_year },
      { type: "select list", label: "Month", list: Date::MONTHNAMES.compact.map(&:upcase), field_name: :selected_month }
    ]
    parse_output_format('XQCC Monthly Xray Received and Viewed')
  end

  def radiographer_pending_review_report
    @headers        = Report::RadiographerPendingReviewReportService.headers
    @radiographers  = Report::RadiographerPendingReviewReportService.radiographers
    start_date      = params[:start_date]
    end_date        = params[:end_date]

    if start_date.present? && end_date.present?
      @data         = Report::RadiographerPendingReviewReportService.new(start_date, end_date).result
    end

    render_xqcc_html
  end

  def xqcc_monthly_non_compliance_report
    @headers      = Report::XqccMonthlyNonComplianceReportService.headers
    @csv          = [Report::XqccMonthlyNonComplianceReportService.headers]
    xray_code     = params[:text_field]
    query_month   = params[:query_month]

    if query_month.present? && xray_code.present?
      @data = Report::XqccMonthlyNonComplianceReportService.new(query_month, xray_code).result
      @csv << Report::XqccMonthlyNonComplianceReportService.new(query_month, xray_code).result_csv
    end

    respond_to do |format|
      format.html { render_xqcc_html }
      format.csv  {
        send_data CSV.generate { |csv| @csv.map{ |row| csv << row } },
        filename: "#{action_name.camelize}-#{DateTime.current.to_i}.csv"
      }
    end
  end

  def xqcc_dx_film_confirmed_as_abnormal
    worksheet_1 = []
    start_date  = params[:filter_date_start]
    end_date    = params[:filter_date_end]
    status      = params[:status]

    worksheet_1 << {
      data: Report::XqccDxFilmConfirmedAsAbnormalReportService.headers,
      style: styling(bold, font("Calibri"), border("028001")) * 32
    }

    if start_date.present? && end_date.present? && status.present?
      data = Report::XqccDxFilmConfirmedAsAbnormalReportService.new(start_date, end_date, status).result

      if data.present?
        data.each do |d|
          radiographer_name = User.find(d.radiographer_id).name
          worksheet_1 << [d.trans_id, d.pcr_code, d.pcr_name, d.worker_code, d.worker_name, d.xray_code, d.xray_name, d.pcr_comment, d.pcr_impression, radiographer_name]
        end
      end

    end

    @excel          = [worksheet_1]

    @filter_options = [
      { type: "date range", label: "PCR Audit Date" },
      { type: "select list", label: "Film Status", list: ["SUSPICIOUS", "IQA"], field_name: :status }
    ]
    parse_output_format("XQCC DX Film Confirmed As Abnormal")
  end

  def xqcc_dx_pending_audit_pcr
    worksheet_1           = []
    start_date            = params[:filter_date_start]
    end_date              = params[:filter_date_end]
    @to_pickup_headers    = Report::XqccDxPendingAuditPcrReportService.to_pickup_headers
    @to_review_headers    = Report::XqccDxPendingAuditPcrReportService.to_review_headers

    worksheet_1   = {
      data: [@to_pickup_headers],
      style: styling(bold, font("Calibri"), border("028001")) * 32
    }

    if start_date.present? && end_date.present?
      @pending_pickup_data = Report::XqccDxPendingAuditPcrReportService.new(start_date, end_date).pending_pickup_result
      @pending_review_data = Report::XqccDxPendingAuditPcrReportService.new(start_date, end_date).pending_review_result
    end

    @excel          = worksheet_1
    @filter_options = [{ type: "date range", label: "Date Range" }]

    respond_to do |format|
      format.html { render_xqcc_html }
      format.xlsx { render_xqcc_xlsx }
    end
  end

  def xqcc_dx_audit_statistics
    worksheet_1 = []
    start_date  = params[:filter_date_start]
    end_date    = params[:filter_date_end]

    @abnormal_headers     = Report::DxAuditStatisticsReportService.abnormal_headers
    @suspicious_headers   = Report::DxAuditStatisticsReportService.suspicious_headers

    worksheet_1     << {
      data: @abnormal_headers,
      style: styling(bold, font("Calibri"), border("028001")) * 32
    }

    if start_date.present? && end_date.present?
      @start_date     = start_date.to_time
      @end_date       = end_date.to_time

      @data_abnormal, @data_suspicious  = Report::DxAuditStatisticsReportService.new(@start_date, @end_date).result
    end

    @excel          = [worksheet_1]

    @filter_options = [{ type: "date range", label: "Audit Date" }]

    respond_to do |format|
      format.html { render_xqcc_html }
      format.xlsx { render_xqcc_xlsx }
    end
  end

  def xqcc_digital_xray_tat_review
    query_year      = params[:selected_year]
    query_month     = params[:selected_month]

    if query_year.present?
      worksheet_1   = Report::XqccDxTatReviewReportService.new(query_year, query_month).result
    elsif query_month.present? && query_year.blank?
      flash[:error] = "Year cannot be blank."
      redirect_to request.path and return
    end

    @excel          = [worksheet_1]

    @filter_options = [
      { type: "select list", label: "Year", list: Date.today.year.downto(2000), field_name: :selected_year },
      { type: "select list", label: "Month", list: Date::MONTHNAMES.compact.map(&:upcase), field_name: :selected_month }
    ]
    parse_output_format('XQCC Digital X-ray TAT Review')
  end


  def xqcc_daily_boxes_store
    @csv            = [Report::XqccDailyBoxesStoreReportService.headers]
    start_date      = params[:filter_date_start]
    end_date        = params[:filter_date_end]

    if start_date.present? && end_date.present?
      @csv = Report::XqccDailyBoxesStoreReportService.new(start_date, end_date).result
    end

    if check_format_html
      headers_footers ||= 1
      total_size      = @csv.size - headers_footers
      @csv            = @csv.first(500 + headers_footers)
      showing_size    = @csv.size - headers_footers
      @displayed_size = "Showing #{ showing_size } out of #{ total_size } rows"
    end

    @filter_options = [{ type: "date range", label: "Date Range" }]
    parse_output_format('Xqcc Daily Boxes Store')
  end

  def xqcc_daily_film_store
    @csv            = [Report::XqccDailyFilmStoreReportService.headers]
    start_date      = params[:filter_date_start]
    end_date        = params[:filter_date_end]

    if start_date.present? && end_date.present?
      @csv = Report::XqccDailyFilmStoreReportService.new(start_date, end_date).result
    end

    if check_format_html
      headers_footers ||= 1
      total_size      = @csv.size - headers_footers
      @csv            = @csv.first(500 + headers_footers)
      showing_size    = @csv.size - headers_footers
      @displayed_size = "Showing #{ showing_size } out of #{ total_size } rows"
    end

    @filter_options = [{ type: "date range", label: "Date Range" }]
    parse_output_format('Xqcc Daily Film Store')
  end

  def xqcc_summary_pending_review
    worksheet_1   = []
    date          = params[:date]
    @headers      = Report::XqccSummaryPendingReviewService.headers

    worksheet_1     << {
      data: @headers,
      style: styling(bold, font("Calibri"), border("028001")) * 32
    }

    if date.present?
      @daily_data, @monthly_data = Report::XqccSummaryPendingReviewService.new(date).result
    end

    @excel = [worksheet_1]

    respond_to do |format|
      format.html { render_xqcc_html }
      format.xlsx { render_xqcc_xlsx }
    end
  end


  def  xqcc_misread
      @csv            = [["No", "X-ray Code", "X-ray Facility Name", "Total X-ray Done","Total Amended Normal To Abnormal", "Total Amended Abnormal To Normal","Total Misread By Xray Facility","Total Misread By Reporting Radiologist","Total Misread By Radiologist Operated Facility","Percentage Of Under Reporting","Percentage Of Over Reporting","Percentage Of Misread"]]
      letters         = []
      where_query     = []

      if params[:filter_date_start].present? && params[:filter_date_end].present?
          start_date  = params[:filter_date_start].to_date
          end_date    = params[:filter_date_end].to_date.tomorrow
          where_query << "t.certification_date >= '#{ start_date }' and t.certification_date < '#{ end_date }'"
      end

      if where_query.present?
          letters     = ActiveRecord::Base.connection.execute("select id,xray_code,xray_fac_name, count(1)as xray_done,
                                                              sum(a.tanta) as total_normal_to_abnormal, sum(a.taatn) as total_abnormal_to_normal, sum(a.tanta)+ sum(a.taatn) as total_misread_by_x,
                                                              sum(case when radiologist_id is not null and (a.taatn =1 or a.tanta=1) then 1 else 0 end) as total_misread_by_report_radio,
                                                              sum(case when radiologist_operated = true and  (a.taatn =1 or a.tanta=1) then 1 else 0 end) as total_misread_by_operated_fac,
                                                              to_char(float8(round(sum(a.taatn))/round(count(1))*100),'FM9999999990.00') as total_over_report,
                                                              to_char(float8(round(sum(a.tanta))/round(count(1))*100),'FM9999999990.00') as total_under_report,
                                                              to_char(float8(round(sum(a.tanta)+ sum(a.taatn))/round(count(1))*100),'FM9999999990.00') as total_misread
                                                              from (
                                                                  select xf.id as id,xf.code as xray_code, xf.name as xray_fac_name,
                                                                  case when XE.result ='NORMAL' and t.xray_result ='UNSUITABLE' then 1 else 0 end as tanta,
                                                                  case when XE.result ='ABNORMAL' and t.xray_result ='SUITABLE' then 1 else 0 end as taatn,
                                                                  xf.license_holder_name as submit_xray_doctor, r.name as submit_radiologist_name, xf.radiologist_name, xf.radiologist_operated,
                                                                  t.certification_date, t.status,t.radiologist_id
                                                                  from transactions t
                                                                  inner join xray_examinations xe on t.id = xe.transaction_id
                                                                  inner join xray_facilities xf on t.xray_facility_id = xf.id
                                                                  left join radiologists r on t.radiologist_id = r.id
                                                                  left join medical_examination_details med on t.id = med.transaction_id
                                                                  where #{ where_query.join(" and ") }
                                                                  and t.xray_result is not null and xe.result  is not null
                                                              ) a
                                                              group by id,xray_code,xray_fac_name")
      end

      letters.each.with_index(1) do |row, index|
          @csv << [index, row.values[1..-1]].flatten
      end

      if check_format_html
          headers_footers ||= 1
          total_size      = @csv.size - headers_footers
          @csv            = @csv.first(500 + headers_footers)
          showing_size    = @csv.size - headers_footers
          @displayed_size = "Showing #{ showing_size } out of #{ total_size } rows"
      end

        @filter_options = [
            { type: "date range", label: "Date Range" },
        ]

      parse_output_format("Misread Report")
  end

  def  xqcc_detail_misread
      @csv            = [["No", "Transaction Code", "Foreign Worker Name","X-ray Code","X-ray Facility Name","X-ray Report (Abnormal/Normal)", "Final X-ray Report (Abnormal/Normal)","Name Of Self Submit Doctor","Name Of Reporting Radiologist","Name Of Radio Operated Doctor","PTB","Heart Disease","Others"]]
      letters         = []
      where_query     = []

      if params[:filter_date_start].present? && params[:filter_date_end].present?
          start_date  = params[:filter_date_start].to_date
          end_date    = params[:filter_date_end].to_date.tomorrow
          where_query << "t.certification_date >= '#{ start_date }' and t.certification_date < '#{ end_date }'"
      end

      if where_query.present?
          letters     = ActiveRecord::Base.connection.execute("select t.id, t.code as trans_id, t.fw_name as fw_name, xf.code as xray_code, xf.name as xray_fac_name,
                                                              xe.result as xray_report,
                                                              case when t.xray_result ='SUITABLE' then 'NORMAL'
                                                                  when t.xray_result ='UNSUITABLE' then 'ABNORMAL' end as final_xray_result,
                                                              xf.license_holder_name as submit_xray_doctor, r.name as submit_radiologist_name,
                                                              max(case when xf.radiologist_operated=true then 'Yes' else 'No' end) radiologist_operated,
                                                              max(case when c.code='3502' then 'Yes' else 'No' end ) tb,
                                                              max(case when c.code='3515' then 'Yes' else 'No' end )heart,
                                                              max(case when c.code='3520' then 'Yes' else 'No' end) othrs
                                                              from transactions t
                                                              inner join xray_examinations xe on t.id = xe.transaction_id
                                                              inner join xray_facilities xf on t.xray_facility_id = xf.id
                                                              left join radiologists r on t.radiologist_id = r.id
                                                              left join medical_examination_details med on t.id = med.transaction_id
                                                              left join conditions c on MED.condition_id=C.ID
                                                              where #{ where_query.join(" and ") }
                                                              and med.condition_id in (82, 91, 99)
                                                              and xe.result <> case when t.xray_result ='SUITABLE' then 'NORMAL'
                                                                when t.xray_result ='UNSUITABLE' then 'ABNORMAL' end
                                                              group by  t.id, t.code, t.fw_name, xf.code , xf.name,
                                                              xe.result ,
                                                              case when t.xray_result ='SUITABLE' then 'NORMAL'
                                                                  when t.xray_result ='UNSUITABLE' then 'ABNORMAL' end,
                                                              t.xray_result ,
                                                              xf.license_holder_name , r.name , xf.radiologist_name, xf.radiologist_operated,
                                                              t.certification_date, t.xray_result, t.status, xe.result order by t.id")
      end

      letters.each.with_index(1) do |row, index|
          @csv << [index, row.values[1..-1]].flatten
      end

      if check_format_html
        headers_footers ||= 1
        total_size      = @csv.size - headers_footers
        @csv            = @csv.first(500 + headers_footers)
        showing_size    = @csv.size - headers_footers
        @displayed_size = "Showing #{ showing_size } out of #{ total_size } rows"
      end

      @filter_options = [
          { type: "date range", label: "Date Range" },
      ]

      parse_output_format("Misread Report")
  end

  def  xqcc_detail_misread
    @csv            = [["No", "Transaction Code", "Foreign Worker Name","X-ray Code","X-ray Facility Name","X-ray Report (Abnormal/Normal)", "Final X-ray Report (Abnormal/Normal)","Name Of Self Submit Doctor","Assigned Radiologist","Name of Radio Operated Doctor","PTB","Heart Disease","Others"]]
    letters         = []
    where_query     = []

    if params[:filter_date_start].present? && params[:filter_date_end].present?
        start_date  = params[:filter_date_start].to_date
        end_date    = params[:filter_date_end].to_date.tomorrow
        where_query << "t.certification_date >= '#{ start_date }' and t.certification_date < '#{ end_date }'"
    end

    if where_query.present?
        letters     = ActiveRecord::Base.connection.execute("select t.id, t.code as trans_id, t.fw_name as fw_name, xf.code as xray_code, xf.name as xray_fac_name,
        xe.result as xray_report,
            case when t.xray_result ='SUITABLE' then 'NORMAL'
                when t.xray_result ='UNSUITABLE' then 'ABNORMAL' end as final_xray_result,
        max (case when xf.radiologist_operated=true then '' else  xf.license_holder_name end) as submit_xray_doctor,
        max(case when t.radiologist_id is not null then r.name end)assign_radiologist,
        max(case when xf.radiologist_operated=true then xf.radiologist_name else '' end) radiologist_operated,
        max(case when xpd.condition_tuberculosis ='YES' then 'Yes' else 'No' end ) tb,
        max(case when xpd.condition_heart_diseases = 'YES' then 'Yes' else 'No' end )heart,
        max(case when xpd.condition_other = 'YES' then 'Yes' else 'No' end) othrs
        from transactions t
        inner join xray_examinations xe on t.id = xe.transaction_id
        inner join xray_facilities xf on t.xray_facility_id = xf.id
        left join radiologists r on t.radiologist_id = r.id
        left join xray_pending_decisions xpd on t.id = xpd.transaction_id
        where #{ where_query.join(" and ") }
        and xe.result <> case when t.xray_result ='SUITABLE' then 'NORMAL'
        when t.xray_result ='UNSUITABLE' then 'ABNORMAL' end
        group by  t.id, t.code, t.fw_name, xf.code , xf.name,
        xe.result ,
        case when t.xray_result ='SUITABLE' then 'NORMAL'
            when t.xray_result ='UNSUITABLE' then 'ABNORMAL' end,
        t.xray_result ,
        xf.license_holder_name , r.name , xf.radiologist_name, xf.radiologist_operated,
        t.certification_date, t.xray_result, t.status, xe.result
        order by t.id")
    end

    letters.each.with_index(1) do |row, index|
        @csv << [index, row.values[1..-1]].flatten
    end

    if check_format_html
      headers_footers ||= 1
      total_size      = @csv.size - headers_footers
      @csv            = @csv.first(500 + headers_footers)
      showing_size    = @csv.size - headers_footers
      @displayed_size = "Showing #{ showing_size } out of #{ total_size } rows"
    end

    @filter_options = [
      { type: "date range", label: "Date Range" },
    ]

    parse_output_format("Detail Misread Report")
  end

def pcr_audit_summary_report
  worksheet   = [
      data: ["PCR Audit Summary Report"],
      style: styling(bold)
  ]

  reviews             = []
  all_totals          = []
  @extended_headers   = 1


  if params[:filter_date_start].present? && params[:filter_date_end].present?
      start_date  = params[:filter_date_start].to_date
      end_date    = params[:filter_date_end].to_date.tomorrow
      timestamp   = "_#{ params[:filter_date_start] }_to_#{ params[:filter_date_end] }"

      worksheet   = [
          data: ["PCR Audit Summary Report for the month #{ start_date.strftime("%m-%Y") }"],
          style: styling(bold)
      ]

      audits   = ActiveRecord::Base.connection.execute(" select pr.transmitted_at::date date,  users.name as name, count(*)
          from pcr_reviews pr
          left join medical_appeals on pr.medical_appeal_id = medical_appeals.id
          left join USERS users on pr.pcr_id = users.id
          where pr.transmitted_at >= '#{ start_date }' and pr.transmitted_at < '#{ end_date }'
          and pcr_id is not null
          group by date, users.name order by date, users.name")
  end

  if audits.present?
      @extended_headers   = 2
      users               = audits.map {|hash| hash["name"] }.uniq.sort.sort_by {|name| name }
      total_users         = users.size
      renamed_users       = users.map {|name| name }

      worksheet << {
          data: [""] + renamed_users + ["Total"],
          style: styling(bold, border) + styling(bold, border(:t, :b)) * total_users + styling(bold, border)
      }

      (start_date...end_date).each do |date|
          selected_rows   = audits.select {|hash| hash["date"] == date.to_s }
          next if selected_rows.blank?

          user_values = users.map do |user_name|
              value_row = selected_rows.find {|hash| hash["name"] == user_name }
              value_row ? value_row["count"] : 0
          end

          all_totals << user_values + [user_values.sum]

          worksheet << {
              data: [date.strftime("%d-%m-%Y")] + user_values + [user_values.sum],
              style: styling(border(:l, :r)) + [{}] * total_users + styling(border(:l, :r))
          }
      end

      grand_total = all_totals.present? ? all_totals.transpose.map(&:sum) : [0] * (total_users + 1)

      worksheet << {
          data: ["Grand Total"] + grand_total,
          style: styling(bold, border) + styling(bold, border(:t, :b)) * total_users + styling(bold, border)
      }
  end
  if check_format_html
      headers_footers = 1
      total_size      = worksheet.size - headers_footers
      worksheet       = worksheet.first(500 + headers_footers)
      showing_size    = worksheet.size - headers_footers
      @displayed_size = "Showing #{ showing_size } out of #{ total_size } rows"
  end

  @excel          = [worksheet]
  @column_widths  = []
  @column_widths  << [13]
  @filter_options = [{ type: "date range", label: "Date Range" }]
  parse_output_format("pcr_audit_summary_report#{ timestamp }")

end

  private

  def verify_xqcc_reports_access
    can_access?('XQCC_REPORTS')
  end

  def verify_pcr_reports_access
    can_access?('PCR_REPORTS')
  end

  def render_xqcc_html
    render "internal/reports/xqcc/#{action_name}/index"
  end

  def render_merts_html
    render "external/quality_summary_reports/#{action_name}/index"
  end

  def render_xqcc_xlsx
    render xlsx: 'index', filename: "#{action_name.camelize}-#{DateTime.current.to_i}.xlsx",
           template: "internal/reports/xqcc/#{action_name}/index"
  end

  def render_xqcc_pdf
    @pdf = true
    render pdf: action_name,
           template: "internal/reports/xqcc/#{action_name}/_pdf_template.html.haml",
           header: {
               html: {
                   template: "internal/reports/xqcc/#{action_name}/pdf_template_header"
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
    @company_name = SystemConfiguration.find_by(code: 'COMPANY_NAME')&.value
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
