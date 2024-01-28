module Internal
  class BlockReasonsController < InternalController
    before_action :set_block_reason, only: [:show, :edit, :update, :destroy]

    # GET /block_reasons
    # GET /block_reasons.json
    def index
      @block_reasons = BlockReason.search_code(params[:code])
      .search_description(params[:description])
      .search_category(params[:category])
      .page(params[:page])
      .per(get_per)
    end

    # GET /block_reasons/1
    # GET /block_reasons/1.json
    def show
    end

    # GET /block_reasons/new
    def new
      @block_reason = BlockReason.new
    end

    # GET /block_reasons/1/edit
    def edit
    end

    # POST /block_reasons
    # POST /block_reasons.json
    def create
      @block_reason = BlockReason.new(block_reason_params)

      respond_to do |format|
        if @block_reason.save
          format.html { redirect_to internal_block_reasons_url, notice: 'Block reason was successfully created.' }
          format.json { render :show, status: :created, location: @block_reason }
        else
          format.html { render :new }
          format.json { render json: @block_reason.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /block_reasons/1
    # PATCH/PUT /block_reasons/1.json
    def update
      respond_to do |format|
        if @block_reason.update(block_reason_params)
          format.html { redirect_to internal_block_reasons_url, notice: 'Block reason was successfully updated.' }
          format.json { render :show, status: :ok, location: @block_reason }
        else
          format.html { render :edit }
          format.json { render json: @block_reason.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /block_reasons/1
    # DELETE /block_reasons/1.json
    def destroy
      @block_reason.destroy
      respond_to do |format|
        format.html { redirect_to internal_block_reasons_url, notice: 'Block reason was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_block_reason
        @block_reason = BlockReason.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def block_reason_params
        params.require(:block_reason).permit(:category, :code, :description)
      end
  end
end