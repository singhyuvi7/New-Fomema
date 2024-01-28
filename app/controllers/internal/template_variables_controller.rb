class Internal::TemplateVariablesController < InternalController
    before_action :set_template_variable, only: [:show,:edit,:update]

    def index
        @template_variables = TemplateVariable.search_name(params[:name])
        .page(params[:page])
        .per(get_per)
    end

    def show
    end

    def edit
    end

    def update
        respond_to do |format|
            if @template_variable.update(template_variable_params)
                format.html { redirect_to internal_template_variables_path, notice: "#{@template_variable.name} was successfully updated." }
                format.json { render :show, status: :ok, location: @template_variable }
            else
                format.html { render :edit }
                format.json { render json: @template_variable.errors, status: :unprocessable_entity }
            end
        end
    end


    private
    # Use callbacks to share common setup or constraints between actions.
    def set_template_variable
        @template_variable = TemplateVariable.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_variable_params
        params.require(:template_variable).permit(:value)
    end
end