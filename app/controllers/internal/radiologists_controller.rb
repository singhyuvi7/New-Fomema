class Internal::RadiologistsController < InternalController
    include Approvalable
    include ServiceProviderDocument
    include ValidateUserable

    before_action :set_radiologist, only: [:show, :edit, :draft, :draft_update, :cancel, :update, :destroy, :approval, :approval_update, :concur, :concur_update, :approval_letter, :registration_invoice, :activate, :reject_renew, :registration_letter, :change_address_approval, :summary_loading_statistic]
    before_action -> { validate_user_email?(@radiologist, params[:radiologist][:email]) }, only: [:update]
    before_action -> { validate_email_with_plus_sign(params[:radiologist][:email]) }, only: [:create, :update]

    before_action -> { can_access?("VIEW_RADIOLOGIST") }, only: [:index, :show]
    before_action -> { can_access?("EDIT_RADIOLOGIST") }, only: [:edit, :update]
    before_action -> { can_access?("DELETE_RADIOLOGIST") }, only: [:destroy]
    before_action -> { can_access?("MSPD_REPORTS") }, only: [:summary_loading_statistic]

    # GET /radiologists
    # GET /radiologists.json
    def index
        if params[:cookied_path] == "y" && session[:cookied_radiologist_approval_path].present?
            redirect_to "#{ request.path }?#{ session[:cookied_radiologist_approval_path] }" and return
        elsif ["APPROVAL", "APPROVAL2", "TO_ACTIVATE"].include?(params[:status])
            session[:cookied_radiologist_approval_path] = request.url.split("?")[1].gsub("cookied_path=y", "")
        end

        respond_to do |format|
            format.html do
                @radiologists = filtered_radiologist.order('created_at DESC').page(params[:page]).per(get_per)
            end
            format.xlsx do
                @pairs = {
                    code: "CODE",
                    title_name: "TITLE",
                    name: "DOCTOR_NAME",
                    icno: "ICNO",
                    xray_facility_name: "XRAY_FACILITY_NAME",
                    created_at: "REGISTRATION_DATE",
                    displayed_address: "ADDRESS",
                    postcode: "POSTCODE",
                    town_name: "DISTRICT_NAME",
                    state_name: "STATE_NAME",
                    phone: "PHONE",
                    fax: "FAX",
                    mobile: "MOBILE",
                    email: "EMAIL",
                    qualification: "QUALIFICATION",
                    is_pcr_yes_no: "IS_PCR",
                    is_panel_xray_facility_yes_no: "IS_PANEL_XRAY_FACILITY",
                    apc_number: "APC_NUMBER",
                    apc_year: "APC_YEAR",
                    nsr_number: "NSR_NUMBER",
                    renewal_agreement_date: "RENEWAL_AGREEMENT_DATE",
                    district_health_office_name: "DISTRICT_HEALTH_OFFICE",
                    status: "STATUS",
                    status_reason_display: "STATUS_REASON",
                    status_comment: "STATUS_COMMENT",
                    activated_at: "ACTIVATED_AT",
                    xray_facility_count: "NO_OF_ASSOCIATES_XRAY_CLINICS",
                    total_worker_allocated: "TOTAL_WORKER_ALLOCATED",
                    total_fw_two_year_ago: "TOTAL_FW_#{2.year.ago.year}",
                    total_fw_one_year_ago: "TOTAL_FW_#{1.year.ago.year}",
                }
                @captions = @pairs.values
                @cols = @pairs.keys
                @radiologists = RadiologistDecorator.decorate_collection filtered_radiologist
                render xlsx: 'index', filename: "Radiologist-#{DateTime.current.to_i}.xlsx"
            end
            format.json do
                @radiologists = filtered_radiologist.order('created_at DESC')
            end
        end
    end

    # GET /radiologists/1
    # GET /radiologists/1.json
    def show
    end

    # GET /radiologists/new
    def new
        @radiologist = Radiologist.new
    end

    # POST /radiologists
    # POST /radiologists.json
    def create
        data = radiologist_params
        data["icno"] = data["icno"].gsub(/[^0-9A-Za-z]/, '') if !data["icno"].nil?

        @radiologist = Radiologist.new(data.merge({
            status: "INACTIVE"
        }))
        # if (User.where("email ilike ?", @radiologist.email).count > 0)
        #     @radiologist.errors.add(:email, "not available")
        #     render :new and return
        # end

        @radiologist.save
        @radiologist.sync_panel_radiologists(params[:radiologist][:panel_radiologists])

        notice = ""

        case params[:submit]
        when 'Save draft'
            save_ok = approval_new_request(@radiologist, category: "RADIOLOGIST_REGISTRATION", draft: true)
            notice = "Radiologist saved as draft."
        when 'Submit for approval'
            save_ok = approval_new_request(@radiologist, category: "RADIOLOGIST_REGISTRATION")
            notice = "New radiologist request created."
        end

        respond_to do |format|
            if save_ok
                format.html { redirect_to internal_radiologists_path, notice: notice }
                format.json { render :show, status: :created, location: @radiologist }
            else
                format.html { render :new }
                format.json { render json: @radiologist.errors, status: :unprocessable_entity }
            end
        end
    end

    # GET /radiologists/1/edit
    def edit
    end

    # PATCH/PUT /radiologists/1
    # PATCH/PUT /radiologists/1.json
    def update
        data = radiologist_params
        data["icno"] = data["icno"].gsub(/[^0-9A-Za-z]/, '') if !data["icno"].nil?
        @radiologist.update(data)
        @radiologist.sync_panel_radiologists(params[:radiologist][:panel_radiologists])
        flash[:notice] = "Radiologist amendment auto-approved. If there's changes in email address, a confirmation email will be send out to verify the new email address."
        redirect_to internal_radiologists_path and return
    end

    # DELETE /radiologists/1
    # DELETE /radiologists/1.json
    def destroy
        @radiologist.destroy
        respond_to do |format|
            format.html { redirect_to internal_radiologists_url, notice: 'Radiologist was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    # GET /radiologists/1/draft
    def draft
        if ["DRAFT", "REVERT"].all? { |str| !@radiologist.approval_status.include?(str) }
            flash[:error] = "Radiologist is not in draft status"
            redirect_to internal_radiologists_path and return
        end
        @radiologist.assign_attributes(@radiologist.approval_item.params)
    end

    def draft_update
        @radiologist.assign_attributes(radiologist_params)
        @radiologist.sync_panel_radiologists(params[:radiologist][:panel_radiologists])

        begin
            case params[:submit]
            when 'Save draft'
                save_ok = approval_update_request(@radiologist, draft: true)
                flash[:notice] = "Radiologist saved as draft."
            when 'Submit for approval'
                save_ok = approval_update_request(@radiologist)
                flash[:notice] = "Radiologist submitted for approval."
            end
        rescue ActiveRecord::RecordInvalid => invalid
            flash.now[:error] = invalid.to_s
            render :edit and return
        rescue Exception => invalid
            redirect_to internal_radiologists_path, notice: invalid.to_s and return
        end

        begin
            respond_to do |format|
                if save_ok
                    format.html { redirect_to internal_radiologists_path, notice: notice }
                    format.json { render :show, status: :ok, location: @radiologist }
                else
                    format.html { render :edit }
                    format.json { render json: @radiologist.errors, status: :unprocessable_entity }
                end
            end
        rescue ActiveRecord::RecordInvalid => invalid
            redirect_to internal_radiologists_path, notice: invalid.to_s
        end
    end

    def cancel
        begin
            approval_cancel_request(@radiologist)
            if @radiologist.approval_status.eql?("NEW_CANCELLED")
                @radiologist.panel_radiologists.destroy
                @radiologist.destroy
            end
        rescue Exception => invalid
            flash.now[:error] = invalid.to_s
            redirect_to internal_radiologists_path and return
        end
        redirect_to internal_radiologists_path, notice: 'Request cancelled.'
    end

    # GET /radiologists/1/approval
    def approval
        @radiologist.assign_attributes(@radiologist.approval_item.params)
    end

    # PATCH/PUT /radiologists/1/approval
    # PATCH/PUT /radiologists/1/approval.json
    def approval_update
        if approval_params[:decision] == 'APPROVE'
            notice = 'Radiologist is approved, concur is needed'
            approval_approve_request(@radiologist, final_approval: approval_get_approval_tier(@radiologist.approval_status) == 2)
        elsif approval_params[:decision] == 'REJECT'
            notice = 'Radiologist is rejected.'
            approval_reject_request(@radiologist)
        elsif approval_params[:decision] == 'REVERT'
            notice = 'Radiologist is reverted.'
            approval_revert_request(@radiologist)
        end
        redirect_to internal_radiologists_path(status: "APPROVAL", cookied_path: "y"), notice: notice
    end

    # GET /radiologists/1/concur
    def concur
        @radiologist.assign_attributes(@radiologist.approval_item.params)
    end

    # PATCH/PUT /radiologists/1/concur
    # PATCH/PUT /radiologists/1/concur.json
    def concur_update
        @radiologist.assign_attributes(@radiologist.approval_item.params)

        record_update_attributes = {
            registration_approved_at: DateTime.now
        }

        @radiologist.update_code

        if @radiologist.is_panel_xray_facility
            flash[:notice] = "Radiologist registration concurred. Radiologist is panel X-Ray Facility, payment is waived, please proceed activate the radiologist"
            @redirect_to = internal_radiologist_path @radiologist
        else
            fee = Fee.find_by(code: "RADIOLOGIST_REGISTRATION")
            order = Order.create({
                customerable: @radiologist,
                category: "RADIOLOGIST_REGISTRATION",
                date: Time.now,
                amount: fee.amount,
                status: "NEW"
            })
            order.order_items.create({
                order_itemable: @radiologist,
                fee_id: fee.id,
                amount: fee.amount
            })
            flash[:notice] = "Radiologist #{@radiologist.code} concurred, order #{order.code} for radiologist registration is created"
            @redirect_to = internal_radiologists_path(status: "APPROVAL2", cookied_path: "y")
        end

        approval_approve_request(@radiologist, comment: params[:concur][:comment], record_update_attributes: record_update_attributes)
        redirect_to @redirect_to || internal_radiologists_path(status: "APPROVAL2", cookied_path: "y")
    end

    def reject_renew
        if !@radiologist.approval_status.eql?("NEW_REJECTED")
            flash[:error] = "Invalid action"
            redirect_to internal_radiologist_path and return
        end
        @radiologist.assign_attributes({
            approval_remark: "restart registration"
        })
        approval_new_request(@radiologist, comment: "restart registration", category: "RADIOLOGIST_REGISTRATION", draft: true)
        # @radiologist.update({
        #     approval_status: "NEW_DRAFT"
        # })
        flash[:notice] = "Radiologist registration restarted";
        redirect_to draft_internal_radiologist_path @radiologist
    end

    def activate
        @radiologist.activate
        @radiologist.create_user if @radiologist.user.blank?
        redirect_to internal_radiologists_path(status: "TO_ACTIVATE", cookied_path: "y"), notice: 'Radiologist was activated.'
    end

    def xray_facilities_filter
        @xray_facilities = XrayFacility.search_code(params[:code]).search_name(params[:name]).all
    end

    def summary_loading_statistic
        @previous_year = Time.now.prev_year
        @current_year = Time.now
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_radiologist
        @radiologist = Radiologist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def radiologist_params
        params.require(:radiologist).permit(:name, :xray_facility_name, :title_id, :icno, :address1, :address2, :address3, :address4, :country_id, :state_id, :postcode, :town_id, :phone, :fax, :mobile, :email, :qualification, :pathologist_name, :is_panel_xray_facility, :district_health_office_id, :is_pcr, :apc_year, :apc_number, :nsr_number, :renewal_agreement_date, :status, :comment, :user_id, :gender, :nationality_id, :race_id)
    end

    def filtered_radiologist
        Radiologist.search_code(params[:code])
        .search_icno(params[:icno])
        .search_name(params[:name])
        .search_facility_name(params[:xray_facility_name])
        .search_state(params[:state_id])
        .search_postcode(params[:postcode])
        .search_town(params[:town_id])
        .search_status(params[:status])
        .search_activated(params[:activated])
        .includes(:state).includes(:town)
    end
end