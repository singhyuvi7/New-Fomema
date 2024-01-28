module InspectorateMasterList
    extend ActiveSupport::Concern

    included do
        before_action :set_batch, only: [:view_master_list, :edit_master_list, :update_master_list]
        before_action :set_item, only: [:edit_master_list, :update_master_list]
    end

    def new_master_list
        respond_to do |format|
            format.html { render 'internal/reports/inspectorate/master_list/new' }
        end
    end

    def create_master_list
        start_date = params[:start_date].to_date.beginning_of_day
        end_date = params[:end_date].to_date.end_of_day
        
        @visit_reports = VisitReport.where(:status => 'LEVEL_2_APPROVED').where.not(:visitable_type => 'Laboratory')
        .where('visit_date BETWEEN ? AND ?', start_date, end_date)
        
        if @visit_reports.blank?
            flash[:error] = "No data in the date range selected"
            redirect_to (request.env["HTTP_REFERER"] || new_master_list_internal_inspectorate_reports_path) and return
        end
        
        @insp_master_list_batch = InspMasterListBatch.create({
            start_date: start_date,
            end_date: end_date
        })
        
        if !@visit_reports.blank?
            @visit_reports.each do |visit_report|
                service_provider = visit_report.visitable

                case visit_report.visitable_type
                when 'Doctor'
                    clinic_name = service_provider&.clinic_name
                    doctor_name = service_provider&.name
                    sop_compliance = visit_report&.visit_report_doctor&.sop_compliance
                when 'XrayFacility'
                    clinic_name = service_provider&.name
                    doctor_name = service_provider&.license_holder_name
                    sop_compliance = visit_report&.visit_report_xray_facility&.sop_compliance
                else
                    clinic_name = ''
                    doctor_name = ''
                    sop_compliance = ''
                end
            
                inspected_by = visit_report.visit_report_visitors&.pluck(:name)
              
                InspMasterList.create({
                    insp_master_list_batch_id: @insp_master_list_batch.id,
                    visit_date: visit_report.visit_date,
                    name_of_clinic: clinic_name,
                    sp_code:service_provider&.code,
                    name_of_doctor: doctor_name,
                    location:service_provider&.town&.name, 
                    state: service_provider&.state&.name, 
                    inspected_by: inspected_by.join(', '), 
                    visit_report_id: visit_report.code, 
                    nc: sop_compliance, 
                    letter_ref: sop_compliance == 'S' ? 'Satisfactory' : visit_report.explanation_letter_reference, 
                    letter_date: sop_compliance == 'S' ? '' : visit_report.explanation_letter_date.try('strftime','%d-%m-%Y'), 
                    report_date: visit_report&.prepare_at&.strftime('%d-%m-%Y'), 
                    report_by: visit_report&.prepare_user&.name
                })
            end
        end

        respond_to do |format|
            format.html { redirect_to view_master_list_internal_inspectorate_reports_path(@insp_master_list_batch) }
        end
    end

    def view_master_list
        @insp_master_lists = apply_scopes(InspMasterList)
        .where(:insp_master_list_batch_id => @batch&.id)
        .search_visit_report_code(params[:visit_report_code])
        .order('visit_date ASC')

        respond_to do |format|
            format.html { render 'internal/reports/inspectorate/master_list/items/view' }
            format.xlsx do
                render xlsx: 'index', filename: "Master List - CLINIC & X-RAY - #{@batch.start_date.strftime('%d%m%Y')} to #{@batch.end_date.strftime('%d%m%Y')}.xlsx",
                       template: 'internal/reports/inspectorate/master_list/items/index'
            end
        end
    end

    def edit_master_list
        @item = InspMasterList.find(params[:item_id])
        respond_to do |format|
            format.html { render 'internal/reports/inspectorate/master_list/items/edit' }
        end
    end

    def update_master_list
        @item.assign_attributes(item_params)

        respond_to do |format|
            if @item.save
                flash[:notice] = "Data has been updated"
                format.html { redirect_to view_master_list_internal_inspectorate_reports_path(@batch) }
            else
                format.html { render 'internal/reports/inspectorate/master_list/items/edit' }
            end
        end
    end

private
    def set_batch
        @batch = InspMasterListBatch.find(params[:id])
    end
    
    def set_item
        @item = InspMasterList.find(params[:item_id])
    end

    def item_params
        params.require(:insp_master_list).permit(:serial_no, :repeated_offence, :date_of_faxed, :follow_up_date, :reminder_letter, :reply_date, :present_in_meeting, :remarks)
    end
end