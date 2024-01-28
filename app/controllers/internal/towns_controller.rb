module Internal
  class TownsController < InternalController
    before_action :set_town, only: [:show, :edit, :update, :destroy, :states]

    # GET /towns
    # GET /towns.json
    def index
      @towns = Town.search_code(params[:code])
      .search_name(params[:name])
      .search_state(params[:state_id])
      .page(params[:page])
      .per(get_per)
    end

    # GET /towns/1
    # GET /towns/1.json
    def show
    end

    # GET /towns/new
    def new
      @town = Town.new
    end

    # GET /towns/1/edit
    def edit
    end

    # POST /towns
    # POST /towns.json
    def create
      @town = Town.new(town_params)

      respond_to do |format|
        if @town.save
          format.html { redirect_to internal_towns_url, notice: 'Town was successfully created.' }
          format.json { render :show, status: :created, location: @town }
        else
          format.html { render :new }
          format.json { render json: @town.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /towns/1
    # PATCH/PUT /towns/1.json
    def update
      respond_to do |format|
        if @town.update(town_params)
          format.html { redirect_to internal_towns_url, notice: 'Town was successfully updated.' }
          format.json { render :show, status: :ok, location: @town }
        else
          format.html { render :edit }
          format.json { render json: @town.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /towns/1
    # DELETE /towns/1.json
    def destroy
      @town.destroy
      respond_to do |format|
        format.html { redirect_to internal_towns_url, notice: 'Town was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
    
    def towns
      @towns = @town.towns
      respond_to do |format|
        format.js { render 'internal/shared/towns', collection: @towns }
        format.json { render :towns, status: :ok }
      end
    end

    # GET /towns/1/clinics.json
    def clinics

      @clinics = Clinic.where("town_id = #{params[:id]}").order("clinics.name").all

      respond_to do |format|
        format.json { render json: @clinics, status: :ok }
      end

    end

    # GET /towns/1/radiologists.json
    def radiologists

      @radiologists = Radiologist.where("town_id = #{params[:id]}").order("radiologists.name").all

      respond_to do |format|
        format.json { render json: @radiologists, status: :ok }
      end

    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_town
      @town = Town.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def town_params
      params.require(:town).permit(:code, :name, :state_id, :postcode)
    end
  end
end
