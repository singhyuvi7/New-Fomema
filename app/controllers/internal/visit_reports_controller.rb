module Internal

  class VisitReportsController < InternalController
    before_action :set_visit_report, only: [:show, :edit, :update, :destroy, :approval, :explanation_letter, :visit_summary, :submit_to_lab, :update_signature, :download, :submit_to_clinic]

    before_action :set_visit_plan, only: [:new]
    before_action :set_report_categories, only: [:new, :create, :update, :edit, :visit_summary]
    before_action :set_years, only: [:new, :create, :show, :edit, :update, :destroy, :approval, :approve_report, :update_signature]

    has_scope :visitable_type, only: [:index]
    has_scope :visit_date_from, only: [:index]
    has_scope :visit_date_to, only: [:index]
    has_scope :status, only: [:index]
    has_scope :code, only: [:index]

    # GET /internal/visit_reports/new
    def new
      @visit_report = VisitReport.new
    end

    def explanation_letter

      if @visit_report&.visitable_type == 'Doctor'
        file = 'pdf_templates/visit_reports/clinic_explanation_letter'
        @transactions = Transaction.where(:id => params[:ids])
        
        @diseases = @transactions.joins(:doctor_examination)
        .joins('join doctor_examination_details on doctor_examinations.id = doctor_examination_details.doctor_examination_id ')
        .joins('join conditions on doctor_examination_details.condition_id = conditions.id')
        .where("conditions.code in (?)", ['3501', '3502', '3503', '3504', '3505', '3506'])
        .select("conditions.code, conditions.description, array_agg(transactions.id) as transaction_ids")
        .group('conditions.code, conditions.description')
      else
        file = 'pdf_templates/visit_reports/xray_explanation_letter'
      end

      @visit_report.explanation_letter_date = DateTime.now
      @visit_report.save
      # debug mode on / off
      @debug = false

      # enable debug by passing ?debug param in url
      if params.has_key?(:debug)
          @debug = true
          render file, layout: 'pdf'
      else
          render pdf: "explanation_letter",
          template: file,
          layout: "pdf.html",
          margin: {
            top: 33,
            left: 25,
            right: 25,
            bottom: 20,
          },
          page_size: nil,
          page_height: "29.7cm",
          page_width: "21cm",
          dpi: "300",
          header: {
            html: {
              template: 'pdf_templates/visit_reports/letter_header'
            }
          }
      end
    end

    protected

    def processCreate(redirect_path)

      visit_report_data = visit_report_params

      visit_report_data[:status] = 'DRAFT'

      # set status if submit for approval
      visit_report_data = setVisitReportStatus(visit_report_data, params[:submit_action])

      @visit_report = VisitReport.new(visit_report_data)

      respond_to do |format|
        if @visit_report.save

          case visit_report_data[:visitable_type]

          when Doctor.to_s
            @visit_report.create_operating_hour(operating_hour_params)
            syncOperatingHour(@visit_report)

            path = internal_visit_report_clinic_edit_path(@visit_report)

            @visit_report.create_visit_report_doctor(visit_report_doctor_params)
            syncInspectorateTeam(@visit_report,params[:visit_report_visitors])

          when Laboratory.to_s
            path = internal_visit_report_laboratory_edit_path(@visit_report)

            @visit_report.create_operating_hour(params[:visit_report][:operating_hour_attributes].permit!)

            @visit_report.create_visit_report_laboratory(visit_report_laboratory_params)
            syncInspectorateTeam(@visit_report,params[:visit_report_visitors])

            ## only for full/partial
            if @visit_report&.laboratory_type&.name != 'COLLECTION'
              @report_categories.each do |report_category|
                report_data =  params[:visit_report][:visit_report_laboratory_attributes]["#{report_category}_attributes"]
                if !report_data.blank?
                  @visit_report.visit_report_laboratory.visit_report_lab_details.create(report_data.permit!)
                end
              end
            end
            
          when XrayFacility.to_s
            @visit_report.create_operating_hour(operating_hour_params)
            syncOperatingHour(@visit_report)
            
            path = internal_visit_report_xray_facility_edit_path(@visit_report)

            @visit_report.create_visit_report_xray_facility(visit_report_xray_facility_params)
            syncInspectorateTeam(@visit_report,params[:visit_report_visitors])

          else

          end

          message = getSubmitMessage(visit_report_data,'created')

          if visit_report_data[:status] === 'DRAFT'
            redirect_path = path
          end

          format.html { redirect_to redirect_path, notice: message }
          format.json { render :show, status: :created, location: @visit_report }
        else
          format.html { render :new }
          format.json { render json: @visit_report.errors, status: :unprocessable_entity }
        end

      end
    end

    def processUpdate(visit_report, redirect_path)

      respond_to do |format|

        visit_report_data = visit_report_params

        # set status if submit for approval
        visit_report_data = setVisitReportStatus(visit_report_data, params[:submit_action])

        if visit_report.update(visit_report_data)

          case visit_report_data[:visitable_type]

          when Doctor.to_s

            visit_report.visit_report_doctor.update(visit_report_doctor_params)
            syncOperatingHour(visit_report)
            syncInspectorateTeam(visit_report,params[:visit_report_visitors])

          when Laboratory.to_s

            visit_report.visit_report_laboratory.update(visit_report_laboratory_params)

            visit_report.operating_hour.update(params[:visit_report][:operating_hour_attributes].permit!)
            syncInspectorateTeam(visit_report,params[:visit_report_visitors])

            ## only for full/partial
            if visit_report&.laboratory_type&.name != 'COLLECTION'
              @report_categories.each do |report_category|
                report_data = params[:visit_report][:visit_report_laboratory_attributes]["#{report_category}_attributes"]
                if !report_data.blank?
                  row = @visit_report.visit_report_laboratory.try(report_category)
                  row.blank? ? @visit_report.visit_report_laboratory.visit_report_lab_details.create(report_data.permit!) : row.update(report_data.permit!)
                end
              end
            end
            ## full/partial end

          when XrayFacility.to_s
            visit_report.visit_report_xray_facility.update(visit_report_xray_facility_params)
            syncOperatingHour(visit_report)
            syncInspectorateTeam(visit_report,params[:visit_report_visitors])

          else

          end

          message = getSubmitMessage(visit_report_data,'updated')

          if visit_report_data[:status] === 'DRAFT'
            redirect_path = request.referrer
          end

          format.html { redirect_to redirect_path, notice: message }
          format.json { render :show, status: :ok, location: visit_report }

        else

          format.html { render :edit }
          format.json { render json: visit_report.errors, status: :unprocessable_entity }
        end
      end
    end

    def processDestroy(visit_report, redirect_path, message = "Visit Report ID '#{@visit_report.code}' Has Been Deleted.")
      visit_report.destroy

      respond_to do |format|
        format.html { redirect_to redirect_path, notice: message }
        format.json { head :no_content }
      end
    end

    def processApprove(visit_report_approval, redirect_path)
      respond_to do |format|

        decision = visit_report_approval[:decision]
        comment = visit_report_approval[:comment]
        approval_by = current_user.id
        approval_at = Time.now

        @visit_report = VisitReport::find(params[:id])

        approval_data = {}
        status = 'REJECTED'
        if @visit_report[:status] === 'LEVEL_1_APPROVAL'
          approval_data[:level_1_approval_decision] = decision
          approval_data[:level_1_approval_comment] = comment
          approval_data[:level_1_approval_by] = approval_by
          approval_data[:level_1_approval_at] = approval_at

          if decision == 'APPROVE'
            status = 'LEVEL_1_APPROVED'
          end
        end
  
        if @visit_report[:status] === 'LEVEL_1_APPROVED'
          approval_data[:level_2_approval_decision] = decision
          approval_data[:level_2_approval_comment] = comment
          approval_data[:level_2_approval_by] = approval_by
          approval_data[:level_2_approval_at] = approval_at

          if decision == 'APPROVE'
            status = 'LEVEL_2_APPROVED'
          end
        end

        approval_data[:status] = status
  
        @visit_report.update(approval_data);

        message = decision == 'REJECT' ? "Visit Report ID '#{@visit_report.code}' Has Been Rejected" : "Visit Report ID '#{@visit_report.code}' Was Approved."

        format.html { redirect_to redirect_path, notice: message }
        format.json { head :no_content }
      end

    end

    def processUpdateSignature(visit_report, redirect_path)
      if visit_report.visitable_type == 'Doctor'
        visit_report.visit_report_doctor.update(visit_report_doctor_signature_params)
      elsif visit_report.visitable_type == 'XrayFacility'
        visit_report.visit_report_xray_facility.update(visit_report_xray_facility_signature_params)
      end
      respond_to do |format|
        format.html { redirect_to redirect_path, notice: 'Signature updated' }
      end
    end

    def processLabSummary(visit_report, redirect_path, submit_action)
      summary = visit_report.visit_report_laboratories.where(:category => 'SUMMARY')
      lab_params = visit_report_laboratory_params.merge!(:category => 'SUMMARY')

      if submit_action == 'summary_with_personnel_signature'
        lab_params = lab_params.except(:fomema_officer_name, :fomema_officer_signature)
      elsif submit_action == 'summary_with_officer_signature'
        lab_params = lab_params.except(:lab_personnel_name, :lab_personnel_designation, :lab_personnel_signature)
      else
        lab_params = lab_params.except(:fomema_officer_name, :fomema_officer_signature, :lab_personnel_name, :lab_personnel_designation, :lab_personnel_signature)
      end

      if summary.blank?
        vr_lab = visit_report.visit_report_laboratories.create(lab_params)
      else
        visit_report.visit_report_laboratory_summary.update(lab_params)
        vr_lab = summary.first
      end

      ## only for full/partial
      if visit_report&.laboratory_type&.name != 'COLLECTION'
        @report_categories.each do |report_category|
          report_data = params[:visit_report][:visit_report_laboratory_attributes]["#{report_category}_attributes"]
          if !report_data.blank?
            row = vr_lab.try(report_category)
            row.blank? ? vr_lab.visit_report_lab_details.create(report_data.except(:id).permit!) : row.update(report_data.except(:id).permit!)
          end
        end
      end
      # full/partial end

      # render json: visit_report.visit_report_laboratory_summary and return
      respond_to do |format|
        format.html { redirect_to redirect_path, notice: 'Visit Summary Updated' }
        format.json { render :show, status: :ok, location: visit_report }
      end
    end

    def getSubmitMessage(visit_report_data,type_msg)
      if visit_report_data[:status] == 'LEVEL_1_APPROVAL'
        message = "Visit Report ID '#{@visit_report.code}' Has Been Submitted For Approval"
      else
        message = "Visit Report ID '#{@visit_report.code}' Saved As Draft"
      end

      return message
    end

    def setVisitReportStatus(visit_report_data, submit_action)

      if submit_action == 'submit'
        visit_report_data[:status] = 'LEVEL_1_APPROVAL'
      else
        visit_report_data[:status] = 'DRAFT'
      end

      return visit_report_data

    end

    def syncInspectorateTeam(visit_report, visit_report_visitor_params)

      # clear previous records

      visit_report.visit_report_visitors.destroy_all

      unless visit_report_visitor_params.nil?

        visit_report_visitor_params.each do |visitor|

          visitor = JSON.parse(visitor)
          data = [
              visitor_id: visitor['id'],
              name: visitor['name']
          ]

          visit_report.visit_report_visitors.create(data)

        end

      end

    end

    def syncOperatingHour(visit_report)
      sp_operating_hour = visit_report.visit_plan_item.visitable.operating_hour
      if sp_operating_hour.present?
        visit_report.operating_hour.update(
          monday_is_close: sp_operating_hour.monday_is_close,
          monday_is_24_hour: sp_operating_hour.monday_is_24_hour,
          monday_start: sp_operating_hour.monday_start,
          monday_end: sp_operating_hour.monday_end,
          monday_break: sp_operating_hour.monday_break,
          tuesday_is_close: sp_operating_hour.tuesday_is_close,
          tuesday_is_24_hour: sp_operating_hour.tuesday_is_24_hour,
          tuesday_start: sp_operating_hour.tuesday_start,
          tuesday_end: sp_operating_hour.tuesday_end,
          tuesday_break: sp_operating_hour.tuesday_break,
          wednesday_is_close: sp_operating_hour.wednesday_is_close,
          wednesday_is_24_hour: sp_operating_hour.wednesday_is_24_hour,
          wednesday_start: sp_operating_hour.wednesday_start,
          wednesday_end: sp_operating_hour.wednesday_end,
          wednesday_break: sp_operating_hour.wednesday_break,
          thursday_is_close: sp_operating_hour.thursday_is_close,
          thursday_is_24_hour: sp_operating_hour.thursday_is_24_hour,
          thursday_start: sp_operating_hour.thursday_start,
          thursday_end: sp_operating_hour.thursday_end,
          thursday_break: sp_operating_hour.thursday_break,
          friday_is_close: sp_operating_hour.friday_is_close,
          friday_is_24_hour: sp_operating_hour.friday_is_24_hour,
          friday_start: sp_operating_hour.friday_start,
          friday_end: sp_operating_hour.friday_end,
          friday_break: sp_operating_hour.friday_break,
          saturday_is_close: sp_operating_hour.saturday_is_close,
          saturday_is_24_hour: sp_operating_hour.saturday_is_24_hour,
          saturday_start: sp_operating_hour.saturday_start,
          saturday_end: sp_operating_hour.saturday_end,
          saturday_break: sp_operating_hour.saturday_break,
          sunday_is_close: sp_operating_hour.sunday_is_close,
          sunday_is_24_hour: sp_operating_hour.sunday_is_24_hour,
          sunday_start: sp_operating_hour.sunday_start,
          sunday_end: sp_operating_hour.sunday_end,
          sunday_break: sp_operating_hour.sunday_break,
          public_holiday_is_close: sp_operating_hour.public_holiday_is_close,
          public_holiday_is_24_hour: sp_operating_hour.public_holiday_is_24_hour,
          public_holiday_start: sp_operating_hour.public_holiday_start,
          public_holiday_end: sp_operating_hour.public_holiday_end,
          public_holiday_break: sp_operating_hour.public_holiday_break
          )
      end
    end

    # set visit plan when user create visit report from visit plan item
    def set_visit_plan
      @visit_plan_item = VisitPlanItem.find(params[:visit_plan_item_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_visit_report
      @visit_report = VisitReport.find(params[:id])
    end

    def set_years
      current_year = Date.today.year
      @years = [current_year]
      for x in 1..4
        @years << current_year-x
      end
    end

    def set_report_categories
      @report_categories = VisitReportLaboratory::REPORT_CATEGORIES
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def visit_report_params
      params.require(:visit_report).permit(:visit_date, :visit_time_from, :visit_time_to,:visit_category, :visit_plan_id, :visit_plan_item_id, :visitable_type, :visitable_id,:follow_up,:prepare_by,:prepare_at,:laboratory_type_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def visit_report_doctor_params
      params.require(:visit_report_doctor).permit(:doctor_id, :doctor_name, :recommendation, :foreign_worker_present, :foreign_worker_present_acceptable, :apc_number,:apc_year,:apc_acceptable, :private_healthcare_registration_number, :private_healthcare_registration_number_acceptable,:written_consent_acceptable, :medical_record_maintenance_acceptable,:communicable_disease_acceptable, :no_communicable_disease,:vacutainer_expiry_date,:vacutainer_acceptable,:adequate_facility_acceptable,:dispatch_record_acceptable,:operating_hour_acceptable,:satisfactory, :non_verify_original_passport_fw_present,:non_verify_original_passport_fw_not_present,:unable_to_produce_apc,:non_notify_communicable_disease,:inadequate_equipment,:insufficient_operation_hour, :inappropriate_vacutainer,:no_produce_dispatch_record,:no_produce_written_consent,:no_produce_medical_record,:closed,:no_produce_borang_b,:other, :type_of_visit,:interacted_with,:number_of_visit_checklist,:other_comment,:unacceptable_fields,:notification_via_notification_form,:notification_via_e_notifikasi,:recommendation_date)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def operating_hour_params
      params.require(:operating_hour).permit(:monday_is_close,:monday_is_24_hour,:monday_start,:monday_end,:monday_break,:tuesday_is_close,:tuesday_is_24_hour,:tuesday_start,:tuesday_end,:tuesday_break,:wednesday_is_close,:wednesday_is_24_hour,:wednesday_start,:wednesday_end,:wednesday_break,:thursday_is_close,:thursday_is_24_hour,:thursday_start,:thursday_end,:thursday_break,:friday_is_close,:friday_is_24_hour,:friday_start,:friday_end,:friday_break,:saturday_is_close,:saturday_is_24_hour,:saturday_start,:saturday_end,:saturday_break,:sunday_is_close,:sunday_is_24_hour,:sunday_start,:sunday_end,:sunday_break,:public_holiday_is_close,:public_holiday_is_24_hour,:public_holiday_start,:public_holiday_end,:public_holiday_break,:close_remark)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def visit_report_laboratory_params
      params.require(:visit_report).require(:visit_report_laboratory_attributes).permit(:visit_report_id, :laboratory_id, :laboratory_name, :address_1, :address_2, :address_3, :address_4, :country_id, :state_id, :town_id, :type_of_visit, :moh_representative, :open_during_operation_hour, :open_during_operation_hour_comment, :adequate_facility, :adequate_facility_comment, :adequate_staff, :adequate_staff_comment, :adequate_instrument, { :adequate_instrument_items => [] }, :adequate_instrument_comment, :despatch_transportation, :transport_to_test_lab, :transport_to_test_lab_comment, :despatch_bag, :despatch_bag_comment, :packaging_to_test_lab, :packaging_to_test_lab_comment, :clinic_to_despatch, :clinic_to_despatch_comment, :despatch_to, :despatch_to_comment, :cc_partial_lab_to_test_lab, :cc_partial_lab_to_test_lab_comment, :collection_centre_to_test_lab, :collection_centre_to_test_lab_name, :collection_centre_to_test_lab_comment, :registration_record, :registration_record_comment, :rejection_register, :rejection_register_comment, :rejection_criteria, :rejection_criteria_comment, :others, :pathologist_name, :pathologist_nsr, :pathologist, :pathologist_comment, :logbook, :logbook_comment, :negative_specimens, :negative_specimens_comment, :positive_specimens, :positive_specimens_comment, :adequate_space, :adequate_space_comment, :appropriate_temperature, :appropriate_temperature_comment, :negative_malaria, :negative_malaria_comment, :quality_check, :quality_check_comment, :checked_before_transcription, :checked_before_transcription_comment, :precaution_taken, :precaution_taken_comment, :records_kept_reg_lab, :records_kept_reg_lab_comment, :records_kept_at_least, :records_kept_at_least_comment, :satisfactory, :satisfactory_comment, :lab_personnel_name, :lab_personnel_designation, :lab_personnel_signature, :fomema_officer_name, :fomema_officer_signature, :created_at, :updated_at, :created_by, :updated_by, :postcode, :category, :traceability_comment)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def visit_report_xray_facility_params
      params.require(:visit_report_xray_facility).permit(:xray_facility_id,:license_holder_name, :type_of_visit, :interacted_with, :radiographer_name, :number_of_visit_checklist, :foreign_worker_present,:foreign_worker_present_acceptable, :apc_number, :apc_year, :apc_acceptable, :private_healthcare_registration_number, :private_healthcare_registration_number_acceptable,:license_serial_number, :license_expiry_date, :license_storing_acceptable, :license_using_acceptable, :xray_license_menstor_acceptable, :xray_license_mengguna_acceptable, :medical_record_maintenance_acceptable, :adequate_facility_acceptable, :dispatch_record_acceptable, :operating_hour_acceptable, :satisfactory, :non_verify_original_passport_fw_present, :non_verify_original_passport_fw_not_present, :unable_to_produce_apc, :no_xray_license_for_mengguna, :inadequate_equipment, :insufficient_operation_hour, :expired_license_menstor_mengguna, :no_produce_medical_record, :closed, :no_produce_borang_b, :other, :other_comment, :recommendation, :dispatch_record_to_xqcc,:unacceptable_fields,:recommendation_date)
    end 

    ## can be remove
    def visit_report_lab_detail_params
      params.require(:visit_report).require(:visit_report_laboratory_attributes).require([:blood_grouping, :malaria_screening]).permit(:report_category)
    end

    def visit_report_doctor_signature_params
      params.require(:visit_report).require(:visit_report_doctor_attributes).permit(:doctor_id,:fomema_officer_signature, :fomema_officer_name, :personnel_signature, :personnel_name, :personnel_designation)
    end 

    def visit_report_xray_facility_signature_params
      params.require(:visit_report).require(:visit_report_xray_facility_attributes).permit(:xray_facility_id,:fomema_officer_signature, :fomema_officer_name, :personnel_signature, :personnel_name, :personnel_designation)
    end 
  end

end
