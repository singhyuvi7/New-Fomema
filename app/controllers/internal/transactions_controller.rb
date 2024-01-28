class Internal::TransactionsController < InternalController
    include Approvalable
    include TransactionDocument
    include Sage
    include BankInfoCheck
    include XrayWebServiceHelper
    include MedicalExaminationInitializer
    include Insurance
    include WorkerBlocking
    include ProfileInfoCheck
    include Watermark

    skip_before_action :verify_authenticity_token, only: [:insurance_purchase]

    before_action :authenticate_internal_user!,except: [:insurance_purchase]
    before_action -> { can_access?("VIEW_ALL_TRANSACTION", "VIEW_BRANCH_TRANSACTION", "VIEW_OWN_TRANSACTION") },                       only: [:index, :show, :filter_doctors, :assign_doctors, :bulk_coupling_update]
    before_action -> { can_access?("CREATE_TRANSACTION") },                         only: [:new, :create]
    before_action -> { can_access?("EDIT_TRANSACTION") },                           only: [:edit, :update]
    before_action -> { can_access?("DELETE_TRANSACTION") },                         only: [:destroy]
    before_action -> { can_access?("CANCEL_TRANSACTION") },                         only: [:cancel, :cancel_update]
    before_action -> { can_access?("EXTEND_TRANSACTION") },                         only: [:extend, :extend_update]
    before_action -> { can_access?("APPROVAL_CHANGE_DOCTOR_TRANSACTION", "APPROVAL_SPECIAL_RENEWAL_TRANSACTION") }, only: [:approval, :approval_update]
    before_action -> { can_access?("SET_PHYSICAL_NOT_DONE_FOR_TRANSACTION") },      only: [:physical_exam_not_done]
    before_action -> { can_access?("SET_IGNORE_MERTS_EXPIRY_FOR_TRANSACTION") },    only: [:toggle_ignore_merts_expiry]
    before_action -> { can_access?("ABORT_RADIOLOGIST_TRANSACTION") },              only: [:abort_radiologist]
    before_action -> { can_access?("REVERT_LAB_RESULTS_FOR_TRANSACTION") },         only: [:revert_laboratory_status_to_exam]
    before_action -> { can_access?("REVERT_XRAY_RESULTS_FOR_TRANSACTION") },        only: [:revert_xray_status_to_exam]
    before_action -> { can_access?("REMOVE_EXAM_DATE_FOR_TRANSACTION") },           only: [:remove_transaction_examination_date]
    before_action -> { can_access?("UPDATE_TRANSACTION_RESULT_FOR_TRANSACTION") },  only: [:update_result]
    before_action -> { can_access?("AMEND_FINAL_RESULT_FOR_TRANSACTION") },         only: [:amend_final_status]
    before_action -> { can_access?("CONCUR_FINAL_RESULT_FOR_TRANSACTION") },        only: [:amendment_approval]
    before_action -> { can_access?("AMEND_FINAL_RESULT_FOR_TRANSACTION", "CONCUR_FINAL_RESULT_FOR_TRANSACTION") }, only: [:cancel_amendment]
    before_action -> { can_access?("PRINT_UNSUITABLE_SLIP") },                      only: [:unsuitable_slip]
    before_action -> { can_access?("PRINT_MEDICAL_EXAMINATION_FORM") },             only: [:medical_form_print,:bulk_print_medical_form]
    before_action -> { can_access?("PRINT_TCUPI_AUDIT_LETTER") },                   only: [:tcupi_audit_case_letter]
    before_action -> { can_access?("PRINT_TCUPI_NON_AUDIT_LETTER") },               only: [:tcupi_nonaudit_case_letter]
    before_action -> { can_access?("EDIT_UNSUITABLE_REASONS_FOR_TRANSACTION") },    only: [:update_unsuitable_reasons]
    before_action -> { can_access?("EDIT_BYPASS_FINGERPRINT_TRANSACTION") },        only: [:bypass_fingerprint, :bypass_fingerprint_update]
    before_action -> { can_access?("EDIT_UNSUITABLE_SLIP_DOWNLOAD_IN_PORTAL") },    only: [:toggle_unsuitable_slip_download]
    before_action -> { can_access?("SET_IGNORE_CANCELLATION_RULE") },               only: [:toggle_ignore_cancellation_rule]
    before_action -> { can_access?("RESEND_UNSUITABLE_LETTER") },                   only: [:resend_unsuitable_letter]
    before_action -> { can_access?("SET_IMM_BLOCK") },                              only: [:toggle_imm_block]
    before_action -> { can_access?("SET_IGNORE_RENEWAL_RULES_FOR_TRANSACTION") },   only: [:toggle_ignore_renewal_rule]
    before_action -> { can_access?("PRINT_MEDICAL_REPORT_LETTER") },                only: [:medical_report_letter]
    before_action -> { can_access?("EDIT_MEDICAL_REPORT_LETTER_DOWNLOAD_IN_PORTAL") },    only: [:toggle_medical_report_letter_download]
    before_action -> { can_access?("SET_IGNORE_SPECIAL_RENEWAL_RULES_FOR_TRANSACTION") },   only: [:toggle_ignore_special_renewal_rule]

    before_action :set_transaction, only: [:show, :edit, :update, :destroy, :cancel, :cancel_update, :extend, :extend_update, :approval, :approval_update, :unsuitable_slip, :new_doctor_approval_letter, :new_laboratory_approval_letter, :new_radiologist_approval_letter, :new_xray_approval_letter, :tcupi_audit_case_letter, :tcupi_nonaudit_case_letter, :abort_radiologist, :update_unsuitable_reasons, :bypass_fingerprint, :bypass_fingerprint_update, :toggle_unsuitable_slip_download, :coupling, :coupling_update, :toggle_ignore_cancellation_rule, :resend_unsuitable_letter, :digital_xray_availability, :toggle_imm_block, :toggle_ignore_renewal_rule, :agency_document_approval, :agency_document_approval_update, :appeal_pdpa_form, :medical_report_letter, :toggle_medical_report_letter_download, :view_approval, :toggle_ignore_special_renewal_rule, :special_renewal_authorisation_letter, :bypass_fingerprint_approval, :bypass_fingerprint_approval_update, :examination_report, :sync_latest_passport_number]
    before_action :set_order_item, if: -> { @transaction.approval_request&.category == "TRANSACTION_CHANGE_DOCTOR" }, only: [:approval ,:approval_update]
    before_action :set_fees, only: [:approval, :approval_update]
    # check bank info
    # before_action -> { can_proceed?(@transaction.try(:employer)) }, only: [:cancel,:cancel_update]
    # before_action -> { can_proceed?(@transaction.try(:employer)) }, if: -> { !['TRANSACTION_CHANGE_DOCTOR','TRANSACTION_SPECIAL_RENEWAL'].include?(@transaction.approval_request.category) || (@transaction.approval_request.category == "TRANSACTION_CHANGE_DOCTOR" && !@order_item.blank? && @order_item&.amount.try(:to_f) > 0) }, only: [:approval, :approval_update]
    # before_action -> { can_proceed?(@transaction.try(:employer),params[:edit_transaction].to_unsafe_h) }, if: -> { params[:select_doctor_type] == "change" && (Fee.find(params[:fee_id]).try(:amount) > 0) }, only: [:assign_doctors]
    # before_action -> { can_proceed?(@transaction.try(:employer)) }, if: -> { ['TRANSACTION_SPECIAL_RENEWAL'].include?(@transaction.approval_request.category) && approval_params[:decision] == 'REJECT' }, only: [:approval_update]
    before_action -> { can_proceed?(nil, @transaction.try(:employer), @transaction.id) }, only: [:cancel,:cancel_update]
    before_action -> { can_proceed?(nil, @transaction.try(:employer), @transaction.id) }, if: -> { !['TRANSACTION_CHANGE_DOCTOR','TRANSACTION_SPECIAL_RENEWAL'].include?(@transaction.approval_request.category) || (@transaction.approval_request.category == "TRANSACTION_CHANGE_DOCTOR" && !@order_item.blank? && @order_item&.amount.try(:to_f) > 0) }, only: [:approval, :approval_update]
    before_action -> { can_proceed?(nil, @transaction.try(:employer), params[:edit_transaction]) }, if: -> { params[:select_doctor_type] == "change" && (Fee.find(params[:fee_id]).try(:amount) > 0) }, only: [:assign_doctors]
    before_action -> { can_proceed?(nil, @transaction.try(:employer), @transaction.id) }, if: -> { ['TRANSACTION_SPECIAL_RENEWAL'].include?(@transaction.approval_request.category) && approval_params[:decision] == 'REJECT' }, only: [:approval_update]
    before_action -> { pending_profile_update?(Employer.find_by(id: @employer.id))  }, only: [ :cancel]

    def index
        # Only for Pending Review & Pending Review Approval Transactions Listing page. This is a requirement from Medical PR team, probably Munirah. NF-801.
        if params[:cookied_path] == "y" && session[:cookied_pr_and_approval_path].present?
            redirect_to "#{ request.path }?#{ session[:cookied_pr_and_approval_path] }" and return
        elsif ["pending_review", "pending_review_approval", "pending_review_and_review_approval","pending_pr_qa"].include?(params[:review_status])
            session[:cookied_pr_and_approval_path] = request.url.split("?")[1].gsub("cookied_path=y", "")
        end

        has_any_parameter   = [:worker_code, :worker_name, :gender, :passport_number, :country_id, :code, :certification_status, :review_status, :xray_status, :order_code, :field_set, :branch_id, :employer_state_id, :transaction_date_start, :transaction_date_end, :medical_examination_date_start, :medical_examination_date_end, :certification_date_start, :certification_date_end, :approval_status, :employer_code].map {|param_name| params[param_name].present? }.include?(true)

        if has_any_parameter
            trans_date = params[:transaction_date_start].present? ? params[:transaction_date_start] : "1998-03-14"

            transactions = Transaction.search_code(params[:code])
                .search_order_code(params[:order_code])
                .search_fw_passport(params[:passport_number])
                .search_fw_country(params[:country_id])
                .search_fw_gender(params[:gender])
                .search_fw_name(params[:worker_name])
                .search_fw_code(params[:worker_code])
                .search_transaction_date_start(trans_date)
                .search_transaction_date_end(params[:transaction_date_end])
                .search_medical_date_start(params[:medical_examination_date_start])
                .search_medical_date_end(params[:medical_examination_date_end])
                .search_certification_date_start(params[:certification_date_start])
                .search_certification_date_end(params[:certification_date_end])
                .search_transaction_final_result(params[:certification_status])
                .search_medical_status(params[:review_status])
                .search_xray_status(params[:xray_status])
                .search_employer_code(params[:employer_code])
                .search_employer_state(params[:employer_state_id])
                .search_branch(params[:branch_id])
                .search_doctor_code(params[:doctor_code])
                .search_request_start_date(params[:request_start_date])
                .search_request_end_date(params[:request_end_date])
                .search_assigned_to(params[:assigned_to], params[:certification_status])

            if has_permission?("VIEW_ALL_TRANSACTION")
            elsif has_permission?("VIEW_BRANCH_TRANSACTION")
                transactions    = transactions.where("transactions.organization_id = ?", current_user.userable_id)
            elsif has_permission?("VIEW_OWN_TRANSACTION")
                transactions    = transactions.where("transactions.created_by = ?", current_user.id)
            end
        else
            transactions = Transaction.none
        end

        transactions        = transactions.search_approval_status(params[:approval_status]) if params[:approval_status].present?

        if params[:field_set] == "tcupi" || params[:review_status].present?
            params[:per]    = 200 if params[:per].blank? # This is required by users. They work on many at once, and don't like to navigate elsewhere.

            ids_for_count   =
                if ["tcupi", "tcupi_approval"].include?(params[:review_status])
                    transactions.select("transactions.id, transactions.fw_maid_online, transactions.tcupi_date")
                else
                    transactions.select("transactions.id, transactions.fw_maid_online, transactions.certification_date")
                end

            case_count      = ids_for_count.try(:size) || 0
            @display_total  = "Displaying #{ case_count } #{ "case".pluralize( case_count ) }"

            # No need to cast for this. Seems like it is relatively fast.
            @trans_ids      =
                if ["tcupi", "tcupi_approval"].include?(params[:review_status])
                    ids_for_count.order("fw_maid_online desc, tcupi_date asc").page(params[:page]).per(get_per).without_count
                else
                    ids_for_count.order("fw_maid_online desc, certification_date asc").page(params[:page]).per(get_per).without_count
                end
        else
            need_to_cast    = [:worker_name, :employer_state_id, :certification_status].map {|param_type| params[param_type].present?}.include?(true)
            # For cases that query with LIKE, or is complex (uses join or a lot of IN/LIKE), it is better to use CAST. However, if the query returns a dataset which is large, ordering by CAST will still be slow, but it seems like it's performance is still faster than regular ordering. After testing, ordering with CAST varchar can be 2 times (if many records) to 30 times (if little records) faster than normal ordering.

            @trans_ids      =
                if need_to_cast
                    transactions.select("transactions.id, cast(transactions.transaction_date as varchar) date_sort")
                else
                    transactions.select("transactions.id, transactions.transaction_date date_sort")
                end.order("date_sort desc").page(params[:page]).per(get_per).without_count
        end

        transactions        = Transaction.where(id: @trans_ids.map(&:id))
        transactions        = transactions.includes(:laboratory, :xray_facility, :radiologist) if params[:field_set] == "doctors"
        @transactions       = transactions.includes(:doctor_examination, :latest_medical_review, :latest_tcupi_review, :doctor, :pending_transaction_amendment, :myimms_transaction, :fw_country)
    end

    def export
        has_any_parameter   = [:worker_code, :worker_name, :gender, :passport_number, :country_id, :code, :certification_status, :review_status, :xray_status, :order_code, :field_set, :branch_id, :employer_state_id, :transaction_date_start, :transaction_date_end, :medical_examination_date_start, :medical_examination_date_end, :certification_date_start, :certification_date_end, :approval_status, :employer_code].map {|param_name| params[param_name].present? }.include?(true)

        if has_any_parameter
            trans_date = params[:transaction_date_start].present? ? params[:transaction_date_start] : "1998-03-14"

            transactions = Transaction.search_code(params[:code])
                .search_order_code(params[:order_code])
                .search_fw_passport(params[:passport_number])
                .search_fw_country(params[:country_id])
                .search_fw_gender(params[:gender])
                .search_fw_name(params[:worker_name])
                .search_fw_code(params[:worker_code])
                .search_transaction_date_start(trans_date)
                .search_transaction_date_end(params[:transaction_date_end])
                .search_medical_date_start(params[:medical_examination_date_start])
                .search_medical_date_end(params[:medical_examination_date_end])
                .search_certification_date_start(params[:certification_date_start])
                .search_certification_date_end(params[:certification_date_end])
                .search_transaction_final_result(params[:certification_status])
                .search_medical_status(params[:review_status])
                .search_xray_status(params[:xray_status])
                .search_employer_code(params[:employer_code])
                .search_employer_state(params[:employer_state_id])
                .search_branch(params[:branch_id])
                .search_doctor_code(params[:doctor_code])

            if has_permission?("VIEW_ALL_TRANSACTION")
            elsif has_permission?("VIEW_BRANCH_TRANSACTION")
                transactions    = transactions.where("transactions.organization_id = ?", current_user.userable_id)
            elsif has_permission?("VIEW_OWN_TRANSACTION")
                transactions    = transactions.where("transactions.created_by = ?", current_user.id)
            end
        else
            transactions = Transaction.none
        end

        transactions        = transactions.search_approval_status(params[:approval_status]) if params[:approval_status].present?

        if params[:field_set] == "tcupi" || params[:review_status].present?
            ids_for_count   =
                if ["tcupi", "tcupi_approval"].include?(params[:review_status])
                    transactions.select("transactions.id, transactions.fw_maid_online, transactions.tcupi_date")
                else
                    transactions.select("transactions.id, transactions.fw_maid_online, transactions.certification_date")
                end

            case_count      = ids_for_count.try(:size) || 0
            @display_total  = "Displaying #{ case_count } #{ "case".pluralize( case_count ) }"

            # No need to cast for this. Seems like it is relatively fast.
            @trans_ids      =
                if ["tcupi", "tcupi_approval"].include?(params[:review_status])
                    ids_for_count.order("fw_maid_online desc, tcupi_date asc")
                else
                    ids_for_count.order("fw_maid_online desc, certification_date asc")
                end
        else
            need_to_cast    = [:worker_name, :employer_state_id, :certification_status].map {|param_type| params[param_type].present?}.include?(true)
            # For cases that query with LIKE, or is complex (uses join or a lot of IN/LIKE), it is better to use CAST. However, if the query returns a dataset which is large, ordering by CAST will still be slow, but it seems like it's performance is still faster than regular ordering. After testing, ordering with CAST varchar can be 2 times (if many records) to 30 times (if little records) faster than normal ordering.

            @trans_ids      =
                if need_to_cast
                    transactions.select("transactions.id, cast(transactions.transaction_date as varchar) date_sort")
                else
                    transactions.select("transactions.id, transactions.transaction_date date_sort")
                end.order("date_sort desc")
        end

        transactions        = Transaction.where(id: @trans_ids.map(&:id))
        transactions        = transactions.includes(:laboratory, :xray_facility, :radiologist) if params[:field_set] == "doctors"
        @transactions       = transactions.includes(:doctor_examination, :latest_medical_review, :latest_tcupi_review, :doctor, :pending_transaction_amendment, :myimms_transaction, :fw_country)

        respond_to do |format|
            format.xlsx do
                render xlsx: 'index', filename: "transactions-#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx"
            end
        end
    end

    def show
        redirect_to internal_transaction_path(@transaction.id), notice: "Viewing Transaction ##{ @transaction.code }" and return if params[:history].present?
        @worker                 = @transaction.foreign_worker
        redirect_to internal_transactions_path, flash: {error: "Invalid record, foreign worker not found"} and return if @worker.nil?
        @employer               = @transaction.employer
        @doctor                 = @transaction.doctor
        @laboratory             = @transaction.laboratory
        @xray_facility          = @transaction.xray_facility
        @radiologist            = @transaction.radiologist
        @medical_review         = @transaction.latest_medical_review    if @transaction.latest_medical_review && @transaction.latest_medical_review.medical_mle1_decision_at?
        @tcupi_review           = @transaction.latest_tcupi_review      if @medical_review.present?
        @pcr_comments           = @transaction.pcr_reviews
        @xray_pending_decisions = @transaction.xray_pending_decisions

        # NF-1722 - show only transaction's related, no need previous blah blah blah
        # @previous_xqcc_pd       = XrayPendingDecision.joins(:transactionz).where(status: "TRANSMITTED", transactions: { foreign_worker_id: @transaction.foreign_worker_id}).where.not(transaction_id: @transaction.id).includes(:transactionz).order(id: :desc)

        # NF-1835 - Display transaction_comments & xqcc_transaction_comments from migrated data.
        @display_t_comments     = @transaction.transaction_comments.order(:created_at)
        @display_xt_comments    = @transaction.xqcc_transaction_comments.order(:created_at)

        @appeal                 = @transaction.latest_medical_appeal
        @appeals                = @transaction.medical_appeals.order(:id).includes(:medical_appeal_comments, latest_medical_appeal_approval: [:medical_mle2], medical_appeal_todos: [:appeal_todo])

        if @tcupi_review.present?
            tcupi_todos             = @tcupi_review.transaction_tcupi_todos.pluck(:tcupi_todo_id)
            @tcupi_audit_letter     = tcupi_todos.include?(6) # To audit CXR by FOMEMA
            @tcupi_non_audit_letter = (tcupi_todos - [6]).present?
        end

        @past_exams             = @worker.transactions.where.not(id: @transaction.try(:id)).order(transaction_date: :desc)
        @result_updates         = @transaction.transaction_result_updates.includes(:user).order(id: :desc)
        @amendments             = @transaction.transaction_amendments.includes(:user, :approved_by).order(id: :desc)
        @reversions             = @transaction.transaction_reversions.order(id: :desc).includes(:user)
        @skip_visited           = true

        # NF-1651 - Abort radiologist for Retake cases.
        @latest_retake      = @transaction.xray_retake
        @retake_can_abort   =  @latest_retake.present? && ["APPROVED", "IN_PROGRESS", "NEW", "EXAM"].include?(@latest_retake.status) && @latest_retake.radiologist_id? && @latest_retake.xray_examination&.radiologist_aborted_at.blank?
    end

    def new
        @transaction = Transaction.new
    end

    def create
        @transaction = Transaction.new(transaction_params)

        respond_to do |format|
            if @transaction.save
                format.html { redirect_to internal_transactions_path, notice: 'Transaction was successfully created.' }
                format.json { render :show, status: :created, location: @transaction }
            else
                format.html { render :new }
                format.json { render json: @transaction.errors, status: :unprocessable_entity }
            end
        end
    end

    def edit
    end

    def update
        @transaction.assign_attributes(transaction_params)
        update_ok = @transaction.save
        respond_to do |format|
            if update_ok
                format.html { redirect_to internal_transactions_url, notice: 'Transaction was successfully updated.' }
                format.json { render :show, status: :ok, location: @transaction }
            else
                format.html { render :edit }
                format.json { render json: @transaction.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @transaction.destroy
        respond_to do |format|
            format.html { redirect_to internal_transactions_url, notice: 'Transaction was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def cancel
        if !@transaction.can_cancel?
            flash[:error] = "Transaction #{@transaction.code} is not allow to cancel"
            redirect_to internal_transaction_path(@transaction) and return
        end
        @transaction_cancel = @transaction.transaction_cancels.new
    end

    def cancel_update
        if !@transaction.medical_examination_date.nil?
            flash[:error] = "Cancel request is rejected because medical examination has started"
            redirect_to internal_transactions_path and return
        end
        if transaction_cancel_params[:reason].strip.empty?
            flash.now[:error] = "Cancel reason is required"
            render :cancel and return
        end

        @transaction.transaction do
            cancel_fee = Fee.find(transaction_cancel_params[:fee_id])
            cancel_amount = cancel_fee.amount
            registration_amount = @transaction.order_item.amount
            refund_amount = registration_amount - cancel_amount
            customer = @transaction.try(:agency) || @transaction.employer
            @agency = @transaction.try(:agency)

            # Unblock IMM if it is agency transaction
            unblock_reason = BlockReason.find_by(code: "OTHER", category: "UNBLOCK")
            unblock_comment = "TRANSACTION CANCELLED, DOCUMENT VERIFICATION NOT DONE BY OPERATION TEAM."
            if !@agency.nil? and @transaction.foreign_worker.is_imm_blocked and @transaction.foreign_worker.block_reason.code == "DOCVERIFY"
                unblock_imm(@transaction.foreign_worker, unblock_reason, unblock_comment, user: current_user)
            end

            if refund_amount > 0
                payment_method_id = cancel_amount > 0 ? @transaction.order_item.order.payment_method_id : PaymentMethod.find_by(code: "FOC").try(:id)

                @order = Order.create({
                    customerable: customer,
                    category: "TRANSACTION_CANCELLATION",
                    payment_method_id: payment_method_id,
                    amount: cancel_amount,
                    status: 'PAID',
                    organization_id: @transaction.organization_id
                })

                @order.order_items.create({
                    order_itemable: @transaction,
                    fee_id: cancel_fee.id,
                    amount: cancel_amount
                })

                @refund = Refund.create({
                    customerable: customer,
                    category: "TRANSACTION_CANCELLATION",
                    payment_method_id: payment_method_id,
                    status: 'PENDING_SEND',
                    organization_id: @transaction.organization_id,
                    comment: [
                        "Transaction Registration Amount: #{registration_amount}",
                        "Transaction Cancellation Amount: #{cancel_amount}",
                        "Refund Amount: #{refund_amount}"
                    ].join("\n")
                })

                @refund.refund_items.create([{
                    refund_itemable: @transaction,
                    amount: registration_amount,
                },{
                    refund_itemable: @order,
                    amount: cancel_amount == 0 ? 0 : -cancel_amount
                }])
                @transaction.update({
                    status: "CANCELLED"
                })
                @transaction.transaction_cancels.create(transaction_cancel_params.merge({
                    cancelled_by: current_user.id,
                    cancelled_at: Time.now,
                    status: "COMPLETED",
                }))

                ## send refund as batch instead of realtime
                # submit_refund (@refund)

                flash[:notice] = "Transaction cancelled, refund record created"
                redirect_to internal_transactions_path and return
            elsif refund_amount < 0
                @order = Order.create({
                    customerable: customer,
                    category: "TRANSACTION_CANCELLATION",
                    amount: refund_amount.abs,
                    status: "PENDING_PAYMENT",
                    organization_id: @transaction.organization_id
                })
                @order.order_items.create({
                    order_itemable: @transaction,
                    fee: cancel_fee,
                    amount: refund_amount.abs
                })
                @transaction.update({
                    status: "CANCEL_PENDING_PAYMENT"
                })
                @transaction.transaction_cancels.create(transaction_cancel_params.merge({
                    cancelled_by: current_user.id,
                    status: "PENDING_PAYMENT",
                }))
                flash[:notice] = "Payment is required, please proceed to payment"
                redirect_to edit_internal_order_path @order and return
            elsif refund_amount == 0
                payment_method_id = cancel_amount > 0 ? @transaction.order_item.order.payment_method_id : PaymentMethod.find_by(code: "FOC").try(:id)

                @order = Order.create({
                    customerable: customer,
                    category: "TRANSACTION_CANCELLATION",
                    payment_method_id: payment_method_id,
                    amount: cancel_amount,
                    status: 'PAID',
                    paid_at: DateTime.now,
                    organization_id: @transaction.organization_id
                })

                @order.order_items.create({
                    order_itemable: @transaction,
                    fee_id: cancel_fee.id,
                    amount: cancel_amount
                })

                @transaction.update({
                    status: "CANCELLED"
                })
                @transaction.transaction_cancels.create(transaction_cancel_params.merge({
                    cancelled_by: current_user.id,
                    cancelled_at: Time.now,
                    status: "COMPLETED",
                }))

                flash[:notice] = "Transaction cancelled"
                redirect_to internal_transactions_path(code: @transaction.code) and return
            end
        end
        # /db-transaction
    end

    def extend
        if !@transaction.extended_at.nil?
            flash[:error] = "Transaction #{@transaction.code} was extended on #{@transaction.extended_at.strftime("%d/%m/%Y")}, only 1 extention allowed."
            redirect_to (request.env["HTTP_REFERER"] || internal_transactions_path) and return
        end

        # fee = Fee.find_by(code: "EXTEND_TRANSACTION")
        # order = Order.create({
        #     customerable: @transaction.employer,
        #     category: "TRANSACTION_EXTENTION",
        #     amount: fee.amount,
        #     status: "NEW"
        # })
        # order.order_items.create({
        #     order_itemable: @transaction,
        #     fee_id: fee.id,
        #     amount: fee.amount
        # })
        # flash[:notice] = "Order created, please proceed to payment"
        # redirect_to edit_internal_order_path order

        @fee = Fee.find_by(code: 'EXTEND_TRANSACTION')
    end

    def extend_update
        if !@transaction.extended_at.nil?
            flash[:error] = "Transaction #{@transaction.code} was extended on #{@transaction.extended_at.strftime("%d/%m/%Y")}, only 1 extention allowed."
            redirect_to (request.env["HTTP_REFERER"] || internal_transactions_path) and return
        end

        @fee = Fee.find(params[:fee_id])

        order = Order.create({
            customerable: @transaction.employer,
            category: "TRANSACTION_EXTENTION",
            amount: @fee.amount,
            status: "NEW"
        })
        order.order_items.create({
            order_itemable: @transaction,
            fee_id: @fee.id,
            amount: @fee.amount
        })

        if @fee.amount > 0
            flash[:notice] = "Order #{order.code} created, please proceed to payment"
            redirect_to edit_internal_order_path order and return
        else
            order.update({
                status: 'PAID',
                paid_at: DateTime.now,
                payment_method: PaymentMethod.find_by(code: "FOC")
            })
        end

        @transaction.extend
        redirect_to internal_transactions_path(:code => @transaction.code), notice: "Transaction is extended." and return
    end

    def approval
        @transaction.assign_attributes(@transaction.approval_item.params)
        case @transaction.approval_request.category
        when "TRANSACTION_CHANGE_DOCTOR"
            @do_refund = "Y"
            render :approval_change_doctor
        when "TRANSACTION_SPECIAL_RENEWAL"
            # organization = Organization.find_by_code('PT').id
            # if @transaction.organization_id == organization
            #     @fee_id = Fee.find_by(code: "SPECIAL_RENEWAL_REJECTED_FEE").id
            # else
                @fee_id = Fee.find_by(code: "FOC").id
            # end
            render :approval_special_renewal
        end
    end

    def view_approval
        render :approval_special_renewal
    end

    def approval_update
        case @transaction.approval_request.category
        when "TRANSACTION_CHANGE_DOCTOR"
            @do_refund = params[:do_refund] || "Y"
            case approval_params[:decision]
            when 'APPROVE'
                flash[:notice] = 'Transaction change doctor request is approved'
                approval_approve_request(@transaction, comment: params[:approval][:comment])
                @transaction.transaction_change_sps.where(status: "APPROVAL").order(created_at: :desc).first.update({
                    decision: "APPROVE",
                    status: "APPROVED",
                    approval_comment: params[:approval][:comment],
                    approval_by: current_user.id,
                    approval_at: Time.now
                })
                @transaction.reset_reprint_count

            when 'REJECT'
                @transaction.transaction_change_sps.where(status: "APPROVAL").order(created_at: :desc).first.update({
                    decision: "REJECT",
                    status: "REJECTED",
                    approval_comment: params[:approval][:comment],
                    approval_by: current_user.id,
                    approval_at: Time.now
                })
                if @do_refund.eql?("Y")
                    if @order_item

                        if @order_item.amount > 0
                            customer = @transaction.try(:agency) || @transaction.employer
                            @refund = Refund.create({
                                customerable: customer,
                                category: "REJECT_TRANSACTION_CHANGE_DOCTOR",
                                amount: @order_item.amount,
                                payment_method_id: @order_item.order.payment_method_id,
                                status: 'PENDING_SEND',
                                organization_id: @order_item&.order&.organization_id
                            })
                            @refund.refund_items.create({
                                refund_itemable: @transaction,
                                amount: @order_item.amount,
                            })

                            ## send refund as batch instead of realtime
                            # submit_refund (@refund)

                            flash_msg = "Transaction change doctor request is rejected, refund #{@refund.code} is created"
                        else
                            flash_msg = "Transaction change doctor request is rejected"
                        end

                        update_order_item = OrderItem.find(@order_item.id)
                        if !update_order_item.blank?
                            update_order_item.update_columns({
                                refunded_at: DateTime.now
                            })
                        end

                        flash[:notice] = flash_msg
                    else
                        flash[:notice] = 'Transaction change doctor request is rejected'
                    end
                else
                    flash[:notice] = "Transaction change doctor request is rejected";
                end
                approval_reject_request(@transaction, comment: params[:approval][:comment])

                # send email
                 TransactionMailer.with({
                    transaction: @transaction,
                    employer: @transaction.employer,
                    agency: @transaction.try(:agency),
                    do_refund: @do_refund
                }).transaction_amend_email.deliver_later
            end
        when "TRANSACTION_SPECIAL_RENEWAL"
            transaction_verify_doc = TransactionVerifyDoc.where(transaction_id: @transaction.id, category: "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION").order(id: :desc).first

            if params[:transaction].present?
                params[:transaction][:uploads].each do |upload|
                    if (!upload[:category].nil? && !upload[:documents].nil?)
                        upl = @transaction.uploads.create(category: upload[:category], remark: "SPECIAL_RENEWAL")
                        upl.documents.attach(upload[:documents])
                    end
                end
            end

            if @transaction.expired_at > Time.now
                case approval_params[:decision]
                when "APPROVE"
                    flash[:notice] = 'Special Renewal transaction is approved'
                    approval_approve_request(@transaction, comment: params[:approval][:comment], record_update_attributes: {
                        status: "NEW"
                    })
                    t = Transaction.find(@transaction.id)
                    t.update!({
                        status: "NEW",
                        approval_status: "NEW_APPROVED"
                    })

                    # send email
                    TransactionMailer.with({
                        transaction: @transaction,
                        employer: @transaction.employer,
                        agency: @transaction.try(:agency),
                        do_refund: 'N',
                    }).transaction_amend_email.deliver_later

                when "REJECT"
                    flash[:notice] = 'Special Renewal transaction is rejected'
                    approval_reject_request(@transaction, comment: params[:approval][:comment], record_update_attributes: {
                        status: "REJECTED"
                    })
                        service_fee = Fee.find(params[:fee_id])
                        service_amount = service_fee.amount
                        registration_amount = @transaction.order_item&.amount
                        refund_amount = registration_amount - service_amount
                        @service_fee_code = service_fee.code

                    if refund_amount > 0
                        payment_method_id = service_amount > 0 ? @transaction.order_item.order.payment_method_id : PaymentMethod.find_by(code: "FOC").try(:id)

                        customer = @transaction.try(:agency) || @transaction.employer

                        @order = Order.create({
                            customerable: customer,
                            category: "TRANSACTION_SPECIAL_RENEWAL_REJECT",
                            payment_method_id: payment_method_id,
                            amount: service_amount,
                            status: 'PAID',
                            organization_id: @transaction.organization_id
                        })

                        @order.order_items.create({
                            order_itemable: @transaction,
                            fee_id: service_fee.id,
                            amount: service_amount
                        })

                        order_item = @transaction.order_item
                        if !order_item.blank?
                            order_item.update_columns({
                                refunded_at: DateTime.now
                            })
                        end

                        @refund = Refund.create({
                            customerable: customer,
                            category: "TRANSACTION_SPECIAL_RENEWAL_REJECT",
                            payment_method_id: @transaction.order_item.order.payment_method_id,
                            status: 'PENDING_SEND',
                            organization_id: @transaction.organization_id,
                            comment: [
                                "Transaction Registration Amount: #{registration_amount}",
                                "Special Renewal Rejected Fee: #{service_amount}",
                                "Refund Amount: #{refund_amount}"
                            ].join("\n")
                        })

                        @refund.refund_items.create([{
                            refund_itemable: @transaction,
                            amount: registration_amount,
                        },{
                            refund_itemable: @order,
                            amount: service_amount == 0 ? 0 : -service_amount
                        }])
                    end
                        ## send refund as batch instead of realtime
                        # submit_refund (@refund)
                        flash[:notice] = "Special Renewal transaction is rejected, refund #{@refund.code} is created"
                        TransactionMailer.with({
                            transaction: @transaction,
                            employer: @transaction.employer,
                            agency: @transaction.try(:agency),
                            do_refund: 'N',
                            service_fee: @service_fee_code
                    }).transaction_amend_email.deliver_later
                end
            else
                flash[:notice] = 'Approval is not allowed because the transaction is expired.'
            end
        else
            case approval_params[:decision]
            when 'APPROVE'
                flash[:notice] = 'Request is approved'
                approval_approve_request(@transaction, comment: params[:approval][:comment])

            when 'REJECT'
                flash[:notice] = 'Request is rejected'
                approval_reject_request(@transaction, comment: params[:approval][:comment])

            when 'REVERT'
                flash[:notice] = 'Request is reverted'
                approval_revert_request(@transaction, comment: params[:approval][:comment])
            end
        end

        redirect_to @redirect_to || internal_transactions_path(:code => @transaction.code)
    end

    def filter_doctors
        params[:per] = 10 if params[:per].blank?

        if params[:tid] == '0'
            @doctors = Doctor.order(:name).includes(:state, :town, xray_facility: [:state, :town], laboratory: [:state, :town])
                .search_code(params[:code])
                .search_name(params[:name])
                .search_clinic_name(params[:clinic_name])
                .search_state(params[:state_id])
                .search_town(params[:town_id])
                .search_postcode(params[:postcode])
                .search_has_xray(params[:has_xray])
                .where("doctors.status = 'ACTIVE' and  doctors.laboratory_id is not null and doctors.xray_facility_id is not null")
                .where("doctors.quota + doctors.quota_modifier - doctors.quota_used > 0")
                .page(params[:page]).per(params[:per])

        else
            if params[:reregister] == '0'
                # doctor listing for blood group benchmark transaction
                prev_transaction = Transaction.find(params[:tid]).previous_transaction
                @doctors = Doctor.order(:name).includes(:state, :town, xray_facility: [:state, :town], laboratory: [:state, :town])
                    .search_code(params[:code])
                    .search_name(params[:name])
                    .search_clinic_name(params[:clinic_name])
                    .search_state(params[:state_id])
                    .search_town(params[:town_id])
                    .search_postcode(params[:postcode])
                    .search_has_xray(params[:has_xray])
                    .joins("join laboratories on doctors.laboratory_id = laboratories.id")
                    .where("(laboratories.service_provider_group_id = ? or laboratories.id = ?)", Laboratory.find(prev_transaction.laboratory_id).service_provider_group_id, Laboratory.find(prev_transaction.laboratory_id))
                    .where("doctors.id != ? and doctors.status = 'ACTIVE' and doctors.laboratory_id is not null and doctors.xray_facility_id is not null", prev_transaction.doctor_id)
                    .where("doctors.quota + doctors.quota_modifier - doctors.quota_used > 0")
                    .page(params[:page]).per(params[:per])
            else
            #doctor listing for reregister
                @doctors = Doctor.order(:name).includes(:state, :town, xray_facility: [:state, :town], laboratory: [:state, :town])
                .search_code(params[:code])
                .search_name(params[:name])
                .search_clinic_name(params[:clinic_name])
                .search_state(params[:state_id])
                .search_town(params[:town_id])
                .search_postcode(params[:postcode])
                .search_has_xray(params[:has_xray])
                .where("doctors.status = 'ACTIVE' and  has_selected_re_medical='true' and doctors.laboratory_id is not null and doctors.xray_facility_id is not null")
                .where("doctors.quota + doctors.quota_modifier - doctors.quota_used > 0")
                .page(params[:page]).per(params[:per])
            end
        end

        render layout: false
    end

    def assign_doctors
        key_pairs = params[:edit_transaction].to_unsafe_h
        flash[:errors] = []

        if params[:select_doctor_type] == "change"
            # check doctor availability
            doctor_count = {}
            key_pairs.each do |transaction_id, doctor_id|
                doctor_count[doctor_id] = (doctor_count[doctor_id] || 0) + 1
            end
            doctor_count.each do |doctor_id, count|
                doctor = Doctor.find(doctor_id)
                if doctor.available_quota_with_grace < count
                    flash[:error] = "Doctor #{doctor.name} (#{doctor.code}) has insufficient quota"
                    redirect_to request.referrer and return
                end
            end
            # /check doctor availability

            # change_sp_reason = ChangeSpReason.find(params[:change_reason_id])
            change_sp_reason_id = params[:change_reason_id]
            change_reason = params[:change_reason].present? ? params[:change_reason].strip : nil
            fee = Fee.find(params[:fee_id])

            customers = {}
            key_pairs.each do |transaction_id, doctor_id|
                transaction = Transaction.find(transaction_id)
                if transaction.approval_status.eql?("UPDATE_PENDING_APPROVAL")
                    flash[:errors] << "transaction #{transaction.code} is pending for approval, change doctor request is not created"
                    next
                end
                if !transaction.agency_id.nil?
                    customers["A#{transaction.agency_id}"] = [] if !customers.key?("A#{transaction.agency_id}")
                    customers["A#{transaction.agency_id}"] << {transaction: transaction, doctor_id: doctor_id}
                else
                    customers["E#{transaction.employer_id}"] = [] if !customers.key?("E#{transaction.employer_id}")
                    customers["E#{transaction.employer_id}"] << {transaction: transaction, doctor_id: doctor_id}
                end
            end

            customers.each do |customers_id, arr|
                if customers_id.start_with?("E")
                    customerable_type = 'Employer'
                    customerable_id = customers_id[1..]
                elsif customers_id.start_with?("A")
                    customerable_type = 'Agency'
                    customerable_id = customers_id[1..]
                end
                order = Order.create({
                    category: "TRANSACTION_CHANGE_DOCTOR",
                    customerable_type: customerable_type,
                    customerable_id: customerable_id,
                    amount: 0
                })
                arr.each do |row|
                    doctor = Doctor.find(row[:doctor_id])
                    transaction_change_sp = row[:transaction].transaction_change_sps.create({
                        change_sp_reason_id: change_sp_reason_id,
                        requester_comment: change_reason,
                        old_doctor_id: row[:transaction].doctor_id,
                        old_laboratory_id: row[:transaction].laboratory_id,
                        old_xray_facility_id: row[:transaction].xray_facility_id,
                        new_doctor_id: doctor.id,
                        new_laboratory_id: doctor.laboratory_id,
                        new_xray_facility_id: doctor.xray_facility_id,
                        requested_by: current_user.id,
                        requested_at: Time.now,
                        status: 'APPROVAL'
                    })
                    order.order_items.create({
                        order_itemable: row[:transaction],
                        fee: fee,
                        amount: fee.amount,
                        additional_information: {
                            transaction: {
                                "doctor_id" => doctor.id,
                                "laboratory_id" => doctor.laboratory_id,
                                "xray_facility_id" => doctor.xray_facility_id,
                            },
                            transaction_change_sp_id: transaction_change_sp.id
                        }
                    })
                end

                if fee.amount <= 0
                    order.update({
                        status: 'PAID',
                        paid_at: DateTime.now,
                        payment_method: PaymentMethod.find_by(code: "FOC")
                    })
                end
            end

            if fee.amount > 0
                flash[:notice] = "Order created, please proceed to payment"
                redirect_to internal_orders_path(status: "NEW", category: "TRANSACTION_CHANGE_DOCTOR") and return
            end

            key_pairs.each do |transaction_id, doctor_id|
                transaction = Transaction.find(transaction_id)
                if transaction.approval_status.eql?("UPDATE_PENDING_APPROVAL")
                    flash[:errors] << "transaction #{transaction.code} is pending for approval, change doctor request is not created"
                    next
                end
                doctor = Doctor.find(doctor_id)
                transaction.assign_attributes({
                    "doctor_id" => doctor.id,
                    "laboratory_id" => doctor.laboratory_id,
                    "xray_facility_id" => doctor.xray_facility_id,
                })
                approval_update_request(transaction, category: "TRANSACTION_CHANGE_DOCTOR")

                # auto approve
                user = User.admin_user
                approval_comment = 'Transaction change doctor request is approved automatically'
                approval_approve_request(transaction, user: user, comment: approval_comment)
                transaction.transaction_change_sps.where(status: "APPROVAL").order(created_at: :desc).first.update({
                    decision: "APPROVE",
                    status: "APPROVED",
                    approval_comment: approval_comment,
                    approval_by: user.id,
                    approval_at: Time.now
                })
                transaction.reset_reprint_count
                # end auto approve
            end
            flash[:notice] = "Change doctor request is created and approved"
            redirect_to (request.env["HTTP_REFERER"] || internal_transactions_path) and return
        else # assign
            # check doctor availability
            doctor_count = {}
            key_pairs.each do |transaction_id, doctor_id|
                doctor_count[doctor_id] = (doctor_count[doctor_id] || 0) + 1
            end
            doctor_count.each do |doctor_id, count|
                doctor = Doctor.find(doctor_id)
                if doctor.available_quota_with_grace < count
                    flash[:error] = "Doctor #{doctor.name} (#{doctor.code}) has insufficient quota"
                    redirect_to request.referrer and return
                end
            end
            # /check doctor availability

            # Blood group discrepancy checking
            key_pairs.each do |transaction_id, doctor_id|
                doctor = Doctor.find(doctor_id)
                t = Transaction.find(transaction_id)
                if t.is_blood_group_benchmark
                    prev_t = t.previous_transaction
                    if prev_t.doctor_id == doctor_id.to_i || Laboratory.find(prev_t.laboratory_id).service_provider_group_id != Laboratory.find(doctor.laboratory_id).service_provider_group_id
                        flash[:error] = "You are not allow to select #{doctor.name} (#{doctor.code}) for re-medical transaction (#{t.fw_code})."
                        redirect_to request.referrer and return
                    end
                end
            end

            # assign doctor
            key_pairs.each do |transaction_id, doctor_id|
                doctor = Doctor.find(doctor_id)
                Transaction.find(transaction_id).update({
                    doctor_id: doctor.id,
                    laboratory_id: doctor.laboratory_id,
                    xray_facility_id: doctor.xray_facility_id
                })
            end
            # /assign doctor

            redirect_to internal_transactions_path(print_form: key_pairs.keys), notice: "Workers & doctors paired" and return
        end
    end

    # No permissions set yet. Looks like used in xray dispatch. - by Joey
    def transaction_by_code
        transactions    = Transaction.where(code: params[:code], xray_film_type: "ANALOG").where.not(certification_date: nil)
        render json: { error: "TRANSACTION NOT FOUND" } and return if transactions.blank?
        @transaction    = transactions.first
        existing        = XrayDispatchItem.where(transaction_id: @transaction.id).present?
        render json: { already_used: true } and return if existing
        @xray_dispatch  = XrayDispatch.new
        @xray_dispatch.xray_dispatch_items.build
        render layout: false
    end

    # No permissions set yet. Looks like used in xray dispatch. - by Joey
    def transaction_by_code_storage
        @transaction = Transaction.find_by(code: params[:code])
        @xray_storage = XrayStorage.new
        @xray_storage.xray_storage_items.build

        # params[:xray_storage_id]

        if @transaction.nil?
            render json: {error: "TRANSACTION NOT FOUND"} and return
        end

        render layout: false
    end

    def physical_exam_not_done
        @transaction    = Transaction.find_by(id: params[:id])
        redirect_to internal_transactions_path and return if @transaction.blank? || !["EXAMINATION", "CERTIFICATION"].include?(@transaction.status)
        @transaction.update(final_result: "UNSUITABLE", medical_result: "UNSUITABLE", medical_status: "CERTIFIED", status: "CERTIFIED", physical_exam_not_done: true, not_done_officer_id: current_user.id, not_done_set_at: Time.now, certification_date: Time.now)
        doctor          = @transaction.doctor
        doctor.update_quota_used(-1) if doctor.present? && @transaction.transaction_date.year == Date.today.year # Do not reimburse if transaction was registered the year before.
        myimms          = MyimmsTransaction.find_or_initialize_by(transaction_id: @transaction.id)
        myimms.update(status: 99)
        redirect_to internal_transaction_path(@transaction)
    end

    def toggle_ignore_merts_expiry
        @transaction    = Transaction.find_by(id: params[:id])
        redirect_to internal_transactions_path and return if @transaction.blank?
        @transaction.update(ignore_expiry: params[:type] == "disable", ignore_merts_expiry_at: params[:type] == "disable" ? Time.now : nil)
        redirect_to internal_transaction_path(@transaction), notice: "MERTS expiry rules #{ @transaction.ignore_expiry ? "ignored" : "enabled" }"
    end

    def toggle_ignore_reprint_rules
        @transaction    = Transaction.find_by(id: params[:id])
        redirect_to internal_transactions_path and return if @transaction.blank?
        @transaction.update(ignore_reprint_rule: params[:type] == "disable")
        redirect_to internal_transaction_path(@transaction), notice: "Reprint rules #{ @transaction.ignore_reprint_rule ? "ignored" : "enabled" }"
    end

    def abort_radiologist
        latest_retake   = @transaction.xray_retake

        if latest_retake.present? && ["APPROVED", "IN_PROGRESS", "NEW", "EXAM"].include?(latest_retake.status) && latest_retake.radiologist_id? && latest_retake.xray_examination&.radiologist_aborted_at.blank?
            latest_retake.xray_examination.update(radiologist_aborted_at: Time.now, radiologist_started_at: nil)
        else
            @transaction.xray_examination.update(radiologist_aborted_at: Time.now, radiologist_started_at: nil)
        end

        redirect_to internal_transaction_path(@transaction), notice: "Radiologist aborted"
    end

    def revert_laboratory_status_to_exam
        @transaction    = Transaction.find_by(id: params[:id])
        @transaction.laboratory_examination.really_destroy!
        @transaction.status = "EXAMINATION" if @transaction.status == "CERTIFICATION"
        @transaction.update(laboratory_transmit_date: nil)
        TransactionReversion.create(transaction_id: @transaction.id, exam_type: "LaboratoryExamination", issues: params[:lab_revert_issues])
        flash[:lab_revert_success] = true
        redirect_to internal_transaction_path(@transaction)
    end

    def revert_xray_status_to_exam
        @transaction    = Transaction.find_by(id: params[:id])
        @exam           = @transaction.xray_examination.really_destroy!
        @transaction.status = "EXAMINATION" if @transaction.status == "CERTIFICATION"
        @transaction.update(xray_transmit_date: nil, radiologist_id: nil, xray_reporter_type: "SELF") # Do not remove fingerprint -> xray_worker_identity_confirmed
        TransactionReversion.create(transaction_id: @transaction.id, exam_type: "XrayExamination", issues: params[:xray_revert_issues])
        flash[:xray_revert_success] = true
        redirect_to internal_transaction_path(@transaction)
    end

    def remove_transaction_examination_date
        @transaction    = Transaction.find_by(id: params[:id])
        redirect_to internal_transactions_path and return if @transaction.blank?
        redirect_to internal_transactions_path and return if @transaction.expired_at <= Time.now

        @transaction.update(medical_examination_date: nil, status: "NEW", transmission_expired_at: nil)
        TransactionReversion.create(transaction_id: @transaction.id, exam_type: "Examination Date", issues: params[:medical_revert_issues])
        flash[:medical_revert_success] = true
        redirect_to internal_transaction_path(@transaction)
    end

    def update_result
        @transaction    = Transaction.find_by(id: params[:id])
        redirect_to internal_transactions_path and return if @transaction.blank?
        return redirect_to internal_transaction_path(@transaction), error: "There is already a pending transaction amendment" if @transaction.transaction_amendments.where(approval_status: nil).present?

        certification_codes = Condition.where(code: DoctorExamination::CERTIFICATION.values).pluck(:id)
        cert_comment_id = Condition.find_by(code: "5501").id
        med_exam = @transaction.medical_examination || @transaction.doctor_examination

        case med_exam.class.to_s
        when "MedicalExamination"
            detail_conditions = med_exam.medical_examination_details.where(condition_id: certification_codes).includes(:condition)
            comment_condition = med_exam.medical_examination_comments.find_by(condition_id: cert_comment_id)
        when
            detail_conditions = med_exam.doctor_examination_details.where(condition_id: certification_codes).includes(:condition)
            comment_condition = med_exam.doctor_examination_comments.find_by(condition_id: cert_comment_id)
        end

        code_to_key_map     = DoctorExamination::CERTIFICATION.invert
        positive_details    = detail_conditions.map {|detail| code_to_key_map[detail.condition.code] }.uniq
        current_details     = DoctorExamination::CERTIFICATION.map {|key, value| [key, positive_details.include?(key) ? "true" : "false"] }.to_h
        submitted_details   = params[:de_attributes].to_unsafe_h.except("certification_comment").transform_values {|val| val == "" ? "false" : val }
        changes_made        = submitted_details.select {|key, value| current_details[key.to_sym] != value }
        comment             = params[:de_attributes][:certification_comment]
        changes_made.merge!({ certification_comment: comment }) if (comment_condition&.comment || "") != comment

        @amendment = TransactionResultUpdate.create!(
            transaction_id: @transaction.id,
            amendment_reason: params[:transaction_amendment_reason],
            wrong_transmission_doctor: params[:check_box__doctor_transmission] == "true",
            wrong_transmission_lab: params[:check_box__lab_transmission] == "true",
            wrong_transmission_xray: params[:check_box__xray_transmission] == "true",
            medical_conditions: changes_made
        )

        # Create medical exam object if it doesnt exist
        medical_examination = @transaction.medical_examination || create_medical_examination(@transaction)
        certification_codes = Condition.where(code: DoctorExamination::CERTIFICATION.values).pluck(:id)
        detail_conditions   = medical_examination.medical_examination_details.where(condition_id: certification_codes).includes(:condition)
        code_to_key_map     = DoctorExamination::CERTIFICATION.invert
        positive_details    = detail_conditions.map {|detail| code_to_key_map[detail.condition.code] }.uniq
        current_details     = DoctorExamination::CERTIFICATION.map {|key, value| [key, positive_details.include?(key) ? "true" : "false"] }.to_h
        saved_changes       = current_details.with_indifferent_access.merge(@amendment.amended_conditions)
        cert_comment_id     = Condition.find_by(code: "5501").id
        comment_condition   = medical_examination.medical_examination_comments.find_by(condition_id: cert_comment_id)&.comment

        medical_examination.save_examination_details_and_comments(
            regular_fields: saved_changes,
            comments:       { "certification_comment" => @amendment.amended_comment.present? ? @amendment.amended_comment : comment_condition }
        )

        # Data will be inserted to amended_notifiable_transaction if there is communicable disease
        @transaction.update!(condition_amended_at: Time.now)

        # Add to MOH notification if it is communicable disease
        quarantine      = @transaction.medical_quarantine_release_date? || @transaction.xray_quarantine_release_date? ? "Y" : "N"
        release_date    = [@transaction.medical_quarantine_release_date, @transaction.xray_quarantine_release_date].compact.max

        diseases = MohNotification.communicable_diseases_hash.with_indifferent_access.map do |key, value|
            value if @amendment.amended_conditions.has_key?(key) && @amendment.amended_conditions[key] == "true"
        end.compact

        diseases.each do |disease|
            MohNotification.find_or_create_by(transaction_id: @transaction.id, disease: disease, quarantined: quarantine, quarantine_release_date: release_date)
        end

        redirect_to internal_transaction_path(@transaction), notice: "MERTS Result for #{ @transaction.foreign_worker&.code } has been successfully updated in MERTS"
    end

    def amend_final_status
        @transaction    = Transaction.find_by(id: params[:id])
        return redirect_to internal_transactions_path if @transaction.blank?
        return redirect_to internal_transaction_path(@transaction), error: "There is already a pending transaction amendment" if @transaction.transaction_amendments.where(approval_status: nil).present?
        new_status          = @transaction.final_result == "SUITABLE" ? "UNSUITABLE" : "SUITABLE"
        certification_codes = Condition.where(code: DoctorExamination::CERTIFICATION.values).pluck(:id)
        cert_comment_id     = Condition.find_by(code: "5501").id
        med_exam            = @transaction.medical_examination || @transaction.doctor_examination

        case med_exam.class.to_s
        when "MedicalExamination"
            detail_conditions   = med_exam.medical_examination_details.where(condition_id: certification_codes).includes(:condition)
            comment_condition   = med_exam.medical_examination_comments.find_by(condition_id: cert_comment_id)
        when
            detail_conditions   = med_exam.doctor_examination_details.where(condition_id: certification_codes).includes(:condition)
            comment_condition   = med_exam.doctor_examination_comments.find_by(condition_id: cert_comment_id)
        end

        code_to_key_map     = DoctorExamination::CERTIFICATION.invert
        positive_details    = detail_conditions.map {|detail| code_to_key_map[detail.condition.code] }.uniq
        current_details     = DoctorExamination::CERTIFICATION.map {|key, value| [key, positive_details.include?(key) ? "true" : "false"] }.to_h
        submitted_details   = params[:de_attributes].to_unsafe_h.except("certification_comment").transform_values {|val| val == "" ? "false" : val }
        changes_made        = submitted_details.select {|key, value| current_details[key.to_sym] != value }
        comment             = params[:de_attributes][:certification_comment]
        changes_made.merge!({ certification_comment: comment }) if (comment_condition&.comment || "") != comment

        TransactionAmendment.create!(transaction_id: @transaction.id,
                                     original_status: @transaction.final_result,
                                     new_status: new_status,
                                     amendment_reason: params[:transaction_amendment_reason],
                                     wrong_transmission_doctor: params[:check_box__doctor_transmission] == "true",
                                     wrong_transmission_lab: params[:check_box__lab_transmission] == "true",
                                     wrong_transmission_xray: params[:check_box__xray_transmission] == "true",
                                     medical_conditions: changes_made)

        redirect_to internal_transaction_path(@transaction), notice: "Certification status change request for #{@transaction.foreign_worker&.code} as #{new_status} has been successfully submitted."
    end

    def amendment_approval
        @transaction    = Transaction.find_by(id: params[:id])
        @amendment      = TransactionAmendment.find_by(id: params[:amendment_id])
        return redirect_to internal_transactions_path if @transaction.blank?
        @amendment.assign_attributes(approval_by: current_user.id, approval_at: Time.now, approval_comment: params[:transaction_amendment_reason])

        if params[:transaction_concur_decision] == "approve"
            @amendment.update!(approval_status: "CONCURRED")
            @transaction.update!(final_result: @amendment.new_status)
            text = "concurred"

            # Create medical exam object if it doesnt exist
            medical_examination = @transaction.medical_examination || create_medical_examination(@transaction)
            certification_codes = Condition.where(code: DoctorExamination::CERTIFICATION.values).pluck(:id)
            detail_conditions   = medical_examination.medical_examination_details.where(condition_id: certification_codes).includes(:condition)
            code_to_key_map     = DoctorExamination::CERTIFICATION.invert
            positive_details    = detail_conditions.map {|detail| code_to_key_map[detail.condition.code] }.uniq
            current_details     = DoctorExamination::CERTIFICATION.map {|key, value| [key, positive_details.include?(key) ? "true" : "false"] }.to_h
            saved_changes       = current_details.with_indifferent_access.merge(@amendment.amended_conditions)
            cert_comment_id     = Condition.find_by(code: "5501").id
            comment_condition   = medical_examination.medical_examination_comments.find_by(condition_id: cert_comment_id)&.comment

            medical_examination.save_examination_details_and_comments(
                regular_fields: saved_changes,
                comments:       { "certification_comment" => @amendment.amended_comment.present? ? @amendment.amended_comment : comment_condition }
            )

            # Data will be inserted to amended_notifiable_transaction if there is communicable disease
            @transaction.update!(condition_amended_at: Time.now)
        elsif params[:transaction_concur_decision] == "reject"
            @amendment.update!(approval_status: "REJECTED")
            text = "rejected"
        end

        redirect_to internal_transaction_path(@transaction), notice: "Certification status change for #{@transaction.foreign_worker&.code} as #{@amendment.new_status} has been successfully #{text}."
    end

    def cancel_amendment
        @transaction    = Transaction.find_by(id: params[:id])
        @amendment      = TransactionAmendment.find_by(id: params[:amendment_id])
        return redirect_to internal_transactions_path if @transaction.blank?
        @amendment.update!(cancelled_at: Time.now, cancelled_by: current_user)
        redirect_to internal_transaction_path(@transaction), notice: "Amendment request cancelled."
    end

    def update_unsuitable_reasons
        reason_ids = params[:selected] || ""
        reason_ids = reason_ids.split(",")
        @transaction.transaction_unsuitable_reasons.where.not(unsuitable_reason_id: reason_ids).destroy_all

        reason_ids.each do |reason_id|
            reason = TransactionUnsuitableReason.with_deleted.find_or_initialize_by(transaction_id: @transaction.id, unsuitable_reason_id: reason_id)
            reason.created_by_system ||= false
            reason.deleted_at = nil
            reason.save
        end

        new_reason_ids = @transaction.transaction_unsuitable_reasons.pluck(:unsuitable_reason_id).map(&:to_s).sort.join(",")
        render json: { reason_ids: new_reason_ids }, status: :ok
    end

    def bypass_fingerprint
        @xray_retake = @transaction.latest_xray_retake
        @bypass_reasons = BypassFingerprintReason.select("id, description, case when code = 'OTHER' then '9' else '1' end seq").order("seq asc, description asc").all
    end

    def bypass_fingerprint_update

        transaction_params = params[:transaction]

        doctor_bypass_date = transaction_params[:doctor_fp] == 'true' ? DateTime.now : nil
        xray_bypass_date = transaction_params[:xray_fp] == 'true' ? DateTime.now : nil

        params[:transaction] = transaction_params.merge({
            "doctor_bypass_fingerprint_date" => doctor_bypass_date,
            "xray_bypass_fingerprint_date" => xray_bypass_date
        })

        @transaction.update(transaction_bypass_params)

        ## for xray retake
        if !@transaction.latest_xray_retake.blank?
            xray_retake_bypass_date = params[:xray_retake_fp] == 'true' ? DateTime.now : nil
            @transaction.latest_xray_retake.update({
                xray_fp: params[:xray_retake_fp],
                xray_bypass_fingerprint_date: xray_retake_bypass_date,
                xray_bypass_fingerprint_reason_id: params[:xray_retake_bypass_fingerprint_reason_id]
            })
        end

        redirect_to internal_transaction_path(@transaction), notice: "Bypass Fingerprint updated"
    end

    def toggle_unsuitable_slip_download
        @transaction.update(unsuitable_slip_download: !@transaction.unsuitable_slip_download)
        redirect_to internal_transaction_path(@transaction), notice: "Unsuitable slip download #{ @transaction.unsuitable_slip_download ? "enabled" : "disabled" } in Portal."
    end

    def toggle_medical_report_letter_download
        @transaction.update(medical_report_letter_download: !@transaction.medical_report_letter_download)
        redirect_to internal_transaction_path(@transaction), notice: "Medical Report Letter download #{ @transaction.medical_report_letter_download ? "enabled" : "disabled" } in Portal."
    end

    def reprint_medical_form
        if !params[:order_code].blank?
            order = Order.find_by_code(params[:order_code])
            if !order.blank? && order.category == 'REPRINT_MEDICAL_FORM'
                @transaction_ids = order.order_items.pluck(:order_itemable_id)
                print_medical_form
            else
                redirect_to internal_transactions_path, notice: "Please select transaction(s) to print medical form"
            end
        elsif params[:ids].blank?
            redirect_to internal_transactions_path, notice: "Please select transaction(s) to print medical form"
        else
            @fee = Fee.find_by(code: 'REPRINT_MEDICAL_FORM')
            @transactions = Transaction.select('transactions.id,transactions.code').where(id: params[:ids].split(','))
            @actual_transaction_with_payments = @transactions.joins(:medical_form_print_logs).group('transactions.id, transactions.code').having('count(medical_form_print_logs.transaction_id) > 0')
        end
    end

    def reprint_medical_form_update
        # create order item
        @transaction_ids = params[:ids].split(',')
        @transactions = Transaction.where(id: @transaction_ids)
        employers = @transactions.pluck(:employer_id).uniq

        # create order for medical form
        @order = Order.create({
            customerable: Employer.find(employers.first),
            category: "REPRINT_MEDICAL_FORM",
            additional_information: {
                transaction_ids: @transaction_ids
            }
        })

        @transactions.each do |transaction|
            print_count = transaction.medical_form_print_logs.count
            fee = print_count > 0 ? Fee.find(params[:fee_id]) : Fee.find_by_code('FOC')
            @order.order_items.create({
                order_itemable: transaction,
                fee_id: fee.id,
                amount: fee.amount
            })
        end

        @order.update_total_amount

        if @order.amount > 0
            redirect_to edit_internal_order_path(@order) and return
        else
            @order.update({
                status: 'PAID',
                paid_at: DateTime.now,
                payment_method: PaymentMethod.find_by(code: "FOC")
            })
        end

        redirect_to reprint_medical_form_internal_transactions_path(order_code: @order.code) and return
    end

    def coupling
        @doctors = Doctor.where(:status => 'ACTIVE').select('id,code,clinic_name as name')
        @xray_facilities = XrayFacility.where(:status => 'ACTIVE').select('id,code,name')
        @laboratories = Laboratory.where(:status => 'ACTIVE').select('id,code,name')
    end

    def coupling_update
        request_data = params[:transaction]
        @transaction.update(transaction_coupling_params)
        redirect_to internal_transaction_path(@transaction), notice: 'Transaction has been updated'
    end

    def bulk_coupling_update
        key_pairs = params[:to_be_changed_coupling].to_unsafe_h
        new_doctor = Doctor.find_by(id: params[:doctor_id]) if !params[:doctor_id].blank?
        new_laboratory = Laboratory.find_by(id: params[:laboratory_id]) if !params[:laboratory_id].blank?
        new_xray_facility = XrayFacility.find_by(id: params[:xray_facility_id]) if !params[:xray_facility_id].blank?

        flash[:errors] = []
        doctor_changed_transactions = []
        laboratory_changed_transactions = []
        xray_facility_changed_transactions = []

        key_pairs.each do |transaction_id, test|
            transaction = Transaction.find(transaction_id)
            if !transaction.medical_examination_date.blank?
                flash[:errors] << "Transaction #{transaction.code} has medical examination date, edit coupling is not allowed."
                next
            end

            if new_doctor
                transaction.update(doctor_id: new_doctor.id)
                doctor_changed_transactions << transaction.code
            end

            if new_laboratory
                if !transaction.laboratory_transmit_date.blank?
                    flash[:errors] << "Transaction #{transaction.code} has laboratory transmit date, edit coupling is not allowed."
                else
                    transaction.update(laboratory_id: new_laboratory.id)
                    laboratory_changed_transactions << transaction.code
                end
            end

            if new_xray_facility
                if !transaction.xray_transmit_date.blank?
                    flash[:errors] << "Transaction #{transaction.code} has xray transmit date, edit coupling is not allowed."
                elsif transaction.xray_examination.present?
                    flash[:errors] << "Transaction #{transaction.code} has xray examination, edit coupling is not allowed."
                else
                    transaction.update(xray_facility_id: new_xray_facility.id)
                    xray_facility_changed_transactions << transaction.code
                end
            end
        end

        message = "Transaction(s) coupling changed."
        message += "<br> Doctor: #{doctor_changed_transactions}" if !doctor_changed_transactions.blank?
        message += "<br> Laboratory: #{laboratory_changed_transactions}" if !laboratory_changed_transactions.blank?
        message += "<br> Xray Facility: #{xray_facility_changed_transactions}" if !xray_facility_changed_transactions.blank?

        redirect_to internal_transactions_path, notice: message.html_safe and return
    end

    def special_renewal_authorisation_letter
        transaction_id = params[:transaction_id]

        employer            = @transaction.employer
        employer_address    = [employer.address1, employer.address2, employer.address3, employer.address4, "#{ employer.postcode } #{ employer&.town&.name }", employer&.state&.name].select(&:present?)
        agency              = @transaction.agency

        @data = {
            letter_date:        Date.today.strftime("%d/%m/%Y"),
            worker_code:        @transaction.fw_code,
            worker_name:        @transaction.fw_name,
            worker_passport:    @transaction.fw_passport_number,
            worker_country:     @transaction.fw_country&.name,
            employer_address:   employer_address,
            employer_name:      employer.name,
            employer_phone:     employer.phone,
            employer_pic:       employer.pic_name? ?  employer.pic_name : employer.name,
            employer_ic_roc:    employer.business_registration_number? ?  employer.business_registration_number : employer.ic_passport_number,
            agency_name:        agency&.name,
            agency_phone:       agency&.phone,
        }

            pdf = "special_renewal_employer_authorisation_form_template"
            template = "/pdf_templates/special_renewal_employer_authorisation_form_template.html.erb"

        render pdf: pdf,
        template: template,
        layout: "pdf.html",
        margin: {
            top: "1cm",
            left: "2cm",
            right: "2cm",
            bottom: "1cm"
        },
        page_size: nil,
        page_height: "29.7cm",
        page_width: "21cm",
        dpi: "300",
        footer: { font_size: 8, right: "Page " "[page] of [topage]" }
    end

    def agency_document_approval

    end

    def agency_document_approval_update
        transaction_verify_doc = TransactionVerifyDoc.where(transaction_id: @transaction.id, category: "AGENCY_TRANSACTION_REGISTRATION").order(id: :desc).first

        if transaction_verify_doc.status != 'APPROVAL'
            flash[:error] = "Failed. Document verification status for transaction #{@transaction.code} (#{@transaction.foreign_worker.code}) is updated to #{} before."
            redirect_to internal_transactions_path and return
        end

        approve_action = params[:approve_action]
        approval_comment = params[:approval_comment]
        transaction_id = @transaction.id

        if approve_action === 'REJECT'
            message = 'rejected'
            status = 'REJECTED'
            context = :reject_documents
        elsif approve_action === 'INCOMPLETE'
            message = 'incomplete'
            status = 'INCOMPLETE'
            context = :incomplete_documents
        elsif approve_action === 'APPROVE'
            message = 'approved'
            status = 'APPROVE'
            context = :approve_documents
        end

        respond_to do |format|
            foreign_worker = @transaction.foreign_worker
            @employer = @transaction.employer
            @agency = @transaction.agency
            @fw = @transaction.foreign_worker

            if approve_action === 'APPROVE'
                unblock_reason = BlockReason.find_by(code: "VERIFICATIONDONE", category: "UNBLOCK")
                unblock_comment = "DOCUMENT VERIFIED BY OPERATION TEAM. #{approval_comment}"
                unblock_imm(@transaction.foreign_worker, unblock_reason, unblock_comment, user: current_user)

                transaction_verify_doc.update({
                    approval_by: current_user.id,
                    approval_at: Time.now,
                    decision: "APPROVE",
                    status: "APPROVED",
                    approval_comment: approval_comment
                })
            elsif approve_action === 'REJECT'
                transaction_verify_doc.update({
                    approval_by: current_user.id,
                    approval_at: Time.now,
                    decision: "REJECT",
                    status: "REJECTED",
                    approval_comment: approval_comment
                })

                send_agency_document_rejected_email(@agency, @employer, @fw, approval_comment)
            elsif approve_action === 'INCOMPLETE'
                transaction_verify_doc.update({
                    approval_by: current_user.id,
                    approval_at: Time.now,
                    decision: "INCOMPLETE",
                    status: "INCOMPLETE",
                    approval_comment: approval_comment
                })

                send_agency_document_incomplete_email(@agency, @employer, @fw, approval_comment, transaction_id)
            end

            format.html { redirect_to internal_transaction_path, notice: 'Transaction successfully ' + message }
            format.json { render :show, status: :ok, location: @transaction }
        end
    end

    def toggle_ignore_cancellation_rule
        @transaction.update(ignore_cancellation_rule: params[:type] == "disable")
        redirect_to internal_transaction_path(@transaction)
    end

    def resend_unsuitable_letter
        employer_email = @transaction.employer.email
        if @transaction.blocked_appeal_list("Doctor").present? && !(@transaction.blocked_appeal_list("Doctor").include? "A previous appeal was made for this foreign worker")
            #cannot appeal
            UnsuitableLetterSent.create(transaction_id: @transaction.id, send_type: "RESEND", email: employer_email)
            TransactionMailer.send_unsuitable_letter_cannot_appeal(@transaction.id).deliver_later
        else
            #can appeal
            UnsuitableLetterSent.create(transaction_id: @transaction.id, send_type: "RESEND", email: employer_email)
            TransactionMailer.send_unsuitable_letter(@transaction.id).deliver_later
        end
        redirect_to internal_transaction_path(@transaction), notice: "Unsuitable Letter resent to #{ employer_email }."
    end

    def digital_xray_availability
        result = checking_digital_xray_available(@transaction.xray_examination&.id)

        if result == :timeout_error
            render "shared/timeout_error_page", layout: false
        else
            render plain: "Transaction #{ @transaction.code } - Digital image available: #{ result ? "YES" : "NO" }"
        end
    end

    def toggle_imm_block
        @transaction.update(is_imm_blocked: params[:type] == "block")
        redirect_to internal_transaction_path(@transaction)
    end

    def toggle_ignore_renewal_rule
        @transaction.update(ignore_renewal_rule: params[:type] == "disable")
        redirect_to internal_transaction_path(@transaction), notice: "Renewal rules #{ @transaction.ignore_renewal_rule ? "ignored" : "enabled" }"
    end

    def toggle_ignore_special_renewal_rule
        @transaction.update(ignore_special_renewal_rule: params[:type] == "disable")
        redirect_to internal_transaction_path(@transaction), notice: "Special Renewal rules #{ @transaction.ignore_special_renewal_rule ? "ignored" : "enabled" }"
    end

    def send_agency_document_rejected_email(agency, employer, fw, approval_comment)
        TransactionMailer.with({
            recipient: @agency.email,
            employer: @employer,
            agency: @agency,
            fw: @fw,
            reason: approval_comment,
        }).agency_document_rejected_email.deliver_later
    end

    def send_agency_document_incomplete_email(agency, employer, fw, approval_comment, transaction_id)
        @url = "#{ENV["APP_URL_PORTAL"]}transactions/#{transaction_id}/reupload_doc"
        TransactionMailer.with({
            recipient: @agency.email,
            employer: @employer,
            agency: @agency,
            fw: @fw,
            reason: approval_comment,
            url: @url
        }).agency_document_incomplete_email.deliver_later
    end

    def bypass_fingerprint_approval
        render :approval_bypass_fingerprint
    end

    def bypass_fingerprint_approval_update
        transaction_verify_doc = TransactionVerifyDoc.where(id: params[:transaction_verify_docs_id]).first

        if transaction_verify_doc.status != 'APPROVAL'
            flash[:error] = "Approval is not allowed."
            redirect_to internal_transactions_path and return
        end

        approval_decision = params[:approval_decision]
        approval_comment = params[:approval_comment]

        # Upload new document
        if params[:transaction][:uploads].present?
            params[:transaction][:uploads].each do |upload|
                if (!upload[:category].nil? && !upload[:documents].nil?)
                    add_watermark(upload[:documents])
                    upl = @transaction.uploads.create(category: upload[:category])
                    upl.documents.attach(upload[:documents])
                end
            end
        end
        if params[:remove_uploaded_file].present?
            ids = params[:remove_uploaded_file].split(",")
            @transaction.uploads.where(id: ids).destroy_all
        end

        if approval_decision === 'APPROVE'
            message = 'approved'
            status = 'APPROVED'
            status_bm = 'DILULUSKAN'
        elsif approval_decision === 'REJECT'
            message = 'rejected'
            status = 'REJECTED'
            status_bm = 'DITOLAK'
        end

        respond_to do |format|
            transaction_verify_doc.update({
                approval_by: current_user.id,
                approval_at: Time.now,
                decision: approval_decision,
                status: status,
                approval_comment: approval_comment
            })

            # bypass_fingerprint_reason = BypassFingerprintReason.find_by(code: transaction_verify_doc.additional_information["bypass_fingerprint_reason"])
            bypass_fingerprint_reason = BypassFingerprintReason.find_by(code: params[:transaction_bypass_reason])

            if approval_decision === 'APPROVE'
                if transaction_verify_doc.category == "DOCTOR_TRANSACTION_BYPASS_FINGERPRINT"
                    @transaction.update({
                        doctor_fp: true,
                        doctor_bypass_fingerprint_reason_id: bypass_fingerprint_reason.id,
                        doctor_bypass_fingerprint_date: DateTime.now,
                    })
                elsif transaction_verify_doc.category == "XRAY_TRANSACTION_BYPASS_FINGERPRINT"
                    if transaction_verify_doc.sourceable_type == "Transaction"
                        @transaction.update({
                            xray_fp: true,
                            xray_bypass_fingerprint_reason_id: bypass_fingerprint_reason.id,
                            xray_bypass_fingerprint_date: DateTime.now,
                        })
                    elsif transaction_verify_doc.sourceable_type == "XrayRetake"
                        xray_retake = XrayRetake.find_by(id: transaction_verify_doc.sourceable_id)
                        xray_retake.update({
                            xray_fp: true,
                            xray_bypass_fingerprint_reason_id: bypass_fingerprint_reason.id,
                            xray_bypass_fingerprint_date: DateTime.now,
                        })
                    end
                end
            end

            # Block purchase medical form and send result
            if params[:suspected_biometric_fraud]
                block_reason = BlockReason.find_by(code: "SUSPECTED_BIOMETRIC_FRAUD", category: "BLOCK")
                block_comment = "SUSPECTED FRAUD DURING BIOMETRIC VERIFICATION"
                block_imm(@transaction.foreign_worker, block_reason, block_comment, user: current_user)
                block_reg_medical(@transaction.foreign_worker, block_reason, block_comment, user: current_user)
            end

            TransactionMailer.with({
                transaction: @transaction,
                decision: status,
                decision_bm: status_bm,
                approval_comment: approval_comment,
                transaction_verify_doc: transaction_verify_doc
            }).bypass_fingerprint_approval_email.deliver_later

            format.html { redirect_to internal_transactions_path, notice: 'Bypass fingerprint request successfully ' + message }
            format.json { render :show, status: :ok, location: @transaction }
        end
    end

    def sync_latest_passport_number
        # this is to update the passport number if the transaction is not latest transaction
        @transaction.update(fw_passport_number: @transaction.foreign_worker.passport_number)
        flash[:info] = "Passport number for transaction #{@transaction.code} has been sync successfully."
        redirect_to internal_transaction_path(@transaction)
    end
private
    def set_transaction
        @transaction = Transaction.find(params[:id]) or redirect_to internal_transactions_url, flash: {notice: "Transaction not found"}
    end

    def transaction_params
        params.require(:transaction).permit(:doctor_id, :laboratory_id, :xray_facility_id, :radiologist_id, :transaction_date, :medical_examination_date, :doctor_transmit_date, :laboratory_transmit_date, :xray_transmit_date, :expired_at, :extended_at, :certification_date, :status, :worker_matched, :worker_consented, :worker_identity_confirmed, :xray_worker_identity_confirmed, :xray_film_type, :xray_report_submission_type, :expired_at, :doctor_fp, :xray_fp)
    end

    def transaction_cancel_params
        params.require(:transaction_cancel).permit(:reason, :fee_id)
    end

    def transaction_coupling_params
        params.require(:transaction).permit(:doctor_id, :xray_facility_id, :laboratory_id)
    end

    def transaction_bypass_params
        params.require(:transaction).permit(:doctor_fp, :xray_fp, :doctor_bypass_fingerprint_reason_id, :xray_bypass_fingerprint_reason_id,:doctor_bypass_fingerprint_date, :xray_bypass_fingerprint_date)
    end

    def transaction_approval_params
        params.permit(:approval_comment)
    end

    def set_order_item
        # @order_item = @transaction.employer.orders.joins(:order_items)
        # .select("order_items.id, order_items.amount")
        # .where("orders.category = ? and orders.status = ? and order_items.order_itemable_type = ? and order_items.order_itemable_id = ?", "TRANSACTION_CHANGE_DOCTOR", "PAID", "Transaction", @transaction.id)
        # .where(order_items: {refunded_at: [nil, ""]})
        # .order('orders.created_by DESC').first

        @order_item = OrderItem.joins("join orders on order_items.order_id = orders.id").where("order_itemable_id = ? and order_itemable_type = ? and orders.category = ? and orders.status = ?", @transaction.id, "Transaction", "TRANSACTION_CHANGE_DOCTOR", "PAID").where(order_items: {refunded_at: [nil, ""]}).order("orders.created_by DESC").first

    end

    def set_fees
        @fees = Fee.where("code in (?)", ["SPECIAL_RENEWAL_REJECTED_FEE", "FOC"]).all
    end
end