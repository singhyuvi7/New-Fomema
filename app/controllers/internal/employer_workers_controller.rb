require 'csv'

class Internal::EmployerWorkersController < InternalController
    include Approvalable
    include Cart
    include RegisterTransaction
    include BulkUploadWorker
    include BankInfoCheck
    include Sage
    include Insurance
    include TransferWorker
    include ProfileInfoCheck
    include Watermark

    before_action :set_employer
    before_action :set_foreign_worker, only: [:show, :edit, :update, :upload, :destroy, :approval, :approval_update, :block, :block_update, :unblock, :unblock_update, :monitor, :monitor_update, :unmonitor, :unmonitor_update, :reverted, :reverted_update, :employer, :employer_update, :change_gender, :activate, :activate_update, :deactivate, :deactivate_update, :approval_change_employer, :approval_change_employer_update, :show_amendment_history]
    before_action :set_fees, only: [:edit]

    before_action -> { can_access?("VIEW_ALL_FOREIGN_WORKER", "VIEW_BRANCH_FOREIGN_WORKER", "VIEW_OWN_FOREIGN_WORKER") }, only: [:index, :show]
    before_action -> { can_access?("CREATE_FOREIGN_WORKER") }, only: [:new, :create]
    before_action -> { can_access?("EDIT_FOREIGN_WORKER") }, only: [:edit, :update, :upload]
    before_action -> { can_access?("EDIT_EMPLOYER_FOREIGN_WORKER") }, only: [:employer, :employer_update]
    before_action -> { can_access?("BLOCK_FOREIGN_WORKER") }, only: [:block, :block_update]
    before_action -> { can_access?("UNBLOCK_FOREIGN_WORKER") }, only: [:unblock, :unblock_update]
    before_action -> { can_access?("MONITOR_FOREIGN_WORKER") }, only: [:monitor, :monitor_update]
    before_action -> { can_access?("UNMONITOR_FOREIGN_WORKER") }, only: [:unmonitor, :unmonitor_update]
    before_action -> { can_access?("ACTIVATE_FOREIGN_WORKER") }, only: [:activate, :activate_update]
    before_action -> { can_access?("DEACTIVATE_FOREIGN_WORKER") }, only: [:deactivate, :deactivate_update]
    before_action -> { can_access?("EDIT_EMPLOYER_SUPPLEMENT_FOREIGN_WORKER") }, only: [:bulk_transfer_worker, :bulk_transfer_worker_update]

    before_action -> { set_fee_amount }, if: -> { @foreign_worker.code.present? }, only: [:update, :change_gender]
    before_action -> { set_order }, if: -> { @foreign_worker.code.present? }, only: [:approval_update]

    # before_action -> { can_proceed?(@foreign_worker.try(:employer)) }, if: -> { @foreign_worker.code.present? && (@fees.sum(&:amount) > 0) }, only: [:update, :change_gender]
    # before_action -> { can_proceed?(@foreign_worker.try(:employer)) }, if: -> { (!@order.blank? && @order.amount > 0) }, only: [:approval_update]
    before_action -> { can_proceed?('Employer', @foreign_worker.try(:employer)) }, if: -> { @foreign_worker.code.present? && (@fees.sum(&:amount) > 0) && (@foreign_worker&.latest_transaction.try(:agency).nil?) }, only: [:update, :change_gender]
    before_action -> { can_proceed?('Agency', @foreign_worker&.latest_transaction.try(:agency)) }, if: -> { @foreign_worker.code.present? && (@fees.sum(&:amount) > 0) && (!@foreign_worker&.latest_transaction.try(:agency).nil?) }, only: [:update, :change_gender]
    before_action -> { can_proceed?('Employer', @order.customerable) }, if: -> { (!@order.blank? && @order.amount > 0 && @order.customerable_type == 'Employer') }, only: [:approval_update]
    before_action -> { can_proceed?('Agency', @order.customerable) }, if: -> { (!@order.blank? && @order.amount > 0 && @order.customerable_type == 'Agency') }, only: [:approval_update]
    before_action -> { pending_profile_update?(Employer.find_by(id: @employer.id)) }, only: [ :bulk_action, :edit]

    def index
        query = ForeignWorker.select("foreign_workers.*, exists (select 1 from order_items join orders on order_items.order_id = orders.id and orders.status = 'PENDING_APPROVAL' where order_items.order_itemable_id = foreign_workers.id and order_items.order_itemable_type = 'ForeignWorker') as has_special_renewal_pending_approval, transaction_carts.id as cart_selected")
        .joins("left join transaction_carts on transaction_carts.foreign_worker_id = foreign_workers.id and transaction_carts.created_by = #{current_user.id}")
        .where("employer_id = ?", @employer.id)
        .search_name(params[:name])
        .search_code(params[:code])
        .search_country(params[:country])
        .search_employer_code(params[:employer_code])
        .search_gender(params[:gender])
        .search_status(params[:status])
        .search_date_of_birth(params[:date_of_birth])
        .search_passport(params[:passport_number])
        .search_monitoring(params[:monitoring])
        .search_branch(params[:branch_id])
        .search_request_start_date(params[:request_start_date])
        .search_request_end_date(params[:request_end_date])
        .search_supplement(params[:employer_supplement_id])


        if has_permission?("VIEW_ALL_FOREIGN_WORKER")
        elsif has_permission?("VIEW_BRANCH_FOREIGN_WORKER")
            query = query.where("foreign_workers.organization_id = ?", current_user.userable_id)
        elsif has_permission?("VIEW_OWN_FOREIGN_WORKER")
            query = query.where("foreign_workers.created_by = ?", current_user.id)
        end

        query = ['UPDATE_PENDING_APPROVAL','UPDATE_REVERTED'].include?(params[:status]) ? query.approval_requests.where("approval_items.id = (SELECT MAX(id) FROM approval_items temp_ai WHERE temp_ai.resource_id = foreign_workers.id and resource_type = 'ForeignWorker')").order('approval_requests.created_at ASC') : query.order('foreign_workers.created_at DESC')

        @foreign_workers = query.page(params[:page])
        .per(get_per).includes(:country).includes(:job_type).includes(:latest_insurance_purchase)

        @has_bulk_action = true
        @cart_count = cart_count
        @transaction_carts = TransactionCart.select("foreign_workers.id, foreign_workers.name, foreign_workers.passport_number, foreign_workers.code").joins(:foreign_worker).order("foreign_workers.name").where(created_by: current_user.id)
    end

    def show
        @monitor_logs = @foreign_worker.fw_monitor_logs.order(created_at: :desc)
        @block_logs = @foreign_worker.fw_block_logs.includes(:block_reason, :requester, :approver).order(created_at: :desc)
        @fw_amendments = @foreign_worker.fw_amendments.order(id: :desc)
    end

    def new
        @foreign_worker = ForeignWorker.new({
            employer_id: @employer.id
        })
    end

    def create
        data = foreign_worker_params.merge({
            employer_id: @employer.id,
            approval_status: 'NEW_APPROVED',
            #maid_online: params[:is_maid_online] ? "PRAON" : "FOMEMA"
            maid_online: params[:programme].blank? ? "FOMEMA" : params[:programme].first
        })
        if SystemConfiguration.get("PATI_NIOS") == "0"
            data[:pati] = false
        end
        @foreign_worker = ForeignWorker.new(data)

        respond_to do |format|
            begin
                if @foreign_worker.save

                    # process file upload
                    params[:foreign_worker][:uploads].each do |upload|
                        if (!upload[:category].nil? && !upload[:documents].nil?)
                            add_watermark(upload[:documents])
                            upl = @foreign_worker.uploads.create(category: upload[:category])
                            upl.documents.attach(upload[:documents])
                        end
                    end

                    format.html { redirect_to internal_employer_employer_workers_url, notice: 'Foreign worker was successfully created.' }
                    format.json { render :show, status: :created, location: @foreign_worker }
                else
                    format.html { render :new }
                    format.json { render json: @foreign_worker.errors, status: :unprocessable_entity }
                end
            rescue Exception => e
                @foreign_worker.errors.add(:base, e.message)
                format.html {
                    render :new
                }
                format.json { render json: @foreign_worker.errors, status: :unprocessable_entity }
            end
        end
    end

    def edit
        @foreign_worker.assign_attributes({
            amendment_reasons: [],
            amendment_reason_comment: nil,
        })
        if (@foreign_worker.code.blank?)
            @fee_id = Fee.find_by(code: "FOC").id
        end
    end

    def upload
        if params[:foreign_worker].present?
            params[:foreign_worker][:uploads].each do |upload|
                if (!upload[:category].nil? && !upload[:documents].nil?)
                    add_watermark(upload[:documents])
                    upl = @foreign_worker.uploads.create(category: upload[:category])
                    upl.documents.attach(upload[:documents])
                end
            end
            if params[:remove_uploaded_file].present?
                ids = params[:remove_uploaded_file].split(",")
                @foreign_worker.uploads.where(id: ids).update_all(updated_by: current_user.id, deleted_at: DateTime.now)
            end
            flash_add(:notices, "Document Foreign worker updated ")
            redirect_to "#{internal_foreign_workers_path}?code=#{@foreign_worker.code}&employer_code=#{@foreign_worker.employer.code}" and return
        end
    end

    def update
        @foreign_worker.transaction do
            @foreign_worker.assign_attributes(foreign_worker_params.merge({
                "amended_at" => Time.now,
                "amended_by" => current_user.id,
                "amendment_reasons" => params[:foreign_worker][:amendment_reasons],
                #maid_online: params[:is_maid_online] ? "PRAON" : "FOMEMA"
                maid_online: params[:programme].blank? ? "FOMEMA" : params[:programme].first
            }))

            #if @foreign_worker.amendment_reasons.blank? || @foreign_worker.amendment_reasons.all?(&:blank?)
            if !@foreign_worker.code.blank? && (@foreign_worker.amendment_reasons.blank? || @foreign_worker.amendment_reasons.all?(&:blank?))
                @foreign_worker.errors.add(:amendment_reasons, "required")
                render :edit and return
            end

            if !@foreign_worker.valid?
                render :edit and return
            end

            if @foreign_worker.pati_changed? && SystemConfiguration.get("PATI_NIOS") == "0"
                @foreign_worker.pati = false
            end

            if @foreign_worker.code.blank?
                @foreign_worker.save

                if params[:foreign_worker][:uploads].present?
                    params[:foreign_worker][:uploads].each do |upload|
                        if (!upload[:category].nil? && !upload[:documents].nil?)
                            add_watermark(upload[:documents])
                            upl = @foreign_worker.uploads.create(category: upload[:category])
                            upl.documents.attach(upload[:documents])
                        end
                    end
                end

                flash[:notice] = "Foreign worker doesn't have transaction yet, foreign worker is amended"
                redirect_to "#{internal_foreign_workers_path}?employer_code=#{@foreign_worker.employer.code}" and return
            end

            order = Order.create({
                customerable: @foreign_worker.employer,
                category: "FOREIGN_WORKER_AMENDMENT",
                amount: 0,
                status: "NEW",
            })
            @fees.each do |fee|
                amount = fee.amount
                additional_information = {
                    "changes" => @foreign_worker.changes,
                    "transaction_id" => @foreign_worker.latest_transaction_id
                }
                order.order_items.create({
                    order_itemable: @foreign_worker,
                    fee_id: fee.id,
                    amount: amount,
                    additional_information: additional_information
                })
            end
            # if sum is 0 update to paid
            if order.amount > 0
                flash[:notice] = "Payment required, please proceed to payment"
                redirect_to edit_internal_order_path order and return
            else
                order.update({
                    status: 'PAID',
                    paid_at: DateTime.now,
                    payment_method: PaymentMethod.find_by(code: "FOC")
                })
            end

            if @foreign_worker.critical_change?
                fw_changes =  @foreign_worker.changes
                approval_update_request(@foreign_worker, category: "FOREIGN_WORKER_AMENDMENT", additional_information: {fee_id: params[:fee_id], order_id: order.id})
                fw_amendment = @foreign_worker.fw_amendments.create({
                    approval_item_id: @foreign_worker.approval_item.id,
                    comment: foreign_worker_params[:amendment_reason_comment]
                })
                params[:foreign_worker][:amendment_reasons].each do |amendment_reason_id|
                    fw_amendment.fw_amendment_reasons.create({
                        amendment_reason_id: amendment_reason_id
                    })
                end
                fw_changes.each do |field, field_changes|
                    if ["name", "date_of_birth", "country_id", "passport_number", "gender"].include?(field)
                        fw_amendment.fw_amendment_details.create({
                            field: field,
                            old_value: field_changes[0],
                            new_value: field_changes[1]
                        })
                    end
                end

                # auto approve
                begin
                    user = User.admin_user
                    approval_comment = "Foreign worker amendment is approved automatically"

                    fw_amendment = FwAmendment.where(approval_item_id: @foreign_worker.approval_item&.id).first
                    if fw_amendment
                        fw_amendment.update(approval_comment: approval_comment, updated_by: user.id)
                    end

                    @foreign_worker.assign_attributes(@foreign_worker.approval_item.params)

                    approval_approve_request(@foreign_worker, user: user, comment: approval_comment)
                    flash[:notice] = "Foreign worker updated"
                    redirect_to "#{internal_foreign_workers_path}?code=#{@foreign_worker.code}&employer_code=#{@foreign_worker.employer.code}" and return
                rescue Exception => invalid
                    if @foreign_worker.invalid?
                        flash[:error] = @foreign_worker.errors.full_messages.join(', ')
                    else
                        flash[:error] = "Failed to approve, please contact IT Support."
                    end
                    if params[:remove_uploaded_file].present?
                        ids = params[:remove_uploaded_file].split(",")
                        @foreign_worker.uploads.where(id: ids).update_all(updated_by: current_user.id, deleted_at: DateTime.now)
                    end
                    redirect_to approval_internal_employer_employer_workers_path(@employer, @foreign_worker) and return
                end
                # end auto approve
            else
                flash[:notices] = []

                approval_update_request(@foreign_worker, category: "FOREIGN_WORKER_AMENDMENT", additional_information: {fee_id: params[:fee_id], order_id: order.id})

                @foreign_worker.assign_attributes(@foreign_worker.approval_item.params)

                approval_approve_request(@foreign_worker)
                if @foreign_worker.errors.count == 0
                    if params[:foreign_worker][:uploads].present?
                        params[:foreign_worker][:uploads].each do |upload|
                            if (!upload[:category].nil? && !upload[:documents].nil?)
                                add_watermark(upload[:documents])
                                upl = @foreign_worker.uploads.create(category: upload[:category])
                                upl.documents.attach(upload[:documents])
                            end
                        end
                    end
                    if params[:remove_uploaded_file].present?
                        ids = params[:remove_uploaded_file].split(",")
                        @foreign_worker.uploads.where(id: ids).update_all(updated_by: current_user.id, deleted_at: DateTime.now)
                    end
                    flash[:notices] << "Foreign worker updated"
                    redirect_to "#{internal_foreign_workers_path}?code=#{@foreign_worker.code}&employer_code=#{@foreign_worker.employer.code}" and return
                else
                    flash.now[:error] = "Foreign worker failed to update"
                    render :edit
                end
            end
        end
        # /db-transaction
    end

    def change_gender
        @foreign_worker.transaction do
            flash[:notices] = []

            @foreign_worker.assign_attributes(foreign_worker_params.merge({
                "amended_at" => Time.now,
                "amended_by" => current_user.id
            }))

            if @foreign_worker.code.blank? || @foreign_worker.latest_transaction_id.blank?
                @foreign_worker.save

                flash[:notice] = "Foreign worker doesn't have transaction yet, foreign worker gender is amended"
                redirect_to internal_employer_employer_workers_path(@employer) and return
            end

            check_order = OrderItem.joins(:order).where(:order_itemable_type => 'ForeignWorker', :order_itemable_id => @foreign_worker.id).where("orders.category in (?) and orders.status in (?)",['FOREIGN_WORKER_GENDER_AMENDMENT'],["NEW", "PENDING_PAYMENT"])

            if !check_order.blank?
                flash[:error] = "Worker has pending order, please head to Order to complete the payment."
                redirect_to edit_internal_employer_employer_worker_path(@foreign_worker.employer_id, @foreign_worker) and return
            end

            if !@fees.blank?
                order = Order.create({
                    customerable: @foreign_worker&.latest_transaction.try(:agency) || @foreign_worker.employer,
                    category: "FOREIGN_WORKER_GENDER_AMENDMENT",
                    organization_id: @foreign_worker&.latest_transaction&.organization_id,
                    amount: 0,
                    status: "NEW",
                })
                @fees.each do |fee|
                    amount = fee.amount
                    additional_information = {
                        "changes" => @foreign_worker.changes,
                        "transaction_id" => @foreign_worker.latest_transaction_id
                    }
                    if fee.code.eql?("FOREIGN_WORKER_GENDER_AMENDMENT")
                        if @foreign_worker.gender.eql?("F")
                            amount = Fee.find_by(code: "TRANSACTION_FEMALE").amount - Fee.find_by(code: "TRANSACTION_MALE").amount
                        else
                            amount = fee.amount
                        end
                    end
                    order.order_items.create({
                        order_itemable: @foreign_worker,
                        fee_id: fee.id,
                        amount: amount,
                        additional_information: additional_information
                    })
                end
                # if sum is 0 update to paid
                if order.amount > 0
                    flash[:notice] = "Payment required, please proceed to payment"
                    redirect_to edit_internal_order_path order and return
                else
                    order.update({
                        status: 'PAID',
                        paid_at: DateTime.now,
                        payment_method: PaymentMethod.find_by(code: "FOC")
                    })
                end

                if @foreign_worker.gender_changed? and @foreign_worker.gender.eql?("M")
                    amount = Fee.find_by(code: "TRANSACTION_FEMALE").amount - Fee.find_by(code: "TRANSACTION_MALE").amount
                    if amount > 0
                        @refund = Refund.create({
                            customerable: @foreign_worker&.latest_transaction.try(:agency) || @foreign_worker.employer,
                            category: "FOREIGN_WORKER_GENDER_AMENDMENT",
                            payment_method_id: @foreign_worker&.latest_transaction&.order_item&.order&.payment_method_id,
                            amount: amount,
                            status: 'PENDING_SEND',
                            organization_id: @foreign_worker&.latest_transaction&.organization_id,
                            additional_information: {
                                order_id: order.id
                            }
                        })
                        @refund.refund_items.create({
                            refund_itemable: @foreign_worker,
                            amount: amount
                        })

                        ## send refund as batch instead of realtime
                        # submit_refund (@refund)

                        flash[:notices] << "Refund #{@refund.code} created"
                    end
                end
            end

            # @foreign_worker.save
            fw_changes =  @foreign_worker.changes
            approval_update_request(@foreign_worker, category: "FOREIGN_WORKER_GENDER_AMENDMENT")
            fw_amendment = @foreign_worker.fw_amendments.create({
                approval_item_id: @foreign_worker.approval_item.id
            })
            fw_changes.each do |field, field_changes|
                if ["name", "date_of_birth", "country_id", "passport_number", "gender"].include?(field)
                    fw_amendment.fw_amendment_details.create({
                        field: field,
                        old_value: field_changes[0],
                        new_value: field_changes[1]
                    })
                end
            end
            @foreign_worker.assign_attributes(@foreign_worker.approval_item.params)
            approval_approve_request(@foreign_worker)

            if @foreign_worker.errors.count == 0
                flash[:notices] << "Foreign worker gender updated"
                redirect_to internal_employer_employer_workers_url and return
            else
                flash.now[:error] = "Foreign worker gender failed to update"
                render :edit
            end
        end
        # /db-transaction
    end

    def reverted
        @foreign_worker.assign_attributes(@foreign_worker.approval_item.params)
    end

    def reverted_update
        @foreign_worker.assign_attributes(foreign_worker_params.merge({
            "amendment_reasons" => params[:foreign_worker][:amendment_reasons]
        }))
        begin
            approval_update_request(@foreign_worker)
        rescue Exception => invalid
            flash[:error] = "No changes detected, please cancel the request if no changes is required"
            redirect_to reverted_internal_employer_employer_worker_path(@employer, @foreign_worker) and return
        end
        flash[:notice] = "Foreign worker submitted for approval"
        redirect_to internal_employer_employer_workers_path(@employer)
    end

    def destroy
        order_items = OrderItem.joins(:order).where(:order_itemable_id => @foreign_worker.id,:order_itemable_type => 'ForeignWorker')

        redirect_to = request.env["HTTP_REFERER"] || internal_employer_employer_workers_url

        if !@foreign_worker.code.blank?
            flash[:error] = "Worker has worker code cannot be deleted"
        elsif !order_items.where(orders: {status: ['NEW','PENDING_PAYMENT','PENDING_AUTHORIZATION','PENDING']}).blank?
            flash[:error] = "Worker has pending payment cannot be deleted."
        elsif !order_items.where(orders: {status: ['PAID']}).blank?
            flash[:error] = "Worker cannot be deleted."
        else
            ## delete biodata requests and responses
            BiodataResponse.where(:foreign_worker_id => @foreign_worker.id).destroy_all
            BiodataRequest.where(:foreign_worker_id => @foreign_worker.id).destroy_all

            ## order
            order_ids = order_items.pluck(:order_id)
            order_items.destroy_all
            Order.where(:id => order_ids).each do |order|
                order.update_total_amount
            end

            @foreign_worker.destroy

            flash[:notice] = 'Foreign worker was successfully deleted.'
            redirect_to = internal_employer_employer_workers_url
        end

        respond_to do |format|
            format.html { redirect_to redirect_to }
            format.json { head :no_content }
        end
    end

    def approval
        if !@foreign_worker.approval_item
            redirect_back fallback_location: internal_employer_employer_workers_url, flash: { warning: "Approval request not found" } and return
        end
        @foreign_worker.assign_attributes(@foreign_worker.approval_item.params)
        @fw_amendments = @foreign_worker.fw_amendments.order(id: :desc)

        case @foreign_worker.approval_request.category
        when "BLOCK_FOREIGN_WORKER"
            render :approval_block_foreign_worker
        when "UNBLOCK_FOREIGN_WORKER"
            render :approval_unblock_foreign_worker
        end
    end

    def approval_update
        @foreign_worker.transaction do
            if ["APPROVE", "REJECT"].include?(approval_params[:decision])
                fw_amendment = FwAmendment.where(approval_item_id: @foreign_worker.approval_item&.id).first
                if fw_amendment
                    fw_amendment.update(approval_comment: approval_params[:comment])
                end
            end

            if ["FOREIGN_WORKER_AMENDMENT", "FOREIGN_WORKER_GENDER_AMENDMENT"].include?(@foreign_worker.approval_request.category)
                @redirect_to = internal_foreign_workers_path(status: "UPDATE_PENDING_APPROVAL", assigned_to: current_user.id)
            else
                @redirect_to = internal_employer_employer_workers_url
            end

            if approval_params[:decision] == 'APPROVE'
                @foreign_worker.assign_attributes(@foreign_worker.approval_item.params)

                # update transaction moved to foreign worker model after_save_callback
                # latest_transaction_update_data = {}
                # latest_transaction_update_data[:is_imm_blocked] = @foreign_worker.is_imm_blocked if @foreign_worker.is_imm_blocked_changed?
                # latest_transaction_update_data[:is_sp_transmit_blocked] = @foreign_worker.is_sp_transmit_blocked if @foreign_worker.is_sp_transmit_blocked_changed?

                if ["BLOCK_FOREIGN_WORKER", "UNBLOCK_FOREIGN_WORKER"].include?(@foreign_worker.approval_request.category)
                    fw_block_log = @foreign_worker.fw_block_logs.where({
                        action: @foreign_worker.approval_request.category.sub!('_FOREIGN_WORKER', '')
                    }).order(created_at: :desc).first
                    fw_block_log.update({
                        approval_decision: "APPROVE",
                        approval_comment: approval_params[:comment],
                        approval_by: current_user.id,
                        approval_at: Time.now
                    }) if fw_block_log

                    # update transaction moved to foreign worker model after_save_callback
                    # if @foreign_worker.latest_transaction_id && latest_transaction_update_data.size > 0
                    #     @foreign_worker.latest_transaction.update(latest_transaction_update_data)
                    # end
                end

                if !@order.blank?
                    if @foreign_worker.gender_changed? and @foreign_worker.gender.eql?("M")
                        amount = Fee.find_by(code: "TRANSACTION_FEMALE").amount - Fee.find_by(code: "TRANSACTION_MALE").amount
                        if amount > 0
                            # refund the extra amount that paid by the customer during transaction registration
                            # refund to the customer who registered the transaction, not to the customer who request for gender amendment
                            fw_order_item = @order.order_items.exclude_convenient_fee.where(order_itemable_type: 'ForeignWorker', order_itemable_id: @foreign_worker.id).first
                            gender_amendment_transaction_id = fw_order_item.get_additional_information_transaction_id

                            transaction = Transaction.find(gender_amendment_transaction_id)
                            if transaction.is_agency_transaction?
                                refund_to = transaction.agency
                            else
                                refund_to = transaction.employer
                            end

                            @refund = Refund.create({
                                customerable: refund_to,
                                category: "FOREIGN_WORKER_GENDER_AMENDMENT",
                                payment_method_id: @foreign_worker&.latest_transaction&.order_item&.order&.payment_method_id,
                                amount: amount,
                                status: 'PENDING_SEND',
                                organization_id: @foreign_worker&.latest_transaction&.organization_id,
                                additional_information: {
                                    order_id: @order.id
                                }
                            })
                            @refund.refund_items.create({
                                refund_itemable: @foreign_worker,
                                amount: amount
                            })

                            ## send refund as batch instead of realtime
                            # submit_refund (@refund)

                            refund_notice = "Refund #{@refund.code} created"
                        end
                    end
                end

                begin
                    approval_approve_request(@foreign_worker, comment: approval_params[:comment])
                rescue Exception => invalid
                    if @foreign_worker.invalid?
                        flash[:error] = @foreign_worker.errors.full_messages.join(', ')
                    else
                        flash[:error] = "Failed to approve, please contact IT Support."
                    end
                    redirect_to approval_internal_employer_employer_workers_path(@employer, @foreign_worker) and return
                end
                # approval_approve_request(@foreign_worker, comment: approval_params[:comment])

                flash[:notices] = ['Foreign worker amendment request is approved']
                if !refund_notice.blank?
                    flash[:notices] << refund_notice
                end

            elsif approval_params[:decision] == 'REJECT'
                flash[:notices] = ['Foreign worker amendment request is rejected']

                if !@order.blank?

                    @order.order_items.exclude_convenient_fee.each do |order_item|
                        order_item.update_columns({
                            refunded_at: DateTime.now
                        })
                    end

                    if ["FOREIGN_WORKER_GENDER_AMENDMENT"].include?(@foreign_worker.approval_request.category)
                        category = "REJECT_FOREIGN_WORKER_GENDER_AMENDMENT"
                    else
                        category = "REJECT_FOREIGN_WORKER_AMENDMENT"
                    end

                    if @order&.amount > 0
                        order_item = @order.order_items.exclude_convenient_fee&.first
                        refund = Refund.create({
                            customerable: @order.customerable,
                            category: category,
                            payment_method_id: @order.payment_method_id,
                            amount: order_item&.amount || 0,
                            status: 'PENDING_SEND',
                            organization_id: @order.organization_id,
                            additional_information: {
                                order_id: @order.id
                            }
                        })
                        refund.refund_items.create({
                            refund_itemable: @foreign_worker,
                            amount: order_item&.amount || 0
                        })

                        ## send refund as batch instead of realtime
                        # submit_refund (refund)

                        flash[:notices] << "Refund #{refund.code} created"
                    end
                end

                if ["BLOCK_FOREIGN_WORKER", "UNBLOCK_FOREIGN_WORKER"].include?(@foreign_worker.approval_request.category)
                    fw_block_log = @foreign_worker.fw_block_logs.where({
                        action: @foreign_worker.approval_request.category.sub!('_FOREIGN_WORKER', '')
                    }).order(created_at: :desc).first
                    fw_block_log.update({
                        approval_decision: "REJECT",
                        approval_comment: approval_params[:comment],
                        approval_by: current_user.id,
                        approval_at: Time.now
                    }) if fw_block_log
                end

                approval_reject_request(@foreign_worker, comment: approval_params[:comment])

            elsif approval_params[:decision] == 'REVERT'
                flash[:notice] = 'Foreign worker amendment request is reverted'
                approval_revert_request(@foreign_worker, comment: approval_params[:comment])
            end

        end
        # /db-transaction
        redirect_to @redirect_to
    end

    def activate
    end

    def activate_update
        update_ok = @foreign_worker.update({
            status: params[:foreign_worker][:status]
        })
        if update_ok
            redirect_to internal_employer_employer_worker_path(@employer, @foreign_worker), notice: "Foreign worker status successfully updated"
        else
            render :activate
        end
    end

    def deactivate
    end

    def deactivate_update
        update_ok = @foreign_worker.update({
            status: params[:foreign_worker][:status]
        })
        if update_ok
            redirect_to internal_employer_employer_worker_path(@employer, @foreign_worker), notice: "Foreign worker status successfully updated"
        else
            render :deactivate
        end
    end

    def bulk_action
        if !params.has_key?(:ids)
            redirect_to internal_employer_employer_workers_url, flash: {notice: "Please select foreign worker"} and return
        end

        case params[:bulk_action]
        when 'add_cart'
            add_cart
        when 'remove_cart'
            remove_cart
        when 'register_transaction'
            register_transaction(allow_special_renewal: true)
        when 'register_transaction_no_special'
            register_transaction(allow_special_renewal: false)
        when /^purchase_insurance/  # purchase_insurance_howden, purchase_insurance_protectmigrant
            provider_code = params[:bulk_action][19..-1].upcase
            purchase_insurance(provider_code)
        when 'transfer_worker'
            transfer_worker
        end

        if @redirect_to != false
            redirect_to @redirect_to || internal_employer_employer_workers_url
        end
    end

    def block
    end

    def block_update
        @foreign_worker.assign_attributes(foreign_worker_block_params)

        # process file upload
        params[:foreign_worker][:uploads].each do |upload|
            if (!upload[:category].nil? && !upload[:documents].nil?)
                add_watermark(upload[:documents])
                upl = @foreign_worker.uploads.create(category: upload[:category])
                upl.documents.attach(upload[:documents])
            end
        end
        if params[:remove_uploaded_file].present?
            ids = params[:remove_uploaded_file].split(",")
            @foreign_worker.uploads.where(id: ids).update_all(updated_by: current_user.id, deleted_at: DateTime.now)
        end

        if @foreign_worker.blocked
            @foreign_worker.assign_attributes({
                blocked_at: Time.now,
                blocked_by: current_user.id
            })
        else
            @foreign_worker.assign_attributes({
                blocked_at: nil,
                blocked_by: nil
            })
        end

        if ["is_reg_medical_blocked", "is_sp_transmit_blocked", "is_imm_blocked", "block_reason_id", "unblock_reason_id"].none? { |key| @foreign_worker.changes.key?(key) }
            if params[:foreign_worker][:uploads].count > 0 || params[:remove_uploaded_file].present?
                flash[:notices] = ["<b style = 'color:red;'>No changes detected. Kindly refer to Block “Yes / No”</b>"]
                redirect_to "#{internal_foreign_workers_path}?code=#{@foreign_worker.code}&employer_code=#{@foreign_worker.employer.code}" and return
            else
                render :block and return
            end
        end

        fw_block_log_data = {
            action: "#{@foreign_worker.blocked ? "" : "UN"}BLOCK",
            block_reason_id: @foreign_worker.blocked ? foreign_worker_block_params[:block_reason_id] : foreign_worker_block_params[:unblock_reason_id],
            comment: @foreign_worker.blocked ? @foreign_worker.block_comment : @foreign_worker.unblock_comment,
            is_reg_medical_blocked: @foreign_worker.is_reg_medical_blocked,
            is_reg_medical_blocked_comment: @foreign_worker.is_reg_medical_blocked_comment,
            is_sp_transmit_blocked: @foreign_worker.is_sp_transmit_blocked,
            is_sp_transmit_blocked_comment: @foreign_worker.is_sp_transmit_blocked_comment,
            is_imm_blocked: @foreign_worker.is_imm_blocked,
            is_imm_blocked_comment: @foreign_worker.is_imm_blocked_comment,
            requested_by: current_user.id,
            requested_at: Time.now,
            fw_verification_par_id: params[:foreign_worker][:fw_verification_pars],
        }
        # flash[:notice] = "#{@foreign_worker.blocked ? "Block" : "Unblock"} request submitted for approval."

        approval_update_request(@foreign_worker, category: "#{@foreign_worker.blocked ? "" : "UN"}BLOCK_FOREIGN_WORKER", comment: @foreign_worker.blocked ? @foreign_worker.block_comment : @foreign_worker.unblock_comment)

        @foreign_worker.fw_block_logs.create(fw_block_log_data)

        # auto approve
        user = User.admin_user
        @foreign_worker.assign_attributes(@foreign_worker.approval_item.params)
        approval_comment = "Foreign worker #{@foreign_worker.blocked ? "block" : "unblock"} request is approved automatically"

        fw_block_log = @foreign_worker.fw_block_logs.where({
            action: @foreign_worker.approval_request.category.sub!('_FOREIGN_WORKER', '')
        }).order(created_at: :desc).first
        fw_block_log.update({
            approval_decision: "APPROVE",
            approval_comment: approval_comment,
            approval_by: user.id,
            approval_at: Time.now
        }) if fw_block_log

        begin
            approval_approve_request(@foreign_worker, user: user, comment: approval_comment)
        rescue Exception => invalid
            if @foreign_worker.invalid?
                flash[:error] = @foreign_worker.errors.full_messages.join(', ')
            else
                flash[:error] = "Failed to approve, please contact IT Support."
            end
            redirect_to approval_internal_employer_employer_workers_path(@employer, @foreign_worker) and return
        end

        if @foreign_worker.is_reg_medical_blocked? && @foreign_worker.is_imm_blocked? && @foreign_worker.block_reason.code == "SUSPECTFRAUD" &&  @foreign_worker.uploads.where(deleted_at: nil, category: ["SUSPICIOUS_IMAGE"]).present?
            @foreign_worker.transactions.update({
                is_next_transaction_re_medical: true
            })
        end

        if !@foreign_worker.blocked? && @foreign_worker.uploads.where(deleted_at: nil, category: ["FOREIGN_WORKER_IMAGE"]).present?
            @foreign_worker.transactions.update({
                is_next_transaction_re_medical: nil
            })
        end

        flash[:notices] = ["Foreign worker #{@foreign_worker.blocked ? "block" : "unblock"} request is approved automatically"]
        # end auto approve

        redirect_to "#{internal_foreign_workers_path}?code=#{@foreign_worker.code}&employer_code=#{@foreign_worker.employer.code}"
    end

    def unblock
        @foreign_worker.unblock_reason_id = BlockReason.find_by(code: "OTHER", category: "UNBLOCK").id
    end

    def unblock_update
        @foreign_worker.assign_attributes(foreign_worker_unblock_params.merge({
            blocked: false,
            blocked_at: nil,
            blocked_by: nil
        }))
        approval_update_request(@foreign_worker, category: "UNBLOCK_FOREIGN_WORKER", comment: params[:foreign_worker][:unblock_comment])

        @foreign_worker.fw_block_logs.create({
            action: "UNBLOCK",
            block_reason_id: foreign_worker_unblock_params[:unblock_reason_id],
            comment: foreign_worker_unblock_params[:unblock_comment],
            requested_by: current_user.id,
            requested_at: Time.now
        })

        flash[:notice] = "Block request submitted for approval."
        redirect_to "#{internal_foreign_workers_path}?code=#{@foreign_worker.code}&employer_code=#{@foreign_worker.employer.code}"
    end

    def monitor
        if @foreign_worker.monitoring.eql?('Y')
            flash[:error] = "Foreign worker #{@foreign_worker.code} is already under monitoring."
            redirect_to internal_employer_employer_workers_url and return
        end

        @monitor_reason = MonitorReason.find_by(code: '9')
    end

    def monitor_update
        if @foreign_worker.monitoring.eql?('Y')
            flash[:error] = "Foreign worker #{@foreign_worker.code} is already under monitoring."
            redirect_to internal_employer_employer_workers_url and return
        end

        @monitor_reason = MonitorReason.find(params[:monitor_reason_id])

        @foreign_worker.update({
            monitoring: 'Y',
            monitor_reason_id: @monitor_reason.id,
            monitor_comment: params[:monitor_comment]
        })

        flash[:notice] = "Foreign worker #{@foreign_worker.code} successfully place under monitoring."
        # redirect_to internal_employer_employer_workers_url and return
        redirect_to "#{internal_foreign_workers_path}?code=#{@foreign_worker.code}&employer_code=#{@foreign_worker.employer.code}" and return
    end

    def unmonitor
        if @foreign_worker.monitoring.eql?('N')
            flash[:error] = "Foreign worker #{@foreign_worker.code} is currently not under monitoring."
            redirect_to internal_employer_employer_workers_url and return
        end
    end

    def unmonitor_update
        if @foreign_worker.monitoring.eql?('N')
            flash[:error] = "Foreign worker #{@foreign_worker.code} is currently not under monitoring."
            redirect_to internal_employer_employer_workers_url and return
        end

        @foreign_worker.update({
            monitoring: 'N',
            unmonitor_comment: params[:unmonitor_comment]
        })

        flash[:notice] = "Foreign worker #{@foreign_worker.code} successfully removed from monitoring."
        # redirect_to internal_employer_employer_workers_url and return
        redirect_to "#{internal_foreign_workers_path}?code=#{@foreign_worker.code}&employer_code=#{@foreign_worker.employer.code}" and return
    end

    def employer
    end

    def employer_update
        if @foreign_worker.update(employer_id: params[:foreign_worker][:employer_id])
            redirect_to "#{internal_foreign_workers_path}?code=#{@foreign_worker.code}&employer_code=#{@foreign_worker.employer.code}", notice: 'Foreign Worker\'s Employer was successfully updated.'
        else
            render :employer
        end
    end

    def bulk_transfer_worker
    end

    def bulk_transfer_worker_update
        foreign_worker_ids = params[:foreign_worker_ids] || params[:ids]
        ForeignWorker.where(:id => foreign_worker_ids).each do |fw|
            if fw.employer_id == @employer.id
                fw.update(employer_supplement_id: params[:selected_employer_supplement_id])
            end
        end
        redirect_to "#{internal_employer_employer_workers_path}", notice: 'Foreign worker(s) transferred successfully.'
    end

    def approval_change_employer
        @fw_change_employer = FwChangeEmployer.where(
            foreign_worker_id: @foreign_worker.id,
            status: "APPROVAL"
        )
        .order(created_at: :desc)
        .first
    end

    def approval_change_employer_update
        @fw_change_employer = FwChangeEmployer.find(params[:fw_change_employer_id])

        if @fw_change_employer.status != 'APPROVAL'
            flash[:error] = "Approval is not allowed."
            redirect_to internal_foreign_workers_path and return
        end

        approval_decision = params.require(:approval)[:decision]
        approval_comment = params.require(:approval)[:comment]

        # default to approve
        message = 'approved'
        status = 'APPROVED'

        if approval_decision === 'REJECT'
            message = 'rejected'
            status = 'REJECTED'
        elsif approval_decision === 'REVERT'
            message = 'reverted'
            status = 'REVERTED'
        end

        respond_to do |format|
            @fw_change_employer.update({
                approval_by: current_user.id,
                approval_at: Time.now,
                decision: approval_decision,
                status: status,
                approval_comment: approval_comment
            })

            if approval_decision === 'APPROVE'
                @foreign_worker.update(employer_id: @fw_change_employer.new_employer_id)
            end

            EmployerMailer.with({
                foreign_worker: @foreign_worker,
                approval_decision: message,
                approval_comment: approval_comment,
            }).change_employer_email.deliver_later

            format.html { redirect_to internal_employer_employer_workers_url, notice: "Change employer request successfully #{message}" }
            format.json { render :show, status: :ok, location: @foreign_worker }
        end
    end

    def show_amendment_history
        @fw_amendments = @foreign_worker.fw_amendments.order(id: :desc)
        render "internal/employer_workers/_fw_amendment_logs", show_partial: false
    end
    private
    def set_employer
        @employer = Employer.find(params[:employer_id])
    end

    def set_foreign_worker
        @foreign_worker = ForeignWorker.find(params[:id])
    end

    def set_fees
        @fees = Fee.where("code in (?)", @foreign_worker.code.blank? ? ["FOC"] : ["FOREIGN_WORKER_AMENDMENT", "FOC"]).all
    end

    def foreign_worker_params
        params.require(:foreign_worker).permit(:name, :passport_number, :gender, :date_of_birth, :employer_id, :country_id, :job_type_id, :arrival_date, :plks_number, :pati, :monitoring, :blocked, :block_reason_id, :block_comment, :unblock_reason_id, :unblock_comment, :blocked_at, :blocked_by, :employer_supplement_id, :amendment_reason_comment, :amended_at, :amended_by)
    end

    def foreign_worker_block_params
        params.require(:foreign_worker).permit(:blocked, :block_reason_id, :block_comment, :unblock_reason_id, :unblock_comment, :is_reg_medical_blocked, :is_reg_medical_blocked_comment, :is_sp_transmit_blocked, :is_sp_transmit_blocked_comment, :is_imm_blocked, :is_imm_blocked_comment)
    end

    def foreign_worker_unblock_params
        params.require(:foreign_worker).permit(:blocked, :unblock_reason_id, :unblock_comment)
    end

    # bulk actions
    def register_transaction(allow_special_renewal: true)
        super(allow_special_renewal: allow_special_renewal)
    end
    # /bulk actions

    def set_fee_amount
        @fees = []

        if params[:action] == 'update'
            fee_id = params[:fee_id]
            fee = Fee.find(fee_id)
            @fees << fee
        end

        @param_gender = params[:foreign_worker][:gender]
        @transaction_gender_to_be_updated = false
        @transaction_expired = (@foreign_worker.try(:latest_transaction).try(:expired_at) <= Time.now && @foreign_worker.try(:latest_transaction).try(:ignore_expiry) == false) if !@foreign_worker.try(:latest_transaction).nil?

        if @param_gender != @foreign_worker.gender && (!['CERTIFIED','CANCELLED','REJECTED'].include?(@foreign_worker.try(:latest_transaction).try(:status)) && @foreign_worker.try(:latest_transaction).try(:medical_examination_date).blank? && !@transaction_expired ) && !@foreign_worker.try(:latest_transaction).nil?
            @transaction_gender_to_be_updated = true
            fee = Fee.find_by(code: "FOREIGN_WORKER_GENDER_AMENDMENT")
            transaction_male_fee = Fee.find_by_code('TRANSACTION_MALE').try(:amount) || 0
            transaction_female_fee = Fee.find_by_code('TRANSACTION_FEMALE').try(:amount) || 0
            if @param_gender == 'F'
                amount_diff = transaction_female_fee-transaction_male_fee
                amount = amount_diff < 0 ? 0 : amount_diff
                fee.amount = amount
                @fees << fee
            else
                amount_diff = transaction_male_fee-transaction_female_fee
                amount = amount_diff < 0 ? 0 : amount_diff
                fee.amount = amount
                @fees << fee
            end
        end
    end

    def set_order
        @order = {}
        @is_gender_changed = false
        approval_request = @foreign_worker.approval_request

        if !@foreign_worker.approval_item.params['gender'].blank? && (@foreign_worker.approval_item.params['gender'] != @foreign_worker.gender)
            @is_gender_changed = true
        end
        if !approval_request.additional_information.blank? && approval_request.additional_information.include?("order_id")
            @order = Order.find(approval_request.additional_information["order_id"])
        end
    end

end
# /class