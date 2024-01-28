class External::FwChangeEmployersController < ExternalController
    include ProfileInfoCheck
    include AgencySopAcknowledgeCheck

    before_action -> { can_access?("VIEW_FW_CHANGE_EMPLOYER") }

    before_action :set_fw_change_employer, only: [:show]
    before_action -> { pending_profile_update?(Employer.find_by(id: current_user.userable_id)) }, if: -> { current_user.userable_type == 'Employer' }, only: [ :index]
    before_action -> { agency_sop_acknowledge_check?(Agency.find_by(id: current_user.userable_id)) }, if: -> { current_user.userable_type == 'Agency' }, only: [ :index]

    # GET /fw_change_employers
    # GET /fw_change_employers.json
    def index
        query = FwChangeEmployer.joins("join foreign_workers on foreign_workers.id = fw_change_employers.foreign_worker_id")
        .search_fixed_worker_name(params[:worker_name])
        .search_fixed_passport(params[:passport_number])
        .search_status(params[:status])
        .search_request_start_date(params[:request_start_date])
        .search_request_end_date(params[:request_end_date])
        .order(created_at: :desc)

        query = query.where(requested_by: current_user.id)

        @fw_change_employers = query.page(params[:page]).per(get_per)
    end

    # GET /fw_change_employers/1
    # GET /fw_change_employers/1.json
    def show
    end

    # GET /fw_change_employers/new
    def new
    end

    # POST /fw_change_employers
    # POST /fw_change_employers.json
    def create
    end

    # GET /fw_change_employers/1/edit
    def edit
    end

    # PATCH/PUT /fw_change_employers/1
    # PATCH/PUT /fw_change_employers/1.json
    def update
    end

    # DELETE /fw_change_employers/1
    # DELETE /fw_change_employers/1.json
    def destroy
    end

    private
    def set_fw_change_employer
        @fw_change_employer = FwChangeEmployer.find(params[:id])
    end
end
# /class