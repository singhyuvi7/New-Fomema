class Internal::DistrictHealthOfficesController < InternalController
    before_action :set_district_health_office, only: [:show, :edit, :update, :destroy]

    # GET /district_health_offices
    # GET /district_health_offices.json
    def index
        @district_health_offices = DistrictHealthOffice.search_name(params[:name])
        .search_code(params[:code])
        .page(params[:page])
        .per(get_per)
    end

    # GET /district_health_offices/1
    # GET /district_health_offices/1.json
    def show
    end

    # GET /district_health_offices/new
    def new
        @district_health_office = DistrictHealthOffice.new
    end

    # GET /district_health_offices/1/edit
    def edit
    end

    # POST /district_health_offices
    # POST /district_health_offices.json
    def create
        @district_health_office = DistrictHealthOffice.new(district_health_office_params)

        respond_to do |format|
            if @district_health_office.save
                format.html { redirect_to internal_district_health_offices_path, notice: 'District Health Office was successfully created.' }
                format.json { render :show, status: :created, location: @district_health_office }
            else
                format.html { render :new }
                format.json { render json: @district_health_office.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /district_health_offices/1
    # PATCH/PUT /district_health_offices/1.json
    def update
        respond_to do |format|
            if @district_health_office.update(district_health_office_params)
                format.html { redirect_to internal_district_health_offices_path, notice: 'DistrictHealthOffice was successfully updated.' }
                format.json { render :show, status: :ok, location: @district_health_office }
            else
                format.html { render :edit }
                format.json { render json: @district_health_office.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /district_health_offices/1
    # DELETE /district_health_offices/1.json
    def destroy
        @district_health_office.destroy
        respond_to do |format|
            format.html { redirect_to internal_district_health_offices_path, notice: 'DistrictHealthOffice was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_district_health_office
        @district_health_office = DistrictHealthOffice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def district_health_office_params
        params.require(:district_health_office).permit(:code, :name, :email, :address1, :address2, :address3, :address4, :postcode, :phone, :fax, :pic_name, :pic_phone, :state_id, :postcode, :town_id, :status)
    end
end