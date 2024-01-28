module InspectorateVisitPlanRequest
    extend ActiveSupport::Concern

    included do
        before_action :set_visit_plan_request, only: [:show_visit_plan_request, :edit_visit_plan_request, :update_visit_plan_request]
    end

    def show_visit_plan_request
        respond_to do |format|
            format.html { render 'internal/reports/inspectorate/visit_plan_request/show' }
        end
    end

    def new_visit_plan_request
        @visit_plan_request = VisitPlanRequest.new()
        respond_to do |format|
            format.html { render 'internal/reports/inspectorate/visit_plan_request/new' }
        end
    end

    def create_visit_plan_request
        @visit_plan_request = VisitPlanRequest.new(visit_plan_request_params)

        spable_type = params[:visit_plan_request][:spable_type]

        if spable_type.blank? || params[:sp_code].blank?
            @visit_plan_request.assign_attributes({
                spable_id: '',
                spable_type: ''
            })
        else
            case spable_type
            when 'Doctor'
                spable_id = Doctor.find_by_code(params[:sp_code])&.id
            when 'XrayFacility'
                spable_id = XrayFacility.find_by_code(params[:sp_code])&.id
            else
                spable_id = nil
            end

            if !spable_id.blank?
                @visit_plan_request.assign_attributes({
                    spable_id: spable_id,
                    spable_type: spable_type
                })
            end
        end

        respond_to do |format|
            if @visit_plan_request.save!
                flash[:notice] = 'New visit plan request created'
                format.html { redirect_to visit_plan_request_internal_inspectorate_reports_path }
            else
                format.html { render 'internal/reports/inspectorate/visit_plan_request/new' }
            end
        end
    end

    def edit_visit_plan_request
        respond_to do |format|
            format.html { render 'internal/reports/inspectorate/visit_plan_request/edit' }
        end
    end

    def update_visit_plan_request
        @visit_plan_request.assign_attributes(visit_plan_request_params)

        spable_type = params[:visit_plan_request][:spable_type]

        if spable_type.blank? || params[:sp_code].blank?
            @visit_plan_request.assign_attributes({
                spable_id: '',
                spable_type: ''
            })
        else
            case spable_type
            when 'Doctor'
                spable_id = Doctor.find_by_code(params[:sp_code])&.id
            when 'XrayFacility'
                spable_id = XrayFacility.find_by_code(params[:sp_code])&.id
            else
                spable_id = nil
            end

            if !spable_id.blank?
                @visit_plan_request.assign_attributes({
                    spable_id: spable_id,
                    spable_type: spable_type
                })
            end
        end

        respond_to do |format|
            if @visit_plan_request.save!
                flash[:notice] = 'Visit plan request has been updated'
                format.html { redirect_to visit_plan_request_internal_inspectorate_reports_path }
            else
                format.html { render 'internal/reports/inspectorate/visit_plan_request/edit' }
            end
        end
    end

    def delete_visit_plan_request
    end

    def search_service_provider
        sp_type = params[:sp_type]
        sp_code = params[:sp_code]

        if !sp_type.blank? && !sp_code.blank?
            case sp_type
            when 'Doctor'
                service_provider = Doctor.where(:code => sp_code)
                .select('doctors.code, doctors.name as pic_name, clinic_name, address1, address2, address3, address4, state_id, town_id, postcode').first
            when 'XrayFacility'
                service_provider = XrayFacility.where(:code => sp_code)
                .select('xray_facilities.code, xray_facilities.name as clinic_name, license_holder_name as pic_name, address1, address2, address3, address4, state_id, town_id, postcode').first
            end

            if service_provider.blank?
                @data = {
                    error: true,
                    message: "Service provider code '#{sp_code}' under service provider type '#{sp_type}' could not be found",
                    data: []
                }
            else
                @data = {
                    error: false,
                    message: "Service provider found",
                    data: service_provider
                }
            end
        else
            @data = {
                error: true,
                message: 'Please select service provider type and enter the service provider code before search',
                data: []
            }
        end

        render json: @data
    end

private
    def set_visit_plan_request
        @visit_plan_request = VisitPlanRequest.find(params[:id])
    end

    def visit_plan_request_params
        params.require(:visit_plan_request).permit(:date_of_request, :is_urgent, :date_of_presentation, :date_of_visit, :satisfactory, :report_by, :insp_type_of_visit, :mspd_type_of_visit, :spable_id, :spable_type, :registered_person, :facility_name, :address1, :address2, :address3, :address4, :state_id, :town_id, :postcode, :prepared_by, :date_of_meeting)
    end
end