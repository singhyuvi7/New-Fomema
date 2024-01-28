module Internal

  class VisitPlanClinicsController < VisitPlansController

    before_action -> { can_access?("VIEW_DOCTOR_VISIT_PLAN") }, only: [:index,:show]
    before_action -> { can_access?("CREATE_DOCTOR_VISIT_PLAN") }, only: [:new,:create]
    before_action -> { can_access?("EDIT_DOCTOR_VISIT_PLAN") }, only: [:edit,:update]
    before_action -> { can_access?("DELETE_DOCTOR_VISIT_PLAN") }, only: [:destroy]
    before_action -> { can_access?("APPROVAL_LEVEL_1_DOCTOR_VISIT_PLAN") }, only: [:approval,:approve_report]
    before_action -> { can_access?("APPROVAL_LEVEL_2_DOCTOR_VISIT_PLAN") }, only: [:approval,:approve_report]

    has_scope :code, only: [:search_providers]
    has_scope :state_ids, only: [:search_providers]
    has_scope :town_ids, only: [:search_providers]
    has_scope :provider_name, only: [:search_providers]
    has_scope :keyword, only: [:search_providers]
    has_scope :postcode, only: [:search_providers]

    # GET /internal/visit_plans/clinics
    # GET /internal/visit_plans/clinics.json
    def index    
      service_provider = Doctor.to_s
      @visit_plans = apply_scopes(VisitPlan)
                    .visitable_type(service_provider)
                    .search_code(params[:code])
                    .search_state(params[:state])
                    .order('id DESC')
                    .page(params[:page])
                    .per(get_per)

      render 'internal/visit_plans/clinics/index'
    end

    # GET /internal/visit_plans/clinics/1
    # GET /internal/visit_plans/clinics/1.json
    def show
      render 'internal/visit_plans/clinics/edit'
    end

    # GET /internal/visit_plans/clinics/new
    def new

      @visit_plan = VisitPlan.includes(:visit_plan_states, :visit_plan_towns, :visit_plan_items).new
      @visit_plan.visitable_type = Doctor.to_s

      render 'internal/visit_plans/clinics/new'

    end

    # view listing of providers
    def providers

      @doctors = []

      if params.has_key?(:filter)
        @doctors = apply_scopes(Doctor).all
      end

      render 'internal/visit_plans/clinics/providers'

    end

    # search providers json, use at form
    def search_providers

      @doctors = []
      @last_year = Date.current.years_ago(1).strftime('%Y')
      @current_year = Date.current.year

      if params.has_key?(:filter)
        @doctors = apply_scopes(Doctor)
                    .search_clinic_name(params[:clinic_name])
                    .search_status(params[:status])
      end

      @doctors = @doctors.joins('left join visit_report_doctors on doctors.id = visit_report_doctors.doctor_id AND visit_report_doctors.id = (SELECT MAX(id) FROM visit_report_doctors WHERE doctors.id = visit_report_doctors.doctor_id)')
      .select("doctors.*,
      satisfactory,
      non_verify_original_passport_fw_present,
      non_verify_original_passport_fw_not_present,
      unable_to_produce_apc,
      non_notify_communicable_disease,
      inadequate_equipment,
      insufficient_operation_hour,
      inappropriate_vacutainer,
      no_produce_dispatch_record,
      no_produce_written_consent,
      no_produce_medical_record,
      closed,
      no_produce_borang_b,
      other,
      visit_report_doctors.created_at as last_visit_report_date, 
      (case when EXTRACT( year from visit_report_doctors.created_at::date) = #{@current_year} then true else false end) as is_current_year_exist,
      (case when (SELECT count(*) from visit_report_doctors where doctor_id = doctors.id and EXTRACT( year from visit_report_doctors.created_at::date) = #{@last_year}) > 0 then true else false end) as is_previous_year_exist, 
      (SELECT count(*) FROM transactions WHERE doctor_id = doctors.id and status not in ('CANCELLED','REJECTED') and EXTRACT( year from transaction_date::date) = #{@last_year} ) as allocations_last_year,
      (SELECT count(*) FROM transactions WHERE doctor_id = doctors.id and status not in ('CANCELLED','REJECTED') and EXTRACT( year from transaction_date::date) = #{@current_year} ) as allocations_current_year,
      (SELECT count(*) FROM transactions WHERE doctor_id = doctors.id and medical_examination_date is not null and EXTRACT( year from transaction_date::date) = #{@last_year} ) as examined_last_year,
      (SELECT count(*) FROM transactions WHERE doctor_id = doctors.id and medical_examination_date is not null and EXTRACT( year from transaction_date::date) = #{@current_year} ) as examined_current_year,
      (SELECT count(*) FROM transactions WHERE doctor_id = doctors.id and certification_date is not null and EXTRACT( year from transaction_date::date) = #{@last_year} ) as certification_last_year,
      (SELECT count(*) FROM transactions WHERE doctor_id = doctors.id and certification_date is not null and EXTRACT( year from transaction_date::date) = #{@current_year} ) as certification_current_year")

      respond_to do |format|
        format.json { render :json => @doctors.to_json(:include => [:state, :town, :xray_facility]), status: :ok }
      end

    end

    # GET /internal/visit_plans/clinics/1/edit
    def edit
      render 'internal/visit_plans/clinics/edit'
    end

    # POST /internal/visit_plans/clinics
    # POST /internal/visit_plans/clinics.json
    def create
      processCreate(Doctor, internal_visit_plans_clinics_path)
    end

    # PATCH/PUT /internal/visit_plans/clinics/1
    # PATCH/PUT /internal/visit_plans/clinics/1.json
    def update
      processUpdate(Doctor, @visit_plan, internal_visit_plans_clinics_path)
    end

    # DELETE /internal/visit_plans/clinics/1
    # DELETE /internal/visit_plans/clinics/1.json
    def destroy
      processDestroy(@visit_plan, internal_visit_plans_clinics_path)
    end

    def approval
      @visit_plan_approval = {}
      render 'internal/visit_plans/clinics/edit'
    end

    def approve_report
      processApprove(@visit_plan_approval, internal_visit_plans_clinics_path)
    end
  end

end
