class Internal::BypassFingerprintReasonsController < InternalController
    before_action :set_bypass_fingerprint_reason, only: [:show, :edit, :update, :destroy]

    before_action -> { can_access?("VIEW_BYPASS_FINGERPRINT_REASON") }, only: [:index, :show]
    before_action -> { can_access?("CREATE_BYPASS_FINGERPRINT_REASON") }, only: [:new, :create]
    before_action -> { can_access?("EDIT_BYPASS_FINGERPRINT_REASON") }, only: [:edit, :update]
    before_action -> { can_access?("DELETE_BYPASS_FINGERPRINT_REASON") }, only: [:destroy]

    # GET /bypass_fingerprint_reasons
    # GET /bypass_fingerprint_reasons.json
    def index
        @bypass_fingerprint_reasons = BypassFingerprintReason.search_code(params[:code])
        .search_description(params[:description])
        .page(params[:page])
        .per(get_per)
    end

    # GET /bypass_fingerprint_reasons/1
    # GET /bypass_fingerprint_reasons/1.json
    def show
    end

    # GET /bypass_fingerprint_reasons/new
    def new
        @bypass_fingerprint_reason = BypassFingerprintReason.new
    end

    # GET /bypass_fingerprint_reasons/1/edit
    def edit
    end

    # POST /bypass_fingerprint_reasons
    # POST /bypass_fingerprint_reasons.json
    def create
        @bypass_fingerprint_reason = BypassFingerprintReason.new(bypass_fingerprint_reason_params)

        respond_to do |format|
            if @bypass_fingerprint_reason.save
                format.html { redirect_to internal_bypass_fingerprint_reasons_url, notice: 'Bypass Fingerprint Reason was successfully created.' }
                format.json { render :show, status: :created, location: @bypass_fingerprint_reason }
            else
                format.html { render :new }
                format.json { render json: @bypass_fingerprint_reason.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /bypass_fingerprint_reasons/1
    # PATCH/PUT /bypass_fingerprint_reasons/1.json
    def update
        respond_to do |format|
            if @bypass_fingerprint_reason.update(bypass_fingerprint_reason_params)
                format.html { redirect_to internal_bypass_fingerprint_reasons_url, notice: 'Bypass Fingerprint Reason was successfully updated.' }
                format.json { render :show, status: :ok, location: @bypass_fingerprint_reason }
            else
                format.html { render :edit }
                format.json { render json: @bypass_fingerprint_reason.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /bypass_fingerprint_reasons/1
    # DELETE /bypass_fingerprint_reasons/1.json
    def destroy
        @bypass_fingerprint_reason.destroy
        respond_to do |format|
            format.html { redirect_to internal_bypass_fingerprint_reasons_url, notice: 'Bypass Fingerprint Reason was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_bypass_fingerprint_reason
        @bypass_fingerprint_reason = BypassFingerprintReason.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bypass_fingerprint_reason_params
        params.require(:bypass_fingerprint_reason).permit(:code, :description)
    end
end