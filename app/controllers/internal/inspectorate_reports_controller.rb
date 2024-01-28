# frozen_string_literal: true

module Internal
    # inspectorate reports controller
    class InspectorateReportsController < InternalController
      include InspectorateMasterList
      include InspectorateVisitPlanRequest
  
      before_action -> { can_access?('INSPECTORATE_REPORTS') }

      has_scope :start_date
      has_scope :end_date
  
      def index
        inspectorate_reports = [
          { title: 'Master List', path: master_list_internal_inspectorate_reports_path },
          { title: 'Visit Plan Request', path: visit_plan_request_internal_inspectorate_reports_path },
          { title: 'By State', path: by_state_internal_inspectorate_reports_path },
          { title: 'By Insp', path: by_insp_internal_inspectorate_reports_path },
          { title: 'Visited Statistic', path: visited_statistic_internal_inspectorate_reports_path },
          { title: 'Non-Compliance Clinic', path: non_compliance_clinic_internal_inspectorate_reports_path },
          { title: 'Non-Compliance Xray', path: non_compliance_xray_internal_inspectorate_reports_path },
        ]
  
        @reports = [
          { title: 'Inspectorate Reports', reports: inspectorate_reports }
        ]
        render 'shared/reports/index'
      end

      def master_list
        @batches = InspMasterListBatch.search_date_range(params[:start_date],params[:end_date])
        .order('start_date DESC, created_at DESC')
        .page(params[:page])
        .per(get_per)

        respond_to do |format|
          format.html { render 'internal/reports/inspectorate/master_list/index' }
        end
      end 

      def visit_plan_request
        @visit_plan_requests = apply_scopes(VisitPlanRequest)
        .order('created_at DESC')
        .page(params[:page])
        .per(get_per)

        @start_date = params[:start_date].presence
        @end_date = params[:end_date].presence

        respond_to do |format|
          format.html { render 'internal/reports/inspectorate/visit_plan_request/index' }
          format.xlsx do
            render xlsx: 'index', filename: "Visit Plan Request.xlsx",
                  template: 'internal/reports/inspectorate/visit_plan_request/index'
          end
        end
      end
      
      def by_state
        date = params[:date].presence
        @start_date = params[:start_date].presence
        @end_date = params[:end_date].presence
        @state_id = params[:state_id]
        @town_id = params[:town_id]
        @data = []
  
        if @start_date.present? && @end_date.present?
          vr_doctors = VisitReport.joins('join doctors on visitable_id = doctors.id')
      
          vr_doctors = vr_doctors.where('doctors.state_id = ?',@state_id) if !@state_id.blank?
          vr_doctors = vr_doctors.where('doctors.town_id = ?',@town_id) if !@town_id.blank?
      
          vr_doctors = vr_doctors.select("DATE(visit_date) as visited_date, count(*) as doctor_count")
          .where(:status => 'LEVEL_2_APPROVED')
          .where('visit_date BETWEEN ? AND ?', @start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
          .where("visitable_type = 'Doctor'")
          .group('visited_date')
      
          vr_xrays = VisitReport.joins('join xray_facilities on visitable_id = xray_facilities.id')
      
          vr_xrays = vr_xrays.where('xray_facilities.state_id = ?',@state_id) if !@state_id.blank?
          vr_xrays = vr_xrays.where('xray_facilities.town_id = ?',@town_id) if !@town_id.blank?
      
          vr_xrays = vr_xrays.select("DATE(visit_date) as visited_date, count(*) as xray_count")
          .where(:status => 'LEVEL_2_APPROVED')
          .where('visit_date BETWEEN ? AND ?', @start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
          .where("visitable_type = 'XrayFacility'")
          .group('visited_date')
      
          merged_data = vr_doctors + vr_xrays

          merged_data.group_by(&:visited_date).each do |key, value|
            @data << value.as_json.reduce({}, :merge)
          end
        end
        
        respond_to do |format|
            format.html { render 'internal/reports/inspectorate/by_state/index' }
            format.xlsx do
                render xlsx: 'index', filename: "By State - CLINIC & X-RAY - #{@start_date.try(:to_date).try(:strftime,'%d%m%Y')} to #{@end_date.try(:to_date).try(:strftime,'%d%m%Y')}.xlsx",
                       template: 'internal/reports/inspectorate/by_state/index'
            end
        end
      end

      def by_insp
        @start_date = params[:start_date].presence
        @end_date = params[:end_date].presence
        @doctor_inps_counts = []
        @doctor_prepared_counts = []
        @xray_inps_counts = []
        @xray_prepared_counts = []
    
        if @start_date.present? && @end_date.present?
          ## by insp
          @doctor_inps_counts = VisitReport.joins(:visit_report_visitors)
          .search_approved_by_visit_year('Doctor',@start_date, @end_date)
          .where('visit_report_visitors.visitor_id is not null')
          .select('visit_report_visitors.name, count(*) as total')
          .group('visit_report_visitors.name')
    
          @doctor_prepared_counts = VisitReport.joins('join users on prepare_by = users.id')
          .search_approved_by_visit_year('Doctor',@start_date, @end_date)
          .select('users.username as name, count(*) as total')
          .group('users.username')
    
          @xray_inps_counts = VisitReport.joins(:visit_report_visitors)
          .search_approved_by_visit_year('XrayFacility',@start_date, @end_date)
          .where('visit_report_visitors.visitor_id is not null')
          .select('visit_report_visitors.name, count(*) as total')
          .group('visit_report_visitors.name')
    
          @xray_prepared_counts = VisitReport.joins('join users on prepare_by = users.id')
          .search_approved_by_visit_year('XrayFacility',@start_date, @end_date)
          .select('users.username as name, count(*) as total')
          .group('users.username')
        end
    
        respond_to do |format|
          format.html { render 'internal/reports/inspectorate/by_insp/index' }
          format.xlsx do
              render xlsx: 'index', filename: "By Insp - CLINIC & X-RAY - #{@start_date.try(:to_date).try(:strftime,'%d%m%Y')} to #{@end_date.try(:to_date).try(:strftime,'%d%m%Y')}.xlsx",
                     template: 'internal/reports/inspectorate/by_insp/index'
          end
        end
      end

      def visited_statistic
        @start_date = params[:start_date].presence
        @end_date = params[:end_date].presence
        @statistics = []

        if @start_date.present? && @end_date.present?
          ## visit statistics
          @statistics = VisitReport.where(:status => 'LEVEL_2_APPROVED')
          .where('visit_date BETWEEN ? AND ?',@start_date, @end_date)
          .where("visitable_type in ('Doctor','XrayFacility')")
          .select("extract(month from coalesce(prepare_at)) as month, 
          sum(case when visitable_type = 'Doctor' then 1 else 0 end) AS doctor_count,
          sum(case when visitable_type = 'XrayFacility' then 1 else 0 end) AS xray_count,
          count(*) as total")
          .group('month')
        end

        respond_to do |format|
          format.html { render 'internal/reports/inspectorate/visited_statistic/index' }
          format.xlsx do
              render xlsx: 'index', filename: "Visited Statistic - CLINIC & X-RAY - #{@start_date.try(:to_date).try(:strftime,'%d%m%Y')} to #{@end_date.try(:to_date).try(:strftime,'%d%m%Y')}.xlsx",
                    template: 'internal/reports/inspectorate/visited_statistic/index'
          end
        end
      end

      def non_compliance_clinic
        @start_date = params[:start_date].presence
        @end_date = params[:end_date].presence
        ## non compliance clinic
        @doctor_non_compliances = {}
    
        if @start_date.present? && @end_date.present?
    
          VisitReportDoctor::NON_COMPLIANCES.each do |compliance, value|
            doctor_non_compliances = VisitReport.search_approved_by_visit_year('Doctor',@start_date, @end_date)
            .joins(:visit_report_doctor)
            .where("#{compliance} = true")
            .select("sum(case when extract(month from coalesce(prepare_at)) = 1 then 1 else 0 end) AS jan,
            sum(case when extract(month from coalesce(prepare_at)) = 2 then 1 else 0 end) AS feb,
            sum(case when extract(month from coalesce(prepare_at)) = 3 then 1 else 0 end) AS mar,
            sum(case when extract(month from coalesce(prepare_at)) = 4 then 1 else 0 end) AS apr,
            sum(case when extract(month from coalesce(prepare_at)) = 5 then 1 else 0 end) AS may,
            sum(case when extract(month from coalesce(prepare_at)) = 6 then 1 else 0 end) AS jun,
            sum(case when extract(month from coalesce(prepare_at)) = 7 then 1 else 0 end) AS july,
            sum(case when extract(month from coalesce(prepare_at)) = 8 then 1 else 0 end) AS aug,
            sum(case when extract(month from coalesce(prepare_at)) = 9 then 1 else 0 end) AS sept,
            sum(case when extract(month from coalesce(prepare_at)) = 10 then 1 else 0 end) AS oct,
            sum(case when extract(month from coalesce(prepare_at)) = 11 then 1 else 0 end) AS nov,
            sum(case when extract(month from coalesce(prepare_at)) = 12 then 1 else 0 end) AS dec,
            count(*) as total")
            @doctor_non_compliances[compliance] = doctor_non_compliances[0]
          end
        end
    
        respond_to do |format|
          format.html { render 'internal/reports/inspectorate/non_compliance_clinic/index' }
          format.xlsx do
              render xlsx: 'index', filename: "Non-Compliance Clinic - #{@start_date.try(:to_date).try(:strftime,'%d%m%Y')} to #{@end_date.try(:to_date).try(:strftime,'%d%m%Y')}.xlsx",
                     template: 'internal/reports/inspectorate/non_compliance_clinic/index'
          end
        end
      end

      def non_compliance_xray
        @start_date = params[:start_date].presence
        @end_date = params[:end_date].presence
        ## non compliance xray
        @xray_non_compliances = {}
    
        if @start_date.present? && @end_date.present?
    
          VisitReportXrayFacility::NON_COMPLIANCES.each do |compliance, value|
            xray_non_compliances = VisitReport.search_approved_by_visit_year('XrayFacility',@start_date, @end_date)
            .joins(:visit_report_xray_facility)
            .where("#{compliance} = true")
            .select("sum(case when extract(month from coalesce(prepare_at)) = 1 then 1 else 0 end) AS jan,
            sum(case when extract(month from coalesce(prepare_at)) = 2 then 1 else 0 end) AS feb,
            sum(case when extract(month from coalesce(prepare_at)) = 3 then 1 else 0 end) AS mar,
            sum(case when extract(month from coalesce(prepare_at)) = 4 then 1 else 0 end) AS apr,
            sum(case when extract(month from coalesce(prepare_at)) = 5 then 1 else 0 end) AS may,
            sum(case when extract(month from coalesce(prepare_at)) = 6 then 1 else 0 end) AS jun,
            sum(case when extract(month from coalesce(prepare_at)) = 7 then 1 else 0 end) AS july,
            sum(case when extract(month from coalesce(prepare_at)) = 8 then 1 else 0 end) AS aug,
            sum(case when extract(month from coalesce(prepare_at)) = 9 then 1 else 0 end) AS sept,
            sum(case when extract(month from coalesce(prepare_at)) = 10 then 1 else 0 end) AS oct,
            sum(case when extract(month from coalesce(prepare_at)) = 11 then 1 else 0 end) AS nov,
            sum(case when extract(month from coalesce(prepare_at)) = 12 then 1 else 0 end) AS dec,
            count(*) as total")
    
            @xray_non_compliances[compliance] = xray_non_compliances[0]
          end
        end
    
        respond_to do |format|
          format.html { render 'internal/reports/inspectorate/non_compliance_xray/index' }
          format.xlsx do
              render xlsx: 'index', filename: "Non-compliance Xray - #{@start_date.try(:to_date).try(:strftime,'%d%m%Y')} to #{@end_date.try(:to_date).try(:strftime,'%d%m%Y')}.xlsx",
                     template: 'internal/reports/inspectorate/non_compliance_xray/index'
          end
        end
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
  