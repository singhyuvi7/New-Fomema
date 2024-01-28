module Internal
  class ClinicsController < InternalController
    before_action :set_clinic, only: [:show, :edit, :update, :destroy]

    # GET /clinics
    # GET /clinics.json
    def index
      @clinics = Clinic.search_code(params[:code])
      .search_name(params[:name])
      .page(params[:page])
      .per(get_per)
    end

    # GET /clinics/1
    # GET /clinics/1.json
    def show
    end

    # GET /clinics/new
    def new
      @clinic = Clinic.new
    end

    # GET /clinics/1/edit
    def edit
    end

    # POST /clinics
    # POST /clinics.json
    def create
      @clinic = Clinic.new(clinic_params)

      respond_to do |format|
        if @clinic.save
          format.html { redirect_to internal_clinics_path, notice: 'Clinic was successfully created.' }
          format.json { render :show, status: :created, location: @clinic }
        else
          format.html { render :new }
          format.json { render json: @clinic.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /clinics/1
    # PATCH/PUT /clinics/1.json
    def update
      respond_to do |format|
        if @clinic.update(clinic_params)
          format.html { redirect_to internal_clinics_path, notice: 'Clinic was successfully updated.' }
          format.json { render :show, status: :ok, location: @clinic }
        else
          format.html { render :edit }
          format.json { render json: @clinic.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /clinics/1
    # DELETE /clinics/1.json
    def destroy
      @clinic.destroy
      respond_to do |format|
        format.html { redirect_to internal_clinics_url, notice: 'Clinic was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_clinic
        @clinic = Clinic.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def clinic_params
        params.require(:clinic).permit(:name, :address, :phone, :country_id, :state_id, :area_id, :status)
      end
  end
end