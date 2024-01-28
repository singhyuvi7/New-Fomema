require 'csv'

class External::WorkerListsController < ExternalController
    include Approvalable
    include Cart
    include RegisterTransaction
    include Insurance
    include BulkUploadWorker
    include BankInfoCheck
    include OrderPaymentUpdate
    include TransferWorker
    include ApprovalAssignmentCheck
    include ProfileInfoCheck
    include Watermark

    before_action -> { can_access?("CREATE_FOREIGN_WORKER") }, only: [:new ,:create]
    before_action -> { can_access?("CREATE_FOREIGN_WORKER") }, if: -> { params[:bulk_action] == 'register_transaction' }, only: [:bulk_action]
    before_action -> { can_access?("EDIT_FOREIGN_WORKER") }, only: [:edit, :update]
    before_action -> { can_access?("DELETE_FOREIGN_WORKER") }, if: -> { params[:bulk_action] == 'destroy' }, only: [:bulk_action]
    before_action -> { can_access?("EDIT_EMPLOYER_SUPPLEMENT_FOREIGN_WORKER") }, if: -> { params[:bulk_action] == 'transfer_worker' }, only: [:bulk_transfer_worker, :bulk_transfer_worker_update]

    before_action :set_employer
    before_action :set_foreign_worker, only: [:show, :edit, :update, :destroy, :revert, :revert_update]
    before_action :set_jim_verified, only: [:edit, :update]

    before_action -> { can_proceed?(@foreign_worker.try(:employer)) }, if: -> { @foreign_worker.code.present? && Fee.find_by(code: "FOREIGN_WORKER_AMENDMENT").amount > 0 }, only: [:edit,:update]
    before_action -> { pending_profile_update?(Employer.find_by(id: current_user.userable_id)) }, if: -> { current_user.userable_type == 'Employer' }, only: [ :index]
    # before_action -> { can_proceed?('Employer', @foreign_worker.try(:employer)) }, if: -> { current_user.userable_type == 'Employer' && @foreign_worker.code.present? && (Fee.find_by(code: "FOREIGN_WORKER_AMENDMENT").amount > 0 || Fee.find_by(code: "FOREIGN_WORKER_GENDER_AMENDMENT").amount > 0) }, only: [:edit,:update]
    # before_action -> { can_proceed?('Agency', Agency.find_by(code: current_user.code)) }, if: -> { current_user.userable_type == 'Agency' && @foreign_worker.code.present? && (Fee.find_by(code: "FOREIGN_WORKER_AMENDMENT").amount > 0 || Fee.find_by(code: "FOREIGN_WORKER_GENDER_AMENDMENT").amount > 0) }, only: [:edit,:update]

    before_action -> { set_fee_amount }, if: -> { @foreign_worker.code.present? }, only: [:edit, :update]

    def index
        query = ForeignWorker.select("foreign_workers.*, transaction_carts.id as cart_selected")
        .search_name(params[:name])
        .search_code(params[:code])
        .search_passport(params[:passport])
        .search_country(params[:country])
        .search_approval_status(params[:approval_status])
        .search_without_code(params[:without_code])
        .active
        .joins("left join transaction_carts on transaction_carts.foreign_worker_id = foreign_workers.id and transaction_carts.created_by = #{current_user.id}")
        .order(name: :asc)

        case current_user.userable_type
        when "Employer"
            if current_user.employer_supplement_id.blank?
                query = query.where(employer_id: current_user.userable.id)
            elsif params[:worker_available_in_hq].present?
                query = query.where(employer_id: current_user.userable.id, employer_supplement_id: nil)
            else
                query = query.where(employer_id: current_user.userable.id, employer_supplement_id: current_user.employer_supplement_id)
            end
        when "Agency"
            redirect_to external_agency_employers_path
        when "Doctor", "Laboratory", "XrayFacility"
            query = query.where("exists (select 1 from transactions where foreign_workers.id = transactions.foreign_worker_id and transactions.#{current_user.userable_type.underscore}_id = ? and transaction_date > ?)", current_user.userable_id, 3.years.ago)
        end

        if params.key?("exclude_foreign_worker_ids")
            query = query.where.not(id: params["exclude_foreign_worker_ids"])
        end

        @foreign_workers = query.order('foreign_workers.created_at DESC')
        .includes(:country).includes(:job_type).includes(:latest_insurance_purchase).page(params[:page])
        .per(get_per)

        @cart_count = cart_count
        @transaction_carts = TransactionCart.select("foreign_workers.id, foreign_workers.name, foreign_workers.passport_number, foreign_workers.code, foreign_workers.employer_supplement_id, employer_supplements.name AS employer_supplement_name").joins(:foreign_worker).joins("LEFT JOIN employer_supplements ON foreign_workers.employer_supplement_id = employer_supplements.id").order("foreign_workers.name").where(created_by: current_user.id)
    end

    def show
    end

    def new
        @foreign_worker = ForeignWorker.new
        # set special condition if employer type MAID ONLINE
        # maidOnlineSpecialConditions
    end

    def create
        data = foreign_worker_params.merge({
            employer_id: current_user.userable.id,
            employer_supplement_id: current_user.employer_supplement_id,
            #maid_online: params[:is_maid_online] ? 'PRAON' : 'FOMEMA'
            maid_online: params[:programme].blank? ? "FOMEMA" : params[:programme].first
        })
        data["plks_number"] = data["plks_number"].gsub(/\D/, '') if !data["plks_number"].nil?

        if SystemConfiguration.get("PATI_PORTAL") == "0"
            data[:pati] = false
        end
        @foreign_worker = ForeignWorker.new(data)

        if params[:submit] == "change_employer"
            change_employer
            return
        end

        saveOK = true

        if ForeignWorker.where("passport_number = ? and status = 'ACTIVE'", foreign_worker_params[:passport_number]).count > 0
            saveOK = false

            fw_matched = ForeignWorker.where(passport_number: foreign_worker_params[:passport_number])
            .where(gender: foreign_worker_params[:gender])
            .where(country_id: foreign_worker_params[:country_id])
            .where(date_of_birth: foreign_worker_params[:date_of_birth])
            .where(status: 'ACTIVE')
            .order(latest_transaction_id: :desc)

            if fw_matched.count == 1 && !fw_matched.first.is_reg_medical_blocked
                if fw_matched.first.employer.id == current_user.userable.id
                    # Do not allow to change if same employer
                    @foreign_worker.errors.add(:base, "The worker record has been created earlier.")
                else
                    @foreign_worker.errors.add(:base, "Duplicate record found. Please upload the copy of passport AND calling visa/Immigration approval/work permit. Click on \"Change Employer\" if the worker is your employee.")
                    @is_change_employer = true
                end
            elsif fw_matched.count == 1 && fw_matched.first.is_reg_medical_blocked
                @foreign_worker.errors.add(:base, "Medical information for #{fw_matched.first.name} – #{fw_matched.first.code || 'N/A'} / #{fw_matched.first.passport_number} is blocked in the systems. Kindly capture the prompt message along with front page of the passport copy and latest work permit for the respective worker and email to cs@fomema.com.my for assistance.")
            else
                @foreign_worker.errors.add(:base, "Duplicate record found. Registration not allowed. Please refer to the nearest FOMEMA branch.")
            end
        end

        if saveOK
            begin
                saveOK = @foreign_worker.save
            rescue Exception => e
                @foreign_worker.errors.add(:base, e.message)
                format.html {
                    render :new
                }
                format.json { render json: @foreign_worker.errors, status: :unprocessable_entity }
                return
            end
        end

        respond_to do |format|
            if saveOK
                message_company = 'Foreign worker data was successfully created. Kindly select the worker you wish to register and click on Add To List button.'
                message_individual = 'Foreign worker data was successfully created. Kindly select the worker you wish to register and click on Buy FOMEMA or Buy Insurance.'
                message = current_user.userable.employer_type.name === 'COMPANY' ? message_company : message_individual
                format.html { redirect_to external_worker_lists_url, notice: message }
                format.json { render :show, status: :created, location: @foreign_worker }
            else
                if @is_change_employer
                    format.html { render :change_employer }
                    format.json { render json: @foreign_worker.errors, status: :unprocessable_entity }
                else
                    format.html { render :new }
                    format.json { render json: @foreign_worker.errors, status: :unprocessable_entity }
                end
            end
        end
    end

    def edit
        @foreign_worker.assign_attributes({
            amendment_reasons: [],
            amendment_reason_comment: nil,
        })

        # set special condition if employer type MAID ONLINE
        # maidOnlineSpecialConditions
    end

    def update
        @foreign_worker.transaction do

            @foreign_worker.assign_attributes(foreign_worker_params.merge({
                "amended_at" => Time.now,
                "amended_by" => current_user.id,
                "amendment_reasons" => params[:foreign_worker][:amendment_reasons],
                "maid_online" => params[:programme].blank? ? "FOMEMA" : params[:programme].first
            }))

            if !@foreign_worker.code.blank? && (@foreign_worker.amendment_reasons.blank? || @foreign_worker.amendment_reasons.all?(&:blank?))
                @foreign_worker.errors.add(:amendment_reasons, "required")
                render :edit and return
            end

            if !@foreign_worker.code.blank?
                if !params[:foreign_worker].has_key?(:uploads) || params[:foreign_worker][:uploads].count == 0 || params[:foreign_worker][:uploads][0][:documents].blank?
                    @foreign_worker.errors.add(:base, "Documents is required")
                    render :edit and return
                end
            end

            if [@foreign_worker.name_changed?, @foreign_worker.date_of_birth_changed?, @foreign_worker.country_id_changed?, @foreign_worker.passport_number_changed?, @foreign_worker.plks_number_changed?, @foreign_worker.arrival_date_changed?, @foreign_worker.maid_online_changed?, @foreign_worker.job_type_id_changed?, @foreign_worker.gender_changed?].none?
                @foreign_worker.errors.add(:base, "No changes detected")
                render :edit and return
            end

            if ForeignWorker.where("passport_number = ? and status = 'ACTIVE' and id != ?", foreign_worker_params[:passport_number], @foreign_worker.id).count > 0
                error_message = "Passport number existed, no amendment allowed. Please email the screenshot of the error, <a href=https://fomema2u.com.my/wp-content/uploads/2023/01/Request_For_Amendment_Of_Foreign_Worker_Informations_25th.pdf target=_blank>amendment form</a>, passport copy, and immigration approval to cs@fomema.com.my.".html_safe
                @foreign_worker.errors.add(:base, error_message)
                render :edit and return
            end

            if !@foreign_worker.valid?
                render :edit and return
            end

            if @foreign_worker.pati_changed? && SystemConfiguration.get("PATI_PORTAL") == "0"
                @foreign_worker.pati = false
            end

            if @foreign_worker.code.blank?
                @foreign_worker.save
                flash[:notice] = "Worker saved"
                redirect_to external_worker_lists_path and return
            else
                if @foreign_worker.critical_change?
                    @foreign_worker.assign_attributes(foreign_worker_params.merge({
                        "employer_amended_at" => Time.now
                    }))
                end
                # @foreign_worker.save
                # flash[:notice] = "Worker saved"
                # redirect_to external_worker_lists_path and return
            end

            # move bank info checking to here so that employer no need to update bank info for non gender amendment request
            if @foreign_worker.gender_changed?
                if current_user.userable_type == 'Employer' && @foreign_worker.code.present? && (Fee.find_by(code: "FOREIGN_WORKER_GENDER_AMENDMENT").amount > 0)
                    can_proceed?('Employer', @foreign_worker.try(:employer))
                    return if @incomplete
                end
            end

            # process file upload
            params[:foreign_worker][:uploads].each do |upload|
                if (!upload[:category].nil? && !upload[:documents].nil?)
                    add_watermark(upload[:documents])
                    upl = @foreign_worker.uploads.create(category: upload[:category])
                    upl.documents.attach(upload[:documents])
                end
            end

            if @foreign_worker.gender_changed?
                change_gender
            else
                order = Order.create({
                    customerable: current_user.userable,
                    category: "FOREIGN_WORKER_AMENDMENT",
                    date: Time.now,
                    amount: 0,
                    status: "NEW"
                })

                if SystemConfiguration.get('PORTAL_WORKER_AMENDMENT_FOC', '0') == '1'
                    fee = Fee.find_by(code: "FOC")
                else
                    fee = Fee.find_by(code: "FOREIGN_WORKER_AMENDMENT")
                end
                order_item = order.order_items.create({
                    order_itemable: @foreign_worker,
                    fee: fee,
                    amount: fee.amount,
                    additional_information: {
                        "changes" => @foreign_worker.changes,
                        "transaction_id" => @foreign_worker.latest_transaction_id
                    }
                })

                # if sum is 0 update to paid
                if order.amount > 0
                    redirect_to edit_external_order_path(order) and return
                else
                    order.update({
                        status: 'PAID',
                        paid_at: DateTime.now,
                        payment_method: PaymentMethod.find_by(code: "FOC")
                    })

                    @order = order
                    payment_update_foreign_worker_amendment
                    redirect_to external_worker_lists_path and return
                end
            end
        end
        # /db-transaction
    end

    def revert
        @foreign_worker.assign_attributes(@foreign_worker.approval_item.params)
    end

    def revert_update
        @foreign_worker.assign_attributes(foreign_worker_params.merge({
            "amended_at" => Time.now,
            "amended_by" => current_user.id,
            "amendment_reasons" => params[:foreign_worker][:amendment_reasons]
        }))
        if !@foreign_worker.code.blank? && @foreign_worker.critical_change?
            @foreign_worker.assign_attributes({
                "employer_amended_at" => Time.now
            })
        end
        if (!@foreign_worker.valid?)
            render :revert and return
        end

