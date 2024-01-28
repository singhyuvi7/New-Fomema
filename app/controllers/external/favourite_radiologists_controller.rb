class External::FavouriteRadiologistsController < ExternalController
    before_action :set_favourite_radiologist, only: [:show, :edit, :update, :destroy]

    # GET /favourite_radiologists
    # GET /favourite_radiologists.json
    def index
        @favourite_radiologists = FavouriteRadiologist.where(xray_facility_id: current_user.userable_id).page(params[:page])
        .per(get_per)
    end

    # GET /favourite_radiologists/1
    # GET /favourite_radiologists/1.json
    def show
    end

    # GET /favourite_radiologists/new
    def new
        # @favourite_radiologist = @xray_facility.favourite_radiologists.new
        @radiologists = Radiologist.where(status: "ACTIVE")
            .search_name(params[:name])
            .search_code(params[:code])
            .where("not exists (select 1 from favourite_radiologists where xray_facility_id = ? and radiologist_id = radiologists.id)", current_user.userable_id)
            .page(params[:page])
            .per(get_per)
    end

    # GET /favourite_radiologists/1/edit
    def edit
    end

    # POST /favourite_radiologists
    # POST /favourite_radiologists.json
    def create

        params[:radiologist_ids].each do |radiologist_id|
            current_user.userable.favourite_radiologists.create({
                radiologist_id: radiologist_id
            })
        end

        flash[:notice] = "Favourite radiologist added";
        redirect_to external_favourite_radiologists_path and return
    end

    # PATCH/PUT /favourite_radiologists/1
    # PATCH/PUT /favourite_radiologists/1.json
    def update
        respond_to do |format|
            if @favourite_radiologist.update(favourite_radiologist_params)
            format.html { redirect_to external_xray_facility_favourite_radiologists_url, notice: 'Favourite radiologist was successfully updated.' }
            format.json { render :show, status: :ok, location: @favourite_radiologist }
            else
            format.html { render :edit }
            format.json { render json: @favourite_radiologist.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /favourite_radiologists/1
    # DELETE /favourite_radiologists/1.json
    def destroy
    end

    def bulk_action
        if !params.has_key?(:favourite_radiologist_ids)
            redirect_to external_favourite_radiologists_path, flash: {notic: "Please select a radiologist"} and return
        end

        case params[:bulk_action]
        when 'destroy1'
            bulk_destroy
        end
        redirect_to external_favourite_radiologists_url
    end

    def bulk_destroy
        errs = []
        FavouriteRadiologist.where("id in (?) and xray_facility_id = ?", params[:favourite_radiologist_ids], current_user.userable_id).destroy_all
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    # def set_xray_facility
    #     @xray_facility = XrayFacility.find(params[:xray_facility_id])
    # end

    def set_favourite_radiologist
        @favourite_radiologist = FavouriteRadiologist.find_by(id: params[:id])
        @favourite_radiologist = FavouriteRadiologist.where({
            id: params[:id],
            xray_facility_id: current_user.userable_id,
        })
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def favourite_radiologist_params
        params.permit(:state, :town, :xray_facility_id, :radiologist_id)
    end
end