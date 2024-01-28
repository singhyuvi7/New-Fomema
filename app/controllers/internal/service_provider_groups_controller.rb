class Internal::ServiceProviderGroupsController < InternalController
    before_action :set_service_provider_group, only: [:show, :edit, :update, :destroy, :members, :member_new, :member_create, :member_destroy]

    # GET /service_provider_groups
    # GET /service_provider_groups.json
    def index
        @service_provider_groups = ServiceProviderGroup.search_code(params[:code])
        .search_name(params[:name])
        .search_category(params[:category])
        .order('created_at DESC')
        .includes(:state).includes(:town)

        respond_to do |format|
            format.html { @service_provider_groups = @service_provider_groups.page(params[:page]).per(get_per) }
            format.json
        end
    end

    # GET /service_provider_groups/1
    # GET /service_provider_groups/1.json
    def show
    end

    # GET /service_provider_groups/new
    def new
        @service_provider_group = ServiceProviderGroup.new({
            status: 'ACTIVE',
            payment_method_id: PaymentMethod.find_by(code: "OUT_CASHORDER").try(:id)
        })

        @default_rates = SystemConfiguration.where(:code => ['DOCTOR_SERVICE_PROVIDER_GROUP_DEFAULT_MALE_RATE','DOCTOR_SERVICE_PROVIDER_GROUP_DEFAULT_FEMALE_RATE','LABORATORY_SERVICE_PROVIDER_GROUP_DEFAULT_MALE_RATE','LABORATORY_SERVICE_PROVIDER_GROUP_DEFAULT_FEMALE_RATE','XRAY_FACILITY_SERVICE_PROVIDER_GROUP_DEFAULT_MALE_RATE','XRAY_FACILITY_SERVICE_PROVIDER_GROUP_DEFAULT_FEMALE_RATE'])
    end

    # GET /service_provider_groups/1/edit
    def edit
    end

    # POST /service_provider_groups
    # POST /service_provider_groups.json
    def create
        data = {
            status: 'ACTIVE'
        }.merge(service_provider_group_params)

        data["bank_payment_id"] = data["business_registration_number"] if data["bank_payment_id"].blank?
        data["male_rate"] = SystemConfiguration.find_by(code: "#{service_provider_group_params[:category].snakecase.upcase}_SERVICE_PROVIDER_GROUP_DEFAULT_MALE_RATE").try(:value) if data["male_rate"].blank?
        data["female_rate"] = SystemConfiguration.find_by(code: "#{service_provider_group_params[:category].snakecase.upcase}_SERVICE_PROVIDER_GROUP_DEFAULT_FEMALE_RATE").try(:value) if data["female_rate"].blank?
        data['payment_method_id'] = PaymentMethod.find_by(code: "OUT_CASHORDER").try(:id) if data['payment_method_id'].blank?

        @service_provider_group = ServiceProviderGroup.new(data)
        respond_to do |format|
            if @service_provider_group.save!
                format.html { redirect_to internal_service_provider_groups_path, notice: 'Service Provider Group was successfully created.' }
                format.json { render :show, status: :created, location: @service_provider_group }
            else
                format.html { render :new }
                format.json { render json: @service_provider_group.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /service_provider_groups/1
    # PATCH/PUT /service_provider_groups/1.json
    def update
        @service_provider_group.assign_attributes(service_provider_group_params)
        begin
            respond_to do |format|
                if @service_provider_group.save!
                    format.html { redirect_to internal_service_provider_groups_path, notice: 'Service Provider Group was successfully updated.' }
                    format.json { render :show, status: :ok, location: @service_provider_group }
                else
                    format.html { render :edit }
                    format.json { render json: @service_provider_group.errors, status: :unprocessable_entity }
                end
            end
        rescue ActiveRecord::RecordInvalid => invalid
            redirect_to internal_service_provider_groups_path, notice: invalid.to_s
        end
    end

    # DELETE /service_provider_groups/1
    # DELETE /service_provider_groups/1.json
    def destroy
        @service_provider_group.destroy
        respond_to do |format|
            format.html { redirect_to internal_service_provider_groups_url, notice: 'Service Provider Group was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    def members
        @memberables = @service_provider_group.category.constantize.where("service_provider_group_id = ?", @service_provider_group.id)
        .search_name(params[:name])
        .search_code(params[:code])
        .page(params[:page])
        .per(get_per)
    end

    def member_new
        @memberables = @service_provider_group.category.constantize
        .search_name(params[:name])
        .search_code(params[:code])
        .where("service_provider_group_id is null")
        .page(params[:page])
        .per(get_per)
    end

    def member_create
        params[:member_ids].each do |member_id|
            @service_provider_group.category.constantize.find(member_id).update({
                service_provider_group_id: @service_provider_group.id
            })
        end
        redirect_to members_internal_service_provider_group_path, notice: "Member added to service provider group"
    end

    def member_destroy
        @service_provider_group.category.constantize.find(params[:member_id]).update({
            service_provider_group_id: nil
        })
        respond_to do |format|
            format.html { redirect_to members_internal_service_provider_group_path, notice: 'Member was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_provider_group
        @service_provider_group = ServiceProviderGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_provider_group_params
        params.require(:service_provider_group).permit(:category, :name, :address1, :address2, :address3, :address4, :country_id, :state_id, :postcode, :town_id, :phone, :fax, :email, :male_rate, :female_rate, :bank_id, :bank_account_holder_name, :bank_account_number, :bank_payment_id, :payment_method_id, :business_registration_number, :email_payment)
    end
end