class Internal::ForeignWorkersController < InternalController
    include Approvalable
    include Watermark

    before_action :set_foreign_worker, only: [:show, :edit, :update, :destroy, :approval, :block, :block_update, :unblock, :unblock_update]

    # GET /foreign_workers
    # GET /foreign_workers.json
    def index

        if [:code, :name, :gender, :passport_number, :country, :date_of_birth, :employer_code, :status, :blocked, :employer_state_id, :branch_id].all? { |sym| params[sym].blank? }
            flash.now[:error] = "Filter criteria needed"
            @foreign_workers = nil
            render :index and return
        end

        foreign_workers = ForeignWorker.select("foreign_workers.*, exists (select 1 from order_items join orders on order_items.order_id = orders.id and orders.status = 'PENDING_APPROVAL' where order_items.order_itemable_id = foreign_workers.id and order_items.order_itemable_type = 'ForeignWorker') as has_special_renewal_pending_approval, transaction_carts.id as cart_selected")
        .joins("left join transaction_carts on transaction_carts.foreign_worker_id = foreign_workers.id and transaction_carts.created_by = #{current_user.id}")
        .search_name(params[:name])
        .search_code(params[:code])
        .search_employer(params[:employer_id])
        .search_country(params[:country])
        .search_employer_code(params[:employer_code])
        .search_gender(params[:gender])
        .search_date_of_birth(params[:date_of_birth])
        .search_passport(params[:passport_number])
        .search_status(params[:status])
        .search_blocked(params[:blocked])
        .search_employer_state(params[:employer_state_id])
        .search_branch(params[:branch_id])
        .search_request_start_date(params[:request_start_date])
        .search_request_end_date(params[:request_end_date])
        .search_assigned_to(params[:assigned_to], params[:status])

        if has_permission?("VIEW_ALL_FOREIGN_WORKER")
        elsif has_permission?("VIEW_BRANCH_FOREIGN_WORKER")
            foreign_workers = foreign_workers.where("foreign_workers.organization_id = ?", current_user.userable_id)
        elsif has_permission?("VIEW_OWN_FOREIGN_WORKER")
            foreign_workers = foreign_workers.where("foreign_workers.created_by = ?", current_user.id)
        end

        foreign_workers = ['UPDATE_PENDING_APPROVAL','UPDATE_REVERTED'].include?(params[:status]) ? foreign_workers.approval_requests.where("approval_items.id = (SELECT MAX(id) FROM approval_items temp_ai WHERE temp_ai.resource_id = foreign_workers.id and resource_type = 'ForeignWorker')").order('approval_requests.created_at ASC') : ['CHANGE_EMPLOYER_PENDING_APPROVAL', 'CHANGE_EMPLOYER_APPROVED', 'CHANGE_EMPLOYER_REJECTED', 'CHANGE_EMPLOYER_REVERTED'].include?(params[:status]) ? foreign_workers.latest_change_employer_requests.order('fw_change_employers.created_at ASC') : ['UPDATE_APPROVED','UPDATE_REJECTED'].include?(params[:status]) ? foreign_workers.approval_requests.where("approval_items.id = (SELECT MAX(id) FROM approval_items temp_ai WHERE temp_ai.resource_id = foreign_workers.id and resource_type = 'ForeignWorker')").order('approval_requests.updated_at desc') : foreign_workers.order('foreign_workers.created_at DESC')

        @foreign_workers = foreign_workers.page(params[:page])
        .per(get_per).includes(:country).includes(:job_type)
    end

    # GET /foreign_workers/1
    # GET /foreign_workers/1.json
    def show
    end

    # GET /foreign_workers/new
    def new
        @foreign_worker = ForeignWorker.new
    end

    # POST /foreign_workers
    # POST /foreign_workers.json
    def create
        @foreign_worker = ForeignWorker.new(foreign_worker_params)
        respond_to do |format|
            if @foreign_worker.save
                format.html { redirect_to internal_foreign_workers_url, notice: 'Foreign worker was successfully created.' }
                format.json { render :show, status: :created, location: @foreign_worker }
            else
                format.html { render :new }
                format.json { render json: @foreign_worker.errors, status: :unprocessable_entity }
            end
        end
    end

    # GET /foreign_workers/1/edit
    def edit
        # redirect_to internal_foreign_worker_url(@foreign_worker) unless @foreign_worker.assigned_to.eql?(current_user.id)
    end

    # PATCH/PUT /foreign_workers/1
    # PATCH/PUT /foreign_workers/1.json
    # request to edit foreign_worker
    def update
        begin
            respond_to do |format|
                if @foreign_worker.update(foreign_worker_params)
                    params[:foreign_worker][:uploads].each do |upload|
                        if (!upload[:category].nil? && !upload[:documents].nil?)
                            add_watermark(upload[:documents])
                            upl = @foreign_worker.uploads.create(category: upload[:category])
                            upl.documents.attach(upload[:documents])
                        end
                    end
                    format.html { redirect_to internal_foreign_workers_url, notice: 'Foreign worker was successfully updated.' }
                    format.json { render :show, status: :ok, location: @foreign_worker }
                else
                    format.html { render :edit }
                    format.json { render json: @foreign_worker.errors, status: :unprocessable_entity }
                end
            end
        rescue ActiveRecord::RecordInvalid => invalid
            redirect_to internal_foreign_workers_url, notice: invalid.to_s
        end
    end

    # DELETE /foreign_workers/1
    # DELETE /foreign_workers/1.json
    def destroy
        @foreign_worker.destroy
        respond_to do |format|
            format.html { redirect_to internal_foreign_workers_url, notice: 'Foreign worker was successfully deleted.' }
            format.json { head :no_content }
        end
    end

    def approval
    end

    def bulk_action
        if !params.has_key?(:ids)
            redirect_to internal_foreign_workers_url, flash: {notice: "Please select foreign worker"} and return
        end

        case params[:bulk_action]
        when 'register_transaction'
            register_transaction
            redirect_to edit_internal_order_path(@order) and return
        end

        redirect_to internal_foreign_workers_url
    end

    def block
    end

    def block_update
        if @foreign_worker.update(foreign_worker_block_params.merge({
            blocked: true,
            blocked_at: DateTime.now,
            blocked_by: current_user.id
        }))
            redirect_to internal_foreign_workers_url, notice: 'Foreign worker was successfully blocked.'
            # format.html { redirect_to internal_foreign_workers_url, notice: 'Foreign worker was successfully blocked.' }
            # format.json { render :show, status: :ok, location: @foreign_worker }
        else
            format.html { render :block }
            format.json { render json: @foreign_worker.errors, status: :unprocessable_entity }
        end
    end

    def unblock
    end

    def unblock_update
        if @foreign_worker.update(foreign_worker_unblock_params.merge({
            blocked: false,
            blocked_at: nil,
            blocked_by: nil
        }))
            redirect_to internal_foreign_workers_url, notice: 'Foreign worker was successfully unblocked.'
            # format.html { redirect_to internal_foreign_workers_url, notice: 'Foreign worker was successfully blocked.' }
            # format.json { render :show, status: :ok, location: @foreign_worker }
        else
            format.html { render :unblock }
            format.json { render json: @foreign_worker.errors, status: :unprocessable_entity }
        end
    end

    def foreign_worker_by_id
      @foreign_worker = ForeignWorker.search_id(params[:id])
      respond_to do |format|
        format.json { render json: @foreign_worker }
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_foreign_worker
        @foreign_worker = ForeignWorker.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def foreign_worker_params
        params.require(:foreign_worker).permit(:name, :passport_number, :gender, :date_of_birth, :employer_id, :country_id, :job_type_id, :arrival_date, :plks_number, :pati, :blocked, :block_reason_id, :block_comment, :unblock_reason_id, :unblock_comment, :blocked_at, :blocked_by, :amendment_reason_id, :amendment_reason_comment, :amended_at, :amended_by)
    end

    def foreign_worker_block_params
        params.require(:foreign_worker).permit(:block_reason_id, :block_comment)
    end

    def foreign_worker_unblock_params
        params.require(:foreign_worker).permit(:block_reason_id, :unblock_comment)
    end

    # bulk actions
    def register_transaction
        employer_workers = {}
        @failed_workers = []

        # run check on each foreign worker
        params[:ids].each do |fw_id|
            foreign_worker = ForeignWorker.find(fw_id)
            if (foreign_worker.has_pending_transaction? or foreign_worker.has_pending_transaction_registration_order?)
                @failed_workers << foreign_worker
            else
                if !employer_workers.key?(foreign_worker.employer.code)
                    employer_workers[foreign_worker.employer.code] = []
                end
                employer_workers[foreign_worker.employer.code] << foreign_worker
            end
        end

        employer_workers.each do |employer_code, workers|
            # create order
            @order = Order.create({
                customerable: Employer.find_by(code: employer_code),
                category: "TRANSACTION_REGISTRATION",
                # payment_method: PaymentMethod.find_by('IPAY88')
            })

            # create order item
            total_fee = 0
            workers.each do |foreign_worker|
                foreign_worker = ForeignWorker.find(foreign_worker.id)
                fee = Fee.find_by(code: "TRANSACTION_#{ForeignWorker::GENDERS[foreign_worker.gender]}")
                @order.order_items.create({
                    order_itemable: foreign_worker,
                    fee_id: fee.id,
                    amount: fee.amount,
                })
                total_fee = total_fee + fee.amount
            end

            @order.update({
                amount: total_fee
            })

        end
    end
    # /bulk actions

end
# /class