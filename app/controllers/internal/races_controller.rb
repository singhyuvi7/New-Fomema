module Internal
    class RacesController < InternalController
        before_action :set_race, only: [:show, :edit, :update, :destroy]
        
        def show
            @races = Race.all
        end 

        # GET /race
        # GET /race.json
        def index
            @races = Race.search_name(params[:name])
            .page(params[:page])
            .per(get_per)
        end

        # GET /races/1
        # GET /races/1.json
        def show
        end
        
        # GET /races/new
        def new
            @race = Race.new
        end

        # POST /races
        # POST /races.json
        def create
            @race = Race.new(race_params)
    
            respond_to do |format|
                if @race.save
                    format.html { redirect_to internal_races_url, notice: 'Race was successfully created.' }
                    format.json { render :show, status: :created, location: @race }
                else
                    format.html { render :new }
                    format.json { render json: @race.errors, status: :unprocessable_entity }
                end
            end
        end
        
        # DELETE /races/1.json
        def destroy
            @race.destroy
            respond_to do |format|
                format.html { redirect_to internal_races_url, notice: 'Race was successfully destroyed.' }
                format.json { head :no_content }
            end
        end

        # GET /races/1/edit
        def edit
        end
        
        # PATCH/PUT /races/1
        # PATCH/PUT /races/1.json
        def update
            respond_to do |format|
                if @race.update(race_params)
                    format.html { redirect_to internal_races_url, notice: 'Race was successfully updated.' }
                    format.json { render :show, status: :ok, location: @race }
                else
                    format.html { render :edit }
                    format.json { render json: @race.errors, status: :unprocessable_entity }
                end
            end
        end
        
        private
        # Use callbacks to share common setup or constraints between actions.
        def set_race
        @race = Race.find(params[:id])
        end
        
        # Never trust parameters from the scary internet, only allow the white list through.
        def race_params
            params.require(:race).permit(:name)
        end
    end
end