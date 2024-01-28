module Internal
  class XrayStoragesController < InternalController
    before_action :set_xray_storage, only: [:new, :show, :edit, :update, :destroy]

    # GET /xray_storages
    # GET /xray_storages.json
    def index
      @xray_storages = XrayStorage.search_code(params[:code])
      .page(params[:page])
      .per(get_per)
    end

    # GET /xray_storages/1
    # GET /xray_storages/1.json
    def show
    end

    # GET /xray_storages/new
    def new
      @xray_storage = XrayStorage.new
      @xray_storage.xray_storage_items.build    ##for nested association

      @ctrl_disabled = false

      # assign new storage code based on last storage code
    end

    # GET /xray_storages/1/edit
    def edit
      @xray_storage.xray_storage_items.build if @xray_storage.xray_storage_items.blank?
      @transactions = @xray_storage.transactions
    end

    # POST /xray_storages
    # POST /xray_storages.json
    def create
      @xray_storage = XrayStorage.new(xray_storage_params)
      respond_to do |format|
        if @xray_storage.save!
          @xray_storage.sync_xray_storage_categories(params["xray_storage"]["categories"])
          format.html { redirect_to internal_xray_storages_url, notice: 'Xray Storage was successfully created.' }
          format.json { render :show, status: :created, location: @xray_storage }
        else
          format.html { render :new }
          format.json { render json: @xray_storage.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /xray_storages/1
    # PATCH/PUT /xray_storages/1.json
    def update
      respond_to do |format|
        if @xray_storage.update(xray_storage_params)
          @xray_storage.sync_xray_storage_categories(params["xray_storage"]["categories"])
          format.html { redirect_to internal_xray_storages_url, notice: 'Xray Storage was successfully updated.' }
          format.json { render :show, status: :ok, location: @xray_storage }
        else
          format.html { render :edit }
          format.json { render json: @xray_storage.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /xray_storages/1
    # DELETE /xray_storages/1.json
    def destroy
      @xray_storage.xray_storage_items.destroy_all  ##for nested association
      @xray_storage.destroy
      respond_to do |format|
        format.html { redirect_to internal_xray_storages_url, notice: 'Xray Storage was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_xray_storage
        @action = params[:action]
        if(@action != "new")
          @xray_storage = XrayStorage.find(params[:id])
        end
      end
      # Never trust parameters from the scary internet, only allow the white list through.
      def xray_storage_params
        params.require(:xray_storage).permit(:code, :batch_number, :organization_id, :category, :status, :disposal_date, xray_storage_items_attributes: [:id, :xray_storage_id, :_destroy, :transaction_id])
      end

  end
end
