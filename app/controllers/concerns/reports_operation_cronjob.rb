# frozen_string_literal: true

# Operation or branch reports cronjob module
module ReportsOperationCronjob
  extend ActiveSupport::Concern

  def daily_branch_registration_cronjob
    @link = daily_branch_registration_internal_operation_reports_path
    parse_output_format('daily branch registration report')
  end

  def daily_branch_registration_interim_cronjob
    @link = daily_branch_registration_internal_operation_reports_path
    parse_output_format('daily branch registration report interim')
  end

  def daily_monthly_registration_with_ytd_cronjob
    @link = daily_monthly_registration_with_ytd_internal_operation_reports_path
    parse_output_format('Daily & Monthly Registration Report with YTD')
  end

  private

  def parse_output_format(filename)
    respond_to do |format|
        format.html { @filename = filename; render 'shared/reports/reports_preview_table' }
        format.csv { send_data CSV.generate { |csv| @csv.each { |row| csv << row } }, filename: "#{ filename }.csv" }
        format.xlsx { render template: 'shared/reports/excel_caxlsx_template', xlsx: "#{ filename }" }
    end
  end
end
