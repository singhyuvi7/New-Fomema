class External::OrdersController < ExternalController
    require "json"
    require "ipay88"
    require "swipe"
    require "fpx"
    require "boleh"
    include Approvalable
    include Sage
    include OrderPaymentUpdate
    include Jim
    include OrderDocument
    include TransactionDocument
    include Insurance
    include Paynet
    include ProfileInfoCheck
    include Bolehpay

    before_action :set_order, only: [:show, :edit, :update, :destroy, :payment, :payment_update, :payment_status, :payment_status_backend, :swipe_payment_status, :swipe_payment_status_backend, :doctor, :doctor_update, :invoice, :remove_order_item, :fpx_payment, :fpx_payment_confirmation, :boleh_payment_status, :boleh_payment_status_backend, :check_insurance_service_provider]
    skip_before_action :authenticate_external_user!, only: [:payment_status, :payment_status_backend, :swipe_payment_status, :swipe_payment_status_backend, :fpx_payment_status, :fpx_payment_status_backend, :boleh_payment_status, :boleh_payment_status_backend]
    skip_before_action :verify_authenticity_token, :only => [:payment_status, :payment_status_backend, :swipe_payment_status, :swipe_payment_status_backend, :fpx_payment_status, :fpx_payment_status_backend, :boleh_payment_status, :boleh_payment_status_backend]

    before_action :check_order_status, only: [:edit, :update, :payment]
    before_action :add_convenient_fee, only: [:update]
    before_action :double_check_convenient_fee, only: [:payment]
    before_action -> { pending_profile_update?(Employer.find_by(id: current_user.userable_id)) }, if: -> { current_user.userable_type == 'Employer' }, only: [ :index]

    has_scope :code
    has_scope :start_date
    has_scope :end_date
    has_scope :category
    has_scope :status
    has_scope :paid_start_date
    has_scope :paid_end_date

    def index
        query = apply_scopes(Order).where(customerable: current_user.userable).where.not(:category => ['Migration','FOREIGN_WORKER_AMENDMENT'])

        if ["Employer", "Agency"].include?(current_user.userable_type) and !current_user.employer_supplement_id.blank?
            query = query.where(created_by: current_user.id)
        end

        if !params[:exclude_status].blank?
            query = query.where.not(status: params[:exclude_status].split(','))
        end

        @orders = query.order('created_at DESC').page(params[:page])
        .per(get_per)
    end

    def show
        case @order.category
        when "TRANSACTION_REGISTRATION"
            @insurance_need_recalculate = InsuranceService.order_need_recalculate?(order: @order)
            render :show_transaction_registration and return
        when "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION"
            @insurance_need_recalculate = InsuranceService.order_need_recalculate?(order: @order)
            render :show_special_renewal_transaction_registration and return
        else
        end
    end

    def new
        @order = Order.new
    end

    def create
    end

    def edit
        # Revert back to previous selected provider
        if !params[:old_insurance_service_provider_id].blank?
            @order.update({
                insurance_service_provider_id: params[:old_insurance_service_provider_id]
            })
        end

        case @order.category
        when "TRANSACTION_REGISTRATION"
            @has_plks_optional = false
            @has_conditional_renewal = false
            @has_ignore_renewal= false
            flash.now[:warnings] = []
            @order.order_items.exclude_convenient_fee.exclude_insurance.each do |order_item|
                ok = get_biodata(order_item) if SystemConfiguration.get("JIM_ENABLE_GET_BIODATA") == "1"
                # flash.now[:warnings] << "#{order_item.order_itemable&.name} failed to retrieve biodata" if !ok

                # RTK checking
                biodata_response = BiodataResponse.where(foreign_worker_id: order_item.order_itemable_id).order(:id).last
                foreign_worker = order_item.order_itemable
                if !biodata_response.nil? && (foreign_worker.maid_online == 'RTK') && !(biodata_response.pra_create_id == 'RTK')
                   # flash.now[:warnings] << "Worker #{foreign_worker.name}, passport No. #{foreign_worker.passport_number} is not under Programme Recalibration. Please uncheck Recalibration Programme in Worker Amendment page. Failing to do so will result in your worker's medical result blocked from sending to Immigration Department."
                end
            end
            @insurance_need_recalculate = InsuranceService.order_need_recalculate?(order: @order)
            render "external/orders/transaction_registrations/edit"
            # render :edit_transaction_registration

        when "TRANSACTION_CHANGE_DOCTOR"
            render :edit_transaction_change_doctor

        when "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION"
            flash.now[:warnings] = []
            @order.order_items.exclude_convenient_fee.exclude_insurance.each do |order_item|
                ok = get_biodata(order_item) if SystemConfiguration.get("JIM_ENABLE_GET_BIODATA") == "1"

                # RTK checking
                biodata_response = BiodataResponse.where(foreign_worker_id: order_item.order_itemable_id).order(:id).last
                foreign_worker = order_item.order_itemable
                if !biodata_response.nil? && (foreign_worker.maid_online == 'RTK') && !(biodata_response.pra_create_id == 'RTK')
                   # flash.now[:warnings] << "Worker #{foreign_worker.name}, passport No. #{foreign_worker.passport_number} is not under Programme Recalibration. Please uncheck Recalibration Programme in Worker Amendment page. Failing to do so will result in your worker's medical result blocked from sending to Immigration Department."
                end
            end
           @insurance_need_recalculate = InsuranceService.order_need_recalculate?(order: @order)
           render "external/orders/special_renewal_transaction_registrations/edit_special_renewal"

        when "INSURANCE_PURCHASE"
            @insurance_need_recalculate = InsuranceService.order_need_recalculate?(order: @order)
            render "external/orders/insurance_purchases/edit"

        when "FOREIGN_WORKER_GENDER_AMENDMENT"
            fw_order_items = @order.order_items.exclude_convenient_fee.where(order_itemable_type: 'ForeignWorker')
            fw_order_items.try(:each) do |fw_order_item|
                foreign_worker = fw_order_item.order_itemable
                gender_amendment_transaction_id = fw_order_item.get_additional_information_transaction_id

                @order_valid = true

                if gender_amendment_transaction_id != foreign_worker.latest_transaction_id
                    @order_valid = false
                    flash[:notices] = ["The foreign worker has newer transaction. Please click on the 'Cancel payment' button to cancel the order."]
                elsif foreign_worker.latest_transaction.expired_at <= Time.now
                    @order_valid = false
                    flash[:notices] = ["Gender amendment is not allowed due to the foreign worker's transaction has been expired. Please click on the 'Cancel payment' button to cancel the order before proceed to amend the gender."]
                elsif !foreign_worker.latest_transaction.medical_examination_date.blank?
                    @order_valid = false
                    flash[:notices] = ["Gender amendment is not allowed due to the foreign worker's transaction has been examined. Please click on the 'Cancel payment' button to cancel the order before proceed to amend the gender."]
                end
            end
            render :edit_foreign_worker_gender_amendment

        when "AGENCY_REGISTRATION", "AGENCY_RENEWAL"
            render "external/orders/agency_registrations/edit"

        end
    end

    def update
        if !params[:order].blank?
            @order.update(order_params)
        end

        case @order.category
        when "TRANSACTION_REGISTRATION"
            update_transaction_registration

        when "TRANSACTION_CHANGE_DOCTOR"
            update_transaction_change_doctor

        when "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION"
            update_special_renewal_transaction_registration

        when "REPRINT_MEDICAL_FORM"
            update_reprint_medical_form

        when "INSURANCE_PURCHASE"
            update_insurance_purchase

        when "AGENCY_REGISTRATION", "AGENCY_RENEWAL"
            update_agency_registration
        else
            update_default
        end
        redirect_to @redirect_to || external_orders_path
    end

    def update_default
        case params[:submit]
        when "cancel"
            @order.update({
                status: "CANCELLED"
            })
            flash[:info] = "Order cancelled"
            @redirect_to = external_orders_path
        when "save"
            @redirect_to = edit_external_order_path(@order)
        when "save_and_proceed_to_payment","save"
            @order.update({
                status: "PENDING_PAYMENT"
            })
            @redirect_to = payment_external_order_path(@order)
        else
            flash[:error] = "Action not supported, please contact administrator"
            @redirect_to = external_orders_path(@order)
        end
    end

    def update_special_renewal_transaction_registration
        case params[:submit]
        when "cancel"
            @order.update({
                status: "CANCELLED"
            })
            flash[:info] = "Order cancelled"
            @redirect_to = external_orders_path
        when "save"
            update_transaction_registration_save
            @redirect_to = edit_external_order_path(@order)
        when "proceed_to_payment"
            @order.update({
                status: "PENDING_PAYMENT"
            })
            @redirect_to = payment_external_order_path(@order)
        when "save_and_proceed_to_payment"
            update_transaction_registration_save
            @order.update({
                status: "PENDING_PAYMENT"
            })
            @redirect_to = payment_external_order_path(@order)
        when "addon_insurance"
            if params[:addon_foreign_worker_ids].blank?
                flash_add(:error, "Please select foreign workers")
            else
                fee = Fee.find_by(code: "INSURANCE_GROSS_PREMIUM")
                params[:addon_foreign_worker_ids].each do |fw_id|
                    # add_fw_rs = purchase_insurance_add_fw(order: @order, fw_id: fw_id, fee: fee)
                    add_fw_rs = InsuranceService.order_add_fw(order: @order, fw_id: fw_id, fee: fee)
                    if add_fw_rs.is_a? String
                        flash_add(:errors, add_fw_rs)
                    end
                end
                @order.update_total_amount
            end
            @redirect_to = edit_external_order_path(@order)
        end
    end

    def update_reprint_medical_form
        case params[:submit]
        when "cancel"
            @order.update({
                status: "CANCELLED"
            })
            flash[:info] = "Order cancelled"
            @redirect_to = external_orders_path
        when "save"
            @redirect_to = edit_external_order_path(@order)
        when "proceed_to_payment"
            @order.update({
                status: "PENDING_PAYMENT"
            })
            @redirect_to = payment_external_order_path(@order)
        when "save_and_proceed_to_payment"
            @order.update({
                status: "PENDING_PAYMENT"
            })
            @redirect_to = payment_external_order_path(@order)
        end
    end

    def update_insurance_purchase
        if ['save_and_proceed_to_payment'].include?(params[:submit])
            @insurance_need_recalculate = InsuranceService.order_need_recalculate?(order: @order)
            if @insurance_need_recalculate
                @redirect_to = edit_external_order_path
                return
            end
        end

        case params[:submit]
        when "cancel"
            @order.update({
                status: "CANCELLED"
            })
            flash[:info] = "Order cancelled"
            @redirect_to = external_orders_path
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
                @redirect_to = edit_external_order_path(@order)
            # end
        when "save_and_proceed_to_payment"
            @order.update({
                status: "PENDING_PAYMENT"
            })
            @redirect_to = payment_external_order_path(@order)
        end
    end

    def update_transaction_registration
        if ['proceed_to_payment','save_and_proceed_to_payment'].include?(params[:submit])
            @insurance_need_recalculate = InsuranceService.order_need_recalculate?(order: @order)
            if @insurance_need_recalculate
                @redirect_to = edit_external_order_path
                return
            end
        end

        case params[:submit]
        when "cancel"
            @order.update({
                status: "CANCELLED"
            })
            @redirect_to = external_orders_path
        when "save"
            update_transaction_registration_save
            @redirect_to = edit_external_order_path(@order)
        when "proceed_to_payment"
            @order.update({
                status: "PENDING_PAYMENT"
            })
            @redirect_to = payment_external_order_path(@order)
        when "save_and_proceed_to_payment"
            update_transaction_registration_save
            @order.update({
                status: "PENDING_PAYMENT"
            })
            @redirect_to = payment_external_order_path(@order)
        when "addon_insurance"
            if params[:addon_foreign_worker_ids].blank?
                flash_add(:error, "Please select foreign workers")
            else
                fee = Fee.find_by(code: "INSURANCE_GROSS_PREMIUM")
                params[:addon_foreign_worker_ids].each do |fw_id|
                    # add_fw_rs = purchase_insurance_add_fw(order: @order, fw_id: fw_id, fee: fee)
                    add_fw_rs = InsuranceService.order_add_fw(order: @order, fw_id: fw_id, fee: fee)
                    if add_fw_rs.is_a? String
                        flash_add(:errors, add_fw_rs)
                    end
                end
                @order.update_total_amount
            end
            @redirect_to = edit_external_order_path(@order)
        end
    end

    def update_transaction_change_doctor
        case params[:submit]
        when "cancel"
            @order.update({
                status: "CANCELLED"
            })
            flash[:info] = "Order cancelled"
            @redirect_to = external_orders_path
        when "save"
            @redirect_to = edit_external_order_path(@order)
        when "save_and_proceed_to_payment"
            @order.update({
                status: "PENDING_PAYMENT"
            })
            @redirect_to = payment_external_order_path(@order)
        end
    end

    def update_transaction_registration_save
        # @order.order_items.where("order_itemable_type = ?", 'ForeignWorker').destroy_all
        @order.transaction do
            rs = Fee.where(code: ["TRANSACTION_MALE", "TRANSACTION_FEMALE"])
            fees = {}
            fee_ids = []
            rs.each do |row|
                fees[row.code] = row
                fee_ids << row.id
            end
            oi_ids = []
            old_fw_ids = @order.order_items.where(fee_id: Fee.find_by(code: ["TRANSACTION_MALE", "TRANSACTION_FEMALE"]).id).pluck(:order_itemable_id)
            new_fw_ids = []
            flash[:errors] = []

            params[:foreign_worker_ids].try(:each) do |fw_id|
                fw = ForeignWorker.find(fw_id)
                ### creation didn't check has_pending_transaction?
                # if fw.has_pending_transaction?
                #     flash[:errors] << "#{fw.name} has pending transaction"
                #     next
                # end
                if (pending_order = Order.joins("join order_items on orders.id = order_items.order_id join fees on order_items.fee_id = fees.id")
                    .where.not(id: @order.id)
                    .where("orders.category" => ["TRANSACTION_REGISTRATION", "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION"])
                    .where("orders.status" => ["NEW", "PENDING_PAYMENT"])
                    .where("order_items.order_itemable_id" => fw_id)
                    .where("fees.code" => ["TRANSACTION_MALE", "TRANSACTION_FEMALE"])
                    .first)
                    flash[:errors] << "#{fw.name} has pending order (#{pending_order.code})"
                    next
                end

                oi = @order.order_items.where({
                    order_itemable_id: fw_id,
                    order_itemable_type: "ForeignWorker",
                    fee_id: fees["TRANSACTION_#{fw.gender_name}"].try(:id),
                    amount: fees["TRANSACTION_#{fw.gender_name}"].try(:amount),
                }).first_or_create
                oi_ids << oi.id
                new_fw_ids << oi.order_itemable_id
            end
            @order.order_items.where(fee_id: fee_ids).where.not(id: oi_ids).each do |order_item|
                # remove other order_items by the same worker when registration is removed
                if ["TRANSACTION_MALE", "TRANSACTION_FEMALE"].include?(order_item.fee&.code)
                    @order.order_items.where({
                        order_itemable_id: order_item.order_itemable_id,
                        order_itemable_type: order_item.order_itemable_type
                    }).where.not(id: oi_ids).destroy_all
                end
                order_item.destroy
            end
            InsuranceService.order_clear_insurance(order: @order)
        end
        # /db-transaction
    end

    def update_agency_registration
        case params[:submit]
        when "cancel"
            flash[:info] = "This order cannot be cancelled"
            @redirect_to = external_orders_path
        when "save"
            @redirect_to = edit_external_order_path(@order)
        when "save_and_proceed_to_payment"
            @redirect_to = payment_external_order_path(@order)
        end
    end

    def check_fw_employer
        if current_user.userable_type == 'Agency'
            fw_order_items = @order&.order_items&.where(order_itemable_type: 'ForeignWorker')
            fw_order_items.try(:each) do |fw_order_item|
                foreign_worker = fw_order_item.order_itemable
                employer = @order&.order_items.first&.order_itemable&.employer_id
                if employer != foreign_worker.employer_id
                    return "Found foreign worker with employer not match"
                end
            end
        else
            fw_order_items = @order&.order_items&.where(order_itemable_type: 'ForeignWorker')
            fw_order_items.try(:each) do |fw_order_item|
                foreign_worker = fw_order_item.order_itemable
                if foreign_worker.employer_id != current_user.userable.id
                    return "Found foreign worker with employer not match"
                end
            end
        end
        return true;
    end

    def destroy

    end

    def payment
        if ['TRANSACTION_REGISTRATION', 'INSURANCE_PURCHASE','SPECIAL_RENEWAL_TRANSACTION_REGISTRATION'].include?(@order.category) && @order.order_items.where(:order_itemable_type => 'ForeignWorker').blank?
            flash[:error] = "Please select foreign worker before making payment."
            redirect_to (request.env["HTTP_REFERER"] || external_orders_path) and return
        end

        check = check_fw_employer
        if check.is_a? String
            flash[:error] = check
            redirect_to (request.env["HTTP_REFERER"] || external_orders_path) and return
        end

        max_check = exceed_max_order_item
        if max_check.is_a? String
            flash[:error] = max_check
            redirect_to (request.env["HTTP_REFERER"] || external_orders_path) and return
        end

        @insurance_need_recalculate = InsuranceService.order_need_recalculate?(order: @order)
        if @insurance_need_recalculate
            redirect_to (request.env["HTTP_REFERER"] || external_orders_path) and return
        end

        insurance_check = check_insurance_service_provider
        if insurance_check.is_a? String
            flash[:error] = insurance_check
            redirect_to (request.env["HTTP_REFERER"] || external_orders_path) and return
        end

        ## 20201105 is the date that reference number start to use order code instead of sequence number. Order created before that will still use sequence number with prefix so that reference number will not overlap with order code
        reference_number = @order.created_at >= '2020-11-05' ? @order.code : ''
        if @order.payment_method.code.include? "IPAY"
            amount = ((ENV['IPAY88_PRODUCTION'] || '1') == '1') ? @order.amount : (@order.payment_method.code == 'IPAY_FPX_B2B' ? 2 : 1)

            request_data = {
                merchant_code: IPay88.merchant_code(@order.payment_method),
                merchant_key: IPay88.merchant_key(@order.payment_method),
                amount: amount,
                reference_number: reference_number,
                currency: IPay88.currency,
                product_description: @order.category,
                user_name: @order.customerable.name,
                user_email: current_user.email || @order.customerable.email,
                user_contact: @order.customerable.phone,
                remark: "order id: #{@order.id}",
                lang: IPay88.lang,
                signature_type: IPay88.signature_type,
                response_url: payment_status_external_order_url(@order, protocol: :https),
                backend_url: payment_status_backend_external_order_url(@order, protocol: :https),
                payment_url: IPay88.payment_url
            }
            @ipay88_request = @order.ipay88_requests.create(request_data)
            render :payment and return
        elsif @order.payment_method.code.include? "SWIPE"
            amount = ((ENV['SWIPE_PRODUCTION'] || '1') == '1') ? @order.amount : (@order.payment_method.code == 'SWIPE_FPX_B2B' ? 2 : 1)

            request_data = {
                merchant_code: Swipe.merchant_code(@order.payment_method),
                merchant_key: Swipe.merchant_key(@order.payment_method),
                payment_id: Swipe.payment_id(@order.payment_method),
                amount: amount,
                reference_number: reference_number,
                currency: Swipe.currency,
                product_description: @order.category,
                user_name: @order.customerable.name,
                user_email: current_user.email || @order.customerable.email,
                user_contact: @order.customerable.phone,
                remark: "order id: #{@order.id}",
                lang: Swipe.lang,
                signature_type: Swipe.signature_type,
                response_url: swipe_payment_status_external_order_url(@order),
                backend_url: swipe_payment_status_backend_external_order_url(@order),
                payment_url: Swipe.payment_url
            }
            @swipe_request = @order.swipe_requests.create(request_data)
            render :swipe_payment and return
        elsif @order.payment_method.code.include? "PAYNET"
            # One order one AR only
            @fpx_banks = submit_bank_list_enquiry(Fpx.msg_token(@order.payment_method))

            if @order.fpx_requests.where(msg_type: "AR", seller_order_no: @order.code).count > 0
                @order.fpx_requests.where(msg_type: "AR", seller_order_no: @order.code).order(id: :desc).all.each do |fpx_request|
                    msg = "Payment has been triggered earlier. You are not allowed to make payment again for this order."
                    if fpx_request.has_success_ar_response? || fpx_request.has_success_ae_response?
                        # has success response
                        flash[:notice] = msg
                    elsif fpx_request.has_pending_response? && !fpx_request.has_failed_response?
                        # has pending response
                        flash[:notice] = msg
                        flash[:notice] = "Order is pending authorization or pending at FPX."
                    elsif fpx_request.has_failed_response?
                        # has failed response
                        flash[:notice] = msg
                        flash[:notice] = failed_payment_message
                    else
                        # no response received, submit authorization enquiry
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
                        new_fpx_request = @order.fpx_requests.create(request_data)
                        submit_authorization_enquiry(new_fpx_request)
                    end

                    break
                end
                redirect_to @redirect_to || external_orders_path and return
            else
                render :fpx_bank_selection and return
            end
        elsif @order.payment_method.code.include? "BOLEH"
            # One order one AR only
            if @order.boleh_requests.where(msg_type: "AR", order_number: @order.code).count > 0
                @order.boleh_requests.where(msg_type: "AR", order_number: @order.code).order(id: :desc).all.each do |boleh_request|
                    msg = "Payment has been triggered earlier. You are not allowed to make payment again for this order."
                    if boleh_request.has_success_ar_response? || boleh_request.has_success_ae_response?
                        # has success response
                        flash[:notice] = msg
                    elsif boleh_request.has_pending_response? && !boleh_request.has_failed_response?
                        # has pending response
                        flash[:notice] = msg
                        flash[:notice] = "Order is pending authorization or pending at BolehPay."
                    elsif boleh_request.has_failed_response?
                        # has failed response
                        flash[:notice] = msg
                        flash[:notice] = failed_payment_message
                    else
                        # no response received, submit requery
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
                        new_boleh_request = @order.boleh_requests.create(request_data)
                        submit_requery(new_boleh_request)
                    end

                    break
                end
                redirect_to @redirect_to || external_orders_path and return
            else
                amount = ((ENV['BOLEH_PRODUCTION'] || '1') == '1') ? @order.amount : 2
                payment_url = @order.payment_method.code == "BOLEH" ? Boleh.payment_url : Boleh.payment_url_web

                request_data = {
                    msg_type: "AR",
                    amount: amount,
                    order_number: reference_number,
                    remark: @order.category,
                    response_url: boleh_payment_status_external_order_url(@order),
                    callback_url: boleh_payment_status_backend_external_order_url(@order),
                    payment_url: payment_url,
                    signature_type: Boleh.signature_type,
                }
                @boleh_request = @order.boleh_requests.create(request_data)
                render :boleh_payment and return
            end
        end
    end

    def payment_update
        backend_payment_response_received = true if ['PAID'].include?(@order.status)

        @order.update({
            status: "PAID",
            comment: "payment_update"
        })

        case @order.category
        when "TRANSACTION_REGISTRATION"
            payment_update_transaction_registration
            if @order.customerable_type == 'Employer' || @order.customerable_type == 'Agency'
                flash_add(:notices, "Payment successful, kindly proceed to select clinic.")
            # elsif @order.customerable_type == 'Agency'
            #     flash_add(:notices, "Payment successful, kindly proceed to upload worker document and select clinic.")
            end
            @redirect_to = @order.payment_method.code.start_with?('PAYNET') ? fpx_payment_confirmation_external_order_path(id: @order.id) : external_transactions_path(order_code: @order.code)

            # insurance
            if InsuranceService.order_has_insurance?(order: @order)
                InsuranceService.generate_worker_code(order: @order)
                if @order.customerable_type == 'Employer'
                    if @order.insurance_purchases.first&.insurance_service_provider&.code == "HOWDEN"
                        flash_add(:notices, "Payment successful, insurance purchased. Kindly check your confirmation email and click on the link given to complete the insurance details.")
                    else
                        flash_add(:notices, "Payment successful, insurance purchased.")
                    end
                elsif @order.customerable_type == 'Agency'
                    flash_add(:notices, "Payment successful, insurance purchased.")
                end
                # @redirect_to = submit_paid_premium_external_insurances_path(@order)
                SubmitPaidInsuranceJob.perform_later(order: @order, response_url: policy_external_insurances_url, backend_url: policy_external_insurances_url)
            end

        when "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION"
            payment_update_special_renewal_transaction_registration
            flash[:notice] = "Payment successful. Please upload document."
            @redirect_to = @order.payment_method.code.start_with?('PAYNET') ? fpx_payment_confirmation_external_order_path(id: @order.id) : external_transactions_path(order_code: @order.code)

            # insurance
            if InsuranceService.order_has_insurance?(order: @order)
                InsuranceService.generate_worker_code(order: @order)
                if @order.customerable_type == 'Employer'
                    flash_add(:notices, "Payment successful, insurance purchased. Kindly check your confirmation email and click on the link given to complete the insurance details.")
                elsif @order.customerable_type == 'Agency'
                    flash_add(:notices, "Payment successful, insurance purchased.")
                end
                # @redirect_to = submit_paid_premium_external_insurances_path(@order)
                SubmitPaidInsuranceJob.perform_later(order: @order, response_url: policy_external_insurances_url, backend_url: policy_external_insurances_url)
            end

        when "TRANSACTION_CANCELLATION"
            payment_update_transaction_cancellation

        when "TRANSACTION_CHANGE_DOCTOR"
            payment_update_transaction_change_doctor
            flash[:notice] = "Payment successful, change doctor request is now pending for approval"
            @redirect_to = external_transactions_path

        when "FOREIGN_WORKER_AMENDMENT"
            payment_update_foreign_worker_amendment
            @redirect_to = external_worker_lists_path

        when "REPRINT_MEDICAL_FORM"
            @transaction_ids = @order.additional_information["transaction_ids"]
            print_medical_form
            return

        when "INSURANCE_PURCHASE"
            InsuranceService.generate_worker_code(order: @order)
            if @order.customerable_type == 'Employer'
                if @order.insurance_purchases.first&.insurance_service_provider&.code == "HOWDEN"
                    flash_add(:notices, "Payment successful, insurance purchased. Kindly check your confirmation email and click on the link given to complete the insurance details.")
                else
                    flash_add(:notices, "Payment successful, insurance purchased.")
                end
            elsif @order.customerable_type == 'Agency'
                flash_add(:notices, "Payment successful, insurance purchased.")
            end
                 # @redirect_to = submit_paid_premium_external_insurances_path(@order)
            @redirect_to = @order.payment_method.code.start_with?('PAYNET') ? fpx_payment_confirmation_external_order_path(id: @order.id) : external_orders_path
            SubmitPaidInsuranceJob.perform_later(order: @order, response_url: policy_external_insurances_url, backend_url: policy_external_insurances_url)

        when "FOREIGN_WORKER_GENDER_AMENDMENT"
            payment_update_foreign_worker_gender_amendment_with_approval if !backend_payment_response_received
            @redirect_to = @order.payment_method.code.start_with?('PAYNET') ? fpx_payment_confirmation_external_order_path(id: @order.id) : external_orders_path

        when "AGENCY_REGISTRATION"
            payment_update_agency_registration if !backend_payment_response_received
            @redirect_to = @order.payment_method.code.start_with?('PAYNET') ? fpx_payment_confirmation_external_order_path(id: @order.id) : external_profile_path

        when "AGENCY_RENEWAL"
            payment_update_agency_renewal if !backend_payment_response_received
            @redirect_to = @order.payment_method.code.start_with?('PAYNET') ? fpx_payment_confirmation_external_order_path(id: @order.id) : external_profile_path

        end
        # redirect_to (@redirect_to or external_orders_path)

    end

    def payment_status
        ipay88_request = @order.ipay88_requests.where(reference_number: params["RefNo"]).last
        amount = params["Amount"].delete(',').to_f
        ipay88_response_data = {
            response_category: "RESPONSE",
            merchant_code: params["MerchantCode"],
            payment_id: params["PaymentId"],
            reference_number: params["RefNo"],
            amount: amount,
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
        if ipay88_request.ipay88_responses.where(:status => "1",:response_category => 'RESPONSE').blank?

            @ipay88_response = ipay88_request.ipay88_responses.create(ipay88_response_data)
            if @ipay88_response.calculate_signature(@order&.payment_method) != @ipay88_response.signature
                flash[:error] = @ipay88_response.error_description
                redirect_to external_orders_path and return
            end

            case @ipay88_response.status
            when "1"
                @order.update({
                    status: "PAID",
                    comment: "payment_status"
                })
                payment_update
            when "6"
                @order.update({
                    status: "PENDING_AUTHORIZATION",
                    comment: "payment_status"
                })
                flash[:notice] = "Transaction initiated. Pending payment status."
                @redirect_to = external_orders_path
            else
                order_status_before_update = @order.status
                @order.update({
                    status: "FAILED"
                })

                if !['FAILED'].include?(order_status_before_update)
                    case @order.category
                    when "AGENCY_REGISTRATION", "AGENCY_RENEWAL"
                        failed_payment_update_recreate_order
                    end
                end

                @errDesc = params["ErrDesc"]
                flash[:error] = failed_payment_message
                @redirect_to = external_orders_path
            end
        else
            @redirect_to = external_orders_path
        end
        redirect_to @redirect_to || external_orders_path
    end

    def payment_status_backend
        ipay88_request = @order.ipay88_requests.where(reference_number: params["RefNo"]).last
        amount = params["Amount"].delete(',').to_f
        ipay88_response_data = {
            response_category: "BACKEND",
            merchant_code: params["MerchantCode"],
            payment_id: params["PaymentId"],
            reference_number: params["RefNo"],
            amount: amount,
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

        if !['PAID'].include?(@order.status)
            if @ipay88_response.calculate_signature(@order&.payment_method) != @ipay88_response.signature
                render html: 'RECEIVEOK'.html_safe and return
            end
            case @ipay88_response.status
            when "1"
                @order.update({
                    status: "PAID",
                    comment: "payment_status_backend"
                })

                case @order.category
                when "TRANSACTION_REGISTRATION"
                    payment_update_transaction_registration
                    if InsuranceService.order_has_insurance?(order: @order)
                        InsuranceService.generate_worker_code(order: @order)
                        SubmitPaidInsuranceJob.perform_later(order: @order, response_url: policy_external_insurances_url, backend_url: policy_external_insurances_url)
                    end
                when "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION"
                    payment_update_special_renewal_transaction_registration
                    if InsuranceService.order_has_insurance?(order: @order)
                        InsuranceService.generate_worker_code(order: @order)
                        SubmitPaidInsuranceJob.perform_later(order: @order, response_url: policy_external_insurances_url, backend_url: policy_external_insurances_url)
                    end
                when "TRANSACTION_CANCELLATION"
                    payment_update_transaction_cancellation
                when "TRANSACTION_CHANGE_DOCTOR"
                    payment_update_transaction_change_doctor
                when "FOREIGN_WORKER_AMENDMENT"
                    payment_update_foreign_worker_amendment
                when "REPRINT_MEDICAL_FORM"
                    @transaction_ids = @order.additional_information["transaction_ids"]
                    print_medical_form
                    return
                when "INSURANCE_PURCHASE"
                    InsuranceService.generate_worker_code(order: @order)
                    SubmitPaidInsuranceJob.perform_later(order: @order, response_url: policy_external_insurances_url, backend_url: policy_external_insurances_url)
                when "FOREIGN_WORKER_GENDER_AMENDMENT"
                    payment_update_foreign_worker_gender_amendment_with_approval
                when "AGENCY_REGISTRATION"
                    payment_update_agency_registration
                when "AGENCY_RENEWAL"
                    payment_update_agency_renewal
                end
            when "6"
                @order.update({
                    status: "PENDING_AUTHORIZATION",
                    comment: "payment_status"
                })
            else
                order_status_before_update = @order.status
                @order.update({
                    status: "FAILED"
                })

                if !['FAILED'].include?(order_status_before_update)
                    case @order.category
                    when "AGENCY_REGISTRATION", "AGENCY_RENEWAL"
                        failed_payment_update_recreate_order
                    end
                end
            end
        end
        render html: 'RECEIVEOK'.html_safe
    end

    def swipe_payment_status
        swipe_request = @order.swipe_requests.where(reference_number: params["RefNo"]).last
        amount = params["Amount"].delete(',').to_f
        swipe_response_data = {
            response_category: "RESPONSE",
            merchant_code: params["MerchantCode"],
            payment_id: params["PaymentId"],
            reference_number: params["RefNo"],
            amount: amount,
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
        if swipe_request.swipe_responses.where(:status => "1",:response_category => 'RESPONSE').blank?

            @swipe_response = swipe_request.swipe_responses.create(swipe_response_data)
            if @swipe_response.calculate_signature(@order&.payment_method) != @swipe_response.signature
                flash[:error] = @swipe_response.error_description
                redirect_to external_orders_path and return
            end

            case @swipe_response.status
            when "1"
                @order.update({
                    status: "PAID",
                    comment: "swipe_payment_status"
                })
                payment_update
            when "2"
                @order.update({
                    status: "PENDING_AUTHORIZATION",
                    comment: "swipe_payment_status"
                })
                flash[:notice] = "Transaction initiated. Pending payment status."
                @redirect_to = external_orders_path
            else
                order_status_before_update = @order.status
                @order.update({
                    status: "FAILED"
                })

                if !['FAILED'].include?(order_status_before_update)
                    case @order.category
                    when "AGENCY_REGISTRATION", "AGENCY_RENEWAL"
                        failed_payment_update_recreate_order
                    end
                end

                @errDesc = params["ErrDesc"]
                flash[:error] = failed_payment_message
                @redirect_to = external_orders_path
            end
        else
            @redirect_to = external_orders_path
        end
        redirect_to @redirect_to || external_orders_path
    end

    def swipe_payment_status_backend
        swipe_request = @order.swipe_requests.where(reference_number: params["RefNo"]).last
        amount = params["Amount"].delete(',').to_f
        swipe_response_data = {
            response_category: "BACKEND",
            merchant_code: params["MerchantCode"],
            payment_id: params["PaymentId"],
            reference_number: params["RefNo"],
            amount: amount,
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
        @swipe_response = swipe_request.swipe_responses.create(swipe_response_data)

        if !['PAID'].include?(@order.status)
            if @swipe_response.calculate_signature(@order&.payment_method) != @swipe_response.signature
                render html: 'RECEIVEOK'.html_safe and return
            end
            case @swipe_response.status
            when "1"
                @order.update({
                    status: "PAID",
                    comment: "swipe_payment_status_backend"
                })

                case @order.category
                when "TRANSACTION_REGISTRATION"
                    payment_update_transaction_registration
                    if InsuranceService.order_has_insurance?(order: @order)
                        InsuranceService.generate_worker_code(order: @order)
                        SubmitPaidInsuranceJob.perform_later(order: @order, response_url: policy_external_insurances_url, backend_url: policy_external_insurances_url)
                    end
                when "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION"
                    payment_update_special_renewal_transaction_registration
                    if InsuranceService.order_has_insurance?(order: @order)
                        InsuranceService.generate_worker_code(order: @order)
                        SubmitPaidInsuranceJob.perform_later(order: @order, response_url: policy_external_insurances_url, backend_url: policy_external_insurances_url)
                    end
                when "TRANSACTION_CANCELLATION"
                    payment_update_transaction_cancellation
                when "TRANSACTION_CHANGE_DOCTOR"
                    payment_update_transaction_change_doctor
                when "FOREIGN_WORKER_AMENDMENT"
                    payment_update_foreign_worker_amendment
                when "REPRINT_MEDICAL_FORM"
                    @transaction_ids = @order.additional_information["transaction_ids"]
                    print_medical_form
                    return
                when "INSURANCE_PURCHASE"
                    InsuranceService.generate_worker_code(order: @order)
                    SubmitPaidInsuranceJob.perform_later(order: @order, response_url: policy_external_insurances_url, backend_url: policy_external_insurances_url)
                when "FOREIGN_WORKER_GENDER_AMENDMENT"
                    payment_update_foreign_worker_gender_amendment_with_approval
                when "AGENCY_REGISTRATION"
                    payment_update_agency_registration
                when "AGENCY_RENEWAL"
                    payment_update_agency_renewal
                end
            when "2"
                @order.update({
                    status: "PENDING_AUTHORIZATION",
                    comment: "swipe_payment_status"
                })
            else
                order_status_before_update = @order.status
                @order.update({
                    status: "FAILED"
                })

                if !['FAILED'].include?(order_status_before_update)
                    case @order.category
                    when "AGENCY_REGISTRATION", "AGENCY_RENEWAL"
                        failed_payment_update_recreate_order
                    end
                end
            end
        end
        render html: 'RECEIVEOK'.html_safe
    end

    def boleh_payment_status
        boleh_request = @order.boleh_requests.where(order_number: params["order_id"]).last
        amount = params["amount"].delete(',').to_f
        boleh_response_data = {
            response_category: "RESPONSE",
            order_number: params["order_id"],
            amount: amount,
            transaction_id: params["ref_id"],
            status: params["status"],
            payment_date: params["payment_date"],
            signature: params["signature"],
        }

        if boleh_request.boleh_responses.where(:status => "approved", :response_category => 'RESPONSE').blank?
            @boleh_response = boleh_request.boleh_responses.create(boleh_response_data)

            if @boleh_response.calculate_signature != @boleh_response.signature
                flash[:error] = "Checksum verification failed."
                redirect_to external_orders_path and return
            end

            case @boleh_response.status
            when "approved"
                @order.update({
                    status: "PAID",
                    comment: "boleh_payment_status"
                })
                payment_update
            when "pending_auth"
                @order.update({
                    status: "PENDING_AUTHORIZATION",
                    comment: "boleh_payment_status"
                })
                flash[:notice] = "Transaction initiated. Pending payment status."
                @redirect_to = external_orders_path
            when "pending", "processing"
                @order.update({
                    status: "PENDING",
                    comment: "boleh_payment_status"
                })
                flash[:notice] = "Transaction initiated. Pending payment status."
                @redirect_to = external_orders_path
            when "duplicated"
                flash[:error] = "Duplicate payment initiated."
            else
                order_status_before_update = @order.status

                @order.update({
                    status: "FAILED"
                })

                if !['FAILED'].include?(order_status_before_update)
                    case @order.category
                    when "AGENCY_REGISTRATION", "AGENCY_RENEWAL"
                        failed_payment_update_recreate_order
                    end
                end

                @errDesc = params["ErrDesc"]
                flash[:error] = failed_payment_message
                @redirect_to = external_orders_path
            end
        else
            @redirect_to = external_orders_path
        end
        redirect_to @redirect_to || external_orders_path
    end

    def boleh_payment_status_backend
        boleh_request = @order.boleh_requests.where(order_number: params["order_id"]).last
        amount = params["amount"].delete(',').to_f
        boleh_response_data = {
            response_category: "BACKEND",
            order_number: params["order_id"],
            amount: amount,
            transaction_id: params["ref_id"],
            status: params["status"],
            payment_date: params["payment_date"],
            signature: params["signature"],
        }
        @boleh_response = boleh_request.boleh_responses.create(boleh_response_data)

        if !['PAID'].include?(@order.status)
            if @boleh_response.calculate_signature != @boleh_response.signature
                render html: 'RECEIVEOK'.html_safe and return
            end

            case @boleh_response.status
            when "approved"
                @order.update({
                    status: "PAID",
                    comment: "boleh_payment_status_backend"
                })

                case @order.category
                when "TRANSACTION_REGISTRATION"
                    payment_update_transaction_registration
                    if InsuranceService.order_has_insurance?(order: @order)
                        InsuranceService.generate_worker_code(order: @order)
                        SubmitPaidInsuranceJob.perform_later(order: @order, response_url: policy_external_insurances_url, backend_url: policy_external_insurances_url)
                    end
                when "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION"
                    payment_update_special_renewal_transaction_registration
                when "TRANSACTION_CANCELLATION"
                    payment_update_transaction_cancellation
                when "TRANSACTION_CHANGE_DOCTOR"
                    payment_update_transaction_change_doctor
                when "FOREIGN_WORKER_AMENDMENT"
                    payment_update_foreign_worker_amendment
                when "REPRINT_MEDICAL_FORM"
                    @transaction_ids = @order.additional_information["transaction_ids"]
                    print_medical_form
                    return
                when "INSURANCE_PURCHASE"
                    InsuranceService.generate_worker_code(order: @order)
                    SubmitPaidInsuranceJob.perform_later(order: @order, response_url: policy_external_insurances_url, backend_url: policy_external_insurances_url)
                when "FOREIGN_WORKER_GENDER_AMENDMENT"
                    payment_update_foreign_worker_gender_amendment_with_approval
                when "AGENCY_REGISTRATION"
                    payment_update_agency_registration
                when "AGENCY_RENEWAL"
                    payment_update_agency_renewal
                end
            when "pending_auth"
                @order.update({
                    status: "PENDING_AUTHORIZATION",
                    comment: "boleh_payment_status"
                })
            when "pending", "processing"
                @order.update({
                    status: "PENDING",
                    comment: "boleh_payment_status"
                })
            when "duplicated"
            else
                order_status_before_update = @order.status

                @order.update({
                    status: "FAILED"
                })

                if !['FAILED'].include?(order_status_before_update)
                    case @order.category
                    when "AGENCY_REGISTRATION", "AGENCY_RENEWAL"
                        failed_payment_update_recreate_order
                    end
                end
            end
        end
        render html: 'RECEIVEOK'.html_safe
    end

    def remove_order_item
        order_item = @order.order_items.find(params[:oi_id])
        if ["TRANSACTION_REGISTRATION","SPECIAL_RENEWAL_TRANSACTION_REGISTRATION"].include?(@order.category) && ["TRANSACTION_MALE", "TRANSACTION_FEMALE"].include?(order_item.fee&.code)
            @order.order_items.where({
                order_itemable_id: order_item.order_itemable_id,
                order_itemable_type: order_item.order_itemable_type
            }).where.not(id: order_item.id).destroy_all
        end
        order_item.destroy
        InsuranceService.order_clear_insurance(order: @order)
        redirect_back fallback_location: edit_external_order_path(@order)
    end

    def swipe_user_guide
        send_file(
            "#{Rails.root}/public/files/SwipeWorkersScanAndPayUserGuide.pdf",
            filename: "SwipeWorkersScanAndPayUserGuide.pdf",
            type: "application/pdf"
        )
    end

    def boleh_user_guide
        send_file(
            "#{Rails.root}/public/files/SwipeWorkersScanAndPayUserGuide.pdf",
            filename: "BolehPayUserGuide.pdf",
            type: "application/pdf"
        )
    end

    def fpx_payment_status
        log_data = {
            :name => self.class.name,
            :api_type => nil,
            :request_type => 'INCOMING',
            :method => "INDIRECT_AC",
            :params => params
        }
        api_log = ApiLog.create(log_data)

        where = {
            code: params["fpx_sellerOrderNo"],
        }
        if !current_user.nil?
            where = where.merge({
                customerable: current_user.userable
            })
        end
        @order = Order.where(where).first or redirect_to external_orders_path, flash: {notice: "Order not found"}

        fpx_request = @order.fpx_requests.where(seller_order_no: params["fpx_sellerOrderNo"], seller_ex_order_no: params["fpx_sellerExOrderNo"]).last

        fpx_response_data = {
            response_category: "RESPONSE",
            msg_type: params['fpx_msgType'],
            msg_token: params['fpx_msgToken'],
            fpx_txn_id: params['fpx_fpxTxnId'],
            seller_ex_id: params['fpx_sellerExId'],
            seller_ex_order_no: params['fpx_sellerExOrderNo'],
            fpx_txn_time: params['fpx_fpxTxnTime'],
            seller_txn_time: params['fpx_sellerTxnTime'],
            seller_order_no: params['fpx_sellerOrderNo'],
            seller_id: params['fpx_sellerId'],
            txn_currency: params['fpx_txnCurrency'],
            txn_amount: params['fpx_txnAmount'],
            checksum: params['fpx_checkSum'],
            buyer_name: params['fpx_buyerName'],
            buyer_bank_id: params['fpx_buyerBankId'],
            debit_auth_code: params['fpx_debitAuthCode'],
            debit_auth_no: params['fpx_debitAuthNo'],
            credit_auth_code: params['fpx_creditAuthCode'],
            credit_auth_no: params['fpx_creditAuthNo']
        }

        if fpx_request.fpx_responses.where(:debit_auth_code => "00",:response_category => 'RESPONSE').blank?
            @fpx_response = fpx_request.fpx_responses.create(fpx_response_data)

            # Construct response checksum source string
            checksum_source_string = "#{params['fpx_buyerBankBranch']}|#{params['fpx_buyerBankId']}|#{params['fpx_buyerIban']}|#{params['fpx_buyerId']}|#{params['fpx_buyerName']}|#{params['fpx_creditAuthCode']}|#{params['fpx_creditAuthNo']}|#{params['fpx_debitAuthCode']}|#{params['fpx_debitAuthNo']}|#{params['fpx_fpxTxnId']}|#{params['fpx_fpxTxnTime']}|#{params['fpx_makerName']}|#{params['fpx_msgToken']}|#{params['fpx_msgType']}|#{params['fpx_sellerExId']}|#{params['fpx_sellerExOrderNo']}|#{params['fpx_sellerId']}|#{params['fpx_sellerOrderNo']}|#{params['fpx_sellerTxnTime']}|#{params['fpx_txnAmount']}|#{params['fpx_txnCurrency']}"

            if !Fpx.verify_checksum(params['fpx_checkSum'], checksum_source_string)
                flash[:error] = "Checksum verification failed."
                redirect_to external_orders_path and return
            end

            case @fpx_response.debit_auth_code
            when "00"
                @order.update({
                    status: "PAID",
                    comment: "fpx_payment_status"
                })
                payment_update
            when "99"
                @order.update({
                    status: "PENDING_AUTHORIZATION",
                    comment: "fpx_payment_status"
                })
                flash[:notice] = "Transaction initiated. Pending payment status."
                @redirect_to = fpx_payment_confirmation_external_order_path(id: @order.id)
            when "09"
                @order.update({
                    status: "PENDING",
                    comment: "fpx_payment_status"
                })
                flash[:notice] = "Transaction initiated. Pending payment status."
                @redirect_to = fpx_payment_confirmation_external_order_path(id: @order.id)
            else
                @order.update({
                    status: "FAILED"
                })
                flash[:error] = failed_payment_message
                @redirect_to = fpx_payment_confirmation_external_order_path(id: @order.id)
            end
        else
            @redirect_to = external_orders_path
        end
        redirect_to @redirect_to || external_orders_path
    end

    def fpx_payment_status_backend
        log_data = {
            :name => self.class.name,
            :api_type => nil,
            :request_type => 'INCOMING',
            :method => "DIRECT_AC",
            :params => params
        }
        api_log = ApiLog.create(log_data)

        where = {
            code: params["fpx_sellerOrderNo"]
        }
        @order = Order.where(where).first

        fpx_request = @order.fpx_requests.where(seller_order_no: params["fpx_sellerOrderNo"], seller_ex_order_no: params["fpx_sellerExOrderNo"]).last

        fpx_response_data = {
            response_category: "BACKEND",
            msg_type: params['fpx_msgType'],
            msg_token: params['fpx_msgToken'],
            fpx_txn_id: params['fpx_fpxTxnId'],
            seller_ex_id: params['fpx_sellerExId'],
            seller_ex_order_no: params['fpx_sellerExOrderNo'],
            fpx_txn_time: params['fpx_fpxTxnTime'],
            seller_txn_time: params['fpx_sellerTxnTime'],
            seller_order_no: params['fpx_sellerOrderNo'],
            seller_id: params['fpx_sellerId'],
            txn_currency: params['fpx_txnCurrency'],
            txn_amount: params['fpx_txnAmount'],
            checksum: params['fpx_checkSum'],
            buyer_name: params['fpx_buyerName'],
            buyer_bank_id: params['fpx_buyerBankId'],
            debit_auth_code: params['fpx_debitAuthCode'],
            debit_auth_no: params['fpx_debitAuthNo'],
            credit_auth_code: params['fpx_creditAuthCode'],
            credit_auth_no: params['fpx_creditAuthNo']
        }
        @fpx_response = fpx_request.fpx_responses.create(fpx_response_data)

        if !['PAID'].include?(@order.status)
            # Construct response checksum source string
            checksum_source_string = "#{params['fpx_buyerBankBranch']}|#{params['fpx_buyerBankId']}|#{params['fpx_buyerIban']}|#{params['fpx_buyerId']}|#{params['fpx_buyerName']}|#{params['fpx_creditAuthCode']}|#{params['fpx_creditAuthNo']}|#{params['fpx_debitAuthCode']}|#{params['fpx_debitAuthNo']}|#{params['fpx_fpxTxnId']}|#{params['fpx_fpxTxnTime']}|#{params['fpx_makerName']}|#{params['fpx_msgToken']}|#{params['fpx_msgType']}|#{params['fpx_sellerExId']}|#{params['fpx_sellerExOrderNo']}|#{params['fpx_sellerId']}|#{params['fpx_sellerOrderNo']}|#{params['fpx_sellerTxnTime']}|#{params['fpx_txnAmount']}|#{params['fpx_txnCurrency']}"

            if !Fpx.verify_checksum(params['fpx_checkSum'], checksum_source_string)
                render html: 'OK'.html_safe and return
            end

            case @fpx_response.debit_auth_code
            when "00"
                @order.update({
                    status: "PAID",
                    comment: "fpx_payment_status_backend"
                })

                case @order.category
                when "TRANSACTION_REGISTRATION"
                    payment_update_transaction_registration
                    if InsuranceService.order_has_insurance?(order: @order)
                        InsuranceService.generate_worker_code(order: @order)
                        SubmitPaidInsuranceJob.perform_later(order: @order, response_url: policy_external_insurances_url, backend_url: policy_external_insurances_url)
                    end
                when "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION"
                    payment_update_special_renewal_transaction_registration
                    if InsuranceService.order_has_insurance?(order: @order)
                        InsuranceService.generate_worker_code(order: @order)
                        SubmitPaidInsuranceJob.perform_later(order: @order, response_url: policy_external_insurances_url, backend_url: policy_external_insurances_url)
                    end
                when "TRANSACTION_CANCELLATION"
                    payment_update_transaction_cancellation
                when "TRANSACTION_CHANGE_DOCTOR"
                    payment_update_transaction_change_doctor
                when "FOREIGN_WORKER_AMENDMENT"
                    payment_update_foreign_worker_amendment
                when "REPRINT_MEDICAL_FORM"
                    @transaction_ids = @order.additional_information["transaction_ids"]
                    print_medical_form
                    return
                when "INSURANCE_PURCHASE"
                    InsuranceService.generate_worker_code(order: @order)
                    SubmitPaidInsuranceJob.perform_later(order: @order, response_url: policy_external_insurances_url, backend_url: policy_external_insurances_url)
                when "FOREIGN_WORKER_GENDER_AMENDMENT"
                    payment_update_foreign_worker_gender_amendment_with_approval
                when "AGENCY_REGISTRATION"
                    payment_update_agency_registration
                when "AGENCY_RENEWAL"
                    payment_update_agency_renewal
                end
            when "99"
                @order.update({
                    status: "PENDING_AUTHORIZATION",
                    comment: "fpx_payment_status_backend"
                })
            when "09"
                @order.update({
                    status: "PENDING",
                    comment: "fpx_payment_status_backend"
                })
            else
                order_status_before_update = @order.status
                @order.update({
                    status: "FAILED"
                })

                if !['FAILED'].include?(order_status_before_update)
                    case @order.category
                    when "AGENCY_REGISTRATION", "AGENCY_RENEWAL"
                        failed_payment_update_recreate_order
                    end
                end
            end
        end
        render html: 'OK'.html_safe
    end

    def fpx_payment
        if @order.fpx_requests.where(msg_type: "AR", seller_order_no: @order.code).count > 0
            redirect_to external_orders_path and return
        end

        fpx_buyer_bank_id = params[:fpx_buyer_bank_id]

        request_data = {
            msg_type: "AR",
            msg_token: Fpx.msg_token(@order.payment_method),
            seller_ex_id: Fpx.seller_ex_id,
            seller_txn_time: Fpx.transaction_time,
            seller_order_no: @order.code,
            seller_id: Fpx.seller_id,
            seller_bank_code: Fpx.seller_bank_code,
            txn_currency: Fpx.currency,
            txn_amount: @order.amount,
            buyer_email: current_user.email || @order.customerable.email,
            buyer_name: @order.customerable.name,
            buyer_bank_id: fpx_buyer_bank_id,
            product_description: @order.category[0..29],
            version: Fpx.version,
            payment_url: Fpx.payment_url
        }
        @fpx_request = @order.fpx_requests.create(request_data)

        form_data = {
            'fpx_msgType' => @fpx_request.msg_type,
            'fpx_msgToken' => @fpx_request.msg_token,
            'fpx_sellerExId' => @fpx_request.seller_ex_id,
            'fpx_sellerExOrderNo' => @fpx_request.seller_ex_order_no,
            'fpx_sellerTxnTime' => @fpx_request.seller_txn_time,
            'fpx_sellerOrderNo' => @fpx_request.seller_order_no,
            'fpx_sellerId' => @fpx_request.seller_id,
            'fpx_sellerBankCode' => @fpx_request.seller_bank_code,
            'fpx_txnCurrency' => @fpx_request.txn_currency,
            'fpx_txnAmount' => ActionController::Base.helpers.number_to_currency(@fpx_request.txn_amount, unit: "", delimiter: ""),
            'fpx_buyerEmail' => @fpx_request.buyer_email,
            'fpx_checkSum' => @fpx_request.checksum,
            'fpx_buyerName' => @fpx_request.buyer_name,
            'fpx_buyerBankId' => @fpx_request.buyer_bank_id,
            'fpx_productDesc' => @fpx_request.product_description,
            'fpx_version' => @fpx_request.version,
            'fpx_buyerAccNo' => "",
            'fpx_buyerBankBranch' => "",
            'fpx_buyerIban' => "",
            'fpx_buyerId' => "",
            'fpx_makerName' => ""
        }

        log_data = {
            :name => self.class.name,
            :api_type => nil,
            :request_type => 'OUTGOING',
            :url => Fpx.payment_url,
            :method => "SUBMIT_AR",
            :params => form_data
        }
        api_log = ApiLog.create(log_data)
    end

    def fpx_payment_confirmation
        @fpx_response = FpxResponse.where(seller_order_no: @order.code).order(id: :desc).last
    end

    def exceed_max_order_item
        max_count = SystemConfiguration.get('MAX_ORDER_ITEM_COUNT').to_i
        order_item_count = @order&.order_items&.where(order_itemable_type: 'ForeignWorker').count
        exceed_message = "Your order has more than <b>#{max_count}</b> workers. Please remove <b>#{order_item_count - max_count}</b> workers from the order before proceed to payment."

        return false if max_count == 0
        return order_item_count > max_count ? exceed_message : false
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
    def set_order
        # @order = Order.find(params[:id])
        where = {
            id: params[:id],
        }
        if !current_user.nil?
            where = where.merge({
                customerable: current_user.userable
            })
        end
        @order = Order.where(where).first or redirect_to external_orders_path, flash: {notice: "Order not found"}
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
        params.require(:order).permit(:payment_method_id,:personal_data_consent)
    end

    def add_convenient_fee
        @order.order_items.joins(:fee).where("fees.code ilike 'ipay_%' or fees.code ilike 'swipe_%' or fees.code ilike 'paynet_%' or fees.code ilike 'boleh%'").destroy_all

        if !params[:order].blank?
            if !params[:order][:payment_method_id].blank?
                payment_method = PaymentMethod.find(params[:order][:payment_method_id])

                convenient_fee = Fee.find_by_code(payment_method&.code)
                if !convenient_fee.blank? && convenient_fee&.amount > 0
                    @order.order_items.create!({
                        order_itemable: @order.customerable,
                        fee_id: convenient_fee.id,
                        amount: convenient_fee.amount
                    })
                end
            end
        end
    end

    def double_check_convenient_fee
        @order.order_items.joins(:fee).where("fees.code ilike 'ipay_%' or fees.code ilike 'swipe_%' or fees.code ilike 'paynet_%' or fees.code ilike 'boleh%'").destroy_all

        if !@order.payment_method_id.blank?
            payment_method = PaymentMethod.find(@order.payment_method_id)

            convenient_fee = Fee.find_by_code(payment_method&.code)
            if !convenient_fee.blank? && convenient_fee&.amount > 0
                @order.order_items.create!({
                    order_itemable: @order.customerable,
                    fee_id: convenient_fee.id,
                    amount: convenient_fee.amount
                })
            end
        end
    end

    def failed_payment_message
        if ['TRANSACTION_REGISTRATION','SPECIAL_RENEWAL_TRANSACTION_REGISTRATION'].include? @order.category
            "Payment unsuccessful. Please go to Register Worker to continue with another payment."
        else
            "Payment unsuccessful. #{@errDesc}"
        end
    end

    def check_order_status
        if ['PAID','CANCELLED','FAILED','PENDING_AUTHORIZATION'].include?(@order.status)
            flash_add(:errors, "Order #{@order.code} is #{@order.status}")
            redirect_to external_orders_path and return
        end
    end
end