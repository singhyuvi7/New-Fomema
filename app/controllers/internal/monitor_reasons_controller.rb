class Internal::MonitorReasonsController < InternalController
    before_action :set_monitor_reason, only: [:show, :edit, :update, :destroy]

    # GET /monitor_reasons
    # GET /monitor_reasons.json
    def index
        @monitor_reasons = MonitorReason.search_code(params[:code])
        .search_description(params[:description])
        .page(params[:page])
        .per(get_per)
    end

    # GET /monitor_reasons/1
    # GET /monitor_reasons/1.json
    def show
    end

    # GET /monitor_reasons/new
    def new
        @monitor_reason = MonitorReason.new
    end

    # GET /monitor_reasons/1/edit
    def edit
    end

    # POST /monitor_reasons
    # POST /monitor_reasons.json
    def create
        @monitor_reason = MonitorReason.new(monitor_reason_params)

        respond_to do |format|
            if @monitor_reason.save
                format.html { redirect_to internal_monitor_reasons_url, notice: 'Monitor reason was successfully created.' }
                format.json { render :show, status: :created, location: @monitor_reason }
            else
                format.html { render :new }
                format.json { render json: @monitor_reason.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /monitor_reasons/1
    # PATCH/PUT /monitor_reasons/1.json
    def update
        respond_to do |format|
            if @monitor_reason.update(monitor_reason_params)
                format.html { redirect_to internal_monitor_reasons_url, notice: 'Monitor reason was successfully updated.' }
                format.json { render :show, status: :ok, location: @monitor_reason }
            else
                format.html { render :edit }
                format.json { render json: @monitor_reason.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /monitor_reasons/1
    # DELETE /monitor_reasons/1.json
    def destroy
        @monitor_reason.destroy
        respond_to do |format|
            format.html { redirect_to internal_monitor_reasons_url, notice: 'Monitor reason was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_monitor_reason
        @monitor_reason = MonitorReason.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def monitor_reason_params
        params.require(:monitor_reason).permit(:code, :description, :short_description)
    end
end