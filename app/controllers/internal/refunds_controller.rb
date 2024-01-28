class Internal::RefundsController < InternalController
    include RefundDocument
    include Sage
    include BankInfoCheck

    before_action :set_refund, only: [:show, :edit, :update, :destroy, :draft, :approval, :approval_update, :cancel, :status, :status_update, :credit_note, :reprocess]
    before_action :set_payment_methods, only: [:index, :show, :new, :create, :edit, :update, :destroy, :draft, :approval, :approval_update, :cancel, :status, :status_update, :credit_note, :reprocess]
    before_action :set_mimes, only: [:new, :create, :edit, :update, :draft]
    before_action :set_customerable_types, only: [:index]

    # before_action -> {
    #     customerable = params[:refund][:customerable_type].constantize
    #     can_proceed?(customerable.find(params[:refund][:customerable_id]))
    # },if: -> { params[:submit] == "Submit for approval" }, only: [:create, :update]
    before_action -> {
        customerable = params[:refund][:customerable_type].constantize
        can_proceed?(customerable, customerable.find(params[:refund][:customerable_id]))
    },if: -> { params[:submit] == "Submit for approval" }, only: [:create, :update]

    # before_action -> { can_proceed?(@refund.customerable) },if: -> { approval_params[:decision] == 'APPROVE' }, only: [:approval_update]
    before_action -> { can_proceed?(@refund.customerable_type, @refund.customerable) },if: -> { approval_params[:decision] == 'APPROVE' }, only: [:approval_update]
    before_action :validate_refunds, only: [:create, :update]
    before_action :check_files, only: [:create, :update]

    has_scope :category
    has_scope :start_date
    has_scope :end_date

    # GET refunds
    # GET refunds.json
    def index
        @refunds = apply_scopes(Refund)
        .search_code(params[:code])
        .search_customerable_type(params[:customerable_type])
        .search_customerable_by_code(params[:customerable_type], params[:customer_code])
        .search_customerable_by_name(params[:customerable_type], params[:customer_name])
        .search_status(params[:status])
        .search_payment_method(params[:payment_method_id])
        .includes(:payment_method).includes(:customerable)
        .order('refunds.created_at DESC')
        .page(params[:page])
        .per(get_per)
    end

    # GET refunds/1
    # GET refunds/1.json
    def show
        @refund_items = @refund.refund_items.order('refund_itemable_type DESC')
        view_file = "internal/refunds/show_#{@refund.category}".downcase
        if template_exists?(view_file)
            render view_file and return
        end
    end

    # GET refunds/new
    def new
        @refund = Refund.new({
            customerable_type: "Employer",
            category: "MANUAL"
        })
    end

    # POST refunds
    # POST refunds.json
    def create
        @refund = Refund.new(refund_params)

        payment_method = PaymentMethod.find(refund_params[:payment_method_id])
        if payment_method.code.start_with?('IPAY', 'SWIPE_', 'PAYNET', 'BOLEH')
            @refund.assign_attributes({
                organization: Organization.find_by_code('PT')
            })
        end

        case params[:submit]
        when "Save draft"
            @refund.assign_attributes({
                status: "DRAFT"
            })
            flash[:notice] = "Refund #{@refund.code} was successfully created as draft."
        when "Submit for approval"
            @refund.assign_attributes({
                status: "APPROVAL",
                request_by: current_user.id,
                request_at: Time.now
            })
            flash[:notice] = "Refund #{@refund.code} was successfully created, pending for approval."
        end

        respond_to do |format|
            if @refund.save
                do_upload
                format.html { redirect_to internal_refunds_path }
                format.json { render :show, status: :created, location: @refund }
            else
                format.html { render :new }
                format.json { render json: @refund.errors, status: :unprocessable_entity }
            end
        end
    end

    # GET refunds/1/edit
    def edit
    end

    def draft
    end

    # PATCH/PUT refunds/1
    # PATCH/PUT refunds/1.json
    def update
        @refund.assign_attributes(refund_params)

        payment_method = PaymentMethod.find(refund_params[:payment_method_id])
        if payment_method.code.start_with?('IPAY', 'SWIPE_', 'PAYNET', 'BOLEH')
            @refund.assign_attributes({
                organization: Organization.find_by_code('PT')
            })
        end

        case params[:submit]
        when "Save draft"
            @refund.assign_attributes({
                status: "DRAFT"
            })
            flash[:notice] = "Refund #{@refund.code} was successfully updated as draft."
        when "Submit for approval"
            @refund.assign_attributes({
                status: "APPROVAL",
                request_by: current_user.id,
                request_at: Time.now
            })
            flash[:notice] = "Refund #{@refund.code} was successfully submit for approval."
        end

        respond_to do |format|
            if @refund.save
                do_upload
                format.html { redirect_to internal_refunds_path }
                format.json { render :show, status: :ok, location: @refund }
            else
                format.html { render :edit }
                format.json { render json: @refund.errors, status: :unprocessable_entity }
            end
        end
    end

    def approval
    end

    def approval_update
        @refund.assign_attributes({
            approval_decision: approval_params[:decision],
            approval_comment: approval_params[:comment],
            approval_by: current_user.id,
            approval_at: Time.now
        })

        case approval_params[:decision]
        when "APPROVE"
            ## only for unutilised payment except bank draft
            submit_special_refund_collection(@refund) if @refund.payment_method.code != 'BANKDRAFT'
            if @is_success == true || @refund.payment_method.code == 'BANKDRAFT'
                @refund.update({
                    status: "PENDING_SEND"
                })
                flash[:notice] = "Request approved"
            else
                flash[:error] = "Fail to submit special refund collection for code '#{@refund.code}'. Please try again."
            end


            ## send refund as batch instead of realtime
            # if @is_success == true || @refund.payment_method.code == 'BANKDRAFT'
            #     submit_refund (@refund)
            # end

        when "REJECT"
            @refund.update({
                status: "REJECTED"
            })
            flash[:notice] = "Request rejected"
        end

        redirect_to internal_refunds_path
    end

    def cancel
        @refund.update({
            status: "CANCELLED"
        })
        flash[:notice] = "Request cancelled"

        redirect_to internal_refunds_path
    end

    # DELETE refunds/1
    # DELETE refunds/1.json
    def destroy
        @refund.uploads.destroy_all
        @refund.destroy
        respond_to do |format|
            format.html { redirect_to internal_refunds_path, notice: "Refund #{@refund.code} was successfully destroyed." }
            format.json { head :no_content }
        end
    end

    def status
    end

    def status_update
        @refund.assign_attributes(refund_params)

        if @refund.save
            redirect_to internal_refunds_path, notice: "Refund #{@refund.code} status updated."
        else
            render :status
        end
    end

    def do_upload
        if params[:refund].key?(:upload_deletes)
            @refund.uploads.where(id: params[:refund][:upload_deletes]).destroy_all
        end
        if params[:refund][:uploads].present?
            params[:refund][:uploads].each do |upload, key|
                upl = @refund.uploads.create
                upl.documents.attach(upload)
            end
        end
    end

    def bulk
        if params[:ids].blank?
            flash[:error] = "Please select refunds to be bulk updated";
            redirect_to internal_refunds_path and return
        end

        case params[:bulk_action]
        when "update_statuses"
            if Refund.where("refunds.id in (?) and refunds.status not in ('PENDING_PAYMENT')", params[:ids]).count > 0
                flash[:error] = "Refunds not in status #{Refund::STATUSES["PENDING_PAYMENT"]} detected, bulk update status is not done.";
                redirect_to internal_refunds_path and return
            end

            Refund.where("refunds.id in (?)", params[:ids]).each do |refund|
                refund.update({
                    status: params[:status]
                })
            end
            flash[:notice] = "Bulk update done.";
        end

        redirect_to internal_refunds_path
    end

    def reprocess
        if @refund.status != 'PAYMENT_FAILED'
            notice = "REFUND (#{@refund.code} STATUS IS NOT FAIL)"
        else
            @refund.status = 'PENDING_SEND'
            @refund.save
            notice = 'RE-PROCESSED FAILED REFUND'

            submit_refund (@refund)
        end

        redirect_back fallback_location: internal_refunds_path, notice: notice
    end

    def export
        @refunds = apply_scopes(Refund)
        .search_code(params[:code])
        .search_customerable_type(params[:customerable_type])
        .search_customerable_by_code(params[:customerable_type], params[:customer_code])
        .search_customerable_by_name(params[:customerable_type], params[:customer_name])
        .search_status(params[:status])
        .search_payment_method(params[:payment_method_id])
        .includes(:payment_method).includes(:customerable)
        .includes(:refund_items)
        .order('refunds.created_at DESC')

        respond_to do |format|
            format.html do
                @refunds = @refunds.page(params[:page])
                .per(get_per)
            end
            format.xlsx do
                render xlsx: 'index', filename: "refunds-#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx"
            end
            format.json { render json: @refunds }
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_refund
        @refund = Refund.find(params[:id])
    end

    def set_payment_methods
        _payment_method_code = @refund&.payment_method&.code

        if _payment_method_code == 'BANKDRAFT'
            @payment_methods = PaymentMethod.where(code: ['BANKDRAFT'])
        else
            @payment_methods = PaymentMethod.where.not(code: ['IPAY88','BANKDRAFT']).where("payment_methods.category = 'IN'").where(:active => 'true')
        end
    end

    def set_customerable_types
        @customerable_types = {}
        @customerable_types = @customerable_types.merge({
            "Agency" => "Agency",
            "Employer" => "Employer"
        })
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def refund_params
        params.require(:refund).permit(:code, :customerable_id, :customerable_type, :category, :date, :amount, :payment_method_id, :status, :comment, :additional_information, :payment_date, :reference, :unutilised)
    end
    def refund_status_params
        params.require(:refund).permit(:status, :comment)
    end

    def approval_params
        params.require(:approval).permit(:decision, :comment)
    end

    def validate_refunds
        _pm_id = refund_params[:payment_method_id]
        _amount = refund_params[:amount]
        _ref = refund_params[:reference]
        _payment_date = refund_params[:payment_date]

        ## check if refund already exist
        refund = Refund.where(:payment_method_id => _pm_id, :amount => _amount, :reference => _ref, :payment_date => _payment_date).where.not(:status => ['CANCELLED'])

        refund = refund.where.not(:id => @refund&.id) if params[:action] == 'update'

        if !refund.blank?
            flash[:error] = "Duplicate refund found."
            redirect_to (request.env["HTTP_REFERER"] || internal_refunds_path) and return
        end

        ## check if payment has already been utilised (cimb and ipay only)
        _payment_method = PaymentMethod.find(_pm_id)
        if ['CIMB_CLICKS'].include?(_payment_method.code) || _payment_method.is_ipay? || _payment_method.is_swipe? || _payment_method.is_fpx? || _payment_method.is_boleh?
            if ['CIMB_CLICKS'].include?(_payment_method.code)
                order_payment = OrderPayment.joins(:order)
                .where(orders:{payment_method_id: _pm_id, status: 'PAID'}).where(:reference => _ref, :amount => _amount, :issue_date => _payment_date)
            end

            if _payment_method.is_ipay?
                ## get ipay request ipay response
                order_payment = Order.joins(:latest_ipay88_request)
                .joins( "INNER JOIN ipay88_responses ON ipay88_requests.id = ipay88_responses.ipay88_request_id")
                .where(:payment_method_id => _pm_id, :status => 'PAID' ,:amount => _amount)
                .where('paid_at::date = ?',_payment_date)
                .where(ipay88_responses: {status: '1',transaction_id: _ref})
                .where('ipay88_requests.sync_date is not null')
            end

            if _payment_method.is_swipe?
                ## get swipe request swipe response
                order_payment = Order.joins(:latest_swipe_request)
                .joins( "INNER JOIN swipe_responses ON swipe_requests.id = swipe_responses.swipe_request_id")
                .where(:payment_method_id => _pm_id, :status => 'PAID' ,:amount => _amount)
                .where('paid_at::date = ?',_payment_date)
                .where(swipe_responses: {status: '1',transaction_id: _ref})
                .where('swipe_requests.sync_date is not null')
            end

            if _payment_method.is_fpx?
                ## get fpx request fpx response
                order_payment = Order.joins(:latest_fpx_request)
                .joins( "INNER JOIN fpx_responses ON fpx_requests.id = fpx_responses.fpx_request_id")
                .where(:payment_method_id => _pm_id, :status => 'PAID' ,:amount => _amount)
                .where('paid_at::date = ?',_payment_date)
                .where(fpx_responses: {debit_auth_code: '00', fpx_txn_id: _ref})
                .where('fpx_requests.sync_date is not null')
            end

            if _payment_method.is_boleh?
                ## get boleh request boleh response
                order_payment = Order.joins(:latest_boleh_request)
                .joins( "INNER JOIN boleh_responses ON boleh_requests.id = boleh_responses.boleh_request_id")
                .where(:payment_method_id => _pm_id, :status => 'PAID' ,:amount => _amount)
                .where('paid_at::date = ?',_payment_date)
                .where(boleh_responses: {status: 'approved', transaction_id: _ref})
                .where('boleh_requests.sync_date is not null')
            end

            if !order_payment.blank?
                flash[:error] = "Payment has already been utilised, cannot be refund."
                redirect_to (request.env["HTTP_REFERER"] || internal_refunds_path) and return
            end
        end
    end

    def set_mimes
        @mime_extensions = ".xls,.xlsx,.pdf,.jpeg,.jpg,.png,.csv,.doc,.docx,.tiff,.tif"
        @mime_content_types = ['application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet','application/pdf','image/jpeg','image/png','text/csv','application/msword','application/vnd.openxmlformats-officedocument.wordprocessingml.document','image/tiff']
    end

    def check_files
        if params[:refund][:uploads].present?
            params[:refund][:uploads].each do |upload, key|
                if !@mime_content_types.include?(upload.content_type)
                    flash[:error] = "File '#{upload.original_filename}' is invalid."
                    case params[:action]
                    when 'create'
                        @refund = Refund.new(refund_params)
                    else
                        @refund.assign_attributes(refund_params)
                    end
                    render params[:action] == 'create' ? :new : :edit and return
                end
            end
        end
    end

end
