module Internal
    class RetakeReasonsController < InternalController
      before_action :set_retake_reason, only: [:show, :edit, :update, :destroy]
  
      # GET /retake_reasons
      # GET /retake_reasons.json
      def index
        @retake_reasons = RetakeReason.search_name(params[:name])
        .page(params[:page])
        .per(get_per)
      end
  
      # GET /retake_reasons/1
      # GET /retake_reasons/1.json
      def show
      end
  
      # GET /retake_reasons/new
      def new
        @retake_reason = RetakeReason.new
      end
  
      # GET /retake_reasons/1/edit
      def edit
      end
  
      # POST /retake_reasons
      # POST /retake_reasons.json
      def create
        @retake_reason = RetakeReason.new(retake_reason_params)
  
        respond_to do |format|
          if @retake_reason.save
            format.html { redirect_to internal_retake_reasons_url, notice: 'Retake reason was successfully created.' }
            format.json { render :show, status: :created, location: @retake_reason }
          else
            format.html { render :new }
            format.json { render json: @retake_reason.errors, status: :unprocessable_entity }
          end
        end
      end
  
      # PATCH/PUT /retake_reasons/1
      # PATCH/PUT /retake_reasons/1.json
      def update
        respond_to do |format|
          if @retake_reason.update(retake_reason_params)
            format.html { redirect_to internal_retake_reasons_url, notice: 'Retake reason was successfully updated.' }
            format.json { render :show, status: :ok, location: @retake_reason }
          else
            format.html { render :edit }
            format.json { render json: @retake_reason.errors, status: :unprocessable_entity }
          end
        end
      end
  
      # DELETE /retake_reasons/1
      # DELETE /retake_reasons/1.json
      def destroy
        @retake_reason.destroy
        respond_to do |format|
          format.html { redirect_to internal_retake_reasons_url, notice: 'Retake reason was successfully destroyed.' }
          format.json { head :no_content }
        end
      end
  
      private
        # Use callbacks to share common setup or constraints between actions.
        def set_retake_reason
          @retake_reason = RetakeReason.find(params[:id])
        end
  
        # Never trust parameters from the scary internet, only allow the white list through.
        def retake_reason_params
          params.require(:retake_reason).permit(:name)
        end
    end
  end