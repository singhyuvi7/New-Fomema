class Internal::AuditsController < InternalController
    before_action :set_auditable, only: [:index, :show]
    def index
        query = @auditable.audits
        if !params[:created_at_from].blank?
            query = query.where("audits.created_at >= ?", params[:created_at_from])
            # if params[:created_at_to].blank?
            #     query = query.where("audits.created_at <= ?", params[:created_at_from])
            # end
        end
        if !params[:created_at_to].blank?
            query = query.where("audits.created_at <= ?", "#{params[:created_at_to]} 23:59:59")
        end
        @audits = query.unscope(:order).order(created_at: :desc, id: :desc).page(params[:page]).per(get_per)

        view_file = "internal/#{@auditable.class.name.downcase.pluralize}/audits/index"
        if template_exists?(view_file)
            render view_file and return
        end
    end

    def show
        @audit = @auditable.audits.find(params[:id])
        @revision = @auditable.revision(@audit.version)
        @revision_previous = @auditable.revision(@audit.version - 1) if @audit.version > 1
        @audit_previous = @audit.previous_audit if @audit.version > 1

        view_file = "internal/#{@auditable.class.name.underscore.pluralize}/audits/show"
        if template_exists?(view_file)
            render view_file and return
        end
    end

    private
    def set_auditable
        @module_title = nil

        if params.key?("doctor_id")
            @auditable = Doctor.find(params[:doctor_id])
            @auditables_link = internal_doctors_path
            @module_title = "Doctor - #{@auditable.name} (#{@auditable.code || 'N/A'})"

        elsif params.key?("laboratory_id")
            @auditable = Laboratory.find(params[:laboratory_id])
            @auditables_link = internal_laboratories_path
            @module_title = "Laboratory - #{@auditable.name} (#{@auditable.code || 'N/A'})"

        elsif params.key?("xray_facility_id")
            @auditable = XrayFacility.find(params[:xray_facility_id])
            @auditables_link = internal_xray_facilities_path
            @module_title = "X-Ray Facility - #{@auditable.name} (#{@auditable.code || 'N/A'})"

        elsif params.key?("radiologist_id")
            @auditable = Radiologist.find(params[:radiologist_id])
            @auditables_link = internal_radiologists_path
            @module_title = "Radiologist - #{@auditable.name} (#{@auditable.code || 'N/A'})"

        elsif params.key?("employer_worker_id")
            @auditable = ForeignWorker.find(params[:employer_worker_id])
            @auditables_link = internal_employer_employer_workers_path(@auditable.employer)
            @module_title = "Foreign Worker - #{@auditable.name} (#{@auditable.code || 'N/A'})"

        elsif params.key?("employer_id")
            @auditable = Employer.find(params[:employer_id])
            @auditables_link = internal_employers_path
            @module_title = "Employer - #{@auditable.name} (#{@auditable.code || 'N/A'})"

        elsif params.key?("transaction_id")
            @auditable = Transaction.find(params[:transaction_id])
            @auditables_link = internal_transactions_path
            @module_title = "Transaction - (#{@auditable.code || 'N/A'})"

        elsif params.key?("service_provider_group_id")
            @auditable = ServiceProviderGroup.find(params[:service_provider_group_id])
            @auditables_link = internal_service_provider_groups_path
            @module_title = "Service Provider Group - (#{@auditable.code || 'N/A'})"

        else
            paths = request.original_fullpath.split("/")
            if paths.count > 2 
                if paths[1].singularize.camelcase.safe_constantize
                    @auditable = paths[1].singularize.camelcase.safe_constantize.find(paths[2])
                elsif paths[1] == "user_setups"
                    @auditable = User.find(paths[2])
                end
            end
            
        end
    end
end