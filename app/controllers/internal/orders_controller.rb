require 'ipay88'

class Internal::OrdersController < InternalController
    include Approvalable
    include Sage
    include OrderPaymentUpdate
    include Cart
    include RegisterTransaction
    include Jim
    include OrderDocument
    include TransactionDocument
    include Insurance
    include Paynet
    include Bolehpay


    before_action :set_order, only: [:show, :edit, :update, :destroy, :payment, :payment_update, :approval, :approval_update, :payment_status, :payment_status_backend, :payment_bankdraft, :payment_bankdraft_new, :payment_bankdraft_create, :payment_bankdraft_edit, :payment_bankdraft_update, :payment_bankdraft_destroy, :payment_bankdraft_add, :payment_bankdraft_add_update, :change_comment, :change_fee, :add_fw, :remove_fw, :update_fw, :invoice,:order_payment_edit, :order_payment_update, :remove_order_item, :requery, :requery_fpx_request, :requery_fpx_request_ae, :edit_status, :edit_status_update, :requery_boleh_request, :requery_boleh_request_ae, :check_insurance_service_provider]
    skip_before_action :authenticate_internal_user!, only: [:payment_status, :payment_status_backend]
    skip_before_action :verify_authenticity_token, :only => [:payment_status, :payment_status_backend]

    before_action -> { can_access?("VIEW_EMPLOYER_ORDER", "VIEW_MSPD_ORDER") }, only: [:index, :show]
    before_action -> { can_access?("CREATE_ORDER") }, only: [:new, :create]
    before_action -> { can_access?("EDIT_ORDER") }, only: [:edit, :update]
    before_action -> { can_access?("DELETE_ORDER") }, only: [:destroy]
    before_action -> { can_access?("PRINT_INVOICE_ORDER") }, only: [:invoice]

    before_action :set_document_numbers, only: [:show]
    before_action :check_payment_method_change, only: [:update, :remove_fw]

    before_action :check_order_status, only: [:edit, :update, :remove_fw, :change_fee, :add_fw, :update_fw, :edit_status, :edit_status_update]

    before_action :check_foreign_workers, if: -> { ['TRANSACTION_REGISTRATION','SPECIAL_RENEWAL_TRANSACTION_REGISTRATION'].include?(@order.category) && params[:submit] != 'cancel' }, only: [:update]


    has_scope :code
    has_scope :category
    has_scope :payment_method_id
    has_scope :status
    has_scope :start_date
    has_scope :end_date
    has_scope :document_number
    has_scope :customer_code
    has_scope :payment_no
    has_scope :organization_id
    has_scope :paid_start_date
    has_scope :paid_end_date

    # GET /orders
    # GET /orders.json
    def index
        @orders = apply_scopes(Order)
        .includes(:payment_method)
        .where.not(:category => 'Migration')

        customerable_types = []
        customerable_types = customerable_types + ["Employer"] if has_permission?("VIEW_EMPLOYER_ORDER")
        customerable_types = customerable_types + ["Agency"] if has_permission?("VIEW_AGENCY_ORDER")
        customerable_types = customerable_types + ["XrayFacility", "Laboratory", "Radiologist", "Doctor"] if has_permission?("VIEW_MSPD_ORDER")
        @orders = @orders.where("orders.customerable_type in (?)", customerable_types)

        @branches = Organization.where(org_type: ['BRANCH', 'HEADQUARTER'])

        @company_name = SystemConfiguration.get("COMPANY_NAME")
        @paid_start_date = params[:paid_start_date]
        @paid_end_date = params[:paid_end_date]
        @now = Time.now

        respond_to do |format|
            format.html do
                @orders  = @orders.order('orders.date DESC')
                .page(params[:page])
                .per(get_per)
            end
            format.xlsx do
                render xlsx: 'index', filename: "orders-#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx"
            end
        end
    end

    # GET /orders/1
    # GET /orders/1.json
    def show
        case @order.category
        when "TRANSACTION_REGISTRATION"
            @insurance_need_recalculate = InsuranceService.order_need_recalculate?(order: @order)
            render :show_transaction_registration and return
            #render :show_transaction_registration
        when "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION"
            @insurance_need_recalculate = InsuranceService.order_need_recalculate?(order: @order)
            render :show_special_renewal_transaction_registration
        end
    end

    # GET /orders/new
    def new
        @order = Order.new
    end

    # POST /orders
    # POST /orders.json
    def create
        @order = Order.new(order_params)

        respond_to do |format|
            if @order.save
                format.html { redirect_to internal_orders_url, notice: 'Order #{@order.code} was successfully created.' }
                format.json { render :show, status: :created, location: @order }
            else
                format.html { render :new }
                format.json { render json: @order.errors, status: :unprocessable_entity }
            end
        end
    end

    # GET /orders/1/edit
    def edit
        @has_conditional_renewal = false
        flash.now[:warnings] = []
        @payment_methods = PaymentMethod.available_for_internal_payment
        @payment_methods = @payment_methods.mspd if ['DOCTOR_CHANGE_ADDRESS','XRAY_FACILITY_CHANGE_ADDRESS','LABORATORY_CHANGE_ADDRESS','DOCTOR_REGISTRATION','XRAY_FACILITY_REGISTRATION','LABORATORY_REGISTRATION','RADIOLOGIST_REGISTRATION'].include?(@order.category)
        @payment_methods = @payment_methods.order(:name)

        # Revert back to previous selected provider
        if !params[:old_insurance_service_provider_id].blank?
            @order.update({
                insurance_service_provider_id: params[:old_insurance_service_provider_id]
            })
        end

        case @order.category
        when "TRANSACTION_REGISTRATION"
            @order.order_items.exclude_convenient_fee.exclude_insurance.each do |order_item|
                ok = get_biodata(order_item) if SystemConfiguration.get("JIM_ENABLE_GET_BIODATA") == "1"
            end
            @insurance_need_recalculate = InsuranceService.order_need_recalculate?(order: @order)
            render "internal/orders/transaction_registrations/edit"
            # render :edit_transaction_registration

        when "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION"
            @order.order_items.exclude_convenient_fee.exclude_insurance.each do |order_item|
                ok = get_biodata(order_item) if SystemConfiguration.get("JIM_ENABLE_GET_BIODATA") == "1"

                # if order_item.additional_information.key?("special_renewal_reasons") \
                #     and !order_item.additional_information["special_renewal_reasons"].blank?
                # end
            end
            @insurance_need_recalculate = InsuranceService.order_need_recalculate?(order: @order)
            render "internal/orders/special_transaction_registrations/edit"
           # render :edit_special_renewal_transaction_registration

        # when "FOREIGN_WORKER_AMENDMENT"
        #     render :edit_foreign_worker_amendment

        when "INSURANCE_PURCHASE"
            @insurance_need_recalculate = InsuranceService.order_need_recalculate?(order: @order)
            render "internal/orders/insurance_purchases/edit"

        else

        end
    end

    # PATCH/PUT /orders/1
    # PATCH/PUT /orders/1.json
    def update
        if !params[:order].blank? && !params[:order][:payment_method_id].blank?
            payment_method_code = PaymentMethod.find(params[:order][:payment_method_id]).try(:code)
            if payment_method_code == 'CIMB_CLICKS' && @order.order_items.pluck(:order_itemable_id).uniq.count > 1
                flash[:error] = "Please take note that CIMB Clicks can only make payment for 1 worker at a time."
                redirect_to (request.env["HTTP_REFERER"] || internal_root_path) and return
            end
        end

        @order.assign_attributes(order_params) if !params[:order].blank?

        case @order.category
        when "TRANSACTION_REGISTRATION"
            update_transaction_registration

        when "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION"
            update_special_renewal_transaction_registration

        when "FOREIGN_WORKER_AMENDMENT"
            update_foreign_worker_amendment

        when "INSURANCE_PURCHASE"
            update_insurance_purchase

        else
            update_default
            # flash[:error] = "Order category #{@order.category} is not supported yet";
            # redirect_to internal_orders_url
        end

        if flash.count == 0
            flash[:notice] = "Order #{@order.code} was successfully updated"
        end
        redirect_to @redirect_to || internal_orders_url
    end

    def update_default
        case params[:submit]
        when "cancel"
            @order.update({
                status: "CANCELLED"
            })
            flash[:notice] = "Order #{@order.code} cancelled"
            @redirect_to = internal_orders_path

        when "save_and_proceed_to_payment"
            if @order.payment_method_id.blank?
                flash[:error] = "Payment method is required to proceed to payment"
                @redirect_to = edit_internal_order_path @order
                return
            end
            @order.update({
                status: "PENDING_PAYMENT"
            })
            @redirect_to = payment_internal_order_path @order

        else
            flash[:error] = "Unknown action"
            @redirect_to = internal_orders_path
        end
    end

    def update_insurance_purchase
        case params[:submit]
        when "cancel"
            @order.update({
                status: "CANCELLED"
            })
            flash[:info] = "Order cancelled"
            @redirect_to = internal_orders_path
        when "save"
            fee_insurance_gross_premium = Fee.find_by(code: "INSURANCE_GROSS_PREMIUM")
            oi_ids = []
            old_fw_ids = @order.order_items.where(fee_id: Fee.find_by(code: "INSURANCE_GROSS_PREMIUM").id).pluck(:order_itemable_id)
            new_fw_ids = []

            params[:foreign_worker_ids].try(:each) do |fw_id|
                add_fw_rs = InsuranceService.order_add_fw(order: @order, fw_id: fw_id, fee: fee_insurance_gross_premium)
                if add_fw_rs.is_a? String
                    flash_add(:errors, add_fw_rs)
                else
                    oi_ids << add_fw_rs.id
                    new_fw_ids << add_fw_rs.order_itemable_id
                end
            end
            @order.order_items.where(fee_id: fee_insurance_gross_premium.id).where.not(id: oi_ids).destroy_all
            InsuranceService.order_clear_insurance(order: @order)
            @order.update_total_amount

            # if old_fw_ids.sort! != new_fw_ids.sort!
            #     @redirect_to = submit_calculator_external_insurances_path(order_id: @order.id)
            # else
                @redirect_to = edit_internal_order_path(@order)
            # end
        when "save_and_proceed_to_payment"
            @order.update({
                status: "PENDING_PAYMENT"
            })
            @redirect_to = payment_internal_order_path(@order)
        end
    end

    def update_transaction_registration
        case params[:submit]
        when "cancel"
            @order.update({
                status: "CANCELLED"
            })
            @redirect_to = internal_orders_path

        when "save"
            @order.save
            update_transaction_registration_save
            @redirect_to = edit_internal_order_path @order

        when "proceed_to_payment"

            if @order.amount > 0
                if @order.payment_method_id.nil?
                    flash[:error] = "Payment method is required to proceed to payment"
                    @redirect_to = internal_orders_path
                end
                @order.update({
                    status: "PENDING_PAYMENT"
                })
                @redirect_to = payment_internal_order_path @order
            else
                @order.update({
                    status: 'PAID',
                    paid_at: DateTime.now,
                    payment_method: PaymentMethod.find_by(code: "FOC")
                })
                payment_update_transaction_registration
                if flash.count == 0
                    flash[:notice] = "Order #{@order.code} paid"
                end
                @redirect_to = internal_transactions_path(order_code: @order.code)
            end

        when "save_and_proceed_to_payment"
            update_transaction_registration_save

            if @order.amount > 0
                if @order.payment_method_id.nil?
                    flash[:error] = "Payment method is required to proceed to payment"
                    @redirect_to = internal_orders_path
                end
                @order.update({
                    status: "PENDING_PAYMENT"
                })
                @redirect_to = payment_internal_order_path @order
            else
                @order.update({
                    status: 'PAID',
                    paid_at: DateTime.now,
                    payment_method: PaymentMethod.find_by(code: "FOC")
                })

                payment_update_transaction_registration
                if flash.count == 0
                    flash[:notice] = "Order #{@order.code} paid"
                end
                @redirect_to = internal_transactions_path(order_code: @order.code)
            end
        when "addon_insurance"
            if params[:foreign_worker_ids].blank?
                flash_add(:error, "Please select foreign workers")
            else
                fee = Fee.find_by(code: "INSURANCE_GROSS_PREMIUM")
                params[:foreign_worker_ids].each do |fw_id|
                    # add_fw_rs = purchase_insurance_add_fw(order: @order, fw_id: fw_id, fee: fee)
                    add_fw_rs = InsuranceService.order_add_fw(order: @order, fw_id: fw_id, fee: fee)
                    if add_fw_rs.is_a? String
                        flash_add(:errors, add_fw_rs)
                    end
                end
                @order.update_total_amount
            end
            @redirect_to = edit_internal_order_path(@order)
        end

    end
    # /def update_transaction_registration

    def update_transaction_registration_save
        #@order.order_items.where("order_itemable_id not in (?)", params[:foreign_worker_ids]).destroy_all

        workers = []
        failed_workers = []

        # run check on each foreign worker
        params[:foreign_worker_ids].each do |fw_id|
            foreign_worker = ForeignWorker.find(fw_id)
            if (foreign_worker.has_pending_transaction? or foreign_worker.has_pending_transaction_registration_order?)
                failed_workers << foreign_worker
            else
                workers << foreign_worker
            end
        end

        # create order item
        workers.each do |foreign_worker|
            foreign_worker = ForeignWorker.find(foreign_worker.id)
            fee = Fee.find_by(code: "TRANSACTION_#{ForeignWorker::GENDERS[foreign_worker.gender]}")
            @order.order_items.create({
                order_itemable: foreign_worker,
                fee_id: fee.id,
                amount: fee.amount,
            })
        end

    end
    # /def update_transaction_registration_save

    def update_special_renewal_transaction_registration
        case params[:submit]
        when "cancel"
            @order.update({
                status: "CANCELLED"
            })
            flash[:notice] = "Order #{@order.code} cancelled"
            @redirect_to = internal_orders_path

        # new flow, pay first, approval later
        when "save_and_proceed_to_payment"
            # params[:comment].each do |c|
            #     OrderItem.find(c[0]).update({
            #         comment: c[1]
            #     })
            # end
            @order.order_items.update({
                comment: "unfit-branch"
            })

            if @order.amount > 0
                @order.update({
                    status: "PENDING_PAYMENT"
                })
                @redirect_to = payment_internal_order_path
            else
                @order.update({
                    status: 'PAID',
                    paid_at: DateTime.now,
                    payment_method: PaymentMethod.find_by(code: "FOC")
                })

                payment_update_special_renewal_transaction_registration
                flash[:notice] = "Payment successful for order #{@order.code}, transaction created and pending for special renewal document"
                @redirect_to = internal_transactions_path(order_code: @order.code)
            end

        when "addon_insurance"
            if params[:foreign_worker_ids].blank?
                flash_add(:error, "Please select foreign workers")
            else
                fee = Fee.find_by(code: "INSURANCE_GROSS_PREMIUM")
                params[:foreign_worker_ids].each do |fw_id|
                    # add_fw_rs = purchase_insurance_add_fw(order: @order, fw_id: fw_id, fee: fee)
                    add_fw_rs = InsuranceService.order_add_fw(order: @order, fw_id: fw_id, fee: fee)
                    if add_fw_rs.is_a? String
                        flash_add(:errors, add_fw_rs)
                    end
                end
                @order.update_total_amount
            end
            @redirect_to = edit_internal_order_path(@order)
        end

