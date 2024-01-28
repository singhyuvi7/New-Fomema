module Internal
  class StatesController < InternalController
    before_action :set_state, only: [:show, :edit, :update, :destroy, :postcodes]
    skip_before_action :authenticate_internal_user!, only: [:postcodes, :towns]

    # GET /states
    # GET /states.json
    def index
      @states = State.search_code(params[:code])
      .search_name(params[:name])
      .search_long_name(params[:long_name])
      .page(params[:page])
      .per(get_per)
    end

    # GET /states/1
    # GET /states/1.json
    def show
    end

    # GET /states/new
    def new
      @state = State.new
    end

    # GET /states/1/edit
    def edit
    end

    # POST /states
    # POST /states.json
    def create
      @state = State.new(state_params)

      respond_to do |format|
        if @state.save
          format.html { redirect_to internal_states_url, notice: 'State was successfully created.' }
          format.json { render :show, status: :created, location: @state }
        else
          format.html { render :new }
          format.json { render json: @state.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /states/1
    # PATCH/PUT /states/1.json
    def update
      respond_to do |format|
        if @state.update(state_params)
          format.html { redirect_to internal_states_url, notice: 'State was successfully updated.' }
          format.json { render :show, status: :ok, location: @state }
        else
          format.html { render :edit }
          format.json { render json: @state.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /states/1
    # DELETE /states/1.json
    def destroy
      @state.destroy
      respond_to do |format|
        format.html { redirect_to internal_states_url, notice: 'State was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    # GET /states/1/postcodes.json
    def postcodes
      @postcodes = @state.postcodes
      collection_object = params[:collection_object]
      respond_to do |format|
        format.js { render 'internal/shared/postcodes', collection: @postcodes, locals: {collection_object: collection_object} }
        format.json { render :postcodes, status: :ok }
      end
    end

    # GET /states/1/towns.json
    def towns
      # @towns = @state.postcodes
      @towns = Town.where("state_id = #{params[:id]}").order("towns.name").all
      collection_object = params[:collection_object]
      respond_to do |format|
        format.js { render 'internal/shared/towns', collection: @towns, locals: {collection_object: collection_object} }
        format.json { render :towns, status: :ok }
      end
    end

    # GET /states/1,2,3,4/multistatetowns.json
    def multistatetowns
      state_ids = params[:id].split(",")

      @towns = Town.where(state_id: state_ids).includes(:state).order("towns.name").all

      respond_to do |format|
        format.json { render :json => @towns.to_json(:include => :state), status: :ok }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_state
        @state = State.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def state_params
        params.require(:state).permit(:name, :long_name, :code)
      end
  end
end