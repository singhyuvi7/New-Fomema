module Internal
  class OrganizationsController < InternalController
    before_action :set_organization, only: [:show, :edit, :update, :destroy]

    # GET /organizations
    # GET /organizations.json
    def index
      @organizations = Organization.search_code(params[:code])
      .search_name(params[:name])
      .search_status(params[:status])
      .page(params[:page])
      .per(get_per)
    end

    # GET /organizations/chart
    def chart
      @root_organization = Organization.first()
      @organization_tree_json = @root_organization.to_node.to_json

      # render json: @organization_tree_json
    end

    # GET /organizations/tree
    def tree

    end

    # GET /organizations/1
    # GET /organizations/1.json
    def show
    end

    # GET /organizations/new
    def new
      @organization = Organization.new

      @organization.parent_id = params[:organization_id]
    end

    # GET /organizations/1/edit
    def edit
    end

    # POST /organizations
    # POST /organizations.json
    def create
      @organization = Organization.new(organization_params)

      respond_to do |format|
        if @organization.save
          format.html { redirect_to internal_organizations_path, notice: 'Organization was successfully created.' }
          format.json { render :show, status: :created, location: @organization }
        else
          format.html { render :new }
          format.json { render json: @organization.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /organizations/1
    # PATCH/PUT /organizations/1.json
    def update
      respond_to do |format|
        if @organization.update(organization_params)
          format.html { redirect_to internal_organizations_path, notice: 'Organization was successfully updated.' }
          format.json { render :show, status: :ok, location: @organization }
        else
          format.html { render :edit }
          format.json { render json: @organization.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /organizations/1
    # DELETE /organizations/1.json
    def destroy
      @organization.destroy
      respond_to do |format|
        format.html { redirect_to internal_organizations_url, notice: 'Organization was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_organization
        @organization = Organization.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def organization_params
        params.require(:organization).permit(:parent_id, :code, :name, :address1, :address2, :address3, :address4, :state_id, :postcode, :town_id, :phone, :fax, :email, :org_type, :bank_code, :bank_co, :bank_acctno, :zone_id, :status)
      end
  end
end