=begin
        # old flow, appproval first before payment
        when "save_and_proceed_to_approval"
            params[:comment].each do |c|
                OrderItem.find(c[0]).update({
                    comment: c[1]
                })
            end
            @order.update({
                status: "PENDING_APPROVAL"
            })
            flash[:info] = "Order #{@order.code} submitted for approval"
            @redirect_to = internal_orders_path
        end
=end
    end

    def change_comment
        @order.order_items.find(params[:order_item_id]).update({
            comment: params[:comment]
        })
        redirect_to edit_internal_order_path(@order)
    end

    def change_fee
        @order.order_items.find(params[:order_item_id]).update({
            fee_id: params[:fee_id],
            amount: Fee.find(params[:fee_id]).amount
        })
        @order.update_total_amount
        redirect_to edit_internal_order_path(@order)
    end

    def add_fw
        check_result = check_fw(params[:foreign_worker_id])
        foreign_worker = check_result[:foreign_worker]
        flash[:errors] = []
        if check_result[:failed_messages].length > 0
            flash[:errors].concat check_result[:failed_messages]
            redirect_to edit_internal_order_path(@order) and return
        end

        if check_result[:special_renewal]
            flash[:errors].concat check_result[:warning_messages]
            redirect_to edit_internal_order_path(@order) and return
        end

        fee = Fee.find_by(code: "TRANSACTION_#{ForeignWorker::GENDERS[foreign_worker.gender]}")
        @order.order_items.create({
            order_itemable: foreign_worker,
            fee_id: fee.id,
            amount: fee.amount,
        })
        @order.update_total_amount
        redirect_to edit_internal_order_path(@order)
    end

    def remove_fw
        @order.order_items.where("order_items.order_itemable_id = ?", params[:foreign_worker_id]).first.destroy
        @order.update_total_amount
        flash[:info] = "Foreign worker removed"
        redirect_to edit_internal_order_path(@order)
    end

    def update_fw
        foreign_worker = ForeignWorker.find(params[:foreign_worker_id])
        order_item = OrderItem.find(params[:order_item_id])

        foreign_worker.assign_attributes(foreign_worker_params)
        foreign_worker.maid_online = params[:programme].blank? ? "FOMEMA" : params[:programme].first

        if foreign_worker.invalid?
            flash[:error] = foreign_worker.errors.full_messages.join(', ')
            redirect_to edit_internal_order_path(@order) and return
        end

        changes = {}
        foreign_worker.changes.each do |k, v|
            changes[k] = v[1]
        end

        order_item.additional_information = {} if order_item.additional_information.blank?
        order_item.additional_information[:foreign_worker] = changes
        order_item.save

        redirect_to edit_internal_order_path(@order)
    end

    def foreign_worker_params
        params.require(:foreign_worker).permit(:name, :passport_number, :gender, :date_of_birth, :employer_id, :country_id, :job_type_id, :arrival_date, :plks_number, :pati, :monitoring, :blocked, :block_reason_id, :block_comment, :unblock_reason_id, :unblock_comment, :blocked_at, :blocked_by, :employer_supplement_id, :amendment_reason_comment, :amended_at, :amended_by)
    end

    def update_foreign_worker_amendment
        case params[:submit]
        when "cancel"
            @order.update({
                status: "CANCELLED"
            })
            @order.order_items.where("order_items.fee_id in (select id from fees where code = 'FOREIGN_WORKER_AMENDMENT')").each do |order_item|
                foreign_worker = order_item.order_itemable
                approval_reject_request(foreign_worker, comment: "Order cancelled") if foreign_worker.approval_request
            end
            flash[:notice] = "Order #{@order.code} cancelled"
            @redirect_to = internal_orders_path

        when "save_and_proceed_to_payment"
            if @order.payment_method_id.blank?
                flash[:error] = "Payment method is required to proceed to payment"
                @redirect_to = edit_internal_order_path(@order) and return
            end
            @order.update({
                status: "PENDING_PAYMENT"
            })
            @redirect_to = payment_internal_order_path @order

        else
            flash[:error] = "Unknown action"
            @redirect_to = internal_orders_path
        end
    end

    # DELETE /orders/1
    # DELETE /orders/1.json
    def destroy
        @order.destroy
        respond_to do |format|
            format.html { redirect_to internal_orders_url, notice: "Order #{@order.code} was successfully destroyed." }
            format.json { head :no_content }
        end
    end

    def approval
        case @order.category
        when "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION"
            render :approval_special_renewal_transaction_registration
        end
    end

    def approval_update
        if approval_params[:decision] == "APPROVE"
            @order.update({
                status: "PENDING_PAYMENT"
            })
            flash[:notice] = "Order #{@order.code} approved, currently pending for payment"
        elsif approval_params[:decision] == "REJECT"
            @order.update({
                status: "REJECTED",
                comment: approval_params[:comment]
            })
            flash[:notice] = "Order #{@order.code} rejected"
        end
        redirect_to internal_orders_path
    end

    def payment
        insurance_check = check_insurance_service_provider
        if insurance_check.is_a? String
            flash[:error] = insurance_check
            redirect_to (request.env["HTTP_REFERER"] || external_orders_path) and return
        end

        case @order.payment_method.code
        when "BANKDRAFT"
            render :bankdraft and return

        when "IPAY88"
            # if @order.customerable_type.downcase == 'employer'
            #     getBiodata
            # end

            request_data = {
                merchant_code: IPay88.merchant_code,
                merchant_key: IPay88.merchant_key,
                amount: Rails.env.eql?("production") ? @order.amount : 1,
                currency: IPay88.currency,
                product_description: @order.category,
                user_name: @order.customerable.name,
                user_email: @order.customerable.email,
                user_contact: @order.customerable.phone,
                remark: "order id: #{@order.id}",
                lang: IPay88.lang,
                signature_type: IPay88.signature_type,
                response_url: "https://#{ENV["SUBDOMAIN_NIOS"].downcase}.#{ENV["APP_DOMAIN"].downcase}#{payment_status_internal_order_path(@order)}",
                backend_url: "https://#{ENV["SUBDOMAIN_NIOS"].downcase}.#{ENV["APP_DOMAIN"].downcase}#{payment_status_backend_internal_order_path(@order)}",
                payment_url: IPay88.payment_url
            }
            @ipay88_request = @order.ipay88_requests.create(request_data)
            # @ipay88_request = @order.ipay88_requests.first
            render :ipay88 and return

        else
            @order_payment = @order.latest_order_payment || OrderPayment.new({
                order_id: @order.id,
                amount: @order.amount
            })
            render :payment_default and return
        end
    end

    def payment_update
        case @order.payment_method.code
        when "BANKDRAFT"
            if @order.bank_draft_allocations.sum(:amount).to_f != @order.amount.to_f
                flash[:error] = "Payment amount and order amount do not match"
                redirect_to payment_internal_order_path @order and return
            end

            # if @order.customerable_type.downcase == 'employer'
            #     getBiodata
            # end
        when "IPAY88"
        else
            @order_payment = @order.latest_order_payment || OrderPayment.new({
                order_id: @order.id,
                amount: @order.amount
            })
            @order_payment.assign_attributes(order_payment_params)

            if !@order_payment.valid?
                render :payment_default and return
            end

            ## if payment has already been refund
            if ['CIMB_CLICKS'].include?(@order.payment_method.code)
                refund = Refund.where(:payment_method_id => @order.payment_method_id, :payment_date => @order_payment.issue_date, :amount => @order_payment.amount, :reference => @order_payment.reference).where.not(:status => ['CANCELLED'])

                if !refund.blank?
                    flash[:error] = 'Payment info found in refund, cannot be use as payment.'
                    redirect_to (request.env["HTTP_REFERER"] || payment_internal_order_path(@order)) and return
                end
            end

            @order_payment.save
        end

        @order.update({
            status: "PAID"
        })

        case @order.category
        when "TRANSACTION_REGISTRATION"
            payment_update_transaction_registration
            @redirect_to = internal_transactions_path(order_code: @order.code)

            # insurance
            if InsuranceService.order_has_insurance?(order: @order)
                InsuranceService.generate_worker_code(order: @order)
                flash_add(:notices, "Payment successful, insurance purchased.")
                # @redirect_to = submit_paid_premium_external_insurances_path(@order)
                SubmitPaidInsuranceJob.perform_later(order: @order, response_url: policy_internal_insurances_url, backend_url: policy_internal_insurances_url)
            end

        when "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION"
            payment_update_special_renewal_transaction_registration
            flash[:notice] = "Payment successful for order #{@order.code}, transaction created and pending for approval"
            @redirect_to = internal_transactions_path(order_code: @order.code)

            # insurance
            if InsuranceService.order_has_insurance?(order: @order)
                InsuranceService.generate_worker_code(order: @order)
                flash_add(:notices, "Payment successful, insurance purchased.")
                # @redirect_to = submit_paid_premium_external_insurances_path(@order)
                SubmitPaidInsuranceJob.perform_later(order: @order, response_url: policy_internal_insurances_url, backend_url: policy_internal_insurances_url)
            end

        when "TRANSACTION_CHANGE_DOCTOR"
            payment_update_transaction_change_doctor
            flash[:notice] = "Payment successful for order #{@order.code}, change doctor request is now pending for approval"
            @redirect_to = internal_transactions_path

        when "FOREIGN_WORKER_AMENDMENT"
            payment_update_foreign_worker_amendment

        when "DOCTOR_REGISTRATION", "LABORATORY_REGISTRATION", "XRAY_FACILITY_REGISTRATION", "RADIOLOGIST_REGISTRATION"
            flash[:notice] = "Order #{@order.code} paid, may proceed to activate"
            @redirect_to = send("internal_#{@order.category.gsub("_REGISTRATION", "").downcase}_path", @order.customerable)

        when "DOCTOR_CHANGE_ADDRESS", "LABORATORY_CHANGE_ADDRESS", "XRAY_FACILITY_CHANGE_ADDRESS"
            # payment_update_sp_change_address
            @redirect_to = send("internal_#{@order.category.gsub("_CHANGE_ADDRESS", "").downcase.pluralize}_path")

        when "DOCTOR_BIOMETRIC_DEVICE", "XRAY_FACILITY_BIOMETRIC_DEVICE"
            payment_update_biometric_device
            flash[:notice] = "Biometric device order #{@order.code} paid"
            @redirect_to = send("internal_#{@order.category.gsub("_BIOMETRIC_DEVICE", "").downcase.pluralize}_path")

        when "TRANSACTION_EXTENTION"
            payment_update_transaction_extention
            transaction = @order.order_items.try(:first).try(:order_itemable)
            flash[:notice] = "Transaction extended"
            @redirect_to = internal_transactions_path(:code => transaction&.code)
        when "REPRINT_MEDICAL_FORM"
            @transaction_ids = @order.additional_information["transaction_ids"]
            @redirect_to = reprint_medical_form_internal_transactions_path(order_code: @order.code)
        when "TRANSACTION_CANCELLATION"
            payment_update_transaction_cancellation
        when "FOREIGN_WORKER_GENDER_AMENDMENT"
            payment_update_foreign_worker_gender_amendment

        when "INSURANCE_PURCHASE"
            InsuranceService.generate_worker_code(order: @order)
            flash_add(:notices, "Payment successful, insurance purchased.")
            # @redirect_to = submit_paid_premium_external_insurances_path(@order)
            @redirect_to = internal_orders_path
            SubmitPaidInsuranceJob.perform_later(order: @order, response_url: policy_internal_insurances_url, backend_url: policy_external_insurances_url)
        end

        if flash.count == 0
            flash[:notice] = "Order #{@order.code} paid"
        end
        redirect_to @redirect_to || internal_orders_path
    end

    def payment_update_sp_change_address
        @order.order_items.each do |order_item|
            approval_approve_request(order_item.order_itemable)
        end
    end

    def remove_order_item
        order_item = @order.order_items.find(params[:oi_id])
        if ["TRANSACTION_REGISTRATION"].include?(@order.category) && ["TRANSACTION_MALE", "TRANSACTION_FEMALE"].include?(order_item.fee&.code)
            @order.order_items.where({
                order_itemable_id: order_item.order_itemable_id,
                order_itemable_type: order_item.order_itemable_type
            }).where.not(id: order_item.id).destroy_all
        end
        order_item.destroy
        InsuranceService.order_clear_insurance(order: @order)
        redirect_back fallback_location: edit_internal_order_path(@order)
    end

    def payment_status
        ipay88_request = @order.ipay88_requests.find_by(reference_number: params["RefNo"])
        ipay88_response_data = {
            response_category: "RESPONSE",
            merchant_code: params["MerchantCode"],
            payment_id: params["PaymentId"],
            reference_number: params["RefNo"],
            amount: params["Amount"],
            currency: params["Currency"],
            remark: params["Remark"],
            transaction_id: params["TransId"],
            authentication_code: params["AuthCode"],
            status: params["Status"],
            error_description: params["ErrDesc"],
            signature: params["Signature"],
            cc_name: params["CCName"],
            cc_number: params["CCNo"],
            s_bank_name: params["S_bankname"],
            s_country: params["S_country"],
            bank_mid: params["BankMID"],
            transaction_date: params["TranDate"]
        }
        @ipay88_response = ipay88_request.ipay88_responses.create(ipay88_response_data)
        if @ipay88_response.calculate_signature(@order&.payment_method) != @ipay88_response.signature
            flash[:error] = "Signature not match!"
            redirect_to internal_orders_path and return
        end

        case @ipay88_response.status
        when "1"
            @order.update({
                status: "PAID"
            })
            payment_update
        else
            @order.update({
                status: "FAILED"
            })
            flash[:error] = "Payment unsuccessfull, #{params["ErrDesc"]}"
            redirect_to internal_orders_path and return
        end
    end

    def payment_status_backend
        ipay88_request = @order.ipay88_requests.find_by(reference_number: params["RefNo"])
        ipay88_response_data = {
            response_category: "BACKEND",
            merchant_code: params["MerchantCode"],
            payment_id: params["PaymentId"],
            reference_number: params["RefNo"],
            amount: params["Amount"],
            currency: params["Currency"],
            remark: params["Remark"],
            transaction_id: params["TransId"],
            authentication_code: params["AuthCode"],
            status: params["Status"],
            error_description: params["ErrDesc"],
            signature: params["Signature"],
            cc_name: params["CCName"],
            cc_number: params["CCNo"],
            s_bank_name: params["S_bankname"],
            s_country: params["S_country"],
            bank_mid: params["BankMID"],
            transaction_date: params["TranDate"]
        }
        @ipay88_response = ipay88_request.ipay88_responses.create(ipay88_response_data)
    end

    def payment_bankdraft
        @bank_drafts = @order.customerable.bank_drafts
        .where("not exists (select 1 from bank_draft_allocations where bank_drafts.id = bank_draft_allocations.bank_draft_id and bank_draft_allocations.allocatable_id = ? and bank_draft_allocations.allocatable_type = 'Order')", @order.id)
        .where("bank_drafts.amount_allocated < bank_drafts.amount")
        .where('bank_drafts.bad = ?','false')
        .page(params[:page])
        .per(get_per)
    end

    def payment_bankdraft_new
        @amount_allocate = @order.amount - @order.bank_draft_allocations.sum(:amount)
        @bank_draft = @order.customerable.bank_drafts.new
    end

    def payment_bankdraft_create
        bank_draft_data = payment_bankdraft_params
        @bank_draft = @order.customerable.bank_drafts.new(bank_draft_data)
        @amount_allocate = params[:amount_allocate].to_f

        if (@bank_draft.amount < @amount_allocate)
            @bank_draft.errors.add(:base, "Amount allocate cannot be be more than amount")
            render :payment_bankdraft_new and return
        end

        @bank_draft.save
        if @bank_draft.errors.count > 0
            render :payment_bankdraft_new and return
        end

        @bank_draft_allocation = @bank_draft.bank_draft_allocations.create({
            allocatable: @order,
            amount: @amount_allocate
        })
        flash[:notice] = "Bank draft created"
        redirect_to payment_internal_order_path @order
    end

    def payment_bankdraft_edit
        @bank_draft_allocation = @order.bank_draft_allocations.find_by(bank_draft_id: params[:bank_draft_id])
        @bank_draft = @bank_draft_allocation.bank_draft
        @amount_allocate = @bank_draft_allocation.amount
    end

    def payment_bankdraft_update
        @bank_draft_allocation = @order.bank_draft_allocations.find_by(bank_draft_id: params[:bank_draft_id])
        @bank_draft = @bank_draft_allocation.bank_draft
        @amount_allocate = params[:amount_allocate].to_f
        @bank_draft.assign_attributes(payment_bankdraft_params)

        if (@bank_draft.amount - @bank_draft.bank_draft_allocations.where("bank_draft_allocations.allocatable_id != ? and bank_draft_allocations.allocatable_type = 'Order'", @order.id).sum(:amount)) < @amount_allocate
            @bank_draft.errors.add(:base, "Total allocated amount is more than bank draft amount")
            render :payment_bankdraft_edit and return
        end

        if @bank_draft.amount_allocated > @bank_draft.amount
            @bank_draft.errors.add(:base, "Amount cannot be lower than the amount that has already been allocated")
            render :payment_bankdraft_edit and return
        end

        @bank_draft.save
        if @bank_draft.errors.count > 0
            render :payment_bankdraft_edit and return
        end

        @bank_draft_allocation.update({
            amount: @amount_allocate
        })
        flash[:notice] = "Bank draft and allocation updated"
        redirect_to payment_internal_order_path @order
    end

    def payment_bankdraft_add
        @bank_draft = BankDraft.find(params[:bank_draft_id])

        if @bank_draft.bad
            flash[:error] = "Unable to proceed with bad bank draft (#{@bank_draft.number})"
            redirect_to (request.env["HTTP_REFERER"] || internal_root_path) and return
        end

        @bank_draft_allocation = @order.bank_draft_allocations.new
        @amount_allocate = @order.amount - @order.bank_draft_allocations.sum(:amount)
    end

    def payment_bankdraft_add_update
        @bank_draft = BankDraft.find(params[:bank_draft_id])
        @amount_allocate = params[:amount_allocate].to_f
        @bank_draft_amount = params[:bank_draft][:amount].to_f

        if (@bank_draft.amount - @bank_draft.amount_allocated) < @amount_allocate
            @bank_draft.errors.add(:base, "Total allocated amount is more than bank draft amount")
            render :payment_bankdraft_add and return
        end

        if @bank_draft.amount_allocated > @bank_draft_amount
            @bank_draft.errors.add(:base, "Amount cannot be lower than the amount that has already been allocated")
            render :payment_bankdraft_add and return
        end

        @bank_draft.update(payment_bankdraft_params)
        @bank_draft_allocation = @order.bank_draft_allocations.where(bank_draft_id: params[:bank_draft_id]).first_or_create
        @bank_draft_allocation.update(amount: @amount_allocate)
        flash[:notice] = "Bank draft added"
        redirect_to payment_internal_order_path @order
    end

    def payment_bankdraft_destroy
        @bank_draft_allocation = @order.bank_draft_allocations.find_by(bank_draft_id: params[:bank_draft_id])
        @bank_draft_allocation.destroy
        flash[:notice] = "Bank draft removed"
        redirect_to payment_internal_order_path @order
    end

    def requery
        if @order.payment_method.code.start_with? "IPAY"
            flash[:error] = "There is no requery implemented for this payment method."
            redirect_to internal_orders_path and return
        elsif @order.payment_method.code.start_with? "SWIPE"
            flash[:error] = "There is no requery implemented for this payment method."
            redirect_to internal_orders_path and return
        elsif @order.payment_method.code.start_with? "PAYNET"
            redirect_to requery_fpx_request_internal_order_path @order
        elsif @order.payment_method.code.start_with? "BOLEH"
            redirect_to requery_boleh_request_internal_order_path @order
        else
            flash[:error] = "There is no requery implemented for this payment method."
            redirect_to internal_orders_path and return
        end
    end

    def requery_fpx_request
        @fpx_requests = @order.fpx_requests.where(msg_token: Fpx.msg_token(@order.payment_method)).order(:id)
    end

    def requery_fpx_request_ae
        if ["PAID", "FAILED", "CANCELLED", "NEW"].include?(@order.status) and request.msg_type == 'AR' and request.has_sync_date?
            flash[:error] = "You are not allowed to requery the status for order #{@order.code}."
            redirect_to requery_fpx_request_internal_order_path and return
        end

        fpx_request = @order.fpx_requests.find_by(id: params[:fpx_request_id])

        request_data = {
            msg_type: "AE",
            msg_token: fpx_request.msg_token,
            seller_ex_id: fpx_request.seller_ex_id,
            seller_ex_order_no: fpx_request.seller_ex_order_no,
            seller_txn_time: fpx_request.seller_txn_time,
            seller_order_no: fpx_request.seller_order_no,
            seller_id: fpx_request.seller_id,
            seller_bank_code: fpx_request.seller_bank_code,
            txn_currency: fpx_request.txn_currency,
            txn_amount: fpx_request.txn_amount,
            buyer_email: fpx_request.buyer_email,
            buyer_name: fpx_request.buyer_name,
            buyer_bank_id: fpx_request.buyer_bank_id,
            product_description: fpx_request.product_description,
            version: fpx_request.version,
            payment_url: Fpx.payment_requery_url
        }
        @fpx_request = @order.fpx_requests.create(request_data)

        submit_authorization_enquiry(@fpx_request)
        redirect_to requery_fpx_request_internal_order_path
    end

    def edit_status
        if !@order.payment_method.code.start_with?('IPAY_FPX', 'SWIPE_', 'PAYNET', 'BOLEH') or ["PAID", "FAILED", "CANCELLED", "NEW"].include?(@order.status)
            flash[:error] = "You are not allowed to amend the status for order #{@order.code}."
            redirect_to internal_orders_path and return
        end
    end

    def edit_status_update
        if !@order.payment_method.code.start_with?('IPAY_FPX', 'SWIPE_', 'PAYNET', 'BOLEH') or ["PAID", "FAILED", "CANCELLED", "NEW"].include?(@order.status)
            flash[:error] = "You are not allowed to amend the status for order #{@order.code}."
            redirect_to internal_orders_path and return
        else
            respond_to do |format|
                order_status_before_update = @order.status
                if @order.update(order_status_params)
                    if !['FAILED'].include?(order_status_before_update)
                        case @order.category
                        when "AGENCY_REGISTRATION", "AGENCY_RENEWAL"
                            failed_payment_update_recreate_order
                        end
                    end

                    format.html { redirect_to internal_orders_url, notice: "Order status for #{@order.code} updated successfully." }
                    format.json { render :show, status: :ok, location: @state }
                else
                    format.html { render :edit_status }
                    format.json { render json: @state.errors, status: :unprocessable_entity }
                end
            end
        end
    end

    def requery_boleh_request
        @boleh_requests = @order.boleh_requests.where(order_id: @order.id).order(:id)
    end

    def requery_boleh_request_ae
        if ["PAID", "FAILED", "CANCELLED", "NEW"].include?(@order.status) and request.msg_type == 'AR' and request.has_sync_date?
            flash[:error] = "You are not allowed to requery the status for order #{@order.code}."
            redirect_to requery_boleh_request_internal_order_path and return
        end

        boleh_request = @order.boleh_requests.find_by(id: params[:boleh_request_id])

        request_data = {
            msg_type: "AE",
            order_number: boleh_request.order_number,
            ex_order_number: boleh_request.ex_order_number,
            amount: boleh_request.amount,
            remark: boleh_request.remark,
            payment_url: Boleh.payment_requery_url,
            signature_type: boleh_request.signature_type,
            signature: boleh_request.signature,
        }
        @boleh_request = @order.boleh_requests.create(request_data)

        submit_requery(@boleh_request)
        redirect_to requery_boleh_request_internal_order_path
    end

    def check_insurance_service_provider
        # To recheck order's insurance service provider
        @order.insurance_purchases.try(:each) do |insurance_purchase|
            message = "Insurance service provider not match. Please click on the 'Calculate Insurance Premium' button to recalculate premium again."
            return message if insurance_purchase.insurance_service_provider_id != @order.insurance_service_provider_id
        end
        return true
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
        @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
        params.require(:order).permit(:payment_method_id)
    end

    def order_payment_params
        params.require(:order_payment).permit(:reference, :amount, :comment, :issue_date)
    end

    def payment_bankdraft_params
        params.require(:bank_draft).permit(:number, :bank_id, :issue_date, :issue_place, :zone_id, :amount)
    end

    def order_status_params
        params.require(:order).permit(:status)
    end

    def set_document_numbers
        @document_numbers = Order.get_document_numbers(@order.id)
    end

    def check_payment_method_change
        check = false
        if !params[:order].blank? && !params[:order][:payment_method_id].blank?
            payment_method = PaymentMethod.find(params[:order][:payment_method_id])
            if @order.payment_method_id != payment_method.id || ['cancel','remove_fw'].include?(params[:submit])
                check = true
            end
        end

        if (['cancel'].include?(params[:submit]) || ['remove_fw'].include?(params[:action]) ) && @order&.payment_method&.code == 'BANKDRAFT'
            check = true
        end

        if check
            ## check if bank draft has allocation done already
            allocation = BankDraftAllocation.where(:allocatable_type => 'Order',:allocatable_id => @order.id)
            if !allocation.blank?
                flash[:error] = "Unable to update order when there's draft allocated to it. Please remove the allocation before doing amendment."
                redirect_to (request.env["HTTP_REFERER"] || internal_root_path) and return
            end
        end
    end

    def check_foreign_workers
        if (@order.category == 'TRANSACTION_REGISTRATION' && params[:foreign_worker_ids].blank?) || (@order.category == 'SPECIAL_RENEWAL_TRANSACTION_REGISTRATION' && @order.order_items.blank?)
            ## foreign worker registration cannot be blank
            flash[:error] = "Foreign worker(s) cannot be blank."
            redirect_to (request.env["HTTP_REFERER"] || internal_root_path) and return
        end
    end

    def check_order_status
        if ['PAID'].include?(@order.status)
            flash[:info] = "Order #{@order.code} has paid successfully and cannot be amended."
            redirect_to internal_orders_path and return
        elsif ['CANCELLED'].include?(@order.status)
            flash[:info] = "Order #{@order.code} has been cancelled and cannot be amended."
            redirect_to internal_orders_path and return
        end
    end

 end
# /class