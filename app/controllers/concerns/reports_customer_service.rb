module ReportsCustomerService
    extend ActiveSupport::Concern

    included do
        before_action :set_company_name, only: %i[bypass_biometric_summary bypass_biometric_detail bypass_biometric_request_detail]
        before_action :set_bypass_types, only: %i[bypass_biometric_summary bypass_biometric_detail bypass_biometric_request_detail]
        before_action :set_reasons, only: %i[bypass_biometric_summary bypass_biometric_detail bypass_biometric_request_detail]
    end

    def bypass_biometric_summary

        start_date = params[:start_date].presence
        end_date = params[:end_date].presence
        @bypass_type = params[:bypass_type]
        @data = []

        if start_date && end_date
            start_date = start_date.to_date.beginning_of_day
            end_date = end_date.to_date.end_of_day

            case @bypass_type
            when 'BEFORE_CERTIFICATION'
                doctor_data = Transaction.joins(:doctor).joins(:doctor_bypass_fingerprint_reason)
                .select("doctors.code,
                sum(case when bypass_fingerprint_reasons.code = 'OTHER' then 1 else 0 end) AS other_count,
                sum(case when bypass_fingerprint_reasons.code = 'BT' then 1 else 0 end) AS bt_count,
                sum(case when bypass_fingerprint_reasons.code = 'MNF' then 1 else 0 end) AS mnf_count,
                sum(case when bypass_fingerprint_reasons.code = 'CC' then 1 else 0 end) AS cc_count,
                sum(case when bypass_fingerprint_reasons.code = 'EC' then 1 else 0 end) AS ec_count,
                sum(case when bypass_fingerprint_reasons.code = 'PHTPA' then 1 else 0 end) AS phtpa_count,
                sum(case when bypass_fingerprint_reasons.code = 'PFIOTA' then 1 else 0 end) AS pfiota_count,
                count(*) as total")
                .where(doctor_bypass_fingerprint_date: start_date..end_date).group('doctors.code')

                xray_data = Transaction.joins(:xray_facility).joins(:xray_bypass_fingerprint_reason)
                .select("xray_facilities.code,
                sum(case when bypass_fingerprint_reasons.code = 'OTHER' then 1 else 0 end) AS other_count,
                sum(case when bypass_fingerprint_reasons.code = 'BT' then 1 else 0 end) AS bt_count,
                sum(case when bypass_fingerprint_reasons.code = 'MNF' then 1 else 0 end) AS mnf_count,
                sum(case when bypass_fingerprint_reasons.code = 'CC' then 1 else 0 end) AS cc_count,
                sum(case when bypass_fingerprint_reasons.code = 'EC' then 1 else 0 end) AS ec_count,
                sum(case when bypass_fingerprint_reasons.code = 'PHTPA' then 1 else 0 end) AS phtpa_count,
                sum(case when bypass_fingerprint_reasons.code = 'PFIOTA' then 1 else 0 end) AS pfiota_count,
                count(*) as total")
                .where(xray_bypass_fingerprint_date: start_date..end_date).group('xray_facilities.code')

                @data = doctor_data + xray_data
            when 'RETAKE'
                @data = XrayRetake.joins(:xray_facility).joins(:xray_bypass_fingerprint_reason)
                .select("xray_facilities.code,
                sum(case when bypass_fingerprint_reasons.code = 'OTHER' then 1 else 0 end) AS other_count,
                sum(case when bypass_fingerprint_reasons.code = 'BT' then 1 else 0 end) AS bt_count,
                sum(case when bypass_fingerprint_reasons.code = 'MNF' then 1 else 0 end) AS mnf_count,
                sum(case when bypass_fingerprint_reasons.code = 'CC' then 1 else 0 end) AS cc_count,
                sum(case when bypass_fingerprint_reasons.code = 'EC' then 1 else 0 end) AS ec_count,
                sum(case when bypass_fingerprint_reasons.code = 'PHTPA' then 1 else 0 end) AS phtpa_count,
                sum(case when bypass_fingerprint_reasons.code = 'PFIOTA' then 1 else 0 end) AS pfiota_count,
                count(*) as total")
                .where(xray_bypass_fingerprint_date: start_date..end_date).group('xray_facilities.code')
                .where("xray_retakes.code like '99%'")
            when 'APPEAL'
                @data = XrayRetake.joins(:xray_facility).joins(:xray_bypass_fingerprint_reason)
                .select("xray_facilities.code,
                sum(case when bypass_fingerprint_reasons.code = 'OTHER' then 1 else 0 end) AS other_count,
                sum(case when bypass_fingerprint_reasons.code = 'BT' then 1 else 0 end) AS bt_count,
                sum(case when bypass_fingerprint_reasons.code = 'MNF' then 1 else 0 end) AS mnf_count,
                sum(case when bypass_fingerprint_reasons.code = 'CC' then 1 else 0 end) AS cc_count,
                sum(case when bypass_fingerprint_reasons.code = 'EC' then 1 else 0 end) AS ec_count,
                sum(case when bypass_fingerprint_reasons.code = 'PHTPA' then 1 else 0 end) AS phtpa_count,
                sum(case when bypass_fingerprint_reasons.code = 'PFIOTA' then 1 else 0 end) AS pfiota_count,
                count(*) as total")
                .where(xray_bypass_fingerprint_date: start_date..end_date).group('xray_facilities.code')
                .where("xray_retakes.code like '88%'")
            else
                flash[:warning] = "Bypass type doesn't exist"
            end
        end

        template = 'internal/reports/customer_service/bypass_biometric_summary/index'
        respond_to do |format|
            @start_date = start_date.try(:strftime,'%d/%m/%Y')
            @end_date = end_date.try(:strftime,'%d/%m/%Y')

            format.html { render template }
            format.xlsx do
                render xlsx: 'index', filename: "Bypass-Biometric-Summary-#{@bypass_types[@bypass_type]}(#{@start_date}to#{@end_date}).xlsx",
                       template: template
            end
        end
    end

    def bypass_biometric_detail
        start_date = params[:start_date].presence
        end_date = params[:end_date].presence
        @bypass_type = params[:bypass_type]
        @data = []

        if start_date && end_date
            start_date = start_date.to_date.beginning_of_day
            end_date = end_date.to_date.end_of_day

            case @bypass_type
            when 'BEFORE_CERTIFICATION'
                doctor_data = Transaction.joins(:doctor).joins(:doctor_bypass_fingerprint_reason)
                .select("DATE(doctor_bypass_fingerprint_date) as bypass_date, doctors.code,
                sum(case when bypass_fingerprint_reasons.code = 'OTHER' then 1 else 0 end) AS other_count,
                sum(case when bypass_fingerprint_reasons.code = 'BT' then 1 else 0 end) AS bt_count,
                sum(case when bypass_fingerprint_reasons.code = 'MNF' then 1 else 0 end) AS mnf_count,
                sum(case when bypass_fingerprint_reasons.code = 'CC' then 1 else 0 end) AS cc_count,
                sum(case when bypass_fingerprint_reasons.code = 'EC' then 1 else 0 end) AS ec_count,
                sum(case when bypass_fingerprint_reasons.code = 'PHTPA' then 1 else 0 end) AS phtpa_count,
                sum(case when bypass_fingerprint_reasons.code = 'PFIOTA' then 1 else 0 end) AS pfiota_count,
                count(*) as total")
                .where(doctor_bypass_fingerprint_date: start_date..end_date).group('bypass_date, doctors.code')

                xray_data = Transaction.joins(:xray_facility).joins(:xray_bypass_fingerprint_reason)
                .select("DATE(xray_bypass_fingerprint_date) as bypass_date, xray_facilities.code,
                sum(case when bypass_fingerprint_reasons.code = 'OTHER' then 1 else 0 end) AS other_count,
                sum(case when bypass_fingerprint_reasons.code = 'BT' then 1 else 0 end) AS bt_count,
                sum(case when bypass_fingerprint_reasons.code = 'MNF' then 1 else 0 end) AS mnf_count,
                sum(case when bypass_fingerprint_reasons.code = 'CC' then 1 else 0 end) AS cc_count,
                sum(case when bypass_fingerprint_reasons.code = 'EC' then 1 else 0 end) AS ec_count,
                sum(case when bypass_fingerprint_reasons.code = 'PHTPA' then 1 else 0 end) AS phtpa_count,
                sum(case when bypass_fingerprint_reasons.code = 'PFIOTA' then 1 else 0 end) AS pfiota_count,
                count(*) as total")
                .where(xray_bypass_fingerprint_date: start_date..end_date).group('bypass_date, xray_facilities.code')

                @data = doctor_data + xray_data
            when 'RETAKE'
                @data = XrayRetake.joins(:xray_facility).joins(:xray_bypass_fingerprint_reason)
                .select("DATE(xray_bypass_fingerprint_date) as bypass_date, xray_facilities.code,
                sum(case when bypass_fingerprint_reasons.code = 'OTHER' then 1 else 0 end) AS other_count,
                sum(case when bypass_fingerprint_reasons.code = 'BT' then 1 else 0 end) AS bt_count,
                sum(case when bypass_fingerprint_reasons.code = 'MNF' then 1 else 0 end) AS mnf_count,
                sum(case when bypass_fingerprint_reasons.code = 'CC' then 1 else 0 end) AS cc_count,
                sum(case when bypass_fingerprint_reasons.code = 'EC' then 1 else 0 end) AS ec_count,
                sum(case when bypass_fingerprint_reasons.code = 'PHTPA' then 1 else 0 end) AS phtpa_count,
                sum(case when bypass_fingerprint_reasons.code = 'PFIOTA' then 1 else 0 end) AS pfiota_count,
                count(*) as total")
                .where(xray_bypass_fingerprint_date: start_date..end_date).group('bypass_date, xray_facilities.code')
                .where("xray_retakes.code like '99%'")
            when 'APPEAL'
                @data = XrayRetake.joins(:xray_facility).joins(:xray_bypass_fingerprint_reason)
                .select("DATE(xray_bypass_fingerprint_date) as bypass_date, xray_facilities.code,
                sum(case when bypass_fingerprint_reasons.code = 'OTHER' then 1 else 0 end) AS other_count,
                sum(case when bypass_fingerprint_reasons.code = 'BT' then 1 else 0 end) AS bt_count,
                sum(case when bypass_fingerprint_reasons.code = 'MNF' then 1 else 0 end) AS mnf_count,
                sum(case when bypass_fingerprint_reasons.code = 'CC' then 1 else 0 end) AS cc_count,
                sum(case when bypass_fingerprint_reasons.code = 'EC' then 1 else 0 end) AS ec_count,
                sum(case when bypass_fingerprint_reasons.code = 'PHTPA' then 1 else 0 end) AS phtpa_count,
                sum(case when bypass_fingerprint_reasons.code = 'PFIOTA' then 1 else 0 end) AS pfiota_count,
                count(*) as total")
                .where(xray_bypass_fingerprint_date: start_date..end_date).group('bypass_date, xray_facilities.code')
                .where("xray_retakes.code like '88%'")
            else
                flash[:warning] = "Bypass type doesn't exist"
            end
        end

        @data = @data.sort_by { |x| x.bypass_date }

        template = 'internal/reports/customer_service/bypass_biometric_detail/index'
        respond_to do |format|
            @start_date = start_date.try(:strftime,'%d/%m/%Y')
            @end_date = end_date.try(:strftime,'%d/%m/%Y')

            format.html { render template }
            format.xlsx do
                render xlsx: 'index', filename: "Bypass-Biometric-Detail-#{@bypass_types[@bypass_type]}(#{@start_date}to#{@end_date}).xlsx",
                       template: template
            end
        end
    end

    def bypass_biometric_request_detail
        start_date = params[:start_date].presence
        end_date = params[:end_date].presence
        @bypass_type = params[:bypass_type]
        approval_by = params[:approval_by]
        @data = []

        if start_date && end_date
            start_date = start_date.to_date.beginning_of_day
            end_date = end_date.to_date.end_of_day

            case @bypass_type
            when 'BEFORE_CERTIFICATION'
                doctor_data = Transaction.joins(:doctor).joins(:doctor_bypass_fingerprint_reason)
                .joins("JOIN transaction_verify_docs tvd ON transactions.id = tvd.transaction_id and tvd.status = 'APPROVED' and tvd.sourceable_type = 'Transaction'")
                .select("DATE(doctor_bypass_fingerprint_date) as bypass_date, doctors.code,
                sum(case when bypass_fingerprint_reasons.code = 'OTHER' then 1 else 0 end) AS other_count,
                sum(case when bypass_fingerprint_reasons.code = 'BT' then 1 else 0 end) AS bt_count,
                sum(case when bypass_fingerprint_reasons.code = 'MNF' then 1 else 0 end) AS mnf_count,
                sum(case when bypass_fingerprint_reasons.code = 'CC' then 1 else 0 end) AS cc_count,
                sum(case when bypass_fingerprint_reasons.code = 'EC' then 1 else 0 end) AS ec_count,
                sum(case when bypass_fingerprint_reasons.code = 'PHTPA' then 1 else 0 end) AS phtpa_count,
                sum(case when bypass_fingerprint_reasons.code = 'PFIOTA' then 1 else 0 end) AS pfiota_count,
                count(*) as total")
                .where(doctor_bypass_fingerprint_date: start_date..end_date).group('bypass_date, doctors.code')

                doctor_data = doctor_data.where("tvd.approval_by = #{approval_by}") if !approval_by.blank?

                xray_data = Transaction.joins(:xray_facility).joins(:xray_bypass_fingerprint_reason)
                .joins("JOIN transaction_verify_docs tvd ON transactions.id = tvd.transaction_id and tvd.status = 'APPROVED' and tvd.sourceable_type = 'Transaction'")
                .select("DATE(xray_bypass_fingerprint_date) as bypass_date, xray_facilities.code,
                sum(case when bypass_fingerprint_reasons.code = 'OTHER' then 1 else 0 end) AS other_count,
                sum(case when bypass_fingerprint_reasons.code = 'BT' then 1 else 0 end) AS bt_count,
                sum(case when bypass_fingerprint_reasons.code = 'MNF' then 1 else 0 end) AS mnf_count,
                sum(case when bypass_fingerprint_reasons.code = 'CC' then 1 else 0 end) AS cc_count,
                sum(case when bypass_fingerprint_reasons.code = 'EC' then 1 else 0 end) AS ec_count,
                sum(case when bypass_fingerprint_reasons.code = 'PHTPA' then 1 else 0 end) AS phtpa_count,
                sum(case when bypass_fingerprint_reasons.code = 'PFIOTA' then 1 else 0 end) AS pfiota_count,
                count(*) as total")
                .where(xray_bypass_fingerprint_date: start_date..end_date).group('bypass_date, xray_facilities.code')

                xray_data = xray_data.where("tvd.approval_by = #{approval_by}") if !approval_by.blank?

                @data = doctor_data + xray_data
            when 'RETAKE'
                @data = XrayRetake.joins(:xray_facility).joins(:xray_bypass_fingerprint_reason)
                .joins("JOIN transaction_verify_docs tvd ON xray_retakes.id = tvd.sourceable_id and tvd.status = 'APPROVED' and tvd.sourceable_type = 'XrayRetake'")
                .select("DATE(xray_bypass_fingerprint_date) as bypass_date, xray_facilities.code,
                sum(case when bypass_fingerprint_reasons.code = 'OTHER' then 1 else 0 end) AS other_count,
                sum(case when bypass_fingerprint_reasons.code = 'BT' then 1 else 0 end) AS bt_count,
                sum(case when bypass_fingerprint_reasons.code = 'MNF' then 1 else 0 end) AS mnf_count,
                sum(case when bypass_fingerprint_reasons.code = 'CC' then 1 else 0 end) AS cc_count,
                sum(case when bypass_fingerprint_reasons.code = 'EC' then 1 else 0 end) AS ec_count,
                sum(case when bypass_fingerprint_reasons.code = 'PHTPA' then 1 else 0 end) AS phtpa_count,
                sum(case when bypass_fingerprint_reasons.code = 'PFIOTA' then 1 else 0 end) AS pfiota_count,
                count(*) as total")
                .where(xray_bypass_fingerprint_date: start_date..end_date).group('bypass_date, xray_facilities.code')
                .where("xray_retakes.code like '99%'")

                @data = @data.where("tvd.approval_by = #{approval_by}") if !approval_by.blank?
            when 'APPEAL'
                @data = XrayRetake.joins(:xray_facility).joins(:xray_bypass_fingerprint_reason)
                .joins("JOIN transaction_verify_docs tvd ON xray_retakes.id = tvd.sourceable_id and tvd.status = 'APPROVED' and tvd.sourceable_type = 'XrayRetake'")
                .select("DATE(xray_bypass_fingerprint_date) as bypass_date, xray_facilities.code,
                sum(case when bypass_fingerprint_reasons.code = 'OTHER' then 1 else 0 end) AS other_count,
                sum(case when bypass_fingerprint_reasons.code = 'BT' then 1 else 0 end) AS bt_count,
                sum(case when bypass_fingerprint_reasons.code = 'MNF' then 1 else 0 end) AS mnf_count,
                sum(case when bypass_fingerprint_reasons.code = 'CC' then 1 else 0 end) AS cc_count,
                sum(case when bypass_fingerprint_reasons.code = 'EC' then 1 else 0 end) AS ec_count,
                sum(case when bypass_fingerprint_reasons.code = 'PHTPA' then 1 else 0 end) AS phtpa_count,
                sum(case when bypass_fingerprint_reasons.code = 'PFIOTA' then 1 else 0 end) AS pfiota_count,
                count(*) as total")
                .where(xray_bypass_fingerprint_date: start_date..end_date).group('bypass_date, xray_facilities.code')
                .where("xray_retakes.code like '88%'")

                @data = @data.where("tvd.approval_by = #{approval_by}") if !approval_by.blank?
            else
                flash[:warning] = "Bypass type doesn't exist"
            end
        end

        @data = @data.sort_by { |x| x.bypass_date }

        template = 'internal/reports/customer_service/bypass_biometric_request_detail/index'
        respond_to do |format|
            @start_date = start_date.try(:strftime,'%d/%m/%Y')
            @end_date = end_date.try(:strftime,'%d/%m/%Y')

            format.html { render template }
            format.xlsx do
                render xlsx: 'index', filename: "Bypass-Biometric-Request-Detail-#{@bypass_types[@bypass_type]}(#{@start_date}to#{@end_date}).xlsx",
                       template: template
            end
        end
    end
    private

    def set_bypass_types
        @bypass_types = {
            "BEFORE_CERTIFICATION" => "Before Certification",
            "RETAKE" => "Retake",
            "APPEAL" => "Appeal"
          }
    end

    def set_reasons
        @reasons = BypassFingerprintReason.select('id, code, description').order('id asc')
    end

    def set_company_name
        @company_name = SystemConfiguration.find_by(code: 'COMPANY_NAME')&.value
    end

    def set_finance_filtering_variables
        @start_date = params[:start_date].presence
        @end_date = params[:end_date].presence
    end

    def render_finance_html
        render "internal/reports/finance/#{action_name}/index"
    end

    def render_finance_pdf
        render pdf: action_name,
               template: "internal/reports/finance/#{action_name}/_pdf_template.html.haml",
               header: {
                   html: {
                       template: "internal/reports/finance/#{action_name}/pdf_template_header"
                   }
               },
               **default_pdf_options
    end

    def render_finance_xlsx
        render xlsx: 'index',
               filename: "#{action_name}-#{@start_date}to#{@end_date}.xlsx",
               template: "internal/reports/finance/#{action_name}/index"
    end
end
