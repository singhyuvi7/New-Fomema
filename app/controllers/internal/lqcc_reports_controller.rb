# frozen_string_literal: true

module Internal
    # inspectorate reports controller
    class LqccReportsController < InternalController
  
      before_action -> { can_access?('LQCC_REPORTS') }
      before_action :set_visit_report, only: [:edit_master_list, :update_master_list]
  
      def index
        inspectorate_reports = [
          { title: 'Master List', path: master_list_internal_lqcc_reports_path }
        ]
  
        @reports = [
          { title: 'LQCC Reports', reports: inspectorate_reports }
        ]
        render 'shared/reports/index'
      end

      def master_list
        @start_date = params[:start_date].presence
        @end_date = params[:end_date].presence
        @visit_reports = []
        @visit_report_collections = []
        @visit_report_full_partials = []
  
        if @start_date.present? && @end_date.present?
            @visit_report_collections = VisitReport.search_approved_by_visit_year('Laboratory',@start_date, @end_date)
            .joins(:laboratory_type)
            .where(laboratory_types: {name: "COLLECTION"})
            .search_code(params[:visit_report_code])

            @visit_report_full_partials = VisitReport.search_approved_by_visit_year('Laboratory',@start_date, @end_date)
            .joins(:laboratory_type)
            .where.not(laboratory_types: {name: "COLLECTION"})
            .search_code(params[:visit_report_code])

            @visit_reports = @visit_report_collections+@visit_report_full_partials
        end

        # render json: @visit_report_full_partials and return
  
        respond_to do |format|
          format.html { render 'internal/reports/lqcc/master_list/index' }
          format.xlsx do
              render xlsx: 'index', filename: "Master List - LQCC - #{@start_date.try(:to_date).try(:strftime,'%d%m%Y')} to #{@end_date.try(:to_date).try(:strftime,'%d%m%Y')}.xlsx",
                    template: 'internal/reports/lqcc/master_list/index'
          end
        end
      end 

      def edit_master_list
        respond_to do |format|
          format.html { render 'internal/reports/lqcc/master_list/edit' }
        end
      end

      def update_master_list
        @visit_report.assign_attributes(visit_report_params)

        respond_to do |format|
            if @visit_report.save
                flash[:notice] = "Data has been updated"
                format.html { redirect_to master_list_internal_lqcc_reports_path+params[:filter_params] }
            else
                format.html { render 'internal/reports/lqcc/master_list/edit' }
            end
        end
      end
  
      private

      def set_visit_report
        @visit_report = VisitReport.find(params[:id])
      end
  
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

      def visit_report_params
        params.require(:visit_report).permit(:committee_meeting_date, :letter_reminder_date)
      end
    end
  end
  