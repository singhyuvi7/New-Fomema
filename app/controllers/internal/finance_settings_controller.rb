class Internal::FinanceSettingsController < InternalController
    before_action :set_finance_setting, only: [:show, :edit, :update, :destroy]

    has_scope :code
    has_scope :category
    has_scope :description
    has_scope :value

    def index
        @finance_settings = apply_scopes(FinanceSetting)
        .page(params[:page])
        .per(get_per)

        # .search_code(params[:code])
        # .search_category(params[:category])
        # .search_description(params[:description])
    end

    def show
    end

    def new
        @finance_setting = FinanceSetting.new
    end

    def create
        @finance_setting = FinanceSetting.new(finance_setting_params)

        respond_to do |format|
            if @finance_setting.save
                format.html { redirect_to internal_finance_settings_path, notice: "Setting #{@finance_setting.code} was successfully created." }
                format.json { render :show, status: :created, location: @finance_setting }
            else
                format.html { render :new }
                format.json { render json: @finance_setting.errors, status: :unprocessable_entity }
            end
        end
    end

    def edit
    end

    def update
        respond_to do |format|
            if @finance_setting.update(finance_setting_params)
            format.html { redirect_to internal_finance_settings_path, notice: 'Setting was successfully updated.' }
            format.json { render :show, status: :ok, location: @finance_setting }
            else
            format.html { render :edit }
            format.json { render json: @finance_setting.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @finance_setting.destroy
        respond_to do |format|
            format.html { redirect_to internal_finance_settings_path, notice: 'Setting was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

private
    def set_finance_setting
        @finance_setting = FinanceSetting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def finance_setting_params
        params.require(:finance_setting).permit(:category, :code, :description, :value)
    end
end