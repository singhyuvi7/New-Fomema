class Internal::FwChangeEmployersController < InternalController
    before_action -> { can_access?("VIEW_FW_CHANGE_EMPLOYER") }

    before_action :set_fw_change_employer, only: [:show]
    # GET /fw_change_employers
    # GET /fw_change_employers.json
    def index
        if [:worker_code, :worker_name, :gender, :passport_number, :country, :date_of_birth, :status, :search_request_start_date, :search_request_end_date].all? { |sym| params[sym].blank? }
            flash.now[:error] = "Filter criteria needed"
            @fw_change_employers = nil
            render :index and return
        end

        fw_change_employers = FwChangeEmployer.joins("join foreign_workers on foreign_workers.id = fw_change_employers.foreign_worker_id")
        .search_worker_code(params[:worker_code])
        .search_worker_name(params[:worker_name])
        .search_gender(params[:gender])
        .search_passport(params[:passport_number])
        .search_country(params[:country])
        .search_date_of_birth(params[:date_of_birth])
        .search_status(params[:status])
        .search_request_start_date(params[:request_start_date])
        .search_request_end_date(params[:request_end_date])

        @fw_change_employers = fw_change_employers.page(params[:page]).per(get_per)
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