module Internal
  class VisitReportClinicsController < VisitReportsController

    before_action -> { can_access?("VIEW_DOCTOR_VISIT_REPORT") }, only: [:index,:show]
    before_action -> { can_access?("CREATE_DOCTOR_VISIT_REPORT") }, only: [:new,:create]
    before_action -> { can_access?("EDIT_DOCTOR_VISIT_REPORT") }, only: [:edit,:update]
    before_action -> { can_access?("DELETE_DOCTOR_VISIT_REPORT") }, only: [:destroy]
    before_action -> { can_access?("APPROVAL_LEVEL_1_DOCTOR_VISIT_REPORT") }, only: [:approval,:approve_report]
    before_action -> { can_access?("APPROVAL_LEVEL_2_DOCTOR_VISIT_REPORT") }, only: [:approval,:approve_report]
    
    before_action :set_communicable_diseases, only: [:show]

    # GET /internal/visit_reports/clinics
    # GET /internal/visit_reports/clinics.json
    def index
      service_provider = Doctor.to_s
      @visit_reports = apply_scopes(VisitReport)
                    .visitable_type(service_provider)
                    .search_service_provider_name(service_provider,params[:sp_name])
                    .search_service_provider_code(service_provider,params[:sp_code])
                    .search_clinic_name(service_provider,params[:clinic_name])
                    .search_service_provider_status(service_provider,params[:facility_status])
                    .order('id DESC')
                    .page(params[:page])
                    .per(get_per)

      render 'internal/visit_reports/clinics/index'
    end

    # GET /internal/visit_reports/clinics/1
    # GET /internal/visit_reports/clinics/1.json
    def show
      render 'internal/visit_reports/clinics/edit'
    end

    # GET /internal/visit_reports/clinics/new
    def new

      @visit_report = VisitReport.includes(:visit_plan, :visit_report_doctor, :operating_hour, :visit_report_visitors).new

      @visit_report.visit_plan_item_id = @visit_plan_item.id

      @visit_report.visit_plan_id = @visit_plan_item.visit_plan_id

      @visit_report.visitable_type = @visit_plan_item.visitable_type
      @visit_report.visitable_id = @visit_plan_item.visitable_id

      # init VisitReportDoctor empty relations to consistent with Edit relations
      @visit_report.visit_report_doctor = VisitReportDoctor.new({
        doctor_name: @visit_plan_item.visitable&.name
      })

      @visit_report.operating_hour = OperatingHour.new

      @visit_report.prepare_by = current_user.id
      @visit_report.prepare_at = DateTime.now.to_date
      @visit_report.visit_time_from = '12:00:00'
      @visit_report.visit_time_to = '12:00:00'

      render 'internal/visit_reports/clinics/new'

    end

    # GET /internal/visit_reports/clinics/1/edit
    def edit
      render 'internal/visit_reports/clinics/edit'
    end

    # POST /internal/visit_reports/clinics
    # POST /internal/visit_reports/clinics.json
    def create
      processCreate(internal_visit_report_clinics_path)
    end

    # PATCH/PUT /internal/visit_reports/clinics/1
    # PATCH/PUT /internal/visit_reports/clinics/1.json
    def update
      processUpdate(@visit_report, internal_visit_report_clinics_path)
    end

    # DELETE /internal/visit_reports/clinics/1
    # DELETE /internal/visit_reports/clinics/1.json
    def destroy
      processDestroy(@visit_report, internal_visit_report_clinics_path)
    end

    def approval
      @visit_report_approval = {}
      render 'internal/visit_reports/clinics/edit'
    end

    def approve_report
      processApprove(params[:visit_report_approval], internal_visit_report_clinics_path)
    end

    def set_communicable_diseases
      this_year = Date.today.year
      @transactions = Transaction.where(:doctor_id => @visit_report.visitable_id, :communicable_diseases => true)
      .where('extract(year from certification_date) = ?', this_year)
    end

    def update_signature
      processUpdateSignature(@visit_report, internal_visit_report_clinic_edit_path)
    end

    def download
      @current = Time.now if @current.blank?
      @date = @current.strftime('%d/%m/%Y')
      @time = @current.strftime('%H:%M:%S %p')

      # debug mode on / off
      @debug = false
      file = 'pdf_templates/visit_reports/visit_report_clinic'

      # enable debug by passing ?debug param in url
      if params.has_key?(:debug)
          @debug = true
          render file, layout: 'pdf'
      else
          render pdf: "visit_report",
          template: file,
          layout: "pdf.html",
          margin: {
              top: 40,
              left: 15,
              right: 15,
              bottom: 20,
          },
          page_size: nil,
          page_height: "29.7cm",
          page_width: "21cm",
          dpi: "300",
          header: {
            html: {
                template: 'pdf_templates/visit_reports/header'
            }
          }
      end
    end

    def submit_to_clinic
      @email_to = params[:email]

      body_template =  'pdf_templates/visit_reports/visit_report_clinic'

      header_template = 'pdf_templates/visit_reports/header'
      @current = Time.now if @current.blank?
      @date = @current.strftime('%d/%m/%Y')
      @time = @current.strftime('%H:%M:%S %p')

      file = WickedPdf.new.pdf_from_string(render_to_string(body_template, layout: 'pdf.html'),
        margin: {
              top: 37,
              left: 15,
              right: 15,
              bottom: 15,
          },
          page_size: nil,
          page_height: "29.7cm",
          page_width: "21cm",
          dpi: "300",
          header: {
            content: render_to_string(header_template, layout: 'pdf.html')
          }
        )

        InspectorateMailer.with({
          recipient: @email_to,
          file: file
        }).visit_report.deliver_now
        
      flash[:notice] = "Visit Report Has Been Emailed to '#{@email_to}'"
      respond_to do |format|
        format.html { redirect_to internal_visit_report_clinic_edit_path(@visit_report) }
      end
    end
  end

end
