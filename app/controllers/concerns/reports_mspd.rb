module ReportsMSPD
    extend ActiveSupport::Concern

    included do
        before_action :set_company_name, only: %i[lab_delay_transmission xray_delay_transmission list_doc_register
                                                  list_lab_register list_xray_register suspended_doctors
                                                  worker_block_send_to_jim doctor_information lab_allocation
                                                  list_of_workers_by_doctor]
        before_action :set_date_time, only: %i[list_of_workers_by_doctor]
        has_scope :allocated, type: :boolean
    end

    def worker_block_send_to_jim
        current = Time.now
        @date = current.strftime('%d/%m/%Y')
        @time = current.strftime('%H:%M:%S %p')
        @headers = ['#', 'Worker Name', 'Worker Code', 'Passport No', 'Country', 'Trans ID', 'Trans Date', 'Certification', 'Certify Date']

        # query
        @transactions = MvImmBlockedTransaction.order("mv_imm_blocked_transactions.fw_name" => :asc)
        # end query

        respond_to do |format|
            format.html { render "internal/reports/mspd/worker_block_send_to_jim/index.html" }
            format.pdf { render pdf: "worker_block_send_to_jim",
                template: 'internal/reports/mspd/worker_block_send_to_jim/pdf_template.html.erb',
                layout: "pdf.html",
                margin: {
                    top: 30,
                    left: 12,
                    right: 12,
                    bottom: 10,
                },
                page_size: nil,
                page_height: "21cm",
                page_width: "29.7cm",
                dpi: "300",
                header: {
                    html: {
                        template: '/internal/reports/mspd/worker_block_send_to_jim/pdf_template_header',
                        locals: {
                            date: @date,
                            time: @time
                        }
                    }
                }
            }
        end
    end

    def list_doc_register
        @start_date = params[:register_date_start]
        @end_date = params[:register_date_end]
        @status = params[:status]

        current = Time.now
        @date = current.strftime('%d/%m/%Y')
        @time = current.strftime('%H:%M:%S %p')
        @headers = ['No.', 'Doctor Code', 'Name / Clinic Name / Address', 'Creation Date', 'Activation Date']
        @doctors = []

        if @start_date.present? and @end_date.present?
            @doctors =
                Doctor
                .with_status(@status)
                .includes(:state, :town)
                .where('activated_at BETWEEN ? AND ?', @start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)\
                .order("activated_at ASC")
        end

        respond_to do |format|
            format.html { render "internal/reports/mspd/list_doc_register/index.html" }
            format.pdf { render pdf: "list_doc_register-#{Time.now.strftime("%Y%m%d%H%M%S")}",
                template: 'internal/reports/mspd/list_doc_register/pdf_template.html.erb',
                layout: "pdf.html",
                margin: {
                    top: 30,
                    left: 12,
                    right: 12,
                    bottom: 10,
                },
                page_size: nil,
                page_height: "21cm",
                page_width: "29.7cm",
                dpi: "300",
                header: {
                    html: {
                        template: '/internal/reports/mspd/list_doc_register/pdf_template_header',
                        locals: {
                            date: @date,
                            time: @time
                        }
                    }
                }
            }
        end
    end

    def list_xray_register
        @start_date = params[:register_date_start]
        @end_date = params[:register_date_end]
        @status = params[:status]

        current = Time.now
        @date = current.strftime('%d/%m/%Y')
        @time = current.strftime('%H:%M:%S %p')
        @headers = ['No.', 'X-Ray Code', 'Name / X-Ray Name / License Holder Name / Address', 'Creation Date', 'Activation Date']
        @xray_facilities = []

        if @start_date.present? && @end_date.present?
            @xray_facilities =
                XrayFacility.joins(:state, :town)
                .with_status(@status)
                .where('xray_facilities.activated_at BETWEEN ? AND ?', @start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
        end

        respond_to do |format|
            format.html { render "internal/reports/mspd/list_xray_register/index.html" }
            format.pdf { render pdf: "list_xray_register-#{Time.now.strftime("%Y%m%d%H%M%S")}",
                template: 'internal/reports/mspd/list_xray_register/pdf_template.html.erb',
                layout: "pdf.html",
                margin: {
                    top: 30,
                    left: 12,
                    right: 12,
                    bottom: 10,
                },
                page_size: nil,
                page_height: "21cm",
                page_width: "29.7cm",
                dpi: "300",
                header: {
                    html: {
                        template: '/internal/reports/mspd/list_xray_register/pdf_template_header',
                        locals: {
                            date: @date,
                            time: @time
                        }
                    }
                }
            }
        end
    end

    def list_lab_register
        @start_date = params[:register_date_start]
        @end_date = params[:register_date_end]
        @status = params[:status]

        current = Time.now
        @date = current.strftime('%d/%m/%Y')
        @time = current.strftime('%H:%M:%S %p')
        @headers = ['No.', 'Lab Code', 'Name / Lab Name / Address', 'Creation Date', 'Activation Date']
        @laboratories = []

        if @start_date.present? && @end_date.present?
            @laboratories =
                Laboratory
                .with_status(@status)
                .where('activated_at BETWEEN ? AND ?', @start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
        end

        respond_to do |format|
            format.html { render "internal/reports/mspd/list_lab_register/index.html" }
            format.pdf { render pdf: "list_lab_register-#{Time.now.strftime('%Y%m%d%H%M%S')}",
                template: 'internal/reports/mspd/list_lab_register/pdf_template.html.erb',
                layout: "pdf.html",
                margin: {
                    top: 30,
                    left: 12,
                    right: 12,
                    bottom: 10,
                },
                page_size: nil,
                page_height: "21cm",
                page_width: "29.7cm",
                dpi: "300",
                header: {
                    html: {
                        template: '/internal/reports/mspd/list_lab_register/pdf_template_header',
                        locals: {
                            date: @date,
                            time: @time
                        }
                    }
                }
            }
        end
    end

    def foreign_worker_registrations
        respond_to do |format|
            format.html { render 'internal/reports/mspd/foreign_worker_registrations/index' }
            format.xlsx do
                start_date = params[:date_from].presence
                end_date = params[:date_to].presence || DateTime.current.strftime('%d/%m/%Y')
                date_source = params[:date_source]

                @transactions = Report::ForeignWorkerRegistrationsReportService.new(start_date, end_date, date_source).result

                render xlsx: 'index', filename: "ForeignWorkerRegistrations-#{start_date}to#{end_date}.xlsx",
                       template: 'internal/reports/mspd/foreign_worker_registrations/index'
            end
        end
    end

    def unsuitable_foreign_workers
        respond_to do |format|
            format.html { render 'internal/reports/mspd/unsuitable_foreign_workers/index' }
            format.xlsx do
                start_date = params[:date_from]
                end_date = params[:date_to].presence || DateTime.current.strftime('%d/%m/%Y')
                date_source = params[:date_source]

                @transactions =
                    Transaction
                    .includes(:foreign_worker, :fw_job_type, :fw_country, :laboratory_examination, :doctor_examination, :medical_examination)
                    .unsuitable
                    .send(:"#{date_source}_between", start_date, end_date)
                    .order(date_source.to_sym)
                    .decorate
                render xlsx: 'index', filename: "UnsuitableForeignWorkers-#{start_date}to#{end_date}.xlsx",
                       template: 'internal/reports/mspd/unsuitable_foreign_workers/index'
            end
        end
    end

    def suspended_doctors
        set_date_time
        set_mspd_filtering_variables
        @headers = ['No.', 'Doctor Code', 'Doctor Name', 'Clinic Name', 'State', 'Date Suspended']

        if @start_date.present? && @end_date.present?
            @doctors =
                Doctor
                .includes(:latest_status_schedule)
                .suspended
                .suspended_date_between(@start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
                .decorate
        end

        respond_to do |format|
            format.html { render_mspd_html }
            format.pdf { render_mspd_pdf }
        end
    end

    def lab_delay_transmission
        @start_date = params[:transaction_date_from].presence
        @end_date = params[:transaction_date_to].presence

        respond_to do |format|
            format.html { render_mspd_html }
            format.pdf do
                return redirect_to lab_delay_transmission_internal_reports_path, notice: 'Require to input valid date range' if [@start_date, @end_date].count(nil) == 1

                @doctors = Report::LaboratoryDelayTransmissionStatisticService.new(delay_transmission_params).result
                render pdf: action_name,
                       template: "internal/reports/mspd/#{action_name}/_pdf_template.html.haml",
                       header: {
                           html: {
                               template: "internal/reports/mspd/#{action_name}/pdf_template_header"
                           }
                       },
                       layout: 'pdf.html',
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
        end
    end

    def xray_delay_transmission
        @start_date = params[:transaction_date_from].presence
        @end_date = params[:transaction_date_to].presence

        respond_to do |format|
            format.html { render_mspd_html }
            format.pdf do
                return redirect_to xray_delay_transmission_internal_reports_path, notice: 'Require to input valid date range' if [@start_date, @end_date].count(nil) == 1

                @doctors = Report::XrayDelayTransmissionStatisticService.new(delay_transmission_params).result
                render pdf: action_name,
                       template: "internal/reports/mspd/#{action_name}/_pdf_template.html.haml",
                       header: {
                           html: {
                               template: "internal/reports/mspd/#{action_name}/pdf_template_header"
                           }
                       },
                       layout: 'pdf.html',
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
        end
    end

    def gp_unutilized_quota
        respond_to do |format|
            format.html { render 'internal/reports/mspd/gp_unutilized_quota/index' }
            format.xlsx do
                doctor_codes = params[:doctor_codes].presence
                laboratory_codes = params[:laboratory_codes].presence
                xray_codes = params[:xray_codes].presence
                year = params[:year].presence

                @transactions = Report::DoctorUnutilizedQuotaService.new(year, doctor_codes, laboratory_codes, xray_codes).result
                render xlsx: 'index', filename: "GPUnutilizedQuota-#{year}.xlsx",
                       template: 'internal/reports/mspd/gp_unutilized_quota/index'
            end
        end
    end

    def mclx_report
        @start_date = params[:start_date].presence
        @end_date = params[:end_date].presence
        @xray_facilities = []
        @doctors = []
        @analog_non_comply_details = []
        @analog_total_submissions = []
        @analog_total_views = []
        @analog_total_view_by_gps = []
        @analog_total_view_by_cr = []
        @analog_non_complies = []
        @digital_non_comply_details = []
        @digital_total_submissions = []
        @digital_total_views = []
        @digital_total_view_by_gps = []
        @digital_total_view_by_cr = []
        @digital_non_complies = []

        ## query reference on MclxReportService

        if @start_date && @end_date
            @start_date = @start_date.to_date.beginning_of_day
            @end_date = @end_date.to_date.end_of_day

            @year = @start_date.strftime('%Y')
            @previous_year = @start_date.last_year.strftime('%Y')
            @previous_year_date_range = @start_date.last_year.beginning_of_year..@start_date.last_year.end_of_year
            @date_range = @start_date..@end_date

            @xray_facilities = XrayFacility.joins(:town).joins(:state)
            .select("xray_facilities.*, towns.name as alt_town_name, states.name as alt_state_name,
            (select count(*) from transactions where created_at between '#{@start_date.last_year.beginning_of_year.beginning_of_day}' and '#{@start_date.last_year.end_of_year.end_of_day}' and xray_facility_id = xray_facilities.id) as total_fw_previous_year,
            (select count(*) from transactions where created_at between '#{@start_date.beginning_of_year.beginning_of_day}' and '#{@start_date.end_of_year.end_of_day}' and xray_facility_id = xray_facilities.id) as total_fw_selected_year,
            (select count(*) from doctors where xray_facility_id = xray_facilities.id and status = 'ACTIVE') as active_clinic_count")
            .where("states.code != 'C'")

            @doctors = Doctor.joins(:town).joins(:state).select("doctors.*, towns.name as alt_town_name, states.name as alt_state_name,
            (select count(*) from transactions where created_at between '#{@start_date.last_year.beginning_of_year.beginning_of_day}' and '#{@start_date.last_year.end_of_year.end_of_day}' and doctor_id = doctors.id) as total_fw_previous_year,
            (select count(*) from transactions where created_at between '#{@start_date.beginning_of_year.beginning_of_day}' and '#{@start_date.end_of_year.end_of_day}' and doctor_id = doctors.id) as total_fw_selected_year").where("states.code != 'C'")

            @analog_non_comply_details = XrayReview.analog
            .joins(transactionz: %i[xray_facility xray_examination])
            .joins(:xray_review_details)
            .joins(xray_review_details: %i[condition])
            .where("xray_examinations.xray_taken_date between '#{@start_date}' and '#{@end_date}'")
            .where(xray_review_details: {text_value: 'Y'})
            .select("DATE(xray_examinations.xray_taken_date) as alt_review_date, xray_facilities.code, xray_facilities.name, conditions.description as parameter_code, count(*)")
            .group('alt_review_date, xray_facilities.code, xray_facilities.name, parameter_code')
            .order('alt_review_date asc')

            @digital_non_comply_details = XrayReview.digital
            .joins(transactionz: %i[xray_facility])
            .joins(:xray_review_details)
            .joins(xray_review_details: %i[condition])
            .where(created_at: @date_range)
            .where(xray_review_details: {text_value: 'Y'})
            .select("DATE(xray_reviews.created_at) as alt_review_date, xray_facilities.code, xray_facilities.name, conditions.description as parameter_code, count(*)")
            .group('alt_review_date, xray_facilities.code, xray_facilities.name, parameter_code')
            .order('alt_review_date asc')

            # digital = xqcc pool / analog = xray examinations
            @analog_total_submissions = XrayExamination.analog
            .joins(transactionz: %i[xray_facility])
            .where(xray_taken_date: @date_range)
            .select('xray_facilities.code,xray_facilities.name, count(*)')
            .group('xray_facilities.code, xray_facilities.name')

            @digital_total_submissions = XqccPool.digital
            .joins(transactionz: %i[xray_facility])
            .where(created_at: @date_range)
            .select('xray_facilities.code, count(*)')
            .group('xray_facilities.code')

            ## total view
            @analog_total_views = XrayReview.analog
            .joins(transactionz: %i[xray_facility xray_examination])
            .where("xray_examinations.xray_taken_date between '#{@start_date}' and '#{@end_date}'")
            .select('xray_facilities.code,xray_facilities.name, count(*)')
            .group('xray_facilities.code, xray_facilities.name')

            @digital_total_views = XrayReview.digital
            .joins(transactionz: %i[xray_facility xray_examination])
            .where(created_at: @date_range)
            .select('xray_facilities.code, count(*)')
            .group('xray_facilities.code')

            # count analog/digital xray review records where radiologist = nil
            # and group by xray facility code
            @analog_total_view_by_gps = XrayReview.analog
            .joins(transactionz: %i[xray_facility xray_examination])
            .where(transactions: { radiologist_id: nil })
            .where("xray_examinations.xray_taken_date between '#{@start_date}' and '#{@end_date}'")
            .select('xray_facilities.code,xray_facilities.name, count(*)')
            .group('xray_facilities.code, xray_facilities.name')

            @digital_total_view_by_gps = XrayReview.digital
            .joins(transactionz: %i[xray_facility xray_examination])
            .where(transactions: { radiologist_id: nil })
            .where(created_at: @date_range)
            .select('xray_facilities.code, count(*)')
            .group('xray_facilities.code')

            # count analog/digital xray review records with radiologist
            # and group by xray facility code
            @analog_total_view_by_cr = XrayReview.analog
            .joins(transactionz: %i[xray_facility xray_examination])
            .where.not(transactions: { radiologist_id: nil })
            .where("xray_examinations.xray_taken_date between '#{@start_date}' and '#{@end_date}'")
            .select('xray_facilities.code,xray_facilities.name, count(*)')
            .group('xray_facilities.code, xray_facilities.name')

            @digital_total_view_by_cr = XrayReview.digital
            .joins(transactionz: %i[xray_facility xray_examination])
            .where.not(transactions: { radiologist_id: nil })
            .where(created_at: @date_range)
            .select('xray_facilities.code, count(*)')
            .group('xray_facilities.code')

            # count analog/digital non-comply xray review records
            # and group by xray code
            @analog_non_complies = XrayReview.analog
            .joins(transactionz: %i[xray_facility xray_examination])
            .joins(:xray_review_details)
            .where("xray_examinations.xray_taken_date between '#{@start_date}' and '#{@end_date}'")
            .where(xray_review_details: {text_value: 'Y'})
            .select("xray_facilities.code, xray_facilities.name, count(*)")
            .group('xray_facilities.code, xray_facilities.name')

            @digital_non_complies = XrayReview.digital
            .joins(transactionz: %i[xray_facility])
            .joins(:xray_review_details)
            .where(created_at: @date_range)
            .where(xray_review_details: {text_value: 'Y'})
            .select("xray_facilities.code, count(*)")
            .group('xray_facilities.code')
        end

        respond_to do |format|
            format.html { render 'internal/reports/mspd/mclx_report/index' }
            format.xlsx do
                render xlsx: 'index', filename: "MCLX-#{@start_date.try(:strftime,'%d%m%Y')}-#{@end_date.try(:strftime,'%d%m%Y')}.xlsx",
                       template: 'internal/reports/mspd/mclx_report/index'
            end
        end
    end

    def radiographer_report
        respond_to do |format|
            format.html { render 'internal/reports/mspd/radiographer_report/index' }
            format.xlsx do
                @start_date = params[:start_date].presence
                @end_date = params[:end_date].presence

                @data, @dates = Report::RadiographerReportService.new(@start_date, @end_date).result
                render xlsx: 'index', filename: "RadiographerReport-#{@start_date}-#{@end_date}.xlsx",
                       template: 'internal/reports/mspd/radiographer_report/index'
            end
        end
    end

    def xray_delay_transactions
        @exam_date_from = params[:medical_examination_date_from].presence
        @exam_date_to = params[:medical_examination_date_to].presence
        @xray_code = params[:xray_code].presence
        @xray_name = params[:xray_name].presence
        @xray_test_done_date_from = params[:xray_test_done_date_from].presence
        @xray_test_done_date_to = params[:xray_test_done_date_to].presence
        @headers = %w[WORKER_NAME WORKER_CODE PASSPORT_NO EXAM_DATE DOCTOR_CODE XRAY_CODE XRAY_NAME DISTRICT_NAME STATE_NAME XRAY_TESTDONE_DATE XRAY_SUBMIT_DATE CERTIFY_DATE DAY_TAKEN]

        if @xray_code || @xray_name
            if @xray_code.present?
                xray_attribute = { code: @xray_code.chomp.strip }
            elsif @xray_name.present?
                xray_attribute = { name: @xray_name.chomp.strip }
            end

            @xray_facility = XrayFacility.find_by(xray_attribute)
            if @xray_facility
                @transactions =
                    @xray_facility
                    .transactions
                    .includes(:xray_examination)
                    .medical_examination_date_between(@exam_date_from, @exam_date_to)
                    .xray_test_done_date_between(@xray_test_done_date_from, @xray_test_done_date_to)
            end
        end

        respond_to do |format|
            format.html { render_mspd_html }
            format.xlsx { render_mspd_xlsx }
        end
    rescue TypeError
        redirect_to xray_delay_transactions_internal_mspd_reports_path, notice: 'Please input valid date range for date'
    end

    def laboratory_delay_transactions
        @exam_date_from = params[:medical_examination_date_from].presence
        @exam_date_to = params[:medical_examination_date_to].presence
        @lab_code = params[:lab_code].presence
        @lab_name = params[:lab_name].presence
        @specimen_taken_date_from = params[:specimen_taken_date_from].presence
        @specimen_taken_date_to = params[:specimen_taken_date_to].presence
        @specimen_received_date_from = params[:specimen_received_date_from].presence
        @specimen_received_date_to = params[:specimen_received_date_to].presence
        @headers = %w[WORKER_NAME WORKER_CODE PASSPORT_NO DOCTOR_CODE
                      LABORATORY_CODE LABORATORY_NAME DISTRICT_NAME STATE_NAME
                      EXAM_DATE LAB_SPECIMEN_TAKEN_DATE LAB_SPECIMEN_RECEIVE_DATE
                      LAB_SUBMIT_DATE DAY_TAKEN]

        if @lab_code || @lab_name
            if @lab_code.present?
                lab_attribute = { code: @lab_code.chomp.strip }
            elsif @lab_name.present?
                lab_attribute = { name: @lab_name.chomp.strip }
            end

            @laboratory = Laboratory.find_by(lab_attribute)
            if @laboratory
                @transactions =
                    @laboratory
                    .transactions
                    .includes(:laboratory_examination)
                    .medical_examination_date_between(@exam_date_from, @exam_date_to)
                    .specimen_taken_date_between(@specimen_taken_date_from, @specimen_taken_date_to)
                    .specimen_received_date_between(@specimen_received_date_from, @specimen_received_date_to)
            end
        end

        respond_to do |format|
            format.html { render_mspd_html }
            format.xlsx { render_mspd_xlsx }
        end
    rescue TypeError
        redirect_to laboratory_delay_transactions_internal_mspd_reports_path, notice: 'Please input valid date range for date'
    end

    def doctor_delay_transactions
        @exam_date_from = params[:medical_examination_date_from].presence
        @exam_date_to = params[:medical_examination_date_to].presence
        @doctor_code = params[:doctor_code].presence
        @clinic_name = params[:clinic_name].presence
        @headers = %w[WORKER_CODE WORKER_NAME PASSPORT_NO COUNTRY_NAME EMPLOYER_CODE EMPLOYER_NAME DOCTOR_CODE DOCTOR_NAME CLINIC_NAME DISTRICT_NAME STATE_NAME EXAM_DATE XRAY_TESTDONE_DATE XRAY_SUBMIT_DATE LAB_SUBMIT_DATE CERTIFY_DATE DAY_TAKEN]

        if @doctor_code || @clinic_name
            if @doctor_code.present?
                doctor_attribute = { code: @doctor_code.chomp.strip }
            elsif @clinic_name.present?
                doctor_attribute = { clinic_name: @clinic_name.chomp.strip }
            end

            @doctor = Doctor.find_by(doctor_attribute)
            if @doctor
                @transactions =
                    @doctor
                    .transactions
                    .includes(:laboratory_examination)
                    .medical_examination_date_between(@exam_date_from, @exam_date_to)
            end
        end

        respond_to do |format|
            format.html { render_mspd_html }
            format.xlsx { render_mspd_xlsx }
        end
    end

    def doctor_information
        @headers = %w[DOCTOR_CODE DOCTOR_NAME EMAIL CLINIC_NAME ADDR_1
                      ADDR_2 ADDR_3 ADDR_4
                      GP_DISTRICT GP_POSTCODE GP_STATE XRAY_CODE LAB_CODE
                      XRAY_NAME XRAY_EMAIL XRAY_ADDR1 XRAY_ADDR2
                      XRAY_ADDR3 XRAY_ADDR4 XRAY_DISTRICT POSTCODE
                      XRAY_STATE PHONE FAX LAB_NAME LAB_EMAIL
                      LAB_ADDR1 LAB_ADDR2
                      LAB_ADDR3 LAB_ADDR4
                      LAB_DISTRICT POSTCODE LAB_STATE PHONE FAX]
        @doctor_code = params[:doctor_code].presence
        @clinic_name = params[:clinic_name].presence

        @doctors =
            Doctor
            .search_code(@doctor_code)
            .search_clinic_name(@clinic_name)
            .decorate

        respond_to do |format|
            format.html { render_mspd_html }
            format.xlsx { render_mspd_xlsx }
            format.pdf do
               render pdf: action_name,
                      template: "internal/reports/mspd/#{action_name}/_pdf_template.html.haml",
                        header: {
                            html: {
                                template: "internal/reports/mspd/#{action_name}/pdf_template_header"
                            }
                        },
                        layout: 'pdf.html',
                        margin: {
                            top: 50,
                            left: 6,
                            right: 6,
                            bottom: 10,
                        },
                        zoom: 0.5,
                        page_size: nil,
                        page_height: '21cm',
                        page_width: '29.7cm',
                        dpi: '300'

            end
        end
    end

    def lab_allocation
        @headers = %w[LABORATORY_CODE LABORATORY_NAME DISTRICT_NAME POSTCODE
                      STATE_NAME ACTIVE_GP]
        @laboratory_code = params[:laboratory_code].presence
        @laboratory_name = params[:laboratory_name].presence
        @state_id = params[:state_id]
        @status = params[:status]

        @laboratories =
            apply_scopes(Laboratory.joins(:state, :town))
            .search_code(@laboratory_code)
            .search_name(@laboratory_name)
            .search_state(@state_id)
            .search_status(@status)
            .order('states.name', 'towns.name')
            .decorate

        respond_to do |format|
            format.html { render_mspd_html }
            format.xlsx { render_mspd_xlsx }
            format.pdf { render_mspd_pdf }
        end
    end

    def list_of_workers_by_doctor
        @start_date = params[:date_from].presence
        @end_date = params[:date_to].presence
        @date_source = params[:date_source]
        @headers = ['No.', 'Worker Code', 'Worker Name', 'Employer Code',
                    'Trans. Date', 'Exam. Date', 'Certify Date', 'Height',
                    'Weight', 'Pulse', 'Systolic', 'Diastolic', 'Bld Grp',
                    'RH', 'Fit Ind']
        @doctor_code = params[:doctor_code].presence
        @doctor = Doctor.find_by(code: @doctor_code)

        if @doctor.present?
            return redirect_to(list_of_workers_by_doctor_internal_mspd_reports_path, notice: 'Please input valid date range') if @start_date.nil? || @end_date.nil?

            if @date_source == 'both'
                @transactions =
                    @doctor
                    .transactions
                    .includes(:foreign_worker, :employer, :medical_examination, :laboratory_examination)
                    .certified_between(@start_date, @end_date)
                    .transaction_date_between(@start_date, @end_date)
                    .where(final_result: %w[SUITABLE UNSUITABLE])
                    .order(:certification_date, :transaction_date)
                    .decorate
            else
                @transactions =
                    @doctor
                    .transactions
                    .includes(:foreign_worker, :employer, :medical_examination, :laboratory_examination)
                    .then { |transactions| transactions.send(:"#{@date_source}_between", @start_date, @end_date) }
                    .where(final_result: %w[SUITABLE UNSUITABLE])
                    .order(@date_source.to_sym)
                    .decorate
            end
        end

        respond_to do |format|
            format.html { render_mspd_html }
            format.pdf { render_mspd_pdf }
        end
    end

    def non_transmission_doctor
        if [:code, :name, :postcode, :state_id, :startdate, :enddate, :duration].any? { |key| !params[key].blank? }
            @transactions = Transaction.joins(:doctor).joins(doctor: :state)
            .search_doctor_code(params[:code])
            .search_doctor_name(params[:name])
            .search_doctor_state(params[:state_id])
            .search_doctor_postcode(params[:postcode])
            .select("doctors.code d_code, doctors.name d_name, doctors.clinic_name d_clinic_name, doctors.phone, states.name state_name, count(*) transaction_count, max(transactions.transaction_date) latest_transaction_date")
            .where("transactions.medical_examination_date between ? and ? and transactions.doctor_transmit_date is null", params[:startdate].to_date.beginning_of_day, params[:enddate].to_date.end_of_day)
            .where("EXTRACT(day from now() - transactions.medical_examination_date) >= ?", params[:duration])
            .group("doctors.code, doctors.name, doctors.clinic_name, doctors.phone, states.name")
            .order(transaction_count: :desc)

            sql = @transactions.to_sql
            rs = ActiveRecord::Base.connection.execute("with tbl as (#{sql}) select count(*) as cnt from tbl")
            @paginator = Kaminari.paginate_array([], total_count: rs.first["cnt"]).page(params[:page]).per(get_per)

            @transactions = @transactions.page(params[:page]).per(get_per)
        else
            flash.now[:warning] = "Filter criteria required"
        end
        respond_to do |format|
            format.html {
                render "internal/reports/mspd/non_transmission_doctor/index"
            }
        end
    end

    def non_transmission_doctor_items
        if [:code, :name, :postcode, :state_id, :startdate, :enddate, :duration].any? { |key| !params[key].blank? }
            @transactions = Transaction.left_joins(:laboratory_examination).left_joins(:xray_examination)
            .search_doctor_code(params[:code])
            .search_doctor_name(params[:name])
            .search_doctor_state(params[:state_id])
            .search_doctor_postcode(params[:postcode])
            .select("transactions.fw_code, transactions.fw_name, transactions.medical_examination_date medical_examination_datez, laboratory_examinations.specimen_taken_date specimen_taken_datez, transactions.laboratory_transmit_date laboratory_transmit_datez, xray_examinations.xray_taken_date xray_taken_datez, transactions.xray_transmit_date xray_transmit_datez, EXTRACT(day from now() - transactions.medical_examination_date) duration, transactions.transaction_date")
            .where("transactions.medical_examination_date between ? and ? and transactions.doctor_transmit_date is null", params[:startdate].to_date.beginning_of_day, params[:enddate].to_date.end_of_day)
            .where("EXTRACT(day from now() - transactions.medical_examination_date) >= ?", params[:duration])
            .order(duration: :desc)

            sql = @transactions.to_sql
            rs = ActiveRecord::Base.connection.execute("with tbl as (#{sql}) select count(*) as cnt from tbl")
            @paginator = Kaminari.paginate_array([], total_count: rs.first["cnt"]).page(params[:page]).per(get_per)

            @transactions = @transactions.page(params[:page]).per(get_per)
        else
            flash.now[:warning] = "Filter criteria required"
        end
        respond_to do |format|
            format.html {
                render "internal/reports/mspd/non_transmission_doctor/items"
            }
        end
    end

    def xray_allocation_to_radiologist
        @csv        = [["Xray Code", "Xray Name"]]

        if params[:text_field].present?
            data    = Radiologist.joins(:xray_facilities).where(code: params[:text_field]).select('xray_facilities.code', 'xray_facilities.name')

            data.each do |d|
                @csv    << [d.code, d.name]
            end
        end

        if check_format_html
            headers_footers ||= 1
            total_size      = @csv.size - headers_footers
            @csv            = @csv.first(500 + headers_footers)
            showing_size    = @csv.size - headers_footers
            @displayed_size = "Showing #{ showing_size } out of #{ total_size } rows"
        end

        @filter_options = [{ type: "text field", label: "Radiologist Code" }]
        parse_output_format('Xray Allocation to Radiologist')
    end

    def list_of_xray
        @csv        = Report::ListOfXrayReportService.headers
        start_date  = params[:filter_date_start]
        end_date    = params[:filter_date_end]

        if start_date.present? && end_date.present?
            @csv    = Report::ListOfXrayReportService.new(start_date, end_date).result
        end

        if check_format_html
            headers_footers ||= 1
            total_size      = @csv.size - headers_footers
            @csv            = @csv.first(500 + headers_footers)
            showing_size    = @csv.size - headers_footers
            @displayed_size = "Showing #{ showing_size } out of #{ total_size } rows"
        end

        @filter_options = [{ type: "date range", label: "Creation Date" }]
        parse_output_format("List of Xray")
    end

    def list_of_laboratories
        @csv        = Report::ListOfLaboratoriesReportService.headers
        start_date  = params[:filter_date_start]
        end_date    = params[:filter_date_end]

        if start_date.present? && end_date.present?
            @csv    = Report::ListOfLaboratoriesReportService.new(start_date, end_date).result
        end

        if check_format_html
            headers_footers ||= 1
            total_size      = @csv.size - headers_footers
            @csv            = @csv.first(500 + headers_footers)
            showing_size    = @csv.size - headers_footers
            @displayed_size = "Showing #{ showing_size } out of #{ total_size } rows"
        end

        @filter_options = [{ type: "date range", label: "Creation Date" }]
        parse_output_format("List of Laboratories")
    end

    def list_of_gp
        @csv        = Report::ListOfGpReportService.headers
        start_date  = params[:filter_date_start]
        end_date    = params[:filter_date_end]

        if start_date.present? && end_date.present?
            @csv    = Report::ListOfGpReportService.new(start_date, end_date).result
        end

        if check_format_html
            headers_footers ||= 1
            total_size      = @csv.size - headers_footers
            @csv            = @csv.first(500 + headers_footers)
            showing_size    = @csv.size - headers_footers
            @displayed_size = "Showing #{ showing_size } out of #{ total_size } rows"
        end

        @filter_options = [{ type: "date range", label: "Creation Date" }]
        parse_output_format("List of GP")
    end

    def clinic_allocation_to_xray_and_lab
        @csv                = [["Doc. Code", "Doc. Name", "Clinic Name", "Address","Town", "W. Count","Previous Year W.Count","Status"]]
        code                = params[:text_field]
        filter_date_start   = params[:filter_date_start]
        filter_date_end     = params[:filter_date_end]

        if code.present?
            data    = Report::ClinicAllocationToXrayAndLabService.new(filter_date_start, filter_date_end, code).result

            data.each do |d|
                @csv    << [d.doc_code, d.doc_name, d.clinic_name, d.address, d.district, ActionController::Base.helpers.number_to_currency(d.w_count, unit: "", precision: 0),d.previous_count, d.doc_status]
            end
        end

        if check_format_html
          headers_footers ||= 1
          total_size      = @csv.size - headers_footers
          @csv            = @csv.first(500 + headers_footers)
          showing_size    = @csv.size - headers_footers
          @displayed_size = "Showing #{ showing_size } out of #{ total_size } rows"
        end

        @filter_options = [
            { type: "date range", label: "Creation Date" },
            { type: "text field", label: "Laboratory / Xray Facility Code" }
        ]

        parse_output_format('Clinic Allocation to Xray Facility and Lab')
    end

    def mspd_suspension
        if [:effective_date_from, :effective_date_to, :created_at_from, :created_at_to].all? { |k| params[k].blank? }
            flash.now[:error] = "Date filter criteria required"
            render 'internal/reports/mspd/mspd_suspension/index'
            return
        end

        @data = VStatusSchedule.includes(:status_scheduleable, status_scheduleable: :state, status_scheduleable: :town)
        if !params[:effective_date_from].blank?
            @data = @data.where("effective_date >= ?", params[:effective_date_from].to_date.beginning_of_day)
        end
        if !params[:effective_date_to].blank?
            @data = @data.where("effective_date <= ?", params[:effective_date_to].to_date.end_of_day)
        end
        if !params[:created_at_from].blank?
            @data = @data.where("created_at >= ?", params[:created_at_from].to_date.beginning_of_day)
        end
        if !params[:created_at_to].blank?
            @data = @data.where("created_at <= ?", params[:created_at_to].to_date.end_of_day)
        end
        if !params[:status_scheduleable_type].blank?
            @data = @data.where(status_scheduleable_type: params[:status_scheduleable_type])
        end

        respond_to do |format|
            format.html do
                @data = @data.page(params[:page])
                .per(get_per)
                render 'internal/reports/mspd/mspd_suspension/index'
            end
            format.xlsx do
                render xlsx: 'internal/reports/mspd/mspd_suspension/index', filename: "mspd_suspension-#{DateTime.current.strftime("%Y%m%d%H%M%S")}.xlsx", template: "internal/reports/mspd/#{action_name}/index"
            end
        end
    end

    def full_quota
        @current = Time.now
        state = params[:state_id]
        town = params[:town_id]
        if state.present? && town.present?
            @doctors = Doctor.select("doctors.id,doctors.code,doctors.name,doctors.clinic_name ,doctors.status,doctors.state_id ,doctors.town_id,doctors.quota_used, count(1) as no,
            (select count(1) from transactions where doctor_id=doctors.id and transaction_date >= (date_trunc('year', current_date-1) + INTERVAL '-1 year')  and transaction_date < date_trunc('year', current_date)) as previous_year,
            (select count(1) from transactions where doctor_id=doctors.id and transaction_date >= (date_trunc('year', current_date-2) + INTERVAL '-2 year')  and transaction_date < (date_trunc('year', current_date-1) + INTERVAL '-1 year') ) as previous_two_year")
            .where("state_id=#{state} and town_id=#{town} and quota <= quota_used")
            .group("doctors.id,doctors.code,doctors.name,doctors.clinic_name,doctors.status,doctors.state_id,doctors.town_id,doctors.quota_used")

        elsif state.present?
            @doctors = Doctor.select("doctors.id,doctors.code,doctors.name,doctors.clinic_name ,doctors.status,doctors.state_id ,doctors.town_id,doctors.quota_used, count(1) as no,
            (select count(1) from transactions where doctor_id=doctors.id and transaction_date >= (date_trunc('year', current_date-1) + INTERVAL '-1 year')  and transaction_date < date_trunc('year', current_date)) as previous_year,
            (select count(1) from transactions where doctor_id=doctors.id and transaction_date >= (date_trunc('year', current_date-2) + INTERVAL '-2 year')  and transaction_date < (date_trunc('year', current_date-1) + INTERVAL '-1 year') ) as previous_two_year")
            .where("state_id=#{state} and quota <= quota_used")
            .group("doctors.id,doctors.code,doctors.name,doctors.clinic_name,doctors.status,doctors.state_id,doctors.town_id,doctors.quota_used")

        elsif
            # @doctors = Doctor.includes(:state, :town).where("quota <= quota_used")
            @doctors = Doctor.select("doctors.id,doctors.code,doctors.name,doctors.clinic_name ,doctors.status,doctors.state_id ,doctors.town_id,doctors.quota_used, count(1) as no,
            (select count(1) from transactions where doctor_id=doctors.id and transaction_date >= (date_trunc('year', current_date-1) + INTERVAL '-1 year')  and transaction_date < date_trunc('year', current_date)) as previous_year,
            (select count(1) from transactions where doctor_id=doctors.id and transaction_date >= (date_trunc('year', current_date-2) + INTERVAL '-2 year')  and transaction_date < (date_trunc('year', current_date-1) + INTERVAL '-1 year') ) as previous_two_year")
            .where("quota <= quota_used")
            .group("doctors.id,doctors.code,doctors.name,doctors.clinic_name,doctors.status,doctors.state_id,doctors.town_id,doctors.quota_used")
        end

        respond_to do |format|
            format.html do
                @doctors = @doctors.page(params[:page]).per(get_per)
                render 'internal/reports/mspd/full_quota/index'
            end
            format.xlsx do
                render xlsx: 'index', filename: "full_quota-#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx", template: 'internal/reports/mspd/full_quota/index'
            end
        end
    end

    def new_dxlr
        if params[:registration_approved_at_from].blank? || params[:registration_approved_at_to].blank?
            flash.now[:error] = "Filter criteria required"
            render 'internal/reports/mspd/new_dxlr/index' and return
        end

        @doctors = Doctor.joins("right join states on states.id = doctors.state_id and doctors.registration_approved_at >= '#{params[:registration_approved_at_from].to_date.strftime("%Y-%m-%d")}' and doctors.registration_approved_at < '#{(params[:registration_approved_at_to].to_date + 1.day).strftime("%Y-%m-%d")}'")
        .select("states.name state_namez, count(doctors.id) as new_count")
        .group("state_namez")
        .order("state_namez")

        @xray_facilities = XrayFacility.joins("right join states on states.id = xray_facilities.state_id and xray_facilities.registration_approved_at >= '#{params[:registration_approved_at_from].to_date.strftime("%Y-%m-%d")}' and xray_facilities.registration_approved_at < '#{(params[:registration_approved_at_to].to_date + 1.day).strftime("%Y-%m-%d")}'")
        .select("states.name state_namez, count(xray_facilities.id) as new_count")
        .group("state_namez")
        .order("state_namez")

        @laboratories = Laboratory.joins("right join states on states.id = laboratories.state_id and laboratories.registration_approved_at >= '#{params[:registration_approved_at_from].to_date.strftime("%Y-%m-%d")}' and laboratories.registration_approved_at < '#{(params[:registration_approved_at_to].to_date + 1.day).strftime("%Y-%m-%d")}'")
        .select("states.name state_namez, count(laboratories.id) as new_count")
        .group("state_namez")
        .order("state_namez")

        @radiologists = Radiologist.joins("right join states on states.id = radiologists.state_id and radiologists.registration_approved_at >= '#{params[:registration_approved_at_from].to_date.strftime("%Y-%m-%d")}' and radiologists.registration_approved_at < '#{(params[:registration_approved_at_to].to_date + 1.day).strftime("%Y-%m-%d")}'")
        .select("states.name state_namez, count(radiologists.id) as new_count")
        .group("state_namez")
        .order("state_namez")

        respond_to do |format|
            format.html do
                render 'internal/reports/mspd/new_dxlr/index'
            end
            # format.xlsx do
            #     render xlsx: 'index', filename: "new_dxlr-#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx", template: 'internal/reports/mspd/new_dxlr/index'
            # end
        end
    end

    def active_dxlr
        @current = Time.now
        @doctors = Doctor.includes(:state, :town).where("quota <= quota_used")

        @doctors = Doctor.joins("right join states on states.id = doctors.state_id and doctors.status = 'ACTIVE'")
        .select("states.name state_namez, count(doctors.id) as active_count")
        .group("state_namez")
        .order("state_namez")

        @xray_facilities = XrayFacility.joins("right join states on states.id = xray_facilities.state_id and xray_facilities.status = 'ACTIVE'")
        .select("states.name state_namez, count(xray_facilities.id) as active_count")
        .group("state_namez")
        .order("state_namez")

        @laboratories = Laboratory.joins("right join states on states.id = laboratories.state_id and laboratories.status = 'ACTIVE'")
        .select("states.name state_namez, count(laboratories.id) as active_count")
        .group("state_namez")
        .order("state_namez")

        @radiologists = Radiologist.joins("right join states on states.id = radiologists.state_id and radiologists.status = 'ACTIVE'")
        .select("states.name state_namez, count(radiologists.id) as active_count")
        .group("state_namez")
        .order("state_namez")

        respond_to do |format|
            format.html do
                render 'internal/reports/mspd/active_dxlr/index'
            end
            # format.xlsx do
            #     render xlsx: 'index', filename: "full_quota-#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx", template: 'internal/reports/mspd/full_quota/index'
            # end
        end
    end

    def quota_summary
        @headers        = Report::QuotaSummaryReportService.headers
        @quota_ranges   = Report::QuotaSummaryReportService.quota_ranges
        year            = params[:selected_year]

        if year.present?
            @data = Report::QuotaSummaryReportService.new(year).result
        end

        render_mspd_html
    end

    def daily_balance_quota
        @current = Time.now
        state = params[:state_id]
        town = params[:town_id]
        @doctors = []

        if state.present? && town.present?
            where_query = "and s.id=#{state} and tw.id=#{town}"
        elsif state.present?
            where_query = "and s.id=#{state}"
        else
            where_query = ""
        end

            @doctors = ActiveRecord::Base.connection.execute(
                "select s.name as state,t.name as district,a.clinic_active,a.total_quota active_quota,a.clinic_inactive,a.inactive_q_used inactive_used_quota,a.count
                total_transaction,a.total_quota+a.inactive_q_used-a.count balance_quota
                from(
                select s.id sid,tw.id tid,
                (select count(1) from doctors d2 where d2.status='ACTIVE' and d2.state_id =s.id and d2.town_id =tw.id) Clinic_Active,
                coalesce ((select sum(quota - quota_used + quota_modifier) from doctors d2 where d2.status='ACTIVE' and d2.state_id =s.id and d2.town_id =tw.id),0) total_quota ,
                coalesce((select count(1) from doctors d2 where d2.status='INACTIVE' and d2.state_id =s.id and d2.town_id =tw.id),0)
                Clinic_Inactive,coalesce((select sum(quota - quota_used + quota_modifier) from doctors d2 where d2.status='INACTIVE' and d2.state_id =s.id and d2.town_id =tw.id),0)
                inactive_q_used,
                count(1)
                from transactions t
                join doctors d on t.doctor_id =d.id
                left join states s on d.state_id =s.id
                left join towns tw on d.town_id = tw.id
                where t.transaction_date>'01-jan-2023' and t.status not in('REJECTED','CANCELED') #{ where_query }
                group by s.id,tw.id
                order by 1 ,2)a
                left join states s on a.sid=s.id
                left join towns t on a.tid=t.id")

        respond_to do |format|
            format.html do
                #doctors = doctors.page(params[:page]).per(get_per)
                render 'internal/reports/mspd/daily_balance_quota/index'
            end
            format.xlsx do
                render xlsx: 'index', filename: "daily_balance_quota-#{Time.now.strftime("%Y%m%d%H%M%S")}.xlsx", template: 'internal/reports/mspd/daily_balance_quota/index'
            end
        end
    end

    private

    def eager_loaded_foreign_worker
        ForeignWorker
            .joins(:latest_transaction)
            .includes(:job_type, :country, employer: :state, transactions: [{ doctor: :town }, :laboratory, :xray_examination, :laboratory_examination, :doctor_examination])
    end

    def set_mspd_filtering_variables
        @start_date = params[:start_date].presence
        @end_date = params[:end_date].presence
    end

    def set_company_name
        @company_name = SystemConfiguration.find_by(code: 'COMPANY_NAME')&.value
    end

    def render_mspd_pdf
        render pdf: action_name,
               template: "internal/reports/mspd/#{action_name}/_pdf_template.html.haml",
               header: {
                   html: {
                       template: "internal/reports/mspd/#{action_name}/pdf_template_header"
                   }
               },
               **default_pdf_options
    end

    def render_mspd_html
        render "internal/reports/mspd/#{action_name}/index"
    end

    def render_mspd_xlsx
        render xlsx: 'index',
               filename: "#{action_name}-#{DateTime.current.to_i}.xlsx",
               template: "internal/reports/mspd/#{action_name}/index"
    end

    def delay_transmission_params
       params.permit(:transaction_date_from, :transaction_date_to, :doctor_code, :laboratory_code, :xray_code)
    end

    def set_date_time
        @date = DateTime.current.strftime('%d/%m/%Y')
        @time = DateTime.current.strftime('%H:%M:%S %p')
    end
end
