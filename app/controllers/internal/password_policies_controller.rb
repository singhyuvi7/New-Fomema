module Internal
  class PasswordPoliciesController < InternalController
    before_action :set_password_policy, only: [:show, :edit, :update, :destroy]

    # GET /password_policies
    # GET /password_policies.json
    def index
      @password_policies = PasswordPolicy.search_name(params[:name])
      .page(params[:page])
      .per(get_per)
    end

    # GET /password_policies/1
    # GET /password_policies/1.json
    def show
    end

    # GET /password_policies/new
    def new
      @password_policy = PasswordPolicy.new
    end

    # GET /password_policies/1/edit
    def edit
    end

    # POST /password_policies
    # POST /password_policies.json
    def create
      @password_policy = PasswordPolicy.new(password_policy_params)
      begin
        respond_to do |format|
          if @password_policy.save!
            format.html { redirect_to internal_password_policies_path, notice: 'Password policy was successfully created.' }
            format.json { render :show, status: :created, location: @password_policy }
          else
            format.html { render :new }
            format.json { render json: @password_policy.errors, status: :unprocessable_entity }
          end
        end
      rescue ActiveRecord::RecordInvalid => invalid
        redirect_to internal_password_policies_path, notice: invalid.to_s
      end
    end

    # PATCH/PUT /password_policies/1
    # PATCH/PUT /password_policies/1.json
    def update
      @password_policy.assign_attributes(password_policy_params)
      begin
        respond_to do |format|
          if @password_policy.save
            format.html { redirect_to internal_password_policies_path, notice: 'Password policy was successfully updated.' }
            format.json { render :show, status: :ok, location: @password_policy }
          else
            format.html { render :edit }
            format.json { render json: @password_policy.errors, status: :unprocessable_entity }
          end
        end
      rescue ActiveRecord::RecordInvalid => invalid
        redirect_to internal_password_policies_path, notice: invalid.to_s
      end
    end

    # DELETE /password_policies/1
    # DELETE /password_policies/1.json
    def destroy
      @password_policy.destroy
      respond_to do |format|
        format.html { redirect_to internal_password_policies_path, notice: 'Password policy was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_password_policy
      @password_policy = PasswordPolicy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def password_policy_params
      params.require(:password_policy).permit(:name, :minimum_length, :require_alphabet, :require_numeric, :require_special_characters, :require_small_and_capital, :block_previous_password, :password_expiry)
    end
  end
end