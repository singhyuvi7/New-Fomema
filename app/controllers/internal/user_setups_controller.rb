class Internal::UserSetupsController < InternalController
    include ValidateUserable

    before_action :set_user, only: [:show, :edit, :update, :destroy, :resend_confirmation]
    before_action -> { validate_setup_user_email?(@user, params[:user][:email]) }, only: [:update]
    before_action -> { validate_email_with_plus_sign(params[:user][:email]) }, only: [:create, :update]
    before_action -> { set_userable_ids }, only: [:edit, :update]
    before_action -> { can_access?("VIEW_USER") }, only: [:index, :show]
    before_action -> { can_access?("CREATE_USER") }, only: [:new, :create]
    before_action -> { can_access?("EDIT_USER") }, only: [:edit, :update]
    before_action -> { can_access?("DELETE_USER") }, only: [:destroy]
    before_action -> { can_access?("RESEND_CONFIRMATION_INSTRUCTION_USER") }, only: [:resend_confirmation]

    # GET /users
    # GET /users.json
    def index
        @users = User.includes(:role)
        .search_username(params[:username])
        .search_code(params[:code])
        .search_name(params[:name])
        .search_email(params[:email])
        .search_role(params[:role_id])
        .search_status(params[:status])

        if params[:submit].eql?("export")
            bulk_export(@users) and return
        end

        @users = @users.page(params[:page])
        .per(get_per)
    end

    # GET /users/1
    # GET /users/1.json
    def show
        @permissions = (@user.role_permissions.pluck(:permission) + @user.user_permissions.pluck(:permission)).uniq
    end

    # GET /users/new
    def new
        @userable_types = {
            "Organization" => "FOMEMA"
        }
        @userable_ids = {}

        if (params.key?(:userable_type))
            @userable_types = {
                params[:userable_type] => User::USERABLE_TYPES[params[:userable_type]]
            }
            @userable_ids = params[:userable_type].constantize.all
        end

        user_data = {
            userable_type: @userable_types.keys[0]
        }
        [:userable_id, :role_id].each do |sym|
            if (params.key?(sym))
                user_data[sym] = params[sym]
            end
        end
        @user = User.new(user_data)
    end

    # GET /users/1/edit
    def edit
        @userable_types = {
            @user.userable_type => User::USERABLE_TYPES[@user.userable_type]
        }
    end

    # POST /users
    # POST /users.json
    def create
        user_data = user_params
        if user_data[:password].blank?
            user_data[:password] = SecureRandom.hex(8)
            user_data[:password_confirmation] = user_data[:password]
        end
        @user = User.new(user_data)
        respond_to do |format|
            if @user.save
                @user.sync_user_permissions(params["user"]["permissions"])
                format.html { redirect_to internal_user_setups_path, notice: 'User was successfully created.' }
                format.json { render :show, status: :created, location: @user }
            else
                @userable_types = {
                    @user.userable_type => User::USERABLE_TYPES[@user.userable_type]
                }
                @userable_ids = case @user.userable_type
                when 'Organization'
                    Organization.order(:name).all
                when "Employer"
                    Employer.order(:name).all
                when "Doctor"
                    Doctor.order(:name).all
                when "Laboratory"
                    Laboratory.order(:name).all
                when "Radiologist"
                    Radiologist.order(:name).all
                when "XrayFacility"
                    XrayFacility.order(:name).all
                when "Agency"
                    Agency.order(:name).all
                else
                    {}
                end
                format.html { render :new }
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /users/1
    # PATCH/PUT /users/1.json
    def update
        user_data = user_params
        if (!user_params.include?("password") or user_params["password"].empty?)
            user_data.delete("password")
            user_data.delete("password_confirmation")
        else
            user_data["confirmed_at"] = @user.confirmed_at || Time.now.strftime('%Y-%m-%d %H:%M:%S')
        end

        notice_msg = 'User was successfully updated.'
        if user_data[:email] != @user.email
            notice_msg += " Please click on the link that has just been send to '#{user_data[:email]}' to verify the email changes."
        end

        respond_to do |format|
            if @user.update(user_data)
                @user.sync_user_permissions(params["user"]["permissions"])
                @redirect_to = case params[:submit]
                when "Save and Continue"
                    edit_internal_user_setup_path(@user)
                else
                    internal_user_setups_path
                end
                format.html { redirect_to @redirect_to, notice: notice_msg }
                format.json { render :show, status: :ok, location: @user }
            else
                @userable_types = {
                    @user.userable_type => User::USERABLE_TYPES[@user.userable_type]
                }
                format.html { render :edit }
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /users/1
    # DELETE /users/1.json
    def destroy
        @user.destroy
        respond_to do |format|
            format.html { redirect_to internal_user_setups_url, notice: 'User was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def bulk_action
        case params[:bulk_action]
        when "export"
            @users = User.where("users.id in (?)", params[:ids])
            bulk_export(@users)
        end
    end

    def bulk_export(users)
        users = users.select("users.id, users.code, users.username, users.name, roles.name role_name,
        users.email, users.userable_type, users.role_id, users.userable_id,
        string_agg(role_permissions.permission, ',') role_permission_lists,
        string_agg(user_permissions.permission, ',') user_permission_lists")
        .joins("left join roles on users.role_id = roles.id
        left join role_permissions on users.role_id = role_permissions.role_id
        left join user_permissions on users.id = user_permissions.user_id")
        .group("users.id, users.code, users.username, users.name, roles.name,
        users.email, users.userable_type, users.role_id, users.userable_id")

        attributes = [
            "id",
            "code",
            "username",
            "name",
            "role",
            "email",
            "userable type",
            "userable",
            "role permissions",
            "user permissions"
        ]
        exp = CSV.generate(headers: true) do |csv|
            csv << attributes

            users.each do |user|
                csv << [
                    user.id,
                    user.code,
                    user.username,
                    user.name,
                    user.role_name,
                    user.email,
                    user.userable_type,
                    user.userable&.name,
                    (user.role_permission_lists || '').split(",").uniq.join("\n"),
                    (user.user_permission_lists || '').split(",").uniq.join("\n")
                ]
            end
        end

        send_data exp, filename: "users-#{Time.now.strftime("%Y%m%d%H%M%S")}.csv"
    end

    def load_userable_ids
        @userable_ids = case params[:type]
        when 'Organization'
            Organization.order(:name).all
        when "Employer"
            Employer.order(:name).all
        when "Doctor"
            Doctor.order(:name).all
        when "Laboratory"
            Laboratory.order(:name).all
        when "Radiologist"
            Radiologist.order(:name).all
        when "XrayFacility"
            XrayFacility.order(:name).all
        when "Agency"
            Agency.order(:name).all
        else
            {}
        end
    end

    def resend_confirmation
        @user.resend_confirmation_instructions
        flash[:notice] = "Confirmation instruction resent"
        redirect_to internal_user_setup_path(@user)
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
        @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
        params.require(:user).permit(:code, :email, :name, :username, :role_id, :password_policy_id, :site, :organization_id, :password, :password_confirmation, :status, :userable_id, :userable_type, :userable_id, :title_id, :user_permissions_attributes, :session_limitable_disabled, :designation, :comment)
    end

    def set_userable_ids
        @userable_ids = case @user.userable_type
        when 'Organization'
            Organization.order(:name).all
        when "Employer"
            Employer.where(:id => @user.userable_id)
        when "Doctor"
            Doctor.where(:id => @user.userable_id)
        when "Laboratory"
            Laboratory.where(:id => @user.userable_id)
        when "Radiologist"
            Radiologist.where(:id => @user.userable_id)
        when "XrayFacility"
            XrayFacility.where(:id => @user.userable_id)
        when "Agency"
            Agency.where(:id => @user.userable_id)
        else
            {}
        end
    end
end