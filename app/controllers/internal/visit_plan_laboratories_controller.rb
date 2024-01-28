module Internal
  class VisitPlanLaboratoriesController < VisitPlansController

    before_action -> { can_access?("VIEW_LABORATORY_VISIT_PLAN") }, only: [:index,:show]
    before_action -> { can_access?("CREATE_LABORATORY_VISIT_PLAN") }, only: [:new,:create]
    before_action -> { can_access?("EDIT_LABORATORY_VISIT_PLAN") }, only: [:edit,:update]
    before_action -> { can_access?("DELETE_LABORATORY_VISIT_PLAN") }, only: [:destroy]
    before_action -> { can_access?("APPROVAL_LEVEL_1_LABORATORY_VISIT_PLAN") }, only: [:approval,:approve_report]
    before_action -> { can_access?("APPROVAL_LEVEL_2_LABORATORY_VISIT_PLAN") }, only: [:approval,:approve_report]

    has_scope :code, only: [:search_providers]
    has_scope :state_ids, only: [:search_providers]
    has_scope :town_ids, only: [:search_providers]
    has_scope :provider_name, only: [:search_providers]
    has_scope :postcode, only: [:search_providers]

    # GET /internal/visit_plans/laboratories
    # GET /internal/visit_plans/laboratories.json
    def index
      @visit_plans = apply_scopes(VisitPlan)
                    .visitable_type(Laboratory.to_s)
                    .search_code(params[:code])
                    .search_state(params[:state])
                    .order('id DESC')
                    .page(params[:page])
                    .per(get_per)

      render 'internal/visit_plans/laboratories/index'
    end

    # GET /internal/visit_plans/laboratories/1
    # GET /internal/visit_plans/laboratories/1.json
    def show
      render 'internal/visit_plans/laboratories/edit'
    end

    # GET /internal/visit_plans/laboratories/new
    def new

      @visit_plan = VisitPlan.includes(:visit_plan_states, :visit_plan_towns, :visit_plan_items).new()
      @visit_plan.visitable_type = Laboratory.to_s

      render 'internal/visit_plans/laboratories/new'

    end

    # search providers json, use at form
    def search_providers

      @laboratories = []
      @last_year = Date.current.years_ago(1).strftime('%Y')
      @current_year = Date.current.year

      if params.has_key?(:filter)
        @laboratories = apply_scopes(Laboratory)
                        .search_clinic_name(params[:clinic_name])
                        .search_doctor_code(params[:doctor_code])
                        .search_doctor_name(params[:doctor_name])
                        .search_status(params[:status])
                        .where('laboratories.laboratory_type_id is not null')
      end

      @laboratories = @laboratories.joins('left join visit_report_laboratories on laboratories.id = visit_report_laboratories.laboratory_id AND visit_report_laboratories.id = (SELECT MAX(id) FROM visit_report_laboratories WHERE laboratories.id = visit_report_laboratories.laboratory_id)')
      .select("laboratories.*, 
      visit_report_laboratories.created_at as last_visit_report_date,
      (case when EXTRACT( year from visit_report_laboratories.created_at::date) = #{@current_year} then true else false end) as is_current_year_exist,
      (case when (SELECT count(*) from visit_report_laboratories where laboratory_id = laboratories.id and EXTRACT( year from visit_report_laboratories.created_at::date) = #{@last_year}) > 0 then true else false end) as is_previous_year_exist")

      respond_to do |format|
        format.json { render :json => @laboratories.to_json(:include => [:state, :town ,:doctors]), status: :ok }
      end

    end

    # GET /internal/visit_plans/laboratories/1/edit
    def edit
      render 'internal/visit_plans/laboratories/edit'
    end

    # POST /internal/visit_plans/laboratories
    # POST /internal/visit_plans/laboratories.json
    def create
      processCreate(Laboratory, internal_visit_plans_laboratories_path)
    end

    # PATCH/PUT /internal/visit_plans/laboratories/1
    # PATCH/PUT /internal/visit_plans/laboratories/1.json
    def update
      processUpdate(Laboratory, @visit_plan, internal_visit_plans_laboratories_path)
    end

    # DELETE /internal/visit_plans/laboratories/1
    # DELETE /internal/visit_plans/laboratories/1.json
    def destroy
      processDestroy(@visit_plan, internal_visit_plans_laboratories_path)
    end

    def approval
      @visit_plan_approval = {}
      render 'internal/visit_plans/laboratories/edit'
    end

    def approve_report
      processApprove(@visit_plan_approval, internal_visit_plans_laboratories_path)
    end
  end

end
