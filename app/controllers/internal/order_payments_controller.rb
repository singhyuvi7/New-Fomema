class Internal::OrderPaymentsController < InternalController

    before_action :set_order_payment, only: [:show, :edit, :update, :hold, :hold_update, :unhold, :unhold_update, :bad, :bad_update, :replace, :replace_update]
    before_action :set_payment_methods, only: [:show, :edit, :update, :replace, :replace_update]

    def index
        @order_payments = OrderPayment.search_reference(params[:reference])
        .search_payment_method(params[:payment_method])
        .search_organization(params[:organization])
        .search_issue_date_from(params[:issue_date_from])
        .search_issue_date_to(params[:issue_date_to])
        .search_created_date_from(params[:created_date_from])
        .search_created_date_to(params[:created_date_to])
        .search_holded(params[:holded])
        .search_bad(params[:bad])
        .search_order_code(params[:order_code])
        .search_posted(params[:is_posted])
        .order('order_payments.created_at DESC')
        .page(params[:page])
        .per(get_per)

        @payment_methods = PaymentMethod.where.not(code: ['IPAY88','BANKDRAFT']).available_for_internal_payment
    end

    def show
    end

    def edit
        @replaced_order_payment = OrderPayment.find_by(replacement_id: @order_payment.id)
    end

    def update

        @order_payment.order.assign_attributes({
            payment_method_id: params[:payment_method_id]
        })
        @order_payment.assign_attributes(order_payment_params)
        if !@order_payment.valid?
            @order_payment.errors.full_messages.each do |message|
                flash[:error] = message
            end
            redirect_to edit_internal_order_payment_path(@order_payment) and return
        end

        ## if payment has already been refund
        if ['CIMB_CLICKS'].include?(@order_payment.order.payment_method.code)
            refund = Refund.where(:payment_method_id => @order_payment.order.payment_method_id, :payment_date => @order_payment.issue_date, :amount => @order_payment.amount, :reference => @order_payment.reference).where.not(:status => ['CANCELLED'])

            if !refund.blank?
                flash[:error] = 'Payment info found in refund, cannot be use as payment.'
                redirect_to (request.env["HTTP_REFERER"] || internal_order_payments_path) and return
            end
        end

        @order_payment.order.save
        @order_payment.save
        flash[:notice] = "Payment details has been updated"

        redirect_to internal_order_payments_path
    end

    def hold
        redirect_to internal_order_payments_path, error: "Payment is already holded" and return if @order_payment.holded

        @order_payment_hold_log = @order_payment.order_payment_hold_logs.new({
            holded_by: current_user.id,
            holded_at: Time.now
        })
    end

    def hold_update
        @order_payment.update({
            holded: true,
            holded_by: current_user.id,
            holded_at: Time.now
        })
        @order_payment.order_payment_hold_logs.create(
            params.require(:order_payment_hold_log).permit(:hold_comment).merge({
                holded_by: current_user.id,
                holded_at: Time.now
            })
        )
        redirect_to internal_order_payments_path, notice: "Payment holded"
    end

    def unhold
        redirect_to internal_order_payments_path, error: "Payment is not holded" and return if !@order_payment.holded

        @order_payment_hold_log = @order_payment.order_payment_hold_logs.where("unholded_at is null").order("created_at desc").first or (redirect_to internal_order_payments_path, error: "Invalid payment hold log" and return)

        @order_payment_hold_log.assign_attributes({
            unholded_by: current_user.id,
            unholded_at: Time.now
        })
    end

    def unhold_update
        @order_payment.update({
            holded: false,
            holded_by: nil,
            holded_at: nil
        })
        @order_payment.order_payment_hold_logs.where("unholded_at is null").order("created_at desc").first.update(
            params.require(:order_payment_hold_log).permit(:unhold_comment).merge({
                unholded_by: current_user.id,
                unholded_at: Time.now
            })
        )
        redirect_to internal_order_payments_path, notice: "Payment unholded"
    end

    def bad
        @order_payment.update({
            bad: true
        })
        redirect_to internal_order_payments_path, notice: "Bad payment marked"
        # redirect_back fallback_location: internal_bank_drafts_path, notice: "Bad bank draft marked"
    end

    def unbad
        @order_payment.update({
            bad: false
        })
        redirect_to internal_order_payments_path, notice: "Bad payment unmarked"
    end

    def replace
        @new_order_payment = OrderPayment.new({
            order_id: @order_payment.order_id,
            amount: @order_payment.amount,
            reference: nil,
            comment: nil,
            issue_date: nil,
            holded: false,
            bad: false,
        })
    end

    def replace_update
        @new_order_payment = OrderPayment.new(order_payment_params)
        @new_order_payment.assign_attributes({
            order_id: @order_payment.order_id
        })

        if !@new_order_payment.valid?
            @new_order_payment.errors.full_messages.each do |message|
                flash[:error] = message
            end
            redirect_to replace_internal_order_payment_path(@order_payment) and return
        end

        if @order_payment.amount > @new_order_payment.amount
            flash.now[:error] = "New payment has lesser amount"
            render :replace and return
        end

        respond_to do |format|
            if @new_order_payment.save
                @order_payment.update({
                    replacement_id: @new_order_payment.id
                })

                @new_order_payment.block_or_unblock_fw
                format.html { redirect_to internal_order_payments_path, notice: 'Payment was successfully replaced.' }
                format.json { render :show, status: :ok, location: @new_order_payment }
            else
                format.html { render :replace }
                format.json { render json: @order_payment.errors, status: :unprocessable_entity }
            end
        end
    end

    def check_unique_cimb
        is_unique = true
        reference = params[:order_payment][:reference]
        issue_date = params[:order_payment][:issue_date]

        if !params[:order_id].blank?
            # for new order payment
            order = Order.find(params[:order_id])
            if order.payment_method.code == 'CIMB_CLICKS'
                payment = OrderPayment.joins(:order).where(:reference => reference).where.not(:issue_date => issue_date).where(orders:{payment_method_id: order&.payment_method_id})

                if !payment.blank?
                    is_unique = false
                end
            end

        else !params[:id].blank?
            # for edit order payment
            order_payment = OrderPayment.find(params[:id])
            payment_method = PaymentMethod.find(params[:payment_method_id])
            if payment_method&.code == 'CIMB_CLICKS' && (params[:order_payment_type] == 'replace' || order_payment.sync_date.blank?)
                payment = OrderPayment.joins(:order).where(:reference => reference).where.not(:issue_date => issue_date).where(orders:{payment_method_id: payment_method&.id}).where.not(:id => order_payment.id)

                if !payment.blank?
                    is_unique = false
                end
            end
        end
        render plain: is_unique and return
    end

private
    def set_order_payment
        @order_payment = OrderPayment.find(params[:id])
    end

    def order_payment_params
        params.require(:order_payment).permit(:reference, :amount, :comment, :issue_date)
    end

    def set_payment_methods
        @payment_methods = PaymentMethod.available_for_internal_payment.where.not(:code => 'BANKDRAFT')
    end
end
