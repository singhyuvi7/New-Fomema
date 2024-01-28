module Internal

  class VisitPlansController < InternalController
    before_action :set_visit_plan, only: [:show, :edit, :update, :destroy, :approval, :download]

    has_scope :visitable_type, only: [:index]
    has_scope :visitable_category, only: [:index]
    has_scope :inspect_from, only: [:index]
    has_scope :inspect_to, only: [:index]
    has_scope :status, only: [:index]

    # GET /internal/visit_plans2
    # GET /internal/visit_plans2.json
    def index
      @visit_plans = VisitPlan
                     .page(params[:page])
                     .per(get_per)
    end

    # GET /internal/visit_plans2/1
    # GET /internal/visit_plans2/1.json
    def show
    end

    # GET /internal/visit_plans2/new
    def new
      @visit_plan = VisitPlan.includes(:visit_plan_states, :visit_plan_towns, :visit_plan_items).new
    end

    # GET /internal/visit_plans2/1/edit
    def edit
    end

    # POST /internal/visit_plans2
    # POST /internal/visit_plans2.json
    def create
      @visit_plan = VisitPlan.new(visit_plan_params)

      respond_to do |format|
        if @visit_plan.save
          format.html { redirect_to @visit_plan, notice: "Visit Plan ID '#{@visit_plan.code}'  Was Successfully Created." }
          format.json { render :show, status: :created, location: @visit_plan }
        else
          format.html { render :new }
          format.json { render json: @visit_plan.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /internal/visit_plans2/1
    # PATCH/PUT /internal/visit_plans2/1.json
    def update
      respond_to do |format|
        if @visit_plan.update(visit_plan_params)
          format.html { redirect_to @visit_plan, notice: "Visit Plan ID '#{@visit_plan.code}' Has Been Updated." }
          format.json { render :show, status: :ok, location: @visit_plan }
        else
          format.html { render :edit }
          format.json { render json: @visit_plan.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /internal/visit_plans2/1
    # DELETE /internal/visit_plans2/1.json
    def destroy
      @visit_plan.destroy
      respond_to do |format|
        format.html { redirect_to visit_plans_url, notice: "Visit Plan ID '#{@visit_plan.code}' Has Been Deleted." }
        format.json { head :no_content }
      end
    end

    def download
      @visit_plan_items = @visit_plan.visit_plan_items
      @title = 'Print Visit Plan'
      @company_name = SystemConfiguration.find_by(code: 'COMPANY_NAME')&.value
      render_pdf
    end

    protected

    def processCreate(visitable_type, redirect_path)

      visit_plan_data = visit_plan_params

      visit_plan_data[:visitable_type] = visitable_type.to_s
      visit_plan_data[:status] = 'DRAFT'

      # set status if submit for approval
      visit_plan_data = setVisitPlanStatus(visit_plan_data, params[:submit_action])

      @visit_plan = VisitPlan.new(visit_plan_data)

      respond_to do |format|
        if @visit_plan.save

          syncVisitPlanCategories(@visit_plan, params[:visit_plan_categories])
          syncVisitPlanItems(visitable_type, @visit_plan, params[:visit_plan_items])
          syncVisitPlanStates(@visit_plan, params[:visit_plan_states])
          syncVisitPlanTowns(@visit_plan, params[:visit_plan_towns])

          message = getSubmitMessage(@visit_plan,'Created')

          format.html { redirect_to redirect_path, notice: message }
          format.json { render :show, status: :created, location: @visit_plan }
        else
          format.html { render :new }
          format.json { render json: @visit_plan.errors, status: :unprocessable_entity }
        end

      end
    end

    def processUpdate(visitable_type, visit_plan, redirect_path)
      respond_to do |format|

        visit_plan_data = visit_plan_params

        # set status if submit for approval
        visit_plan_data = setVisitPlanStatus(visit_plan_data, params[:submit_action])

        if visit_plan.update(visit_plan_data)

          syncVisitPlanCategories(visit_plan, params[:visit_plan_categories])
          syncVisitPlanItems(visitable_type, visit_plan, params[:visit_plan_items])
          syncVisitPlanStates(visit_plan, params[:visit_plan_states])
          syncVisitPlanTowns(visit_plan, params[:visit_plan_towns])

          message = getSubmitMessage(visit_plan,'Updated')

          format.html { redirect_to redirect_path, notice: message }
          format.json { render :show, status: :ok, location: visit_plan }

        else

          format.html { render :edit }
          format.json { render json: visit_plan.errors, status: :unprocessable_entity }
        end
      end
    end

    def processDestroy(visit_plan, redirect_path, message = "Visit Plan ID '#{@visit_plan.code}' Has Been Deleted.")
      visit_plan.destroy

      respond_to do |format|
        format.html { redirect_to redirect_path, notice: message }
        format.json { head :no_content }
      end
    end

    def processApprove(visit_plan_approval, redirect_path)
      respond_to do |format|

        decision = params[:visit_plan_approval][:decision]
        comment = params[:visit_plan_approval][:comment]
        approval_by = current_user.id
        approval_at = Time.now

        @visit_plan = VisitPlan::find(params[:id])

        approval_data = {}
        status = 'REJECTED'
        if @visit_plan[:status] === 'LEVEL_1_APPROVAL'
          approval_data[:level_1_approval_decision] = decision
          approval_data[:level_1_approval_comment] = comment
          approval_data[:level_1_approval_by] = approval_by
          approval_data[:level_1_approval_at] = approval_at

          if decision == 'APPROVE'
            status = 'LEVEL_1_APPROVED'
          end
        end
  
        if @visit_plan[:status] === 'LEVEL_1_APPROVED'
          approval_data[:level_2_approval_decision] = decision
          approval_data[:level_2_approval_comment] = comment
          approval_data[:level_2_approval_by] = approval_by
          approval_data[:level_2_approval_at] = approval_at

          if decision == 'APPROVE'
            status = 'LEVEL_2_APPROVED'
          end
        end

        approval_data[:status] = status
  
        @visit_plan.update(approval_data);
        message = decision == 'REJECT' ? "Visit Plan ID '#{@visit_plan.code}' Has Been Rejected" : "Visit Plan ID '#{@visit_plan.code}' Was Approved."

        format.html { redirect_to redirect_path, notice: message }
        format.json { head :no_content }
      end

    end

    def render_pdf
      # debug mode on / off

      @debug = false

      # enable debug by passing ?debug param in url
      if params.has_key?(:debug)
          @debug = true
          render 'internal/visit_plans/shared/visit_list_print', layout: 'pdf'
      else
          render pdf: "visit_list_print",
          template: "internal/visit_plans/shared/visit_list_print",
          header: {
            html: {
                template: "internal/visit_plans/shared/visit_list_header"
            }
          },
          layout: "pdf.html",
          margin: {
            top: 30,
            left: 12,
            right: 12,
            bottom: 10,
          },
          page_size: nil,
          page_height: "21cm",
          page_width: "29.7cm",
          dpi: "300"
      end
    end

    def setVisitPlanStatus(visit_plan_data, submit_action)

      if submit_action === 'submit'
        visit_plan_data[:status] = 'LEVEL_1_APPROVAL'
      else
        visit_plan_data[:status] = 'DRAFT'
      end
      
      return visit_plan_data
    end

    def getSubmitMessage(visit_plan_data,type_msg)
      if visit_plan_data[:status] == 'LEVEL_1_APPROVAL'
        message = "Visit Plan ID '#{visit_plan_data[:code]}' Has Been Submitted For Approval"
      else
        message = "Visit Plan ID '#{visit_plan_data[:code]}' Was Successfully "+type_msg
      end

      return message
    end


    def syncVisitPlanCategories(visit_plan, category_params)

      unless category_params.nil?

        # clear previous records

        visit_plan.visit_plan_categories.destroy_all

        category_params.each do |category|

          data = [
              category: category
          ]

          visit_plan.visit_plan_categories.create(data)

        end

      end

    end

    def syncVisitPlanStates(visit_plan, state_params)

      # clear previous records

      visit_plan.visit_plan_states.destroy_all

      unless state_params.nil?

        state_params.each do |state_id|

          data = [
              state_id: state_id
          ]

          visit_plan.visit_plan_states.create(data)

        end

      end

    end

    def syncVisitPlanTowns(visit_plan, town_params)

      # clear previous records

      visit_plan.visit_plan_towns.destroy_all

      town_ids = []

      if ['DRAFT'].include?(visit_plan.status)
        unless town_params.nil?
          # insert new records
         town_ids = town_params
        end
      else
        model = visit_plan.visitable_type.constantize
        table = model.table_name

        town_ids = visit_plan.visit_plan_items.joins("join #{table} on visit_plan_items.visitable_id = #{table}.id").pluck(:town_id).uniq
      end

      # insert new records
      town_ids.each do |town_id|
        town = Town.find(town_id)
        unless town.nil?
          data = [
              state_id: town.state_id,
              town_id: town_id
          ]
          visit_plan.visit_plan_towns.create(data)
        end
      end

    end

    def syncVisitPlanItems(visitable_type, visit_plan, item_params)

      # clear previous records

      visit_plan.visit_plan_items.destroy_all

      unless item_params.nil?

        # abort item_params.inspect

        item_params.each do |item_id|

          model_record = visitable_type.where("id = #{item_id}").first()

          unless model_record.nil?

            data = [
                visitable_type: visitable_type,
                visitable_id: item_id,
                state_id: model_record.state_id,
                town_id: model_record.town_id
            ]

            visit_plan_item = visit_plan.visit_plan_items.create(data)

          end

        end

      end

    end

    # Use callbacks to share common setup or constraints between actions.
    def set_visit_plan
      @visit_plan = VisitPlan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def visit_plan_params
      params.require(:visit_plan).permit(:inspect_from, :inspect_to, :comment)
    end
  end

end
