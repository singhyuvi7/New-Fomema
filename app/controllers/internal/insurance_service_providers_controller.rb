class Internal::InsuranceServiceProvidersController < InternalController
    before_action :set_insurance_service_provider, only: [:show, :edit, :update, :destroy]

    # GET /insurance_service_providers
    # GET /insurance_service_providers.json
    def index
        @insurance_service_providers = InsuranceServiceProvider.search_code(params[:code])
        .search_name(params[:name])
        .search_display_name(params[:display_name])
        .search_active(params[:active])
        .order(:name)
        .page(params[:page])
        .per(get_per)
    end

    # GET /insurance_service_providers/1
    # GET /insurance_service_providers/1.json
    def show
    end

    # GET /insurance_service_providers/new
    def new
        @insurance_service_provider = InsuranceServiceProvider.new
    end

    # GET /insurance_service_providers/1/edit
    def edit
    end

    # POST /insurance_service_providers
    # POST /insurance_service_providers.json
    def create
        @insurance_service_provider = InsuranceServiceProvider.new(insurance_service_provider_params)

        respond_to do |format|
            if @insurance_service_provider.save
                format.html { redirect_to internal_insurance_service_providers_url, notice: 'Insurance Service Provider was successfully created.' }
                format.json { render :show, status: :created, location: @insurance_service_provider }
            else
                format.html { render :new }
                format.json { render json: @insurance_service_provider.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /insurance_service_providers/1
    # PATCH/PUT /insurance_service_providers/1.json
    def update
        @insurance_service_provider.assign_attributes(insurance_service_provider_params)

        respond_to do |format|
            if @insurance_service_provider.valid?
                @insurance_service_provider.save

                format.html { redirect_to internal_insurance_service_providers_url, notice: 'Insurance Service Provider was successfully updated.' }
                format.json { render :show, status: :ok, location: @insurance_service_provider }
            else
                format.html { render :edit }
                format.json { render json: @insurance_service_provider.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /insurance_service_providers/1
    # DELETE /insurance_service_providers/1.json
    def destroy
        @insurance_service_provider.destroy
        respond_to do |format|
            format.html { redirect_to internal_insurance_service_providers_url, notice: 'Insurance Service Provider was successfully destroyed.' }
            format.json { head :no_content }
        end
    end
private
    # Use callbacks to share common setup or constraints between actions.
    def set_insurance_service_provider
        @insurance_service_provider = InsuranceServiceProvider.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def insurance_service_provider_params
        params.require(:insurance_service_provider).permit(:name, :code, :display_name, :payment_to_code, :active)
    end
end