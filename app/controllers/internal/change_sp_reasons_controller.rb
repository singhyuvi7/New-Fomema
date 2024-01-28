class Internal::ChangeSpReasonsController < InternalController
    before_action :set_change_sp_reason, only: [:show, :edit, :update, :destroy]

    # GET /change_sp_reasons
    # GET /change_sp_reasons.json
    def index
        @change_sp_reasons = ChangeSpReason.search_code(params[:code])
        .search_description(params[:description])
        .page(params[:page])
        .per(get_per)
    end

    # GET /change_sp_reasons/1
    # GET /change_sp_reasons/1.json
    def show
    end

    # GET /change_sp_reasons/new
    def new
        @change_sp_reason = ChangeSpReason.new
    end

    # GET /change_sp_reasons/1/edit
    def edit
    end

    # POST /change_sp_reasons
    # POST /change_sp_reasons.json
    def create
        @change_sp_reason = ChangeSpReason.new(change_sp_reason_params)

        respond_to do |format|
            if @change_sp_reason.save
                format.html { redirect_to internal_change_sp_reasons_url, notice: 'Change SP reason was successfully created.' }
                format.json { render :show, status: :created, location: @change_sp_reason }
            else
                format.html { render :new }
                format.json { render json: @change_sp_reason.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /change_sp_reasons/1
    # PATCH/PUT /change_sp_reasons/1.json
    def update
        respond_to do |format|
            if @change_sp_reason.update(change_sp_reason_params)
                format.html { redirect_to internal_change_sp_reasons_url, notice: 'Change SP reason was successfully updated.' }
                format.json { render :show, status: :ok, location: @change_sp_reason }
            else
                format.html { render :edit }
                format.json { render json: @change_sp_reason.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /change_sp_reasons/1
    # DELETE /change_sp_reasons/1.json
    def destroy
        @change_sp_reason.destroy
        respond_to do |format|
            format.html { redirect_to internal_change_sp_reasons_url, notice: 'Change SP reason was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_change_sp_reason
        @change_sp_reason = ChangeSpReason.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def change_sp_reason_params
        params.require(:change_sp_reason).permit(:code, :description)
    end
end