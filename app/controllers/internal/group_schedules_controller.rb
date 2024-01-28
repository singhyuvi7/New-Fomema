class Internal::GroupSchedulesController < InternalController
    before_action -> { can_access?("VIEW_GROUP_SCHEDULE") }, only: [:index,:show]
    before_action -> { can_access?("CREATE_GROUP_SCHEDULE") }, only: [:new,:create]
    before_action -> { can_access?("EDIT_GROUP_SCHEDULE") }, only: [:edit,:update]
    before_action -> { can_access?("DELETE_GROUP_SCHEDULE") }, only: [:destroy]

    before_action :set_group_schedule, only: [:show, :edit, :update, :destroy]
    before_action :check_service_provider, only: [:create]
    before_action :check_duplicate_schedule, only: [:create, :update]

    def index
        query = SpGroupSchedule.search_sp_schedulable_type(params[:sp_schedulable_type])
        .search_service_provider_group(params[:service_provider_group])
        if !params[:sp_schedulable_code].blank?
            query = query.joins("join #{params[:sp_schedulable_type].underscore.pluralize} on #{params[:sp_schedulable_type].underscore.pluralize}.id = sp_group_schedules.sp_schedulable_id").where("#{params[:sp_schedulable_type].underscore.pluralize}.code = ?", params[:sp_schedulable_code])
        end
        @group_schedules = query.page(params[:page])
        .per(get_per)

    end
    
    def show
        @groups = ServiceProviderGroup.all
        @sp_schedulable_code = @group_schedule.sp_schedulable&.code
    end

    def new 
        @groups = {}
        @sp_schedulable_code = params[:sp_schedulable_code]
        @group_schedule = SpGroupSchedule.new
        @group_schedule.sp_schedulable_type = params[:sp_schedulable_type]
    end

    def create
        @groups = {}
        @sp_schedulable_code = params[:sp_schedulable_code]
        
        @group_schedule = SpGroupSchedule.new(group_schedule_params.merge({
            sp_schedulable_id: @service_provider&.id
        }))

        # get existing schedules on the selected date
        existingSchedule = SpGroupSchedule.where(:sp_schedulable_id => @group_schedule.sp_schedulable_id, :sp_schedulable_type => @group_schedule.sp_schedulable_type).where('DATE(scheduled_date) = ?', @group_schedule.scheduled_date.strftime('%F')).first
        # end

        if existingSchedule
            if @group_schedule.scheduled_date.strftime('%F') != Date.today.strftime('%F')
                @group_schedule.errors.add(:base, "The selected date already has an assigned group scheduled. Please select another date or cancel the previous schedule in order to schedule a new one")
            end
        end

        # check no existing group but leave group
        if @service_provider&.service_provider_group_id.blank? && @group_schedule.service_provider_group_id.blank?
            @group_schedule.errors.add(:base, "Can't leave group when service provider is not tie to any group.")
        end
        # end 

        if @group_schedule.errors.count > 0
            render :new and return
        end

        if @group_schedule.scheduled_date.strftime('%F') == Date.today.strftime('%F')
            # update group history table
            history = SpGroupHistory.new
            history.service_providable_id = @group_schedule.sp_schedulable_id
            history.service_providable_type = @group_schedule.sp_schedulable_type
            history.service_provider_group_id = @group_schedule.service_provider_group_id
            today = Date.today
            if @group_schedule.service_provider_group_id
                history.join_date = today
                history.save
            else
                existing_history = SpGroupHistory.where(:service_providable_id => @group_schedule.sp_schedulable_id, :service_providable_type => @group_schedule.sp_schedulable_type).order("created_at").last
                if existing_history.present?
                    existing_history.update({
                        exit_date: today
                    })
                else
                    # get previous group id from sp table
                    history.service_provider_group_id = @service_provider.service_provider_group_id
                    history.exit_date = today
                    history.save
                end
            end

            @service_provider.update({
                service_provider_group_id: @group_schedule.service_provider_group_id
            })
            # end update
        end

        respond_to do |format|
            if @group_schedule.save
                format.html { redirect_to internal_group_schedules_path, notice: 'Service Provider Group Schedule Was Successfully Created.' }
                format.json { render :show, status: :created, location: @group_schedule }
            else
                format.html { render :new }
                format.json { render json: @group_schedule.errors, status: :unprocessable_entity }
            end
        end
    end

    def edit
        @groups = ServiceProviderGroup.all
        @sp_schedulable_code = @group_schedule.sp_schedulable&.code
    end

    def update
        # get existing schedules on the selected date
        existingSchedule = SpGroupSchedule.where(:sp_schedulable_id => @group_schedule.sp_schedulable_id, :sp_schedulable_type => @group_schedule.sp_schedulable_type).where('DATE(scheduled_date) = ?', params[:sp_group_schedule][:scheduled_date]).where.not(:id => @group_schedule.id).first
        # end

        if existingSchedule
            if params[:sp_group_schedule][:scheduled_date] != Date.today.strftime('%F')
                flash[:error] = "The selected date already has an assigned group scheduled. Please select another date or cancel the previous schedule in order to schedule a new one"
                redirect_to (request.env["HTTP_REFERER"] || internal_root_path) and return
            end
        end

        # check no existing group but leave group
        if @group_schedule.sp_schedulable&.service_provider_group_id.blank? && params[:sp_group_schedule][:service_provider_group_id].blank?
            flash[:error] = "Can't leave group when service provider is not tie to any group."
            redirect_to (request.env["HTTP_REFERER"] || internal_root_path) and return
        end
        # end 

        respond_to do |format|
            if @group_schedule.update(group_schedule_params)
                format.html { redirect_to internal_group_schedules_path, notice: 'Group schedule was successfully updated.' }
                format.json { render :show, status: :ok, location: @group_schedule }
            else
                format.html { render :edit }
                format.json { render json: @group_schedule.errors, status: :unprocessable_entity }
            end
        end
    end

    def schedulable_groups
        @groups = ServiceProviderGroup.where("service_provider_groups.category = ? AND service_provider_groups.status = ? AND payment_method_id is not null AND male_rate > 0 AND female_rate > 0", params[:type], 'ACTIVE').all
        render json: @groups
    end

    def destroy
        @group_schedule.destroy
        respond_to do |format|
          format.html { redirect_to internal_group_schedules_path, notice: 'Scheduler was successfully destroyed.' }
          format.json { head :no_content }
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_schedule
        @group_schedule = SpGroupSchedule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_schedule_params
        params.require(:sp_group_schedule).permit(:sp_schedulable_type, :sp_schedulable_id, :scheduled_date, :service_provider_group_id)
    end

    def check_service_provider
        @service_provider = params[:sp_group_schedule][:sp_schedulable_type].constantize.find_by(code: params[:sp_schedulable_code])

        if !@service_provider
            flash[:error] = "Service Provider Code is invalid"
            redirect_to (request.env["HTTP_REFERER"] || internal_root_path) and return
        end
    end

    def check_duplicate_schedule
        if params[:action] == 'create'
            service_provider_id = @service_provider&.id
            sp_schedulable_type = params[:sp_group_schedule][:sp_schedulable_type]
        else
            service_provider_id = params[:sp_group_schedule][:sp_schedulable_id]
            sp_schedulable_type = @group_schedule.sp_schedulable_type
        end

        duplicate_schedule = SpGroupSchedule.where(:sp_schedulable_id => service_provider_id, :sp_schedulable_type => sp_schedulable_type, :service_provider_group_id => params[:sp_group_schedule][:service_provider_group_id]).where('scheduled_date > ?', DateTime.now)

        if params[:action] == 'update'
            duplicate_schedule = duplicate_schedule.where.not(:id => @group_schedule.id)
        end

        if !duplicate_schedule.blank?
            flash[:error] = "Duplicate Group Schedule"
            redirect_to (request.env["HTTP_REFERER"] || internal_root_path) and return
        end
    end
end
