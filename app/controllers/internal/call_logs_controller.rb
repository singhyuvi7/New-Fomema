class Internal::CallLogsController < InternalController
    before_action :set_call_log, only: [:show, :edit, :update, :destroy]
    before_action :set_options, only: [:new, :edit]

    before_action -> { can_access?("VIEW_CALL_LOG") }, only: [:index, :show]
    before_action -> { can_access?("CREATE_CALL_LOG") }, only: [:new, :create]
    before_action -> { can_access?("EDIT_CALL_LOG") }, only: [:edit, :update]
    before_action -> { can_access?("DELETE_CALL_LOG") }, only: [:destroy]

    def index
        @call_logs = CallLog.search_id(params[:call_log_id])
        .search_callable_type(params[:callable_type])
        .search_call_date_from(params[:start_date])
        .search_call_date_to(params[:end_date])
        
        if !params[:callable_type].blank?
            @call_logs = @call_logs.search_callable_code(params[:callable_type].constantize, params[:callable_code])
            @call_logs = @call_logs.search_callable_name(params[:callable_type].constantize, params[:callable_name])
        end
        
        @call_logs = @call_logs.page(params[:page])
        .per(get_per)
    end

    def show
    end

    def new
        data = {
            callable_type: "XrayFacility",
            created_by: current_user.id,
            called_at: Time.now,
            status: "OPEN"
        }
        @call_log = CallLog.new(data)
    end

    def create
        @call_log = CallLog.new(call_log_params)
  
        respond_to do |format|
          if @call_log.save
            format.html { redirect_to internal_call_logs_url, notice: 'Call Log was successfully created.' }
            format.json { render :show, status: :created, location: @call_log }
          else
            format.html { render :new }
            format.json { render json: @call_log.errors, status: :unprocessable_entity }
          end
        end
    end

    def edit
    end

    def update
        respond_to do |format|
            if @call_log.update(call_log_params)
                format.html { redirect_to internal_call_logs_path, notice: 'Call Log was successfully updated.' }
                format.json { render :show, status: :ok, location: @call_log }
            else
                format.html { render :edit }
                format.json { render json: @call_log.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @call_log.destroy
        flash[:notice] = "Call Log was successfully deleted."
        redirect_to internal_call_logs_path
    end

    def search_callable
        @callables = params[:callable_type].constantize
        .search_code(params[:code])
        .search_name(params[:name])
    end

    private
    def set_call_log
        @call_log = CallLog.find(params[:id])
    end

    def set_options
        @creators = User.select("id, name").where("exists (select 1 from role_permissions rp where rp.role_id = users.role_id and rp.permission = ?) or exists (select 1 from user_permissions up where up.user_id = users.id and up.permission = ?)", "CREATE_CALL_LOG", "CREATE_CALL_LOG")

        @call_log_case_types = CallLogCaseType.select("id, description").order(:description)
    end

	def call_log_params
		params.require(:call_log).permit(:callable_type, :callable_id, :called_at, :phone, :discussant_name, :fax, :email, :issue, :comment, :status, :created_by, :call_log_case_type_id)
	end
end
