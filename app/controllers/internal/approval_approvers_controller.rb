class Internal::ApprovalApproversController < InternalController
    before_action :set_approval_approver, only: [:show, :edit, :update, :destroy]
    before_action :set_required_role_permissions, only: [:new, :edit, :approver_list]
    before_action :set_all_approvers, only: [:new, :edit]

    # GET /approval_approvers
    # GET /approval_approvers.json
    def index
        @approval_approvers = ApprovalApprover.search_category(params[:category])
        .search_status(params[:status])
        .page(params[:page])
        .per(get_per)
    end

    # GET /approval_approvers/1
    # GET /approval_approvers/1.json
    def show
    end

    # GET /approval_approvers/new
    def new
        @approval_approver = ApprovalApprover.new
    end

    # GET /approval_approvers/1/edit
    def edit
    end

    # POST /approval_approvers
    # POST /approval_approvers.json
    def create
        @approval_approver = ApprovalApprover.new(approval_approver_params)

        respond_to do |format|
            if @approval_approver.save
                format.html { redirect_to internal_approval_approvers_path, notice: 'Approval approver was successfully created.' }
                format.json { render :show, status: :created, location: @approval_approver }
            else
                format.html { render :new }
                format.json { render json: @approval_approver.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /approval_approvers/1
    # PATCH/PUT /approval_approvers/1.json
    def update
        respond_to do |format|
            if @approval_approver.update(approval_approver_params)
                format.html { redirect_to internal_approval_approvers_path, notice: 'Approval approver was successfully updated.' }
                format.json { render :show, status: :ok, location: @approval_approver }
            else
                format.html { render :edit }
                format.json { render json: @approval_approver.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /approval_approvers/1
    # DELETE /approval_approvers/1.json
    def destroy
        @approval_approver.destroy
        respond_to do |format|
            format.html { redirect_to internal_approval_approvers_path, notice: 'Approval approver was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def approver_list
        approve_permissions = Role.joins(:role_permissions).where(status: "ACTIVE", category: "Organization", role_permissions: @role_permissions).pluck(:id)
        User.where(status: "ACTIVE", userable_type: "Organization", role_id: approve_permissions)
    end

    # GET /approval_approvers/FOREIGN_WORKER_AMENDMENT/category_approvers.json
    def category_approvers
        case params[:category]
        when "FOREIGN_WORKER_AMENDMENT"
            role_permissions = {
                permission: "APPROVAL_FOREIGN_WORKER",
            }
        when "EMPLOYER_REGISTRATION"
            role_permissions = {
                permission: "APPROVAL_EMPLOYER",
            }
        when "CHANGE_OF_EMPLOYER"
            role_permissions = {
                permission: "CHANGE_EMPLOYER_APPROVAL_FOREIGN_WORKER",
            }
        when "EMPLOYER_AMENDMENT"
            role_permissions = {
                permission: "APPROVAL_EMPLOYER_CRITICAL_INFO",
            }
        when "TRANSACTION_SPECIAL_RENEWAL"
            role_permissions = {
                permission: "APPROVAL_SPECIAL_RENEWAL_TRANSACTION",
            }
        when "TRANSACTION_BYPASS_FINGERPRINT"
            role_permissions = {
                permission: "APPROVAL_BYPASS_FINGERPRINT_TRANSACTION",
            }
        else
            role_permissions = @role_permissions
        end

        approve_permissions = Role.joins(:role_permissions).where(status: "ACTIVE", category: "Organization", role_permissions: role_permissions).pluck(:id)
        @category_approvers = User.where(status: "ACTIVE", userable_type: "Organization", role_id: approve_permissions).select(:id, :name, :email).order(:name)

        respond_to do |format|
            format.json { render json: @category_approvers, status: :ok }
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_approval_approver
        @approval_approver = ApprovalApprover.find(params[:id])
    end

    def set_all_approvers
        @approver_list = approver_list
    end

    def set_required_role_permissions
        @role_permissions = {
            permission: "APPROVAL_FOREIGN_WORKER",
            permission: "APPROVAL_EMPLOYER",
            permission: "APPROVAL_EMPLOYER_CRITICAL_INFO",
            permission: "CHANGE_EMPLOYER_APPROVAL_FOREIGN_WORKER",
            permission: "APPROVAL_SPECIAL_RENEWAL_TRANSACTION",
        }
    end

    # # Never trust parameters from the scary internet, only allow the white list through.
    def approval_approver_params
        params.require(:approval_approver).permit(:category, :status, :user_id)
    end
end