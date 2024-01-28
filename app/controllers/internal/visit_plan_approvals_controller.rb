module Internal

  class VisitPlanApprovalsController < InternalController
    before_action :set_visit_plan, only: [:show, :edit, :update]

    has_scope :visitable_type, only: [:index]
    has_scope :visitable_category, only: [:index]
    has_scope :inspect_from, only: [:index]
    has_scope :inspect_to, only: [:index]
    has_scope :status, only: [:index]

    # GET /internal/visit_plan_approvals
    # GET /internal/visit_plan_approvals.json
    def index

      @visit_plan_approvals = apply_scopes(VisitPlan)
                              .approval
                              .order('id DESC')
                              .page(params[:page])
                              .per(get_per)

    end

    # GET /internal/visit_plan_approvals/1
    # GET /internal/visit_plan_approvals/1.json
    def show
    end

    # GET /internal/visit_plan_approvals/new
    def new
    end

    # GET /internal/visit_plan_approvals/1/edit
    def edit

    end

    # POST /internal/visit_plan_approvals
    # POST /internal/visit_plan_approvals.json
    def create

    end

    # PATCH/PUT /internal/visit_plan_approvals/1
    # PATCH/PUT /internal/visit_plan_approvals/1.json
    def update

      approval_data = {}

      decision = visit_plan_approval_params[:decision]
      comment = visit_plan_approval_params[:comment]
      approval_by = current_user.id
      approval_at = Time.now

      status = 'REJECTED'

      if @visit_plan.status_in_database === 'LEVEL_1_APPROVAL'

        approval_data[:level_1_approval_decision] = decision
        approval_data[:level_1_approval_comment] = comment
        approval_data[:level_1_approval_by] = approval_by
        approval_data[:level_1_approval_at] = approval_at

        if decision === 'APPROVE'
          status = 'LEVEL_1_APPROVED'
        end

      end

      if @visit_plan.status_in_database === 'LEVEL_1_APPROVED'

        approval_data[:level_2_approval_decision] = decision
        approval_data[:level_2_approval_comment] = comment
        approval_data[:level_2_approval_by] = approval_by
        approval_data[:level_2_approval_at] = approval_at

        if decision === 'APPROVE'
          status = 'LEVEL_2_APPROVED'
        end

      end

      approval_data[:status] = status

      # abort status.inspect

      respond_to do |format|
        if @visit_plan.update(approval_data)
          format.html { redirect_to internal_visit_plan_approvals_path, notice: 'Visit Plan was successfully ' + visit_plan_approval_params[:decision] }
          format.json { render :show, status: :ok, location: @visit_plan }
        else
          format.html { render :edit }
          format.json { render json: @visit_plan.errors, status: :unprocessable_entity }
        end
      end

    end

    # DELETE /internal/visit_plan_approvals/1
    # DELETE /internal/visit_plan_approvals/1.json
    def destroy

    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_visit_plan
      @visit_plan = VisitPlan.includes(visit_plan_states: [:state], visit_plan_towns: [:town], visit_plan_items: [:visitable]).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def visit_plan_approval_params
      params.require(:visit_plan_approval).permit(:decision, :comment)
    end

  end

end
