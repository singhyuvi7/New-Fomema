module Internal
  class AmendmentReasonsController < InternalController
    before_action :set_amendment_reason, only: [:show, :edit, :update, :destroy]

    before_action -> { can_access?("VIEW_AMENDMENT_REASON") }, only: [:index, :show]
    before_action -> { can_access?("CREATE_AMENDMENT_REASON") }, only: [:new, :create]
    before_action -> { can_access?("EDIT_AMENDMENT_REASON") }, only: [:edit, :update]
    before_action -> { can_access?("DELETE_AMENDMENT_REASON") }, only: [:destroy]

    # GET /amendment_reasons
    # GET /amendment_reasons.json
    def index
      @amendment_reasons = AmendmentReason.search_code(params[:code])
     .search_description(params[:name])
     .page(params[:page])
     .per(get_per)
    end

    # GET /amendment_reasons/1
    # GET /amendment_reasons/1.json
    def show
    end

    # GET /amendment_reasons/new
    def new
      @amendment_reason = AmendmentReason.new
    end

    # GET /amendment_reasons/1/edit
    def edit
    end

    # POST /amendment_reasons
    # POST /amendment_reasons.json
    def create
      @amendment_reason = AmendmentReason.new(amendment_reason_params)

      respond_to do |format|
        if @amendment_reason.save
          format.html { redirect_to internal_amendment_reasons_url, notice: 'Amendment reason was successfully created.' }
          format.json { render :show, status: :created, location: @amendment_reason }
        else
          format.html { render :new }
          format.json { render json: @amendment_reason.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /amendment_reasons/1
    # PATCH/PUT /amendment_reasons/1.json
    def update
      respond_to do |format|
        if @amendment_reason.update(amendment_reason_params)
          format.html { redirect_to internal_amendment_reasons_url, notice: 'Amendment reason was successfully updated.' }
          format.json { render :show, status: :ok, location: @amendment_reason }
        else
          format.html { render :edit }
          format.json { render json: @amendment_reason.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /amendment_reasons/1
    # DELETE /amendment_reasons/1.json
    def destroy
      @amendment_reason.destroy
      respond_to do |format|
        format.html { redirect_to internal_amendment_reasons_url, notice: 'Amendment reason was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_amendment_reason
        @amendment_reason = AmendmentReason.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def amendment_reason_params
        params.require(:amendment_reason).permit(:code, :name)
      end
  end
end