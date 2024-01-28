module Internal
  class LaboratoryTypesController < InternalController
    before_action :set_laboratory_type, only: [:show, :edit, :update, :destroy]

    # GET /laboratory_types
    # GET /laboratory_types.json
    def index
      @laboratory_types = LaboratoryType.search_name(params[:name])
      .page(params[:page])
      .per(get_per)
    end

    # GET /laboratory_types/1
    # GET /laboratory_types/1.json
    def show
    end

    # GET /laboratory_types/new
    def new
      @laboratory_type = LaboratoryType.new
    end

    # GET /laboratory_types/1/edit
    def edit
    end

    # POST /laboratory_types
    # POST /laboratory_types.json
    def create
      @laboratory_type = LaboratoryType.new(laboratory_type_params)

      respond_to do |format|
        if @laboratory_type.save
          format.html { redirect_to internal_laboratory_types_url, notice: 'Laboratory type was successfully created.' }
          format.json { render :show, status: :created, location: @laboratory_type }
        else
          format.html { render :new }
          format.json { render json: @laboratory_type.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /laboratory_types/1
    # PATCH/PUT /laboratory_types/1.json
    def update
      respond_to do |format|
        if @laboratory_type.update(laboratory_type_params)
          format.html { redirect_to internal_laboratory_types_url, notice: 'Laboratory type was successfully updated.' }
          format.json { render :show, status: :ok, location: @laboratory_type }
        else
          format.html { render :edit }
          format.json { render json: @laboratory_type.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /laboratory_types/1
    # DELETE /laboratory_types/1.json
    def destroy
      @laboratory_type.destroy
      respond_to do |format|
        format.html { redirect_to internal_laboratory_types_url, notice: 'Laboratory type was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_laboratory_type
        @laboratory_type = LaboratoryType.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def laboratory_type_params
        params.require(:laboratory_type).permit(:name)
      end
  end
end