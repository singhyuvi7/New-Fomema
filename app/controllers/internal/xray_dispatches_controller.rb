class Internal::XrayDispatchesController < InternalController
    before_action :set_xray_dispatch, only: [:new, :show, :edit, :update, :destroy]

    # GET /xray_dispatches
    # GET /xray_dispatches.json
    def index
        @xray_dispatches = XrayDispatch.search_code(params[:code])
        .search_xray_facility_id(params[:xray_facility_id])
        .page(params[:page])
        .per(get_per)

        #@transaction = Transaction.search_code(params[:code])
    end

    # GET /xray_dispatches/1
    # GET /xray_dispatches/1.json
    def show
        @xray_dispatch.xray_dispatch_items.build if @xray_dispatch.xray_dispatch_items.blank?
        @transactions = @xray_dispatch.transactions
        @ctrl_disabled = true
    end

    # GET /xray_dispatches/new
    def new
        @xray_dispatch = XrayDispatch.new
        @xray_dispatch.xray_dispatch_items.build    ##for nested association

        @ctrl_disabled = false

        # assign new dispatch code based on last dispatch code
    end

    # GET /xray_dispatches/1/edit
    def edit
        @xray_dispatch.xray_dispatch_items.build if @xray_dispatch.xray_dispatch_items.blank?
        @transactions = @xray_dispatch.transactions
    end

    # POST /xray_dispatches
    # POST /xray_dispatches.json
    def create
        @xray_dispatch = XrayDispatch.new(xray_dispatch_params)
        respond_to do |format|
            if @xray_dispatch.save!
                cnt = @xray_dispatch.xray_dispatch_items.count
                @xray_dispatch.update({
                    film_count: cnt,
                    received_count: cnt,
                })
                format.html { redirect_to internal_xray_dispatches_url, notice: 'X-Ray Dispatch was successfully created.' }
                format.json { render :show, status: :created, location: @xray_dispatch }
            else
                format.html { render :new }
                format.json { render json: @xray_dispatch.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /xray_dispatches/1
    # PATCH/PUT /xray_dispatches/1.json
    def update
        respond_to do |format|
            if @xray_dispatch.update(xray_dispatch_params)
                cnt = @xray_dispatch.xray_dispatch_items.count
                @xray_dispatch.update({
                    film_count: cnt,
                    received_count: cnt,
                }) 
                format.html { redirect_to internal_xray_dispatches_url, notice: 'X-Ray Dispatch was successfully updated.' }
                format.json { render :show, status: :ok, location: @xray_dispatch }
            else
                format.html { render :edit }
                format.json { render json: @xray_dispatch.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /xray_dispatches/1
    # DELETE /xray_dispatches/1.json
    def destroy
        @xray_dispatch.xray_dispatch_items.destroy_all  ##for nested association
        @xray_dispatch.destroy
        
        respond_to do |format|
            format.html { redirect_to internal_xray_dispatches_url, notice: 'X-Ray Dispatch was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def each
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_xray_dispatch
        @action = params[:action]
        if(@action != "new")
            @xray_dispatch = XrayDispatch.find(params[:id])
        end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def xray_dispatch_params
        params.require(:xray_dispatch).permit(:code, :xray_facility_id, :film_count, :received_count, :sent_date, :received_date, xray_dispatch_items_attributes: [:id, :xray_dispatch_id, :_destroy, :transaction_id])
    end

end
