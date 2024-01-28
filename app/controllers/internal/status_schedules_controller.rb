class Internal::StatusSchedulesController < InternalController
    before_action :set_status_schedule, only: [:show, :edit, :update, :destroy]

    # GET /status_schedules
    # GET /status_schedules.json
    def index
        query = StatusSchedule.includes(:status_scheduleable, :creator).search_status_scheduleable_type(params[:status_scheduleable_type])
        .search_from(params[:from])
        .search_to(params[:to])
        .search_status(params[:status])
        .search_created_by(params[:created_by])
        if !params[:status_scheduleable_code].blank?
            query = query.joins("join #{params[:status_scheduleable_type].underscore.pluralize} on #{params[:status_scheduleable_type].underscore.pluralize}.id = status_schedules.status_scheduleable_id").where("#{params[:status_scheduleable_type].underscore.pluralize}.code = ?", params[:status_scheduleable_code])
        end
        @status_schedules = query.order(from: :desc)
        .page(params[:page])
        .per(get_per)
    end

    # GET /status_schedules/1
    # GET /status_schedules/1.json
    def show
    end

    # GET /status_schedules/new
    def new
        @statuses = {}
        @status_reasons = {}
        @status_scheduleable_code = params[:status_scheduleable_code]
        data = {
            status_scheduleable_type: params[:status_scheduleable_type],
            from: Time.now
        }
        if params.key?(:status_scheduleable_type)
            @statuses = params[:status_scheduleable_type].constantize::STATUSES || {}
            if @status_scheduleable_code
                status_scheduleable = params[:status_scheduleable_type].constantize.find_by(code: @status_scheduleable_code)
                if status_scheduleable
                    max_to = status_scheduleable.status_schedules.maximum("to")
                    if max_to
                        data[:from] = max_to + 1.days
                    end
                end
            end
        end
        @status_schedule = StatusSchedule.new(data)
    end

    # POST /status_schedules
    # POST /status_schedules.json
    def create
        @statuses = status_schedule_params[:status_scheduleable_type].constantize::STATUSES || {}
        @status_reasons = status_schedule_params[:status_scheduleable_type].constantize::STATUS_REASONS[status_schedule_params[:status]] || {}
        @status_scheduleable_code = params[:status_scheduleable_code]

        @status_scheduleable = status_schedule_params[:status_scheduleable_type].constantize.find_by(code: @status_scheduleable_code)
        @status_schedule = StatusSchedule.new(status_schedule_params.merge({
            status_scheduleable_id: @status_scheduleable&.id
        }))
        
        if !@status_scheduleable
            @status_schedule.errors.add(:base, "Service Provider Code is invalid")
            render :new and return
        end

        @status_schedule.valid?
        if @status_schedule.errors.count > 0
            render :new and return
        end

        respond_to do |format|
            if @status_schedule.save
                if (
                    (@status_schedule.from == Date.tomorrow and Time.now.hour >= 23) or (@status_schedule.from <= Date.today and (@status_schedule.to.blank? or @status_schedule.to >= Date.today))
                )
                    @status_schedule.update({
                        previous_status: @status_schedule.status_scheduleable.status,
                        previous_status_reason: @status_schedule.status_scheduleable.status_reason,
                        previous_comment: @status_schedule.status_scheduleable.status_comment
                    })
                    @status_schedule.status_scheduleable.update({
                        status: @status_schedule.status,
                        status_reason: @status_schedule.status_reason,
                        status_comment: @status_schedule.comment
                    })
                end

                format.html { redirect_to internal_status_schedules_path(status_scheduleable_type: status_schedule_params[:status_scheduleable_type], status_scheduleable_code: params[:status_scheduleable_code]), notice: 'Status schedule was successfully created.' }
                format.json { render :show, status: :created, location: @status_schedule }
            else
                format.html { render :new }
                format.json { render json: @status_schedule.errors, status: :unprocessable_entity }
            end
        end
    end

    # GET /status_schedules/1/edit
    def edit
        @statuses = @status_schedule.status_scheduleable_type.constantize::STATUSES || {}
        @status_reasons = @status_schedule.status_scheduleable_type.constantize::STATUS_REASONS[@status_schedule.status] || {}
        @status_scheduleable_code = @status_schedule.status_scheduleable&.code
    end

    # PATCH/PUT /status_schedules/1
    # PATCH/PUT /status_schedules/1.json
    def update
        @statuses = @status_schedule.status_scheduleable_type.constantize::STATUSES || {}
        @status_reasons = @status_schedule.status_scheduleable_type.constantize::STATUS_REASONS[@status_schedule.status] || {}
        @status_scheduleable_code = @status_schedule.status_scheduleable&.code

        @status_schedule.assign_attributes(status_schedule_params)

        respond_to do |format|
            if @status_schedule.save
                # update status
                if status_schedule_params[:from].try(:to_date) < Date.today && (status_schedule_params[:to].empty? || status_schedule_params[:to].try(:to_date) >= Date.today)
                    @status_schedule.update({
                        previous_status: @status_schedule.status_scheduleable.status,
                        previous_status_reason: @status_schedule.status_scheduleable.status_reason,
                        previous_comment: @status_schedule.status_scheduleable.status_comment
                    })
                    @status_schedule.status_scheduleable.update({
                        status: @status_schedule.status,
                        status_reason: @status_schedule.status_reason,
                        status_comment: @status_schedule.comment
                    })
                end
                # end
                format.html { redirect_to internal_status_schedules_path, notice: 'Status schedule was successfully updated.' }
                format.json { render :show, status: :ok, location: @status_schedule }
            else
                format.html { render :edit }
                format.json { render json: @status_schedule.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /status_schedules/1
    # DELETE /status_schedules/1.json
    def destroy
        @status_schedule.destroy
        respond_to do |format|
            format.html { redirect_to internal_status_schedules_url, notice: 'Status schedule was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def scheduleable_statuses
        @statuses = params[:type].constantize::STATUSES
    end

    def scheduleable_status_reasons
        @status_reasons = params[:type].constantize::STATUS_REASONS[params[:status]]
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_status_schedule
        @status_schedule = StatusSchedule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def status_schedule_params
        params.require(:status_schedule).permit(:status_scheduleable_type, :status_scheduleable_id, :from, :to, :status, :status_reason, :comment)
    end
end