=begin
        if foreign_worker.critical_change?
            flash[:notice] = "Worker amendment request submitted, approval is required."
            approval_update_request(foreign_worker)
        else
            approval_approve_request(foreign_worker)
            flash[:notice] = "Worker amendment request submitted and approved."
        end
=end

        # process file upload
        params[:foreign_worker][:uploads].each do |upload|
            if (!upload[:category].nil? && !upload[:documents].nil?)
                add_watermark(upload[:documents])
                upl = @foreign_worker.uploads.create(category: upload[:category])
                upl.documents.attach(upload[:documents])
            end
        end

        approval_update_request(@foreign_worker)

        redirect_to external_worker_lists_path, notice: "Reverted worker amendment request submitted, approval is required."
    end

    def change_gender
        flash[:notices] ||= []

        check_order = OrderItem.joins(:order).where(:order_itemable_type => 'ForeignWorker', :order_itemable_id => @foreign_worker.id).where("orders.category in (?) and orders.status in (?)",['FOREIGN_WORKER_GENDER_AMENDMENT', 'TRANSACTION_REGISTRATION', 'SPECIAL_RENEWAL_TRANSACTION_REGISTRATION'],["NEW", "PENDING_PAYMENT", "PENDING_AUTHORIZATION", "PENDING"])
        if !check_order.blank?
            flash[:error] = "Worker has pending order, please complete the payment."
            redirect_to edit_external_order_path(Order.find(check_order.first.order_id)) and return
        end

        # Letchumy request to hide
        # if !@transaction_gender_to_be_updated
        #     if @transaction_expired
        #         flash[:notices] << "Transaction expired. The amendment will not reflect to the transaction."
        #     elsif !@foreign_worker.latest_transaction_id.blank? && !@foreign_worker.latest_transaction.medical_examination_date.nil?
        #         flash[:notices] << "Foreign worker's latest transaction has been examined by doctor. The amendment will not reflect to the transaction."
        #     else
        #         flash[:notices] << "The amendment will not reflect to the transaction."
        #     end
        # end

        approval_request_additional_information = nil
        if !@fees.blank?
            order = Order.create({
                customerable: @foreign_worker.employer,
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
                flash[:notices] << "Payment required, please proceed to payment"
                redirect_to edit_external_order_path order and return
            else
                order.update({
                    status: 'PAID',
                    paid_at: DateTime.now,
                    payment_method: PaymentMethod.find_by(code: "FOC")
                })
            end
            approval_request_additional_information = {fee_id: Fee.find_by(code: "FOREIGN_WORKER_GENDER_AMENDMENT").id, order_id: order.id}
        end

        # @foreign_worker.save
        fw_changes =  @foreign_worker.changes

        approval_assigned_to("FOREIGN_WORKER_AMENDMENT")

        approval_update_request(@foreign_worker, category: "FOREIGN_WORKER_GENDER_AMENDMENT", additional_information: approval_request_additional_information, assigned_to_user_id: @assigned_to_user_id)

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

        flash[:notices] << "Amendment submitted. Auto-notification email will be sent once approved/rejected within 3 working days."
        redirect_to "#{external_worker_lists_path}?code=#{@foreign_worker.code}" and return
    end

    def destroy
    end

    def bulk_action
        if !params.has_key?(:ids)
            redirect_to external_worker_lists_path, flash: {notice: "Please select worker"} and return
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
        when 'destroy'
            bulk_destroy
        when 'transfer_worker'
            transfer_worker
        end

        if @redirect_to != false
            redirect_to @redirect_to || external_worker_lists_path
        end
    end

    # check if current logged in employer is MAID ONLNE

    # @return [Boolean]
    def isEmployerMaidOnline

        is_maid_online = false

        if current_user.userable_type === 'Employer'

            if current_user.userable.employer_type.name === 'MAID ONLINE'
                is_maid_online = true
            end

        end

        return is_maid_online

    end

    # check if current logged in employer their transactions can be appeal
=begin
    def transactionCanAppeal

        can_appeal = true

        if isEmployerMaidOnline
            can_appeal = false
        end

        return can_appeal

    end
=end

=begin
    # define special conditions for MAID ONLINE employer
    def maidOnlineSpecialConditions

        @hide_pati = false
        @is_maindonline = false
        @domestic_job = 'DOMESTIC'

        if isEmployerMaidOnline
            # set maid online default job type to DOMESTIC

            job_type = JobType.where({ name: @domestic_job }).first

            @foreign_worker.job_type_id = job_type.id

            # hide pati

            @hide_pati = true
            @is_maindonline = true
        end

    end
=end

    def register_transaction(allow_special_renewal: true)
        @employer = current_user.userable
        super(allow_special_renewal: allow_special_renewal)
    end

    def bulk_destroy
        foreign_worker_ids = params[:foreign_worker_ids] || params[:ids]
        foreign_workers = ForeignWorker.where("foreign_workers.id in (?) and foreign_workers.employer_id = ?", foreign_worker_ids, current_user.userable.id)
        fw_created_by_branch = foreign_workers.joins(:creator).where(users:{userable_type: 'Organization'})

        order_items = OrderItem.joins(:order).where(:order_itemable_id => foreign_worker_ids,:order_itemable_type => 'ForeignWorker')

        if !foreign_workers.where.not(code: nil).blank?
            flash[:error] = "Worker(s) that has worker code cannot be deleted."
        elsif !fw_created_by_branch.blank?
            flash[:error] = "Worker(s) that are created at branch cannot be deleted. (#{fw_created_by_branch.map(&:name).join ','})"
        elsif !order_items.where(orders: {status: ['NEW','PENDING_PAYMENT','PENDING_AUTHORIZATION','PENDING']}).blank?
            flash[:error] = "Worker(s) has pending payment cannot be deleted."
        elsif !order_items.where(orders: {status: ['PAID']}).blank?
            flash[:error] = "Worker(s) cannot be deleted."
        elsif !foreign_workers.where(employer_supplement_id: current_user.employer_supplement_id).exists?
            flash[:error] = "Worker(s) cannot be deleted."
        else
            ## delete biodata requests and responses
            BiodataResponse.where(:foreign_worker_id => foreign_worker_ids).destroy_all
            BiodataRequest.where(:foreign_worker_id => foreign_worker_ids).destroy_all

            ## order
            order_ids = order_items.pluck(:order_id)
            order_items.destroy_all
            Order.where(:id => order_ids).each do |order|
                order.update_total_amount
            end

            foreign_workers.destroy_all
            flash[:notice] = "Worker(s) has been deleted"
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
        redirect_to "#{external_worker_lists_path}", notice: 'Foreign worker(s) transferred successfully.'
    end

    def change_employer
        can_change = false
        fw = ForeignWorker.where(passport_number: foreign_worker_params[:passport_number])
        .where(gender: foreign_worker_params[:gender])
        .where(country_id: foreign_worker_params[:country_id])
        .where(date_of_birth: foreign_worker_params[:date_of_birth])
        .where(status: 'ACTIVE')
        .order(latest_transaction_id: :desc)

        if fw.count == 1
            foreign_worker = ForeignWorker.find_by(id: fw.first.id)
            if foreign_worker.latest_fw_change_employer&.status != "APPROVAL"
                can_change = true

                # process file upload
                params[:foreign_worker][:uploads].each do |upload|
                    if (!upload[:category].nil? && !upload[:documents].nil?)
                        add_watermark(upload[:documents])
                        upl = foreign_worker.uploads.create(category: upload[:category])
                        upl.documents.attach(upload[:documents])
                    end
                end

                approval_assigned_to("CHANGE_OF_EMPLOYER")

                foreign_worker.fw_change_employers.create({
                    foreign_worker_id: foreign_worker.id,
                    customerable_id: current_user.userable.id,
                    customerable_type: 'Employer',
                    old_employer_id: foreign_worker.employer_id,
                    new_employer_id: current_user.userable.id,
                    fw_name: foreign_worker_params[:name],
                    fw_passport_number: foreign_worker_params[:passport_number],
                    fw_country_id: foreign_worker_params[:country_id],
                    fw_gender: foreign_worker_params[:gender],
                    fw_date_of_birth: foreign_worker_params[:date_of_birth],
                    status: "APPROVAL",
                    requested_by: current_user.id,
                    requested_at: Time.now,
                    assigned_to: @assigned_to_user_id,
                })

                message = 'Change employer request submitted for approval.'
            else
                message = 'Change employer request is pending for approval. Please try again later.'
            end
        else
            message = 'Duplicate record found. Change employer is not allowed. Please refer to the nearest FOMEMA branch.'
        end

        respond_to do |format|
            format.html { redirect_to external_worker_lists_url, notice: message }
            format.json { render :show, status: :created, location: foreign_worker }
        end
    end

    def change_employer_revert
        redirect_to external_worker_lists_path, flash: {notice: "Worker not found"} and return if !has_reverted_change_employer_request?

        @foreign_worker = ForeignWorker.where({
            id: params[:id]
        }).first or redirect_to external_worker_lists_path, flash: {notice: "Worker not found"}
    end

    def change_employer_revert_update
        redirect_to external_worker_lists_path, flash: {notice: "Worker not found"} and return if !has_reverted_change_employer_request?

        change_employer
    end

    private
    def set_foreign_worker
        @foreign_worker = ForeignWorker.find(params[:id])
        @foreign_worker = ForeignWorker.where({
            id: params[:id],
            employer_id: current_user.userable.id,
        }).first or redirect_to external_worker_lists_path, flash: {notice: "Worker not found"}
    end

    def set_employer
        @employer = current_user.userable
    end

    def foreign_worker_params
        params.require(:foreign_worker).permit(:name, :gender, :date_of_birth, :passport_number, :country_id, :job_type_id, :plks_number, :pati, :amendment_reason_comment, :arrival_date, :employer_amended_at)
    end

    def set_jim_verified
        @jim_verified = @foreign_worker&.latest_transaction&.biodata_transaction&.status == 'SUCCESS'

        # Requested by Letchumy to override this checking - SR20220150
        # @disallow_amend_critical_info = (@jim_verified || !@foreign_worker.employer_amended_at.blank?) ? true : false
        # @disallow_amend_passport = (!@jim_verified && !@foreign_worker.employer_amended_at.blank?) ? true : false
        @disallow_amend_critical_info = (@jim_verified) ? true : false
        @disallow_amend_passport = false
    end

    def set_fee_amount
        @fees = []

        @param_gender = params[:gender]
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

    def has_reverted_change_employer_request?
        FwChangeEmployer.where("status = 'REVERTED' and requested_by = ? and foreign_worker_id = ?", current_user.id, params[:id]).count > 0
    end
end
