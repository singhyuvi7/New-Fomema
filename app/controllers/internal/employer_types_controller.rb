module Internal
  class EmployerTypesController < InternalController
    before_action :set_employer_type, only: [:show, :edit, :update, :destroy]

    # GET /employer_types
    # GET /employer_types.json
    def index
      @employer_types = EmployerType.search_name(params[:name])
      .page(params[:page])
      .per(get_per)
    end

    # GET /employer_types/1
    # GET /employer_types/1.json
    def show
    end

    # GET /employer_types/new
    def new
      @employer_type = EmployerType.new
    end

    # GET /employer_types/1/edit
    def edit
    end

    # POST /employer_types
    # POST /employer_types.json
    def create
      @employer_type = EmployerType.new(employer_type_params)

      respond_to do |format|
        if @employer_type.save
          format.html { redirect_to internal_employer_types_path, notice: 'Employer type was successfully created.' }
          format.json { render :show, status: :created, location: @employer_type }
        else
          format.html { render :new }
          format.json { render json: @employer_type.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /employer_types/1
    # PATCH/PUT /employer_types/1.json
    def update
      respond_to do |format|
        if @employer_type.update(employer_type_params)
          format.html { redirect_to internal_employer_types_path, notice: 'Employer type was successfully updated.' }
          format.json { render :show, status: :ok, location: @employer_type }
        else
          format.html { render :edit }
          format.json { render json: @employer_type.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /employer_types/1
    # DELETE /employer_types/1.json
    def destroy
      @employer_type.destroy
      respond_to do |format|
        format.html { redirect_to internal_employer_types_path, notice: 'Employer type was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_employer_type
        @employer_type = EmployerType.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def employer_type_params
        params.require(:employer_type).permit(:name)
      end
  end
end