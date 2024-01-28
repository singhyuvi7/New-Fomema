class External::TransactionsController < ExternalController
    include Approvalable
    include TransactionDocument
    include Insurance
    include Sage
    include BankInfoCheck
    include XrayExaminationModule
    include OrderPaymentUpdate
    include MertsExaminations
    include TransactionsIndexConcern
    include ProfileInfoCheck
    include WorkerBlocking
    include Watermark
    include ApprovalAssignmentCheck
    include AgencySopAcknowledgeCheck

    skip_before_action :verify_authenticity_token, only: [:insurance_purchase]

    before_action :authenticate_external_user!,                             except: [:insurance_purchase]
    before_action -> { can_access?("VIEW_ALL_TRANSACTION") },               only: [:index, :examination_history, :filter_doctors, :assign_doctors, :report_print, :bulk_print_medical_form]
    before_action -> { can_access?("CANCEL_TRANSACTION") },                 only: [:cancel, :cancel_update]
    before_action -> { can_access?("MEDICAL_EXAMINATION_TRANSACTION") },    only: [:medical_examination, :medical_examination_update, :tcupi_review, :tcupi_review_post, :verify_fingerprint]
    before_action -> { can_access?("PRINT_MEDICAL_EXAMINATION_FORM") },     only: [:medical_form_print,:bulk_print_medical_form]
    before_action -> { can_access?("PRINT_UNSUITABLE_SLIP") },              only: [:unsuitable_slip]
    before_action -> { can_access?("PRINT_MEDICAL_REPORT_LETTER") },        only: [:medical_report_letter]
    before_action -> { can_access?("PRINT_MEDICAL_EXAMINATION_REPORT", "PRINT_XRAY_EXAMINATION_REPORT") }, only: [:report_print]
    before_action :set_transaction,                                         only: [:show, :cancel, :cancel_update, :medical_examination, :medical_examination_update, :unsuitable_slip, :examination_history, :tcupi_audit_case_letter, :tcupi_nonaudit_case_letter, :report_print, :upload_doc, :reupload_doc, :appeal_pdpa_form, :view_tcupi, :medical_report_letter, :remove_exam_date, :remove_exam_date_update, :special_renewal_authorisation_letter, :can_submit_bypass_fingerprint_request, :bypass_fingerprint, :bypass_fingerprint_update]
    before_action :check_foreign_worker_blocked_or_monitoring,              only: [:medical_examination, :medical_examination_update, :tcupi_review, :tcupi_review_post]
    before_action :set_order,                                               only: [:index]

    # check bank info
    # before_action -> { can_proceed?(@transaction.try(:employer)) }, only: [:cancel,:cancel_update]
    # before_action -> { can_proceed?(@transaction.try(:employer),params[:edit_transaction]) }, if: -> { params[:select_doctor_type] == "change"}, only: [:assign_doctors]
    before_action -> { can_proceed?('Employer', @transaction.try(:employer), params[:id]) }, if: -> { current_user.userable_type == 'Employer' }, only: [:cancel,:cancel_update]
    before_action -> { can_proceed?('Agency', @transaction.try(:agency), params[:id]) }, if: -> { current_user.userable_type == 'Agency' }, only: [:cancel,:cancel_update]
    before_action -> { can_proceed?('Employer', @transaction.try(:employer), params[:edit_transaction]) }, if: -> { current_user.userable_type == 'Employer' && params[:select_doctor_type] == "change"}, only: [:assign_doctors]
    before_action -> { can_proceed?('Agency', @transaction.try(:agency), params[:edit_transaction]) }, if: -> { current_user.userable_type == 'Agency' && params[:select_doctor_type] == "change"}, only: [:assign_doctors]
    before_action -> { pending_profile_update?(Employer.find_by(id: current_user.userable_id)) }, if: -> { current_user.userable_type == 'Employer' }, only: [ :index]
    before_action -> { agency_sop_acknowledge_check?(Agency.find_by(id: current_user.userable_id)) }, if: -> { current_user.userable_type == 'Agency' }, only: [ :index]

    def index
        trans_date      = transactions_index_parameter_checking_and_cookies

        transactions    = Transaction.search_by_user_type(current_user)
            .search_transaction_date_start(trans_date) # Please do not remove this. This is necessary for faster queries.
            .search_fw_code(params[:worker_code])
            .search_fw_name(params[:worker_name])
            .search_fw_passport(params[:passport_number])
            .search_fw_country(params[:country_id])
            .search_code(params[:transaction_code])
            .search_certification_date_start(params[:certification_date_start])
            .search_certification_date_end(params[:certification_date_end])
            .search_doctor_clinic_code(params[:clinic_doctor_name])
            .search_order_code(params[:order_code])
            .search_transactions_external_status(params[:status], current_user.userable_type)
            .search_xray_facility_id(params[:xray_facility_id])

        if current_user.userable_type == "Employer" and !current_user.employer_supplement_id.blank?
            transactions    = transactions.where("exists (select 1 from foreign_workers where transactions.foreign_worker_id = foreign_workers.id and foreign_workers.employer_supplement_id = ?)", current_user.employer_supplement_id)
        end

        transactions_index_transactions_list(transactions)
        transactions_index_radiologist_xray_dropdown_list
        transactions_index_loading_state_list

        if ["Doctor", "Laboratory", "XrayFacility", "Radiologist"].include?(current_user.userable_type)
            @has_bulletin_pending_acknowledge = current_user.bulletins.where("require_acknowledge is true and not exists (select 1 from bulletin_user_view_logs buvl where buvl.bulletin_id = bulletins.id and buvl.user_id = ? and acknowledged is true)", current_user.id).count > 0
            if current_user.userable_type == "Doctor"
                message = "Please read and acknowledge Bulletins <b>Require Acknowledgement</b> before continue the medical examination"
            elsif current_user.userable_type == "XrayFacility"
                message = "Please read and acknowledge Bulletins <b>Require Acknowledgement</b> before continue the chest X-ray examination"
            else
                message = "Please read and acknowledge bulletins require acknowledgement before continue medical examination"
            end
            if @has_bulletin_pending_acknowledge
                redirect_to external_bulletins_path, warning: message
            end
        end
    end

    def show
        # There is nothing in this page. Redirect to Medical Examination.
        if @transaction.doctor_transmit_date? && ["Doctor", "Employer"].include?(current_user.userable_type)
            redirect_to examination_history_external_transaction_path(@transaction)
        else
            redirect_to medical_examination_external_transactions_path(@transaction)
        end
    end

    # (Start) Allow Error, incase bots try to access this page.
        def new
        end

        def create
        end

        def edit
        end

        def update
        end

        def destroy
        end
    # (End)

    def upload_doc
        redirect_to external_transactions_path and return if ['APPROVAL', 'APPROVED','REJECTED'].include? (@transaction.transaction_verify_docs.last&.status) or @transaction.status == "CANCELLED" or (@transaction.expired_at < Time.now and @transaction.medical_examination_date.nil?)
        upload_status = params[:upload_status]


        if @transaction.order_item.order.category == "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION"
            remark = "SPECIAL_RENEWAL"
            category = "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION"
            transaction_verify_doc_status = "APPROVED"
            notices = "Upload document successful and pending for approval"
        else
            remark = nil
            category = "AGENCY_TRANSACTION_REGISTRATION"
            transaction_verify_doc_status = "APPROVAL"

            if upload_status == 'reupload'
                notices ="Reupload document successful for #{@transaction.foreign_worker.name} (#{@transaction.foreign_worker.passport_number})."
            else
                notices = "Upload document successful, kindly proceed to select clinic."
            end
        end

        if params[:transaction].present?
            params[:transaction][:uploads].each do |upload|
                if (!upload[:category].nil? && !upload[:documents].nil?)
                    add_watermark(upload[:documents])
                    upl = @transaction.uploads.create(category: upload[:category], remark: remark)
                    upl.documents.attach(upload[:documents])
                end
            end

            if @transaction.order_item.order.category != "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION"

                @transaction.transaction_verify_docs.create({
                    transaction_id: @transaction.id,
                    category: category,
                    status: transaction_verify_doc_status,
                    submitted_by: current_user.id,
                    submitted_at: Time.now
                })
            end
            flash_add(:notices, notices)
            redirect_to external_transactions_path and return
        end
    end

    def reupload_doc
        redirect_to external_transactions_path and return if ['APPROVAL', 'APPROVED','REJECTED'].include? (@transaction.transaction_verify_docs.last&.status) or @transaction.status == "CANCELLED" or (@transaction.expired_at < Time.now and @transaction.medical_examination_date.nil?)
    end

    def remove_exam_date
        redirect_to external_transactions_path and return if @transaction.blank?
        redirect_to external_transactions_path and return if @transaction.expired_at <= Time.now
    end

    def remove_exam_date_update
        @transaction    = Transaction.find_by(id: params[:id])

        redirect_to external_transactions_path and return if @transaction.blank?
        redirect_to external_transactions_path and return if @transaction.expired_at <= Time.now

        @transaction.update(medical_examination_date: nil, status: "NEW", transmission_expired_at: nil)
        TransactionReversion.create(transaction_id: @transaction.id, exam_type: "Examination Date", issues: params[:medical_revert_issues])
        flash[:notice] = "Examination date for <b> #{@transaction.code} </b> has been successfully deleted in MERTS."
        redirect_to external_transactions_path and return
    end

    def cancel
        if @transaction.status != "NEW"
            flash[:error] = "Invalid transaction status. Please go to FOMEMA branch to cancel transaction #{@transaction.code}"
            redirect_to external_transactions_path and return
        end
        if !@transaction.can_cancel?
            flash[:error] = "Transaction #{@transaction.code} is not allow to cancel"
            redirect_to external_transactions_path and return
        end
        @transaction_cancel = @transaction.transaction_cancels.new
    end

    def cancel_update
        ActiveRecord::Base.transaction do
            @transaction.lock!

            if !@transaction.medical_examination_date.nil?
                flash[:error] = "Cancel request is rejected because medical examination has started"
                redirect_to external_transactions_path and return
            end
            if !['NEW'].include?(@transaction.status)
                flash[:error] = "Unable to cancel transaction #{@transaction.code}"
                redirect_to external_transactions_path and return
            end

            cancel_fee = Fee.find_by(code: "CANCEL_TRANSACTION")
            cancel_amount = cancel_fee.amount
            registration_amount = @transaction.order_item.amount
            refund_amount = registration_amount - cancel_amount
            customer = @transaction.try(:agency) || @transaction.employer
            @agency = @transaction.try(:agency)

            # Unblock IMM if it is agency transaction
            unblock_reason = BlockReason.find_by(code: "OTHER", category: "UNBLOCK")
            unblock_comment = "TRANSACTION CANCELLED, DOCUMENT VERIFICATION NOT DONE BY OPERATION TEAM."
            if !@agency.nil? and @transaction.foreign_worker.is_imm_blocked and @transaction.foreign_worker.block_reason.code == "DOCVERIFY"
                unblock_imm(@transaction.foreign_worker, unblock_reason, unblock_comment)
            end

            if refund_amount > 0
                @order = Order.create({
                    customerable: customer,
                    category: "TRANSACTION_CANCELLATION",
                    payment_method_id: @transaction.order_item.order.payment_method_id,
                    amount: cancel_amount,
                    status: 'PAID',
                    organization_id: @transaction.organization_id
                })

                @order.order_items.create({
                    order_itemable: @transaction,
                    fee_id: cancel_fee.id,
                    amount: cancel_amount
                })

                @employer = @transaction.employer
                @refund = Refund.create({
                    customerable: customer,
                    category: "TRANSACTION_CANCELLATION",
                    amount: refund_amount,
                    status: 'PENDING_SEND',
                    payment_method_id: @transaction.order_item.order.payment_method_id,
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

                @transaction.transaction_cancels.create({
                    cancelled_by: current_user.id,
                    cancelled_at: Time.now,
                    status: "COMPLETED",
                    fee_id: cancel_fee&.id
                })

                ## send refund as batch instead of realtime
                # submit_refund (@refund)

                flash[:notice] = "Your refund is being processed. Please note that the refund process shall take up to 14 working days from the date of request. You may go to refund module to check on the status from time to time."
                incomplete_bank_info = case
                when !@agency.nil?
                    @agency.bank_id.blank? or @agency.bank_account_number.blank?
                else
                    @employer.bank_id.blank? or @employer.bank_account_number.blank?
                end
                if incomplete_bank_info
                    flash[:warning] = "Bank and bank account information is required for refund, please update required information in profile."
                end
                redirect_to external_transactions_path and return
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
                @transaction.transaction_cancels.create({
                    cancelled_by: current_user.id,
                    status: "PENDING_PAYMENT",
                })

                flash[:notice] = "Payment is required, please proceed to payment"
                redirect_to edit_external_order_path(@order) and return
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

                @transaction.transaction_cancels.create({
                    cancelled_by: current_user.id,
                    cancelled_at: Time.now,
                    status: "COMPLETED",
                })

                flash[:notice] = "Transaction cancelled"
                redirect_to external_transactions_path and return
            else
                flash[:error] = "Please go to FOMEMA branch to cancel transaction #{@transaction.code}"
                redirect_to external_transactions_path and return
            end
        end
        # /db-transaction
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
                .where("doctors.status = 'ACTIVE' and doctors.laboratory_id is not null and doctors.xray_facility_id is not null")
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

        render "/internal/transactions/filter_doctors", layout: false
    end

    def assign_doctors
        # Do not use ActiveRecord::Base.transaction, it will work with callbacks after_save or after_commit, but saved_changes & previous_changes methods will stop working.
        # ActiveRecord::Base.transaction do
            # check doctor availability
                doctor_count    = {}
                key_pairs       = params[:edit_transaction].to_unsafe_h

                key_pairs.each do |transaction_id, doctor_id|
                    doctor_count[doctor_id] = (doctor_count[doctor_id] || 0) + 1
                end

                doctor_count.each do |doctor_id, count|
                    doctor = Doctor.find(doctor_id)

                    if doctor.available_quota < count
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

            key_pairs.each do |transaction_id, doctor_id|
                doctor = Doctor.find(doctor_id)

                Transaction.find(transaction_id).update(
                    doctor_id: doctor.id,
                    laboratory_id: doctor.laboratory_id,
                    xray_facility_id: doctor.xray_facility_id
                )
            end

            redirect_to external_transactions_path(print_form: key_pairs.keys), notice: "Workers and doctors paired"
        # end
    end

    def view_tcupi
        @tcupi_review           = @transaction.latest_tcupi_review
        tcupi_todos             = @tcupi_review.transaction_tcupi_todos.pluck(:tcupi_todo_id)
        @tcupi_audit_letter     = tcupi_todos.include?(6) # To audit CXR by FOMEMA
        @tcupi_non_audit_letter = (tcupi_todos - [6]).present?
    end

    def verify_fingerprint
        method = 'VerifyWorkerFP'
        fp_result = 0
        fw_transaction_id = params[:transaction_id]
        type = params[:type]
        @foreign_worker = ForeignWorker.find(params[:id])
        transaction = Transaction::find(fw_transaction_id)

        responsable = params[:xray_retake_id].blank? ? transaction : XrayRetake.find(params[:xray_retake_id])

        if @foreign_worker
            biodata = @foreign_worker.biodata_responses.last

            if biodata.blank?
                # return error couldnt find biodata
                response_data = {
                    status: 'error',
                    message: "Unable to get #{@foreign_worker.name} information."
                }
                log_biometric(fw_transaction_id, params, response_data, "couldn't find biodata error")
                render json: response_data
                return
            end

            url = URI.parse("http://"+ENV['JIM_HOST']+":"+ENV['JIM_PORT']+"/fomema/verifyWorkerFP")
            header = {'Content-Type': 'application/json'}

            #header
            applId = ENV["JIM_APP_ID"]
            applUserId = current_user.userable.code
            applReferenceId = @foreign_worker.code
            clientDeviceSerial = params[:device_serial]
            clientMAC = params[:mac]
            clientIP = params[:ip]
            clientComputerName = params[:computer_name]
            requestDateTime = DateTime.now.strftime("%F %H:%M")

            header_data = {
                applId: applId,
                applUserId: applUserId,
                applReferenceId: applReferenceId,
                clientDeviceSerial: clientDeviceSerial,
                clientMAC: clientMAC,
                clientIP: clientIP,
                clientComputerName: clientComputerName,
                requestDateTime: requestDateTime
            }

            request_data = {
                surname: '',
                givenname: @foreign_worker.name.upcase,
                gender: @foreign_worker.gender === 'M' ? 1 : 2, # 1 for Male, 2 for Female
                doc_no: @foreign_worker.passport_number,
                doc_expiry: biodata.document_expiry_date,
                doc_issue_authority: biodata.document_issue_authority,
                nationality: @foreign_worker.country['code'],
                birth_date: @foreign_worker.date_of_birth.strftime('%Y%m%d'),
                applicationNumber: biodata.application_number,
                naid: @foreign_worker.afis_id,
                deviceStatus: 'Y'
            }

            # loop fingerprint
            fingerprints_data = {}
            selected_fingerprint = params[:selected_fingerprint]
            score = params[:score]
            img_content = params[:fp_data]
            fingerprint_types = BiodataResponse::FINGERPRINT_TYPES

            fingerprint_types.each do |key,value|
                fingerprints_data[value.parameterize.underscore] = {
                    img_content: img_content,
                    quality_score: score
                }
            end
            ## loop end
            request_data = request_data.merge(fingerprints_data)

            request_msg = {
                header: header_data,
                request: request_data
            }

            # save request to database
            fingerprint_request = FingerprintRequest.new
            fingerprint_request.foreign_worker_id = @foreign_worker['id']
            fingerprint_request.app_id = header_data[:applId]
            fingerprint_request.app_user_id = header_data[:applUserId]
            fingerprint_request.app_reference_id = header_data[:applReferenceId]
            fingerprint_request.client_device_serial = header_data[:clientDeviceSerial]
            fingerprint_request.client_mac = header_data[:clientMAC]
            fingerprint_request.client_ip = header_data[:clientIP]
            fingerprint_request.client_computer_name = ''
            fingerprint_request.request_datetime = header_data[:requestDateTime]
            fingerprint_request.surname = request_data[:surname]
            fingerprint_request.given_name = request_data[:givenname]
            fingerprint_request.gender = request_data[:gender]
            fingerprint_request.doc_no = request_data[:doc_no]
            fingerprint_request.doc_expiry = request_data[:doc_expiry]
            fingerprint_request.doc_issue_authority = request_data[:doc_issue_authority]
            fingerprint_request.nationality = request_data[:nationality]
            fingerprint_request.birth_date = request_data[:birth_date]
            fingerprint_request.application_number = request_data[:applicationNumber]
            fingerprint_request.naid = request_data[:naid]
            fingerprint_request.device_status = request_data[:deviceStatus]
            fingerprint_request.left_thumb_img_content = request_data['left_thumb'][:img_content]
            fingerprint_request.left_thumb_quality_score = request_data['left_thumb'][:quality_score]
            fingerprint_request.left_index_img_content = request_data['left_index'][:img_content]
            fingerprint_request.left_index_quality_score = request_data['left_index'][:quality_score]
            fingerprint_request.left_middle_img_content = request_data['left_middle'][:img_content]
            fingerprint_request.left_middle_quality_score = request_data['left_middle'][:quality_score]
            fingerprint_request.left_ring_img_content = request_data['left_ring'][:img_content]
            fingerprint_request.left_ring_quality_score = request_data['left_ring'][:quality_score]
            fingerprint_request.left_little_img_content = request_data['left_little'][:img_content]
            fingerprint_request.left_little_quality_score = request_data['left_little'][:quality_score]
            fingerprint_request.right_thumb_img_content = request_data['right_thumb'][:img_content]
            fingerprint_request.right_thumb_quality_score = request_data['right_thumb'][:quality_score]
            fingerprint_request.right_index_img_content = request_data['right_index'][:img_content]
            fingerprint_request.right_index_quality_score = request_data['right_index'][:quality_score]
            fingerprint_request.right_middle_img_content = request_data['right_middle'][:img_content]
            fingerprint_request.right_middle_quality_score = request_data['right_middle'][:quality_score]
            fingerprint_request.right_ring_img_content = request_data['right_ring'][:img_content]
            fingerprint_request.right_ring_quality_score = request_data['right_ring'][:quality_score]
            fingerprint_request.right_little_img_content = request_data['right_little'][:img_content]
            fingerprint_request.right_little_quality_score = request_data['right_little'][:quality_score]
            fingerprint_request.save

            header_data[:applTransactionId] = fingerprint_request.app_transaction_id
            # end save

            custom_error = false
            begin
                request = Net::HTTP::Post.new(url.request_uri, header)
                response = Net::HTTP.start(url.host, url.port) {|http|
                  http.read_timeout = SystemConfiguration.get("JIM_BIODATA_TIMEOUT", 30).to_i
                  request.body = request_msg.to_json
                  response = http.request(request)
                }
                log_api(method, request_msg, url, response.body, response.to_json)

                if response && response.code == '200'
                    response = JSON.parse(response.body)
                    response_header = response['header']
                    response_response = response['response']
                    response_statusCode = response_header['statusCode']
                    messages = response_header['description']

                    # store all data into database
                    fingerprintResponse = FingerprintResponse.new
                    fingerprintResponse.visitable_type =  type == 'doctor' ? Doctor.to_s : XrayFacility.to_s
                    fingerprintResponse.visitable_id = current_user.userable.id
                    fingerprintResponse.foreign_worker_id = @foreign_worker['id']
                    fingerprintResponse.fingerprint_request_id = fingerprint_request.id
                    fingerprintResponse.foreign_worker_id = @foreign_worker['id']
                    fingerprintResponse.status_code = response_header['statusCode']
                    fingerprintResponse.status_message = response_header['statusMessage']
                    fingerprintResponse.description = response_header['description']
                    fingerprintResponse.row_count = response_header['rowCount']
                    fingerprintResponse.status = response_response['status']
                    fingerprintResponse.message = response_response['message']
                    fingerprintResponse.fp_matching_status = response_response['fp_matching_status']
                    fingerprintResponse.fp_biosl = response_response['fp_biosl']
                    fingerprintResponse.transaction_id = response_response['transaction_id']
                    fingerprintResponse.request_datetime = response_header['requestDateTime']
                    fingerprintResponse.response_datetime = response_header['responseDateTime']
                    fingerprintResponse.fw_transaction_id = fw_transaction_id
                    fingerprintResponse.responsable = responsable
                    fingerprintResponse.save!

                    # response to ajax call
                    response_data = {message: messages}
                    response_data['status'] = response_statusCode == 'GWY0000' ? 'success' : 'error'
                    if response_statusCode === 'GWY0000'
                        fp_result = 1
                    end
                    log_biometric(fw_transaction_id, params, response_data, "response code 200")
                elsif response && response.code == '400'
                    custom_error = true

                    response = JSON.parse(response.body)
                    response_header = response['header']
                    response_statusCode = response_header['statusCode']

                    # error in response #1
                    response_data = {
                        status: 'error',
                        message: response_header['description']
                    }
                    log_biometric(fw_transaction_id, params, response_data, "error in response #1. response code 400")
                else
                    custom_error = true
                    # error in response #2
                    response_data = {
                        status: 'error',
                        message: "Failed to detect fingerprint."
                    }
                    log_biometric(fw_transaction_id, params, response_data, "error in response #2. custom error")
                end
            rescue Net::ReadTimeout => e
                response_data = {
                    status: 'error',
                    message: "Unable to get #{@foreign_worker.name} information."
                }
                log_api(method, request_msg, url, e.inspect ,e)
                log_biometric(fw_transaction_id, params, response_data, "net read timeout")
            rescue StandardError => e
                fp_result = 2
                response_data = {
                    status: 'bypass',
                    message: "Unable to get #{@foreign_worker.name} information."
                }
                log_api(method, request_msg, url, e.inspect ,e)
                log_biometric(fw_transaction_id, params, response_data, "standard error which should bypass checking")
            end

        else
            # return error
            response_data = {
                status: 'error',
                message: "Unable to get #{@foreign_worker.name} information."
            }
            log_biometric(fw_transaction_id, params, response_data, "couldn't find foreign worker")
        end

        if custom_error
            fingerprintResponse = FingerprintResponse.new
            fingerprintResponse.visitable_type =  type == 'doctor' ? Doctor.to_s : XrayFacility.to_s
            fingerprintResponse.visitable_id = current_user.userable.id
            fingerprintResponse.foreign_worker_id = @foreign_worker['id']
            fingerprintResponse.fingerprint_request_id = fingerprint_request.id
            fingerprintResponse.foreign_worker_id = @foreign_worker['id']
            fingerprintResponse.status_code = 'error'
            fingerprintResponse.status_message = 'Error'
            fingerprintResponse.description = response_data[:message]
            fingerprintResponse.row_count = 0
            fingerprintResponse.request_datetime = requestDateTime
            fingerprintResponse.response_datetime = requestDateTime
            fingerprintResponse.fw_transaction_id = fw_transaction_id
            fingerprintResponse.responsable = responsable
            fingerprintResponse.save!
        end

        result_datetime = DateTime.now
        if type == 'doctor'
            transaction.doctor_fp_result = fp_result
            transaction.doctor_fp_result_date = result_datetime
            if fp_result == 2
                transaction.doctor_bypass_fingerprint_date = result_datetime
                responsable.doctor_bypass_fingerprint_reason_id = BypassFingerprintReason.find_by_code('PHTPA')&.id
                transaction.doctor_fp = true
            end

            transaction.save
        else
            responsable.xray_fp_result = fp_result
            responsable.xray_fp_result_date = result_datetime
            if fp_result == 2
                responsable.xray_bypass_fingerprint_date = result_datetime
                responsable.xray_bypass_fingerprint_reason_id = BypassFingerprintReason.find_by_code('PHTPA')&.id
                responsable.xray_fp = true
            end

            responsable.save
        end

        render json: response_data
        return
    end

    def bypass_fingerprint
        redirect_to external_transactions_path and return if @transaction.blank?
        redirect_to external_transactions_path, notice: "Permission denied." and return if !has_permission?("CREATE_BYPASS_FINGERPRINT_REQUEST")
        redirect_to external_transactions_path, notice: "Bypass fingerprint request for #{@transaction.code} is pending for approval or approved." and return if !can_submit_bypass_fingerprint_request
    end

    def bypass_fingerprint_update
        redirect_to external_transactions_path and return if @transaction.blank?
        redirect_to external_transactions_path, notice: "Bypass fingerprint request for #{@transaction.code} is pending for approval or approved." and return if !can_submit_bypass_fingerprint_request

        case current_user.userable_type
        when "Doctor"
            category = "DOCTOR_TRANSACTION_BYPASS_FINGERPRINT"
        when "XrayFacility"
            category = "XRAY_TRANSACTION_BYPASS_FINGERPRINT"
        end

        if params[:transaction].present?
            params[:transaction][:uploads].each do |upload|
                if (!upload[:category].nil? && !upload[:documents].nil?)
                    add_watermark(upload[:documents])
                    upl = @transaction.uploads.create({
                        category: upload[:category],
                        remark: category,
                    })
                    upl.documents.attach(upload[:documents])
                end
            end

            approval_assigned_to("TRANSACTION_BYPASS_FINGERPRINT")

            @transaction.transaction_verify_docs.create({
                transaction_id: @transaction.id,
                category: category,
                status: "APPROVAL",
                additional_information: {
                    bypass_fingerprint_reason: params[:transaction_bypass_reason],
                    phone: params[:phone]
                },
                assigned_to: @assigned_to_user_id,
                submitted_by: current_user.id,
                submitted_at: Time.now,
                sourceable: @transaction,
            })

            flash_add(:notices, "Bypass fingerprint request for #{@transaction.foreign_worker.name} (#{@transaction.foreign_worker.passport_number}) submitted and pending for approval.")
            redirect_to external_transactions_path and return
        end
    end

private
    def set_transaction
        @transaction = Transaction.find_by(id: params[:id])
        return_to_transactions_index and return if @transaction.blank?

        case current_user.userable_type
        when "Doctor"
            return_to_transactions_index and return if @transaction.doctor_id != current_user.userable.id
        when "Laboratory"
            return_to_transactions_index and return if @transaction.laboratory_id != current_user.userable.id
        when "XrayFacility"
            return_to_transactions_index and return if @transaction.xray_facility_id != current_user.userable.id
        when "Radiologist"
            return_to_transactions_index and return if @transaction.xray_reporter_type != "RADIOLOGIST" || @transaction.radiologist_id != current_user.userable.id
        when "Employer"
            return_to_transactions_index and return if @transaction.employer_id != current_user.userable.id
        when "Agency"
            return_to_transactions_index and return if @transaction.agency_id != current_user.userable.id
        end
    end

    def return_to_transactions_index
        redirect_to external_transactions_path, notice: "Transaction not found"
    end

    def set_order
        @order = Order.where(:code => params[:order_code]).first
    end

    def check_foreign_worker_blocked_or_monitoring
        if @transaction.present?
            worker = @transaction.foreign_worker
            redirect_to external_transactions_path, error: "Medical information for #{worker.name} – #{worker.code || 'N/A'} / #{worker.passport_number} is blocked in the systems. Kindly capture the prompt message along with front page of the passport copy and latest work permit for the respective worker and email to cs@fomema.com.my for assistance." and return if @transaction.is_sp_transmit_blocked?

            # Monitoring allowed to conduct merts tests. It will show up as a flagged criteria in certification -> "Worker has been manually tagged for monitoring".
            # redirect_to external_transactions_path, error: "Cannot proceed with medical examination because foreign worker #{ worker.name } is under monitoring. Kindly advise the employer to refer to FOMEMA branch office." and return if worker.monitoring == "Y"
        end
    end

    def log_api(method, params, url, response, full_response)
        log_data = {
            :name => self.class.name,
            :api_type => 'REST_API',
            :request_type => 'OUTGOING',
            :url => url,
            :method => method,
            :params => params,
            :response => response,
            :full_response => full_response,
        }

        api_log = ApiLog.create(log_data)
    end

    def log_biometric(transaction_id, params, response,remarks)

        log_data = {
            :transaction_id => transaction_id,
            :params => params,
            :response => response,
            :remarks => remarks
        }

        api_log = BiometricLog.create(log_data)
    end

    def can_submit_bypass_fingerprint_request
        allow_bypass = false

        case current_user.userable_type
        when "Doctor"
            allow_bypass = TransactionVerifyDoc.where(transaction_id: @transaction.id, sourceable: @transaction, category: 'DOCTOR_TRANSACTION_BYPASS_FINGERPRINT', status: ['APPROVAL', 'APPROVED']).count == 0
            allow_bypass = allow_bypass && @transaction.doctor_bypass_fingerprint_date.blank? && !@transaction.expired_merts?
        when "XrayFacility"
            allow_bypass = TransactionVerifyDoc.where(transaction_id: @transaction.id, sourceable: @transaction, category: 'XRAY_TRANSACTION_BYPASS_FINGERPRINT', status: ['APPROVAL', 'APPROVED']).count == 0
            allow_bypass = allow_bypass && @transaction.xray_bypass_fingerprint_date.blank? && !@transaction.expired_merts?
        end
        return allow_bypass
    end
end