# frozen_string_literal: true

# Operation or branch reports module
module ReportsOperation
  extend ActiveSupport::Concern

  included do
    before_action :check_month_params_presence, only: %i[monthly_registration_by_job_type monthly_registration_by_job_type],
                                                if: :xlsx_request?
    before_action :set_company_name, only: %i[health_screening_statistics details_worker_insurance daily_monthly_worker_insurance]
    before_action :set_branches, only: %i[details_worker_insurance]
  end

  def monthly_registration_by_job_type
    respond_to do |format|
      format.html do
        @months = year_month_options_list
        render_operation_html
      end
      format.xlsx do
        @year, month = params[:month].split('-')
        @month = Date::MONTHNAMES[month.to_i]
        @branches, @job_types, @data, @total = Report::MonthlyRegistrationByJobTypeService.new(@year, month).result

        render_operation_xlsx
      end
    end
  end

  def monthly_registration_by_branch
    respond_to do |format|
      format.html do
        @months = year_month_options_list
        render_operation_html
      end
      format.xlsx do
        @year, month = params[:month].split('-')
        @month = Date::MONTHNAMES[month.to_i]
        @data, @total = Report::MonthlyRegistrationByBranchService.new(@year, month).result

        render_operation_xlsx
      end
    end
  end

  def health_screening_statistics
    respond_to do |format|
      format.html { render_operation_html }
      format.xlsx do
        @sector_data, @state_data, @origin_data, @total_count = Report::HealthScreeningStatisticsService.new.result
        render_operation_xlsx
      end
    end
  end

  def daily_branch_registration
    @date = params[:date].presence
    @for_mail = false
    if @date
      service = Report::DailyBranchRegistrationReportService.new(params[:date])
      @headers = service.headers
      if service.valid?
        @data, @certification_data, @registration_headers, @certification_headers = service.result
        @date = service.date
      end
    end

    respond_to do |format|
      format.html { render_operation_html }
    end
  end

  def daily_monthly_registration_with_ytd
    @date = params[:date].presence
    @for_mail = false

    if @date
      service = Report::DailyRegistrationDetailReportService.new(@date)

      if service.valid?
        @past_year, @current_year, @current_year_monthly, @current_month_daily, @branches_data, @branches, @cert_past_year, @cert_current_year, @cert_current_year_monthly, @cert_current_month_daily = service.result
      end
    end

    respond_to do |format|
      format.html { render_operation_html }
    end
  end

  def regpatiday
    @csv        = [["TRANSDATE", "BRANCH", "TOTAL"]]
    start_date      = params[:filter_date_start]
    end_date        = params[:filter_date_end]

    if start_date && end_date
      data  = Report::DailyRegpatidayReportService.new(start_date, end_date).result

      data.each do |d|
        @csv    << [d["transaction_date"].to_datetime.strftime("%d-%b-%Y"), d["branch"], d["count"]]
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
    parse_output_format('Regpatiday')
  end

  def details_worker_insurance

    @start_date = params[:start_date].presence
    @end_date = params[:end_date].presence
    @branch_id = params[:branch]
    @insurance_service_provider_id = params[:insurance_service_provider_id]

    if @start_date && @end_date
      order_ids = OrderItem.joins(:order).get_insurance_fee.where(orders:{paid_at: @start_date.to_date.beginning_of_day..@end_date.to_date.end_of_day}).pluck('orders.id').uniq

      # @data = Order.search_organization(@branch_id).where(:id => order_ids).order('paid_at ASC')
      query = apply_scopes(Order).search_organization(@branch_id).where("orders.id in (?)", order_ids)

      if !@insurance_service_provider_id.blank?
        query = query.joins("JOIN insurance_purchases ON insurance_purchases.order_id = orders.id")
        .where("insurance_purchases.insurance_service_provider_id = #{@insurance_service_provider_id}")
      end

      @data = query.order('paid_at ASC')

      order_items = @data.joins(:order_items)
      @total_sst = order_items.merge(OrderItem.get_insurance_sst).sum('order_items.amount') || 0
      @total_stamp_duty = order_items.merge(OrderItem.get_insurance_stamp_duty).sum('order_items.amount') || 0
      @total_gross_premium = order_items.merge(OrderItem.get_insurance_gross_premium).sum('order_items.amount') || 0
      @total_adminfees = order_items.merge(OrderItem.get_insurance_adminfees).sum('order_items.amount') || 0
      @total_adminfees_sst = order_items.merge(OrderItem.get_insurance_adminfees_sst).sum('order_items.amount') || 0
    end

    respond_to do |format|
      format.html { render_operation_html }
      format.xlsx do
        render_operation_xlsx
      end
    end
  end

  def daily_monthly_worker_insurance
    @date = params[:month].presence

    if @date
      ## if its current month, dont put end of day

      @date = @date.to_date
      current_month = Date.today.month
      start_date = @date.beginning_of_month.beginning_of_day
      end_date = current_month == @date.month ? Date.today.end_of_day : @date.end_of_month.end_of_day
      year_first_date = start_date.beginning_of_year

      fee_codes = ['INSURANCE_GROSS_PREMIUM','TRANSACTION_MALE','TRANSACTION_FEMALE']

      @monthly_data = OrderItem.joins(:order)
      .joins( "INNER JOIN fees ON order_items.fee_id = fees.id" )
      .where(orders:{paid_at: year_first_date..end_date})
      .where('fees.code IN (?)',fee_codes)
      .select("extract(month from paid_at) as month, extract(year from paid_at) as year, sum(case when fees.code = 'TRANSACTION_MALE' or fees.code = 'TRANSACTION_FEMALE' then 1 else 0 end) as registration, sum(case when fees.code = 'INSURANCE_GROSS_PREMIUM' and order_items.amount > 0 and (orders.insurance_service_provider_id = 1 or orders.insurance_service_provider_id is null) then 1 else 0 end) as insurance_howden, sum(case when fees.code = 'INSURANCE_GROSS_PREMIUM' and order_items.amount > 0 and orders.insurance_service_provider_id = 2 then 1 else 0 end) as insurance_protectmigrant, sum(case when fees.code = 'INSURANCE_GROSS_PREMIUM' and order_items.amount > 0 then 1 else 0 end) as insurance")
      .group("month, year").order('month ASC')

      @daily_data = OrderItem.joins(:order)
      .joins( "INNER JOIN fees ON order_items.fee_id = fees.id" )
      .where(orders:{paid_at: start_date..end_date})
      .where('fees.code IN (?)',fee_codes)
      .select("DATE(orders.paid_at) as paid_date, sum(case when fees.code = 'TRANSACTION_MALE' or fees.code = 'TRANSACTION_FEMALE' then 1 else 0 end) as registration, sum(case when fees.code = 'INSURANCE_GROSS_PREMIUM' and order_items.amount > 0 and (orders.insurance_service_provider_id = 1 or orders.insurance_service_provider_id is null) then 1 else 0 end) as insurance_howden, sum(case when fees.code = 'INSURANCE_GROSS_PREMIUM' and order_items.amount > 0 and orders.insurance_service_provider_id = 2 then 1 else 0 end) as insurance_protectmigrant, sum(case when fees.code = 'INSURANCE_GROSS_PREMIUM' and order_items.amount > 0 then 1 else 0 end) as insurance")
      .group("paid_date").order('paid_date ASC')

    end

    respond_to do |format|
      format.html { render_operation_html }
      format.xlsx do
        render_operation_xlsx
      end
    end
  end

  private

  def set_company_name
    @company_name = SystemConfiguration.find_by(code: 'COMPANY_NAME')&.value
  end

  def render_operation_html
    render "internal/reports/operation/#{action_name}/index"
  end

  def render_operation_xlsx
    render xlsx: 'index', filename: "#{action_name.camelize}-#{DateTime.current.to_i}.xlsx",
           template: "internal/reports/operation/#{action_name}/index"
  end

  def render_operation_pdf
    render pdf: action_name,
           template: "internal/reports/operation/#{action_name}/_pdf_template.html.haml",
           header: {
               html: {
                   template: "internal/reports/operation/#{action_name}/pdf_template_header"
               }
           },
           **default_pdf_options
  end

  def check_month_params_presence
    return if params[:month].present?

    redirect_to(monthly_registration_by_job_type_internal_operation_reports_path, notice: 'Require to input month field')
  end

  def xlsx_request?
    request.format.xlsx?
  end

  def year_month_options_list
    (1.year.ago.beginning_of_month.to_date..DateTime.current.end_of_month.to_date)
      .map { |d| [d.strftime('%Y-%b'), "#{d.year}-#{d.month}"] }
      .uniq
      .reverse
  end

  def set_branches
    @branches = Organization.where(:org_type => 'BRANCH')
  end
end
