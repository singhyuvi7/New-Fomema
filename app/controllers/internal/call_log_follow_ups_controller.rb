class Internal::CallLogFollowUpsController < InternalController
    before_action :set_call_log
    before_action :set_call_log_follow_up, only: [:show, :edit, :update, :destroy]

    before_action -> { can_access?("VIEW_FOLLOW_UP_CALL_LOG") }, only: [:index, :show]
    before_action -> { can_access?("CREATE_FOLLOW_UP_CALL_LOG") }, only: [:new, :create]
    before_action -> { can_access?("EDIT_FOLLOW_UP_CALL_LOG") }, only: [:edit, :update]
    before_action -> { can_access?("DELETE_FOLLOW_UP_CALL_LOG") }, only: [:destroy]

    def show
    end

    def new
        data = {
            created_at: Time.now,
            created_by: current_user.id,
        }
        @call_log_follow_up = @call_log.call_log_follow_ups.new(data)
    end

    def create
        @call_log_follow_up = @call_log.call_log_follow_ups.new(call_log_follow_up_params)
  
        respond_to do |format|
            if @call_log_follow_up.save
                format.html { redirect_to internal_call_log_url(@call_log), notice: 'Follow Up was successfully created.' }
                format.json { render :show, status: :ok, location: @call_log }
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
            if @call_log_follow_up.update(call_log_follow_up_params)
                format.html { redirect_to internal_call_log_path(@call_log), notice: 'Follow Up was successfully updated.' }
                format.json { render :show, status: :ok, location: @call_log }
            else
                format.html { render :edit }
                format.json { render json: @call_log_follow_up.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @call_log_follow_up.destroy
        flash[:notice] = "Follow up deleted successfully"
        redirect_to internal_call_log_path(@call_log)
    end
    
    private
    def set_call_log
        @call_log = CallLog.find(params[:call_log_id])
    end

    def set_call_log_follow_up
        @call_log_follow_up = CallLogFollowUp.find(params[:id])
    end

    def call_log_follow_up_params
		params.require(:call_log_follow_up).permit(:comment)
    end
end
