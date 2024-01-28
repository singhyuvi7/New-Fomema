module Internal
  class VisitReportLaboratoriesController < VisitReportsController

    before_action -> { can_access?("VIEW_LABORATORY_VISIT_REPORT") }, only: [:index,:show]
    before_action -> { can_access?("CREATE_LABORATORY_VISIT_REPORT") }, only: [:new,:create]
    before_action -> { can_access?("EDIT_LABORATORY_VISIT_REPORT") }, only: [:edit,:update]
    before_action -> { can_access?("DELETE_LABORATORY_VISIT_REPORT") }, only: [:destroy]
    before_action -> { can_access?("APPROVAL_LEVEL_1_LABORATORY_VISIT_REPORT") }, only: [:approval,:approve_report]
    before_action -> { can_access?("APPROVAL_LEVEL_2_LABORATORY_VISIT_REPORT") }, only: [:approval,:approve_report]

    before_action :set_officers, only: [:new, :edit, :show, :approval, :visit_summary]
    before_action :set_selected_visitors, only:[:edit, :show, :approval, :visit_summary]
    before_action :set_tabs, only: [:new, :edit, :show, :approval, :visit_summary, :submit_to_lab, :download]
    before_action :set_summary_data, only: [:visit_summary, :submit_to_lab]

    def index
      service_provider = Laboratory.to_s
      @visit_reports = apply_scopes(VisitReport)
                    .visitable_type(service_provider)
                    .search_service_provider_name(service_provider,params[:sp_name])
                    .search_service_provider_code(service_provider,params[:sp_code])
                    .search_clinic_name(service_provider,params[:clinic_name])
                    .search_service_provider_status(service_provider,params[:facility_status])
                    .order('id DESC')
                    .page(params[:page])
                    .per(get_per)

      render 'internal/visit_reports/laboratories/index'
    end

    def show
      render 'internal/visit_reports/laboratories/edit'
    end

    # GET /internal/visit_reports/laboratories/new
    def new
      @visit_report = VisitReport.new({
        visit_plan_item_id: @visit_plan_item.id,
        visit_plan_id: @visit_plan_item.visit_plan_id,
        visitable_type: @visit_plan_item.visitable_type,
        visitable_id: @visit_plan_item.visitable_id,
        laboratory_type_id: @visit_plan_item.visitable.laboratory_type_id,
        status: 'NEW'
      })

      vr_lab = {
        visit_report: @visit_report,
        laboratory_id: @visit_plan_item.visitable_id,
        laboratory_name: @visit_plan_item.visitable&.name,
        address_1: @visit_plan_item.visitable&.address1,
        address_2: @visit_plan_item.visitable&.address2,
        address_3: @visit_plan_item.visitable&.address3,
        address_4: @visit_plan_item.visitable&.address4,
        country: @visit_plan_item.visitable&.country,
        state: @visit_plan_item.visitable&.state,
        town: @visit_plan_item.visitable&.town,
        postcode: @visit_plan_item.visitable&.postcode,
        type_of_visit: @visit_plan_item.visit_plan.visit_plan_categories[0].category
      }

      @report_categories.each do |report_category|
        vr_lab[report_category] = VisitReportLabDetail.new
      end

      @visit_report.visit_report_laboratory = VisitReportLaboratory.new(vr_lab)

      @visit_report.operating_hour = OperatingHour.new(@visit_plan_item.visitable&.operating_hour.as_json)

      render 'internal/visit_reports/laboratories/new'
    end

    # GET /internal/visit_reports/laboratories/1/edit
    def edit
      if @visit_report&.laboratory_type&.name != 'COLLECTION'
        @report_categories.each do |report_category|
          row = @visit_report.visit_report_laboratory.try(report_category)
          @visit_report.visit_report_laboratory.send("#{report_category}=", VisitReportLabDetail.new({report_category: report_category})) if row.blank?
        end
      end

      render 'internal/visit_reports/laboratories/edit'
    end

    def create
      processCreate(internal_visit_reports_laboratories_path)
    end

    def update
      if ['summary','summary_with_officer_signature','summary_with_personnel_signature'].include?(params[:submit_action])
        processLabSummary(@visit_report, internal_visit_report_laboratory_visit_summary_path, params[:submit_action])
      else
        # render json: params[:visit_report][:visit_report_laboratory_attributes] and return
        ## clear report_category if iso is no?
        processUpdate(@visit_report, internal_visit_reports_laboratories_path)
      end
    end

    def destroy
      processDestroy(@visit_report, internal_visit_reports_laboratories_path)
    end

    def approval
      render 'internal/visit_reports/laboratories/edit'
    end

    def approve_report
      processApprove(params[:approval], internal_visit_reports_laboratories_path)
    end

    def visit_summary
      @is_summary = true
      @visit_report.visit_report_laboratory.attributes.each do |key, value|
        if !['id'].include?(key)
          @visit_report.visit_report_laboratory[key] = @visit_report.visit_report_laboratory_summary[key]
        end
      end

      @report_categories.each do |report_category|
        if !@visit_report.visit_report_laboratory_summary.try(report_category).blank?
          @visit_report.visit_report_laboratory.try(report_category).attributes.each do |key, value|
            if !['id'].include?(key)
              @visit_report.visit_report_laboratory.try(report_category)[key] = @visit_report.visit_report_laboratory_summary.try(report_category)[key]
            end
          end
        end
      end

      render 'internal/visit_reports/laboratories/visit_summary'
    end

    def submit_to_lab
      @email_to = params[:laboratory_email]

      body_template = 'internal/visit_reports/laboratories/pdf/visit_summary/main'

      header_template = 'internal/visit_reports/laboratories/pdf/header'
      @date = Date.today
      @company_name = SystemConfiguration.find_by(code: 'COMPANY_NAME')&.value

      # see pdf template instead of sending email
      # if params.has_key?(:debug)
      #     @debug = true
      #     # render json: @order and return
      #     render body_template, layout: 'pdf' and return
      # end

      # render pdf: "visit_summary",
      #     template: body_template,
      #     layout: "pdf.html",
      #     margin: {
      #         top: 40,
      #         left: 15,
      #         right: 15,
      #         bottom: 15,
      #     },
      #     page_size: nil,
      #     page_height: "29.7cm",
      #     page_width: "21cm",
      #     dpi: "300",
      #     header: {
      #         html: {
      #             template: header_template,
      #         }
      #     } and return
      # end to see pdf template

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

      LqccMailer.with({
        recipient: @email_to,
        file: file
      }).visit_summary.deliver_now
        
      flash[:notice] = "Visit Summary Report Has Been Emailed to '#{@email_to}'"
      respond_to do |format|
            format.html { redirect_to internal_visit_report_laboratory_visit_summary_path(@visit_report) }
      end
    end

    def download
      if @visit_report.laboratory_type&.name == 'COLLECTION'
        body_template = 'internal/visit_reports/laboratories/pdf/collection/main'
      else
        body_template = 'internal/visit_reports/laboratories/pdf/full_partial/main'
      end

      header_template = 'internal/visit_reports/laboratories/pdf/header'
      @date = Date.today
      @company_name = SystemConfiguration.find_by(code: 'COMPANY_NAME')&.value

      ## see pdf template instead of sending email
      # if params.has_key?(:debug)
      #     @debug = true
      #     # render json: @order and return
      #     render body_template, layout: 'pdf' and return
      # end

      # render pdf: "visit_summary",
      #     template: body_template,
      #     layout: "pdf.html",
      #     margin: {
      #         top: 40,
      #         left: 15,
      #         right: 15,
      #         bottom: 15,
      #     },
      #     page_size: nil,
      #     page_height: "29.7cm",
      #     page_width: "21cm",
      #     dpi: "300",
      #     header: {
      #         html: {
      #             template: header_template,
      #         }
      #     } and return
      ## end to see pdf template

      render pdf: "lqcc_visit_report",
        template: body_template,
        layout: "pdf.html",
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
            html: {
                template: header_template
            }
      }
    end

    protected

    def set_officers
      @officers = User.joins(:role).where(:userable_type => 'Organization').where(roles:{code: ['INSPECTORATE_EXECUTIVE','INSPECTORATE_LQCC_MEDICAL_OFFICER','LQCC_EXECUTIVE']}).select("users.id,users.username as name")
    end

    def set_selected_visitors
      @visit_report_visitors = @visit_report&.visit_report_visitors.select('visitor_id as id, name')
    end

    def set_tabs
      lab_type = @visit_report&.laboratory_type&.name.blank? ? @visit_plan_item.visitable.laboratory_type&.name : @visit_report&.laboratory_type&.name
      if lab_type != 'COLLECTION'
        @tabs = VisitReportLaboratory::FULL_PARTIAL_TABS
      else
        @tabs = VisitReportLaboratory::COLLECTION_TABS
      end
    end

    def set_summary_data
      visit_report_lab = @visit_report.visit_report_laboratory_summary
      if @visit_report.laboratory_type&.name == 'COLLECTION'
        @title = 'Collection Centre'
        facility_adequacy_1 = [
            [:adequate_facility, "Adequate Facility"]
        ]

        facility_adequacy_2 = [
            [:adequate_staff, "Adequate Staff"],
        ]

        facility_adequacy_3 = [
            [:adequate_instrument, "Adequate Instrument"]
        ]

        appropriate_specimen_transportation = [
            [:transport_to_test_lab, "Transportation to Testing Laboratory"],
        ]

        appropriate_specimen_packaging = [
            [:despatch_bag, "Despatch Bag"],
            [:packaging_to_test_lab, "Packaging to Testing Laboratory"],
        ]

        record_of_specimen_traceability = [
            [:clinic_to_despatch, "Clinic to Despatch"],
            [:despatch_to, "Despatch to Collection Centre"],
            [:collection_centre_to_test_lab, "Collection Centre to Testing Laboratory"],
        ]

        pre_analytical_procedure = [
            [:registration_record, "Specimen Registration Record"],
            [:rejection_register, "Specimen Rejection Register"],
            [:rejection_criteria, "Specimen Rejection Criteria"],
        ]

        specimen_storage = [
            [:adequate_space, "Adequate Space"],
            [:appropriate_temperature, "Appropriate Temperature"],
        ]

        facility_adequacy_1_values = facility_adequacy_1.map do |key, value|
            visit_report_lab.try(key)
        end

        facility_adequacy_2_values = facility_adequacy_2.map do |key, value|
          visit_report_lab.try(key)
        end

        facility_adequacy_3_values = facility_adequacy_3.map do |key, value|
          visit_report_lab.try(key)
        end

        appropriate_specimen_transportation_values = appropriate_specimen_transportation.map do |key, value|
            visit_report_lab.try(key)
        end

        appropriate_specimen_packaging_values = appropriate_specimen_packaging.map do |key, value|
            visit_report_lab.try(key)
        end

        record_of_specimen_traceability_values = record_of_specimen_traceability.map do |key, value|
            visit_report_lab.try(key)
        end

        pre_analytical_procedure_values = pre_analytical_procedure.map do |key, value|
            visit_report_lab.try(key)
        end

        specimen_storage_values = specimen_storage.map do |key, value|
            visit_report_lab.try(key)
        end

        @sections = [
            {
              title: 'Facility Adequacy',
              title_slug: 'facility_adequacy',
              table: 'visit_report_laboratory',
              has_no: (facility_adequacy_1_values+facility_adequacy_2_values+facility_adequacy_3_values).include?('NO'),
              fields: [{
                  subtitle: "",
                  subfields: facility_adequacy_1,
                  has_no: facility_adequacy_1_values.include?('NO')
                },{
                  subtitle: "",
                  subfields: facility_adequacy_2,
                  has_no: facility_adequacy_2_values.include?('NO')
                },{
                  subtitle: "",
                  subfields: facility_adequacy_3,
                  has_no: facility_adequacy_3_values.include?('NO')
                }
              ]
            },
            {
              title: 'Pre-Analytical',
              title_slug: 'pre_analytical',
              table: 'visit_report_laboratory',
              has_no: (appropriate_specimen_transportation_values+appropriate_specimen_packaging_values+record_of_specimen_traceability_values+pre_analytical_procedure_values).include?('NO'),
              fields: [
                  {
                      subtitle: "Appropriate Specimen Transportation",
                      subfields: appropriate_specimen_transportation,
                      has_no: appropriate_specimen_transportation_values.include?('NO')
                  },
                  {
                      subtitle: "Appropriate Specimen Packaging",
                      subfields: appropriate_specimen_packaging,
                      has_no: appropriate_specimen_packaging_values.include?('NO')
                  },
                  {
                      subtitle: "Record of Specimen Traceability",
                      subfields: record_of_specimen_traceability,
                      has_no: record_of_specimen_traceability_values.include?('NO')
                  },
                  {
                      subtitle: "Pre-Analytical Procedure",
                      subfields: pre_analytical_procedure,
                      has_no: pre_analytical_procedure_values.include?('NO')
                  },
              ]
            },
            {
              title: 'Specimen Storage',
              title_slug: 'specimen_storage',
              table: 'visit_report_laboratory',
              has_no: specimen_storage_values.include?('NO'),
              fields: [{
                  subtitle: "Specimen Storage",
                  subfields: specimen_storage,
                  has_no: specimen_storage_values.include?('NO')
              }]
            },
        ]

        @has_no_overall = (facility_adequacy_1_values+facility_adequacy_2_values+facility_adequacy_3_values+appropriate_specimen_transportation_values+appropriate_specimen_packaging_values+record_of_specimen_traceability_values+pre_analytical_procedure_values+specimen_storage_values).include?('NO')
      else
        @title = 'Full/Partial'

        ## facility
        facility_adequacy = [
          [:adequate_facility, "Adequate Facility"]
        ]

        facility_adequacy_2 = [
          [:adequate_staff, "Adequate Staff"]
        ]

        pathologist = [
          [:pathologist, "Pathologist"],
          [:logbook, "Logbook"]
        ]

        instrument = [
          [:adequate_instrument, "Adequate Instrument"]
        ]

        appropriate_specimen_transportation = [
            [:transport_to_test_lab, "Transportation to Testing Laboratory"],
        ]

        facility_adequacy_values = facility_adequacy.map do |key, value|
          visit_report_lab.try(key)
        end

        facility_adequacy_2_values = facility_adequacy_2.map do |key, value|
          visit_report_lab.try(key)
        end

        pathologist_values = pathologist.map do |key, value|
          visit_report_lab.try(key)
        end

        instrument_values = instrument.map do |key, value|
          visit_report_lab.try(key)
        end
        ## end facility

        ## pre analytical
        appropriate_specimen_transportation = [
            [:transport_to_test_lab, "Transportation to Testing Laboratory"],
        ]

        appropriate_specimen_packaging = [
            [:despatch_bag, "Despatch Bag"],
            [:packaging_to_test_lab, "Packaging to Testing Laboratory"],
        ]

        record_of_specimen_traceability = [
            [:clinic_to_despatch, "Clinic to Despatch"],
            [:despatch_to, "Despatch to Laboratory"],
            [:cc_partial_lab_to_test_lab, "CC/Partial lab to testing laboratory"],
        ]

        pre_analytical_procedure = [
            [:registration_record, "Specimen Registration Record"],
            [:rejection_register, "Specimen Rejection Register"],
            [:rejection_criteria, "Specimen Rejection Criteria"],
        ]
        appropriate_specimen_transportation_values = appropriate_specimen_transportation.map do |key, value|
          visit_report_lab.try(key)
        end

        appropriate_specimen_packaging_values = appropriate_specimen_packaging.map do |key, value|
            visit_report_lab.try(key)
        end

        record_of_specimen_traceability_values = record_of_specimen_traceability.map do |key, value|
            visit_report_lab.try(key)
        end

        pre_analytical_procedure_values = pre_analytical_procedure.map do |key, value|
            visit_report_lab.try(key)
        end
        ## end analytical

        ## blood_grouping
        blood_grouping = [
          [:iso_status, "MS ISO Status"],
          [:iqa, "IQA"],
          [:eqa, "EQA"],
          [:test_worksheet, "Test Worksheet"],
          [:tpm, "TPM"],
          [:instrument_maintenance_record, "Instrument Maintenance Record"]
        ]
        blood_grouping_values = blood_grouping.map do |key, value|
          visit_report_lab.blood_grouping.try(key)
        end
        ## end blood_grouping

        ## malaria_screening
        malaria_screening = [
          [:iso_status, "MS ISO Status"],
          [:iqa, "IQA"],
          [:eqa, "EQA"],
          [:test_worksheet, "Test Worksheet"],
          [:tpm, "TPM"],
          [:instrument_maintenance_record, "Instrument Maintenance Record"],
          [:traceability, "Traceability to referral laboratory"]
        ]
        malaria_screening_values = malaria_screening.map do |key, value|
          visit_report_lab.malaria_screening.try(key)
        end
        ## end malaria_screening
        
        ## malaria_screening
        malaria_screening = [
          [:iso_status, "MS ISO Status"],
          [:iqa, "IQA"],
          [:eqa, "EQA"],
          [:test_worksheet, "Test Worksheet"],
          [:tpm, "TPM"],
          [:instrument_maintenance_record, "Instrument Maintenance Record"],
          [:traceability, "Traceability to referral laboratory"]
        ]
        malaria_screening_values = malaria_screening.map do |key, value|
          visit_report_lab.malaria_screening.try(key)
        end
        ## end malaria_screening

        ## malaria_bfmp
        malaria_bfmp = [
          [:iso_status, "MS ISO Status"],
          [:iqa, "IQA"],
          [:eqa, "EQA"],
          [:test_worksheet, "Test Worksheet"],
          [:tpm, "TPM"],
          [:instrument_maintenance_record, "Instrument Maintenance Record"],
          [:traceability, "Traceability to referral laboratory"]
        ]
        malaria_bfmp_values = malaria_bfmp.map do |key, value|
          visit_report_lab.malaria_bfmp.try(key)
        end
        ## end malaria_bfmp

        ## hbsag_screening
        hbsag_screening = [
          [:iso_status, "MS ISO Status"],
          [:iqa, "IQA"],
          [:eqa, "EQA"],
          [:test_worksheet, "Test Worksheet"],
          [:tpm, "TPM"],
          [:instrument_maintenance_record, "Instrument Maintenance Record"],
          [:traceability, "Traceability to referral laboratory"]
        ]
        hbsag_screening_values = hbsag_screening.map do |key, value|
          visit_report_lab.hbsag_screening.try(key)
        end
        ## end hbsag_screening

        ## hbsag_verification
        hbsag_verification = [
          [:iso_status, "MS ISO Status"],
          [:iqa, "IQA"],
          [:eqa, "EQA"],
          [:test_worksheet, "Test Worksheet"],
          [:tpm, "TPM"],
          [:instrument_maintenance_record, "Instrument Maintenance Record"],
          [:traceability, "Traceability to referral laboratory"]
        ]
        hbsag_verification_values = hbsag_verification.map do |key, value|
          visit_report_lab.hbsag_verification.try(key)
        end
        ## end hbsag_verification

        ## hiv_screening
        hiv_screening = [
          [:iso_status, "MS ISO Status"],
          [:iqa, "IQA"],
          [:eqa, "EQA"],
          [:test_worksheet, "Test Worksheet"],
          [:tpm, "TPM"],
          [:instrument_maintenance_record, "Instrument Maintenance Record"],
          [:traceability, "Traceability to referral laboratory"]
        ]
        hiv_screening_values = hiv_screening.map do |key, value|
          visit_report_lab.hiv_screening.try(key)
        end
        ## end hiv_screening

        ## hiv_verification
        hiv_verification = [
          [:iso_status, "MS ISO Status"],
          [:iqa, "IQA"],
          [:eqa, "EQA"],
          [:test_worksheet, "Test Worksheet"],
          [:tpm, "TPM"],
          [:instrument_maintenance_record, "Instrument Maintenance Record"],
          [:traceability, "Traceability to referral laboratory"]
        ]
        hiv_verification_values = hiv_verification.map do |key, value|
          visit_report_lab.hiv_verification.try(key)
        end
        ## end hiv_verification

        ## vdrl_rpr
        vdrl_rpr = [
          [:iso_status, "MS ISO Status"],
          [:iqa, "IQA"],
          [:eqa, "EQA"],
          [:test_worksheet, "Test Worksheet"],
          [:tpm, "TPM"],
          [:instrument_maintenance_record, "Instrument Maintenance Record"],
          [:traceability, "Traceability to referral laboratory"]
        ]
        vdrl_rpr_values = vdrl_rpr.map do |key, value|
          visit_report_lab.vdrl_rpr.try(key)
        end
        ## end vdrl_rpr

        ## tpha_tppa
        tpha_tppa = [
          [:iso_status, "MS ISO Status"],
          [:iqa, "IQA"],
          [:eqa, "EQA"],
          [:test_worksheet, "Test Worksheet"],
          [:tpm, "TPM"],
          [:instrument_maintenance_record, "Instrument Maintenance Record"],
          [:traceability, "Traceability to referral laboratory"]
        ]
        tpha_tppa_values = tpha_tppa.map do |key, value|
          visit_report_lab.tpha_tppa.try(key)
        end
        ## end tpha_tppa

        ## urine_drugs_screening
        urine_drugs_screening = [
          [:iso_status, "MS ISO Status"],
          [:iqa, "IQA"],
          [:eqa, "EQA"],
          [:test_worksheet, "Test Worksheet"],
          [:tpm, "TPM"],
          [:instrument_maintenance_record, "Instrument Maintenance Record"],
          [:traceability, "Traceability to referral laboratory"]
        ]
        urine_drugs_screening_values = urine_drugs_screening.map do |key, value|
          visit_report_lab.urine_drugs_screening.try(key)
        end
        ## end urine_drugs_screening

        ## urine_drugs_verification
        urine_drugs_verification = [
          [:iso_status, "MS ISO Status"],
          [:iqa, "IQA"],
          [:eqa, "EQA"],
          [:test_worksheet, "Test Worksheet"],
          [:tpm, "TPM"],
          [:instrument_maintenance_record, "Instrument Maintenance Record"],
          [:traceability, "Traceability to referral laboratory"]
        ]
        urine_drugs_verification_values = urine_drugs_verification.map do |key, value|
          visit_report_lab.urine_drugs_verification.try(key)
        end
        ## end urine_drugs_verification

        ## upt
        upt = [
          [:iso_status, "MS ISO Status"],
          [:iqa, "IQA"],
          [:eqa, "EQA"],
          [:test_worksheet, "Test Worksheet"],
          [:tpm, "TPM"],
          [:instrument_maintenance_record, "Instrument Maintenance Record"],
          [:traceability, "Traceability to referral laboratory"]
        ]
        upt_values = upt.map do |key, value|
          visit_report_lab.upt.try(key)
        end
        ## end upt

        ## serum_assay
        serum_assay = [
          [:iso_status, "MS ISO Status"],
          [:iqa, "IQA"],
          [:eqa, "EQA"],
          [:test_worksheet, "Test Worksheet"],
          [:tpm, "TPM"],
          [:instrument_maintenance_record, "Instrument Maintenance Record"],
          [:traceability, "Traceability to referral laboratory"]
        ]
        serum_assay_values = serum_assay.map do |key, value|
          visit_report_lab.serum_assay.try(key)
        end
        ## end serum_assay

        ## urine_biochemistry
        urine_biochemistry = [
          [:iso_status, "MS ISO Status"],
          [:iqa, "IQA"],
          [:eqa, "EQA"],
          [:test_worksheet, "Test Worksheet"],
          [:tpm, "TPM"],
          [:instrument_maintenance_record, "Instrument Maintenance Record"],
          [:traceability, "Traceability to referral laboratory"]
        ]
        urine_biochemistry_values = urine_biochemistry.map do |key, value|
          visit_report_lab.urine_biochemistry.try(key)
        end
        ## end urine_biochemistry

        ## specimen storage
        specimen_storage_1 = [
            [:negative_specimens, "Negative Specimens Kept for Two(2) Days"],
        ]
        specimen_storage_2 = [
            [:positive_specimens, "Positive Specimens for Eight(8) Weeks"],
        ]
        specimen_storage_3 = [
          [:adequate_space, "Adequate Space"],
          [:appropriate_temperature, "Appropriate Temperature"]
        ]
        specimen_storage_4 = [
          [:negative_malaria, "Negative Malaria Slides for Two(2) Weeks"],
        ]
        specimen_storage_5 = [
          [:quality_check, "Quality Check on 10% of Negative and 100% of Positive Slides to Vector Borne Disease Unit of MOH State Level (Pahang/Johor)"],
        ]

        specimen_storage_1_values = specimen_storage_1.map do |key, value|
          visit_report_lab.try(key)
        end
        specimen_storage_2_values = specimen_storage_2.map do |key, value|
          visit_report_lab.try(key)
        end
        specimen_storage_3_values = specimen_storage_3.map do |key, value|
          visit_report_lab.try(key)
        end
        specimen_storage_4_values = specimen_storage_4.map do |key, value|
          visit_report_lab.try(key)
        end
        specimen_storage_5_values = specimen_storage_5.map do |key, value|
          visit_report_lab.try(key)
        end
        ## end specimen storage

        ## reporting/record keeping
        record_keeping_1 = [
          [:checked_before_transcription, "Reports been checked before transcription/issue"],
        ]
        record_keeping_2 = [
          [:precaution_taken, "Precaution taken to avoid manipulation of results (Level of IT security)"],
        ]
        record_keeping_3 = [
          [:records_kept_reg_lab, "Records of specimens and results are kept at the registered laboratory for at the last two(2) years"],
        ]
        record_keeping_4 = [
          [:records_kept_at_least, "Records of specimens and results are kept for at least seven(7) years"],
        ]
        record_keeping_1_values = record_keeping_1.map do |key, value|
          visit_report_lab.try(key)
        end
        record_keeping_2_values = record_keeping_2.map do |key, value|
          visit_report_lab.try(key)
        end
        record_keeping_3_values = record_keeping_3.map do |key, value|
          visit_report_lab.try(key)
        end
        record_keeping_4_values = record_keeping_4.map do |key, value|
          visit_report_lab.try(key)
        end
        ## end reporting
      
        @sections = [
          {
            title: 'Facility Adequacy',
            title_slug: 'facility_adequacy',
            table: 'visit_report_laboratory',
            has_no: (facility_adequacy_values+facility_adequacy_2_values+pathologist_values+instrument_values).include?('NO'),
            fields: [{
                subtitle: "",
                subfields: facility_adequacy,
                has_no: facility_adequacy_values.include?('NO')
            },{
              subtitle: "",
              subfields: facility_adequacy_2,
              has_no: facility_adequacy_2_values.include?('NO')
            },{
                subtitle: "Pathologist",
                subfields: pathologist,
                has_no: pathologist_values.include?('NO')
            },{
              subtitle: "",
              subfields: instrument,
              has_no: instrument_values.include?('NO')
            }]
          },{
            title: 'Pre-Analytical',
            title_slug: 'pre_analytical',
            table: 'visit_report_laboratory',
            has_no: (appropriate_specimen_transportation_values+appropriate_specimen_packaging_values+record_of_specimen_traceability_values+pre_analytical_procedure_values).include?('NO'),
            fields: [
                {
                    subtitle: "Appropriate Specimen Transportation",
                    subfields: appropriate_specimen_transportation,
                    has_no: appropriate_specimen_transportation_values.include?('NO')
                },
                {
                    subtitle: "Appropriate Specimen Packaging",
                    subfields: appropriate_specimen_packaging,
                    has_no: appropriate_specimen_packaging_values.include?('NO')
                },
                {
                    subtitle: "Record of Specimen Traceability",
                    subfields: record_of_specimen_traceability,
                    has_no: record_of_specimen_traceability_values.include?('NO')
                },
                {
                    subtitle: "Pre-Analytical Procedure",
                    subfields: pre_analytical_procedure,
                    has_no: pre_analytical_procedure_values.include?('NO')
                },
            ]
          },{
            title: 'ABO RH(D) Blood Grouping',
            title_slug: 'blood_grouping',
            table: 'blood_grouping',
            has_no: blood_grouping_values.include?('NO'),
            fields: [
              {
                  subtitle: "",
                  subfields: blood_grouping,
                  has_no: blood_grouping_values.include?('NO')
              }
            ]
          },{
            title: 'Malaria - Screening',
            title_slug: 'malaria_screening',
            table: 'malaria_screening',
            has_no: malaria_screening_values.include?('NO'),
            fields: [
              {
                  subtitle: "",
                  subfields: malaria_screening,
                  has_no: malaria_screening_values.include?('NO')
              }
            ]
          },{
            title: 'Malaria - BFMP',
            title_slug: 'malaria_bfmp',
            table: 'malaria_bfmp',
            has_no: malaria_bfmp_values.include?('NO'),
            fields: [
              {
                  subtitle: "",
                  subfields: malaria_bfmp,
                  has_no: malaria_bfmp_values.include?('NO')
              }
            ]
          },{
            title: 'HBSAG - Screening',
            title_slug: 'hbsag_screening',
            table: 'hbsag_screening',
            has_no: hbsag_screening_values.include?('NO'),
            fields: [
              {
                  subtitle: "",
                  subfields: hbsag_screening,
                  has_no: hbsag_screening_values.include?('NO')
              }
            ]
          },{
            title: 'HBSAG - Verification',
            title_slug: 'hbsag_verification',
            table: 'hbsag_verification',
            has_no: hbsag_verification_values.include?('NO'),
            fields: [
              {
                  subtitle: "",
                  subfields: hbsag_verification,
                  has_no: hbsag_verification_values.include?('NO')
              }
            ]
          },{
            title: 'HIV - Screening',
            title_slug: 'hiv_screening',
            table: 'hiv_screening',
            has_no: hiv_screening_values.include?('NO'),
            fields: [
              {
                  subtitle: "",
                  subfields: hiv_screening,
                  has_no: hiv_screening_values.include?('NO')
              }
            ]
          },{
            title: 'HIV - Verification',
            title_slug: 'hiv_verification',
            table: 'hiv_verification',
            has_no: hiv_verification_values.include?('NO'),
            fields: [
              {
                  subtitle: "",
                  subfields: hiv_verification,
                  has_no: hiv_verification_values.include?('NO')
              }
            ]
          },{
            title: 'VDRL/RPR',
            title_slug: 'vdrl_rpr',
            table: 'vdrl_rpr',
            has_no: vdrl_rpr_values.include?('NO'),
            fields: [
              {
                  subtitle: "",
                  subfields: vdrl_rpr,
                  has_no: vdrl_rpr_values.include?('NO')
              }
            ]
          },{
            title: 'TPHA/TPPA',
            title_slug: 'tpha_tppa',
            table: 'tpha_tppa',
            has_no: tpha_tppa_values.include?('NO'),
            fields: [
              {
                  subtitle: "",
                  subfields: tpha_tppa,
                  has_no: tpha_tppa_values.include?('NO')
              }
            ]
          },{
            title: 'Urine Drugs - Screening',
            title_slug: 'urine_drugs_screening',
            table: 'urine_drugs_screening',
            has_no: urine_drugs_screening_values.include?('NO'),
            fields: [
              {
                  subtitle: "",
                  subfields: urine_drugs_screening,
                  has_no: urine_drugs_screening_values.include?('NO')
              }
            ]
          },{
            title: 'Urine Drugs - Verification',
            title_slug: 'urine_drugs_verification',
            table: 'urine_drugs_verification',
            has_no: urine_drugs_verification_values.include?('NO'),
            fields: [
              {
                  subtitle: "",
                  subfields: urine_drugs_verification,
                  has_no: urine_drugs_verification_values.include?('NO')
              }
            ]
          },{
            title: 'UPT',
            title_slug: 'upt',
            table: 'upt',
            has_no: upt_values.include?('NO'),
            fields: [
              {
                  subtitle: "",
                  subfields: upt,
                  has_no: upt_values.include?('NO')
              }
            ]
          },{
            title: 'SERUM β-hCG Assay',
            title_slug: 'serum_assay',
            table: 'serum_assay',
            has_no: serum_assay_values.include?('NO'),
            fields: [
              {
                  subtitle: "",
                  subfields: serum_assay,
                  has_no: serum_assay_values.include?('NO')
              }
            ]
          },{
            title: 'Urine Biochemistry',
            title_slug: 'urine_biochemistry',
            table: 'urine_biochemistry',
            has_no: urine_biochemistry_values.include?('NO'),
            fields: [
              {
                  subtitle: "",
                  subfields: urine_biochemistry,
                  has_no: urine_biochemistry_values.include?('NO')
              }
            ]
          },
          {
            title: 'Specimen Storage',
            title_slug: 'specimen_storage',
            table: 'visit_report_laboratory',
            has_no: (specimen_storage_1_values+specimen_storage_2_values+specimen_storage_3_values+specimen_storage_4_values+specimen_storage_5_values).include?('NO'),
            fields: [
              {
                  subtitle: "",
                  subfields: specimen_storage_1,
                  has_no: specimen_storage_1_values.include?('NO')
              },
              {
                  subtitle: "",
                  subfields: specimen_storage_2,
                  has_no: specimen_storage_2_values.include?('NO')
              },
              {
                  subtitle: "Specimen Storage",
                  subfields: specimen_storage_3,
                  has_no: specimen_storage_3_values.include?('NO')
              },
              {
                  subtitle: "",
                  subfields: specimen_storage_4,
                  has_no: specimen_storage_4_values.include?('NO')
              },
              {
                  subtitle: "",
                  subfields: specimen_storage_5,
                  has_no: specimen_storage_5_values.include?('NO')
              }
            ]
          },{
            title: 'Reporting/Record Keeping',
            title_slug: 'record_keeping',
            table: 'visit_report_laboratory',
            has_no: (record_keeping_1_values+record_keeping_2_values+record_keeping_3_values+record_keeping_4_values).include?('NO'),
            fields: [
              {
                subtitle: "",
                subfields: record_keeping_1,
                has_no: record_keeping_1_values.include?('NO')
              },
              {
                  subtitle: "",
                  subfields: record_keeping_2,
                  has_no: record_keeping_2_values.include?('NO')
              },
              {
                  subtitle: "",
                  subfields: record_keeping_3,
                  has_no: record_keeping_3_values.include?('NO')
              },
              {
                subtitle: "",
                subfields: record_keeping_4,
                has_no: record_keeping_4_values.include?('NO')
              }
            ]
          }
        ]

        @has_no_overall = (facility_adequacy_values+facility_adequacy_2_values+pathologist_values+instrument_values+appropriate_specimen_transportation_values+appropriate_specimen_packaging_values+record_of_specimen_traceability_values+pre_analytical_procedure_values+blood_grouping_values+malaria_screening_values+malaria_bfmp_values+hbsag_screening_values+hbsag_verification_values+hiv_screening_values+hiv_verification_values+vdrl_rpr_values+tpha_tppa_values+urine_drugs_screening_values+urine_drugs_verification_values+upt_values+serum_assay_values+urine_biochemistry_values+specimen_storage_1_values+specimen_storage_2_values+specimen_storage_3_values+specimen_storage_4_values+specimen_storage_5_values+record_keeping_1_values+record_keeping_2_values+record_keeping_3_values+record_keeping_4_values).include?('NO')
      end
    end

  end

end
