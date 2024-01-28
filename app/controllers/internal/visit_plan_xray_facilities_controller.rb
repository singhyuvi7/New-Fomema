module Internal
  class VisitPlanXrayFacilitiesController < VisitPlansController

    before_action -> { can_access?("VIEW_XRAY_FACILITY_VISIT_PLAN") }, only: [:index,:show]
    before_action -> { can_access?("CREATE_XRAY_FACILITY_VISIT_PLAN") }, only: [:new,:create]
    before_action -> { can_access?("EDIT_XRAY_FACILITY_VISIT_PLAN") }, only: [:edit,:update]
    before_action -> { can_access?("DELETE_XRAY_FACILITY_VISIT_PLAN") }, only: [:destroy]
    before_action -> { can_access?("APPROVAL_LEVEL_1_XRAY_FACILITY_VISIT_PLAN") }, only: [:approval,:approve_report]
    before_action -> { can_access?("APPROVAL_LEVEL_2_XRAY_FACILITY_VISIT_PLAN") }, only: [:approval,:approve_report]

    has_scope :code, only: [:search_providers]
    has_scope :state_ids, only: [:search_providers]
    has_scope :town_ids, only: [:search_providers]
    has_scope :provider_name, only: [:search_providers]
    has_scope :postcode, only: [:search_providers]


    # GET /internal/visit_plans/xray_facilities
    # GET /internal/visit_plans/xray_facilities.json
    def index
      @visit_plans = apply_scopes(VisitPlan)
                    .visitable_type(XrayFacility.to_s)
                    .search_code(params[:code])
                    .search_state(params[:state])
                    .order('id DESC')
                    .page(params[:page])
                    .per(get_per)

      render 'internal/visit_plans/xray_facilities/index'
    end

    # GET /internal/visit_plans/xray_facilities/1
    # GET /internal/visit_plans/xray_facilities/1.json
    def show
      render 'internal/visit_plans/xray_facilities/edit'
    end

    # GET /internal/visit_plans/xray_facilities/new
    def new

      @visit_plan = VisitPlan.includes(:visit_plan_states, :visit_plan_towns, :visit_plan_items).new
      @visit_plan.visitable_type = XrayFacility.to_s

      render 'internal/visit_plans/xray_facilities/new'

    end

    # search providers json, use at form
    def search_providers

      @xray_facilities = []
      @last_year = Date.current.years_ago(1).strftime('%Y')
      @current_year = Date.current.year

      if params.has_key?(:filter)
        @xray_facilities = apply_scopes(XrayFacility)
                          .search_clinic_name(params[:clinic_name])
                          .search_doctor_code(params[:doctor_code])
                          .search_doctor_name(params[:doctor_name])
                          .search_status(params[:status]).all
      end

      @xray_facilities = @xray_facilities.joins('left join visit_report_xray_facilities on xray_facilities.id = visit_report_xray_facilities.xray_facility_id AND visit_report_xray_facilities.id = (SELECT MAX(id) FROM visit_report_xray_facilities WHERE xray_facilities.id = visit_report_xray_facilities.xray_facility_id)')
      .select("xray_facilities.*,
      satisfactory,
      non_verify_original_passport_fw_present,
      non_verify_original_passport_fw_not_present,
      unable_to_produce_apc,
      no_xray_license_for_mengguna,
      inadequate_equipment,
      insufficient_operation_hour,
      expired_license_menstor_mengguna,
      no_produce_medical_record,
      closed,
      no_produce_borang_b,
      other,
      dispatch_record_to_xqcc,
      visit_report_xray_facilities.created_at as last_visit_report_date,
      (case when EXTRACT( year from visit_report_xray_facilities.created_at::date) = #{@current_year} then true else false end) as is_current_year_exist,
      (case when (SELECT count(*) from visit_report_xray_facilities where xray_facility_id = visit_report_xray_facilities.id and EXTRACT( year from visit_report_xray_facilities.created_at::date) = #{@last_year}) > 0 then true else false end) as is_previous_year_exist,
      (SELECT count(*) FROM transactions WHERE xray_facility_id = xray_facilities.id and status not in ('CANCELLED','REJECTED') and EXTRACT( year from transaction_date::date) = #{@last_year} ) as allocations_last_year,
      (SELECT count(*) FROM transactions WHERE xray_facility_id = xray_facilities.id and status not in ('CANCELLED','REJECTED') and EXTRACT( year from transaction_date::date) = #{@current_year} ) as allocations_current_year,
      (SELECT count(*) FROM transactions WHERE xray_facility_id = xray_facilities.id and medical_examination_date is not null and EXTRACT( year from transaction_date::date) = #{@last_year} ) as examined_last_year,
      (SELECT count(*) FROM transactions WHERE xray_facility_id = xray_facilities.id and medical_examination_date is not null and EXTRACT( year from transaction_date::date) = #{@current_year} ) as examined_current_year")

      respond_to do |format|
        format.json { render :json => @xray_facilities.to_json(:include => [:state, :town,:doctors]), status: :ok }
      end

    end

    # GET /internal/visit_plans/xray_facilities/1/edit
    def edit
      render 'internal/visit_plans/xray_facilities/edit'
    end

    # POST /internal/visit_plans/xray_facilities
    # POST /internal/visit_plans/xray_facilities.json
    def create
      processCreate(XrayFacility, internal_visit_plans_xray_facilities_path)
    end

    # PATCH/PUT /internal/visit_plans/xray_facilities/1
    # PATCH/PUT /internal/visit_plans/xray_facilities/1.json
    def update
      processUpdate(XrayFacility, @visit_plan, internal_visit_plans_xray_facilities_path)
    end

    # DELETE /internal/visit_plans/xray_facilities/1
    # DELETE /internal/visit_plans/xray_facilities/1.json
    def destroy
      processDestroy(@visit_plan, internal_visit_plans_xray_facilities_path)
    end

    def approval
      @visit_plan_approval = {}
      render 'internal/visit_plans/xray_facilities/edit'
    end

    def approve_report
      processApprove(@visit_plan_approval, internal_visit_plans_xray_facilities_path)
    end
  end

end
