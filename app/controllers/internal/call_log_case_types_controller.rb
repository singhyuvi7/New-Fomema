class Internal::CallLogCaseTypesController < InternalController
    before_action :set_call_log_case_type, only: [:show, :edit, :update, :destroy, :states]

    # GET /call_log_case_types
    # GET /call_log_case_types.json
    def index
        @call_log_case_types = CallLogCaseType.search_code(params[:code])
        .search_description(params[:description])
        .page(params[:page])
        .per(get_per)
    end

    # GET /call_log_case_types/1
    # GET /call_log_case_types/1.json
    def show
    end

    # GET /call_log_case_types/new
    def new
        @call_log_case_type = CallLogCaseType.new
    end

    # GET /call_log_case_types/1/edit
    def edit
    end

    # POST /call_log_case_types
    # POST /call_log_case_types.json
    def create
        @call_log_case_type = CallLogCaseType.new(call_log_case_type_params)

        respond_to do |format|
            if @call_log_case_type.save
                format.html { redirect_to internal_call_log_case_types_url, notice: 'Call Log Case Type was successfully created.' }
                format.json { render :show, status: :created, location: @call_log_case_type }
            else
                format.html { render :new }
                format.json { render json: @call_log_case_type.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /call_log_case_types/1
    # PATCH/PUT /call_log_case_types/1.json
    def update
        respond_to do |format|
            if @call_log_case_type.update(call_log_case_type_params)
                format.html { redirect_to internal_call_log_case_types_url, notice: 'Call Log Case Type was successfully updated.' }
                format.json { render :show, status: :ok, location: @call_log_case_type }
            else
                format.html { render :edit }
                format.json { render json: @call_log_case_type.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /call_log_case_types/1
    # DELETE /call_log_case_types/1.json
    def destroy
        @call_log_case_type.destroy
        respond_to do |format|
            format.html { redirect_to internal_call_log_case_types_url, notice: 'Call Log Case Type was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_call_log_case_type
        @call_log_case_type = CallLogCaseType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def call_log_case_type_params
        params.require(:call_log_case_type).permit(:code, :description)
    end
end