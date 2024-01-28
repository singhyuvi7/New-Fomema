class Internal::DigitalXrayProvidersController < InternalController
    before_action :set_digital_xray_provider, only: [:show, :edit, :update, :destroy, :states]

    # GET /digital_xray_providers
    # GET /digital_xray_providers.json
    def index
        @digital_xray_providers = DigitalXrayProvider.search_code(params[:code])
        .search_name(params[:name])
        .page(params[:page])
        .per(get_per)
    end

    # GET /digital_xray_providers/1
    # GET /digital_xray_providers/1.json
    def show
    end

    # GET /digital_xray_providers/new
    def new
        @digital_xray_provider = DigitalXrayProvider.new
    end

    # GET /digital_xray_providers/1/edit
    def edit
    end

    # POST /digital_xray_providers
    # POST /digital_xray_providers.json
    def create
        @digital_xray_provider = DigitalXrayProvider.new(digital_xray_provider_params)

        if !params[:digital_xray_provider][:passphrase].blank?
            if params[:digital_xray_provider][:passphrase] != params[:digital_xray_provider][:passphrase_confirmation]
                @digital_xray_provider.errors.add(:passphrase, "do not tally")
                render :edit and return
            end
        end

        if !params[:digital_xray_provider][:passphrase].blank?
            @digital_xray_provider.assign_attributes({
                passphrase: DigitalXrayProvider.encrypt_passphrase(params[:digital_xray_provider][:passphrase])
            })
        end

        respond_to do |format|
            if @digital_xray_provider.save
                format.html { redirect_to internal_digital_xray_providers_url, notice: 'Digital X-Ray Provider was successfully created.' }
                format.json { render :show, status: :created, location: @digital_xray_provider }
            else
                format.html { render :new }
                format.json { render json: @digital_xray_provider.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /digital_xray_providers/1
    # PATCH/PUT /digital_xray_providers/1.json
    def update
        @digital_xray_provider.assign_attributes(digital_xray_provider_params)

        if !params[:digital_xray_provider][:passphrase].blank?
            if params[:digital_xray_provider][:passphrase] != params[:digital_xray_provider][:passphrase_confirmation]
                @digital_xray_provider.errors.add(:passphrase, "do not tally")
                render :edit and return
            end
        end

        respond_to do |format|
            if @digital_xray_provider.valid?

                if !params[:digital_xray_provider][:passphrase].blank?
                    @digital_xray_provider.assign_attributes({
                        passphrase: DigitalXrayProvider.encrypt_passphrase(params[:digital_xray_provider][:passphrase])
                    })
                end

                @digital_xray_provider.save

                format.html { redirect_to internal_digital_xray_providers_url, notice: 'Digital X-Ray Provider was successfully updated.' }
                format.json { render :show, status: :ok, location: @digital_xray_provider }
            else
                format.html { render :edit }
                format.json { render json: @digital_xray_provider.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /digital_xray_providers/1
    # DELETE /digital_xray_providers/1.json
    def destroy
        @digital_xray_provider.destroy
        respond_to do |format|
            format.html { redirect_to internal_digital_xray_providers_url, notice: 'Digital X-Ray Provider was successfully destroyed.' }
            format.json { head :no_content }
        end
    end
private
    # Use callbacks to share common setup or constraints between actions.
    def set_digital_xray_provider
        @digital_xray_provider = DigitalXrayProvider.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def digital_xray_provider_params
        params.require(:digital_xray_provider).permit(:name, :code, :provider_url)
    end
end