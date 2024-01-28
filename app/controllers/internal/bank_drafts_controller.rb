class Internal::BankDraftsController < InternalController
    before_action :set_bank_draft, only: [:show, :edit, :update, :destroy, :hold, :hold_update, :unhold, :unhold_update, :bad, :unbad, :replace, :replace_update, :refund, :refund_update]
    before_action :set_payerable_types, only: [:index, :new, :create, :edit, :update, :replace, :replace_update]

    before_action -> { can_access?("VIEW_BANK_DRAFT") }, only: [:index, :show]
    before_action -> { can_access?("CREATE_BANK_DRAFT") }, only: [:new, :create]
    before_action -> { can_access?("EDIT_BANK_DRAFT") }, only: [:edit, :update]
    before_action -> { can_access?("DELETE_BANK_DRAFT") }, only: [:destroy]
    before_action -> { can_access?("HOLD_BANK_DRAFT") }, only: [:hold, :hold_update]
    before_action -> { can_access?("UNHOLD_BANK_DRAFT") }, only: [:unhold, :unhold_update]
    before_action -> { can_access?("SET_BAD_BANK_DRAFT") }, only: [:bad]
    before_action -> { can_access?("UNSET_BAD_BANK_DRAFT") }, only: [:unbad]
    before_action -> { can_access?("REPLACE_BANK_DRAFT") }, only: [:replace, :replace_update]
    before_action -> { can_access?("REFUND_BANK_DRAFT") }, only: [:refund, :refund_update]

    # GET /bank_drafts
    # GET /bank_drafts.json
    def index
        if params[:payerable_type].blank?
            flash.now[:errors] = ["Filter criteria for payer type is needed"]
            @bank_drafts = nil
            render :index and return
        end

        @bank_drafts = BankDraft.search_number(params[:number])
        .search_bank(params[:bank])
        .search_organization(params[:organization])
        .search_issue_date(params[:issue_date])
        .search_issue_date_from(params[:issue_date_from])
        .search_issue_date_to(params[:issue_date_to])
        .search_created_date_from(params[:created_date_from])
        .search_created_date_to(params[:created_date_to])
        .search_holded(params[:holded])
        .search_bad(params[:bad])
        .search_order_code(params[:order_code])
        .search_payerable_by_code(params[:payerable_type], params[:payerable_code])
        .search_posted(params[:is_posted])
        .includes(:payerable)
        .includes(:bank)
        .includes(:zone)
        .order('bank_drafts.created_at desc')
        .page(params[:page])
        .per(get_per)
    end

    # GET /bank_drafts/1
    # GET /bank_drafts/1.json
    def show
    end

    # GET /bank_drafts/new
    def new
        @bank_draft = BankDraft.new
        @payer_type = params[:payer_type]
        @payer_code = params[:payer_code]
    end

    # POST /bank_drafts
    # POST /bank_drafts.json
    def create
        @payer_type = params[:bank_draft][:payerable_type]
        @payer_code = params[:payer_code]
        @payer = params[:bank_draft][:payerable_type].constantize.find_by(code: params[:payer_code])
        @bank_draft = BankDraft.new(bank_draft_params)
        if !@payer
            @bank_draft.errors.add(:base, "Payer not found")
            render :new and return
        end
        @bank_draft.assign_attributes(
            payerable: @payer,
            bad: false,
            holded: false
        )

        respond_to do |format|
            if @bank_draft.save
                format.html { redirect_to internal_bank_drafts_url, notice: 'Bank Draft was successfully created.' }
                format.json { render :show, status: :created, location: @bank_draft }
            else
                format.html { render :new }
                format.json { render json: @bank_draft.errors, status: :unprocessable_entity }
            end
        end
    end

    # GET /bank_drafts/1/edit
    def edit
        @payer_type = @bank_draft.payerable_type
        @payer_code = @bank_draft.payerable.code
    end

    # PATCH/PUT /bank_drafts/1
    # PATCH/PUT /bank_drafts/1.json
    def update
        @payer_type = params[:bank_draft][:payerable_type]
        @payer_code = params[:payer_code]
        @payer = params[:bank_draft][:payerable_type].constantize.find_by(code: params[:payer_code])
        @bank_draft.assign_attributes(bank_draft_params)
        if !@payer
            @bank_draft.errors.add(:base, "Payer not found")
            render :edit and return
        end
        @bank_draft.assign_attributes(
            payerable: @payer
        )

        if @bank_draft.amount_allocated > @bank_draft.amount 
            @bank_draft.errors.add(:base, "Amount cannot be lower than the amount that has already been allocated")
            render :edit and return
        end

        respond_to do |format|
            if @bank_draft.save
                format.html { redirect_to internal_bank_drafts_url, notice: 'Bank Draft was successfully updated.' }
                format.json { render :show, status: :ok, location: @bank_draft }
            else
                format.html { render :edit }
                format.json { render json: @bank_draft.errors, status: :unprocessable_entity }
            end
        end
    end

    def replace
        @payer_type = @bank_draft.payerable_type
        @payer_code = @bank_draft.payerable.code
        @new_bank_draft = BankDraft.new({
            payerable: @bank_draft.payerable,
            number: nil,
            bank_id: nil,
            issue_date: nil,
            issue_place: nil,
            zone_id: nil,
            amount: @bank_draft.amount,
            holded: false,
            bad: false,
        })
    end

    def replace_update
        @payer_type = params[:bank_draft][:payerable_type]
        @payer_code = params[:payer_code]
        @payer = params[:bank_draft][:payerable_type].constantize.find_by(code: params[:payer_code])

        @new_bank_draft = BankDraft.new(bank_draft_params)
        @new_bank_draft.assign_attributes({
            payerable: @payer
        })

        if @bank_draft.amount_allocated > @new_bank_draft.amount
            flash.now[:error] = "New bank draft has lesser amount"
            render :replace and return
        end

        respond_to do |format|
            if @new_bank_draft.save
                @bank_draft.assign_attributes({
                    replacement_id: @new_bank_draft.id
                })
                @bank_draft.save(validate: false)

                @bank_draft.bank_draft_allocations.each do |bank_draft_allocation|
                    bank_draft_allocation.update({
                        bank_draft_id: @new_bank_draft.id
                    })
                end
                @new_bank_draft.block_or_unblock_fw
                format.html { redirect_to internal_bank_drafts_url, notice: 'Bank Draft was successfully replaced.' }
                format.json { render :show, status: :ok, location: @bank_draft }
            else
                format.html { render :edit }
                format.json { render json: @bank_draft.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /bank_drafts/1
    # DELETE /bank_drafts/1.json
    def destroy
        @bank_draft.destroy
        respond_to do |format|
            format.html { redirect_to internal_bank_drafts_url, notice: 'Bank Draft was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def hold
        redirect_to internal_bank_drafts_path, error: "Bank draft is already holded" and return if @bank_draft.holded

        @bank_draft_hold_log = @bank_draft.bank_draft_hold_logs.new({
            holded_by: current_user.id,
            holded_at: Time.now
        })
    end

    def hold_update
        @bank_draft.update({
            holded: true,
            holded_by: current_user.id,
            holded_at: Time.now
        })
        @bank_draft.bank_draft_hold_logs.create(
            params.require(:bank_draft_hold_log).permit(:hold_comment).merge({
                holded_by: current_user.id,
                holded_at: Time.now
            })
        )
        redirect_to internal_bank_drafts_path, notice: "Bank draft holded"
    end

    def unhold
        redirect_to internal_bank_drafts_path, error: "Bank draft is not holded" and return if !@bank_draft.holded

        @bank_draft_hold_log = @bank_draft.bank_draft_hold_logs.where("unholded_at is null").order("created_at desc").first or (redirect_to internal_bank_drafts_path, error: "Invalid bank draft hold log" and return)

        @bank_draft_hold_log.assign_attributes({
            unholded_by: current_user.id,
            unholded_at: Time.now
        })
    end

    def unhold_update
        @bank_draft.update({
            holded: false,
            holded_by: nil,
            holded_at: nil
        })
        @bank_draft.bank_draft_hold_logs.where("unholded_at is null").order("created_at desc").first.update(
            params.require(:bank_draft_hold_log).permit(:unhold_comment).merge({
                unholded_by: current_user.id,
                unholded_at: Time.now
            })
        )
        redirect_to internal_bank_drafts_path, notice: "Bank draft unholded"
    end

    def bad
        @bank_draft.update({
            bad: true
        })
        # redirect_to internal_bank_drafts_path, notice: "Bad bank draft marked"
        redirect_back fallback_location: internal_bank_drafts_path, notice: "Bad bank draft marked"
    end

    def unbad
        @bank_draft.update({
            bad: false
        })
        # redirect_to internal_bank_drafts_path, notice: "Bad bank draft unmarked"
        redirect_back fallback_location: internal_bank_drafts_path, notice: "Bad bank draft unmarked"
    end

    def refund
        @refund = Refund.new({
            customerable: @bank_draft.payerable,
            amount: (@bank_draft.amount || 0) - (@bank_draft.amount_allocated || 0),
            category: "MANUAL"
        })
    end

    def refund_update
        @refund = Refund.new({
            customerable: @bank_draft.payerable,
            amount: (@bank_draft.amount || 0) - (@bank_draft.amount_allocated || 0),
            category: "MANUAL",
            request_by: current_user.id,
            request_at: Time.now,
            date: Time.now.strftime("%Y-%m-%d"),
            organization_id: @bank_draft.organization_id
        })
        @refund.assign_attributes(refund_params)

        if @refund.save
            @refund.refund_items.create({
                refund_itemable: @bank_draft,
                amount: @refund.amount
            })
            redirect_to internal_bank_drafts_path, notice: "Refund successfully created."
        else
            render :refund
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_bank_draft
        @bank_draft = BankDraft.find(params[:id])
    end

    def set_payerable_types
        @payerable_types = {}
        @payerable_types = @payerable_types.merge({"Employer" => "Employer"}) if has_permission?("VIEW_EMPLOYER_BANK_DRAFT")
        @payerable_types = @payerable_types.merge({
            "Doctor" => "Doctor",
            "Laboratory" => "Laboratory",
            "XrayFacility" => "X-Ray Facility",
            "Radiologist" => "Radiologist"
        }) if has_permission?("VIEW_SERVICE_PROVIDER_BANK_DRAFT")
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bank_draft_params
        params.require(:bank_draft).permit(:number, :bank_id, :issue_date, :issue_place, :zone_id, :amount, :bad, :holded)
    end
end