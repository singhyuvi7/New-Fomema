module Internal
    class EmployerUsersController < InternalController
        before_action :set_employer
        before_action :set_user, only: [:show, :edit, :update, :destroy]

        # GET /foreign_workers
        # GET /foreign_workers.json
        def index
            @employer = Employer.find(params[:employer_id])
            @users = User.where("userable_id = ? and userable_type = ?", @employer.id, 'Employer')
            .search_name(params[:name])
            .page(params[:page])
            .per(get_per)
        end

        def show
        end

        def new
            if !params[:supplemental].blank?
                @role = Role.find_by(code: "EMPLOYER_SUPPLEMENTAL")
                @employer_supplement = @employer.employer_supplements.new
            else
                @role = Role.find_by(code: "EMPLOYER")
            end
            @user = User.new({
                userable: @employer,
                role_id: @role.id
            })

            @user.build_employer_supplement
            # @user.employer_supplement = EmployerSupplement.new
        end

        def create
            user_data = user_params
            @role = Role.find(user_data[:role_id])

            @user = @employer.users.new(user_data.merge({
                status: "ACTIVE",
                password: params[:user][:password].blank? ? "Aa1!#{SecureRandom.hex(PasswordPolicy.find_by(name: "External User").minimum_length)}" : params[:user][:password],
                password_changed_at: (@role.password_policy.password_expiry+1).months.ago
            }))
            if (@role.code == 'EMPLOYER_SUPPLEMENTAL')
                nested_params = params[:user][:employer_supplement_attributes]

                employer_supplement_data = employer_supplement_params.merge({
                    name: user_params[:name],
                    email: user_params[:email]
                }).merge(
                    state_id: nested_params[:state_id], town_id: nested_params[:town_id], postcode: nested_params[:postcode]
                )
                
                @employer_supplement = @employer.employer_supplements.new(employer_supplement_data)
                @user.employer_supplement = @employer_supplement
            end

            if User.where(email: user_data[:email]).count > 0
                # @user.password = ""
                flash.now[:error] = "Email not available"
                render :new and return
                # redirect_to @role.code == 'EMPLOYER_SUPPLEMENTAL' ? new_internal_employer_employer_user_path(supplemental: 1) : new_internal_employer_employer_user_path
                return
            end

            if User.where(username: user_data[:username]).count > 0
                # @user.password = ""
                flash.now[:error] = "Username not available"
                render :new and return
                # redirect_to @role.code == 'EMPLOYER_SUPPLEMENTAL' ? new_internal_employer_employer_user_path(supplemental: 1) : new_internal_employer_employer_user_path
                return
            end

            respond_to do |format|
                if @user.save

                    if (@role.code == 'EMPLOYER_SUPPLEMENTAL')
                        @employer_supplement.save
                        @user.update({
                            employer_supplement_id: @employer_supplement.id
                        })
                    end

                    format.html { redirect_to internal_employer_employer_users_path, notice: 'User was successfully created.' }
                    format.json { render :show, status: :created, location: @user }
                else
                    format.html { render :new }
                    format.json { render json: @user.errors, status: :unprocessable_entity }
                end
            end
        end

        def edit
            @role = @user.role
            @employer_supplement = @user.employer_supplement if !@user.employer_supplement.blank?
        end

        def update
            @role = @user.role
            @employer_supplement = @user.employer_supplement
            user_data = user_params
            if (!user_params.include?("password") || user_params["password"].empty?)
                user_data.delete("password")
                user_data.delete("password_confirmation")
            end
            respond_to do |format|
                if @user.update(user_data)
                    if !@user.employer_supplement.blank?
                        nested_params = params[:user][:employer_supplement_attributes]

                        @user.employer_supplement.update(employer_supplement_params.merge({
                            name: user_params[:name],
                            email: user_params[:email]
                        }).merge(
                            state_id: nested_params[:state_id], town_id: nested_params[:town_id], postcode: nested_params[:postcode]
                        ))
                    end
                    format.html { redirect_to internal_employer_employer_users_path, notice: 'User was successfully updated.' }
                    format.json { render :show, status: :ok, location: @user }
                else
                    format.html { render :edit }
                    format.json { render json: @user.errors, status: :unprocessable_entity }
                end
            end
        end

        def destroy
            @user.destroy
            respond_to do |format|
                format.html { redirect_to internal_employer_employer_users_path, notice: 'User was successfully destroyed.' }
                format.json { head :no_content }
            end
        end

        def bulk_supplement
        end

        def bulk_supplement_create
            role = Role.find_by(code: 'EMPLOYER_SUPPLEMENTAL')
            flash[:errors] = []
            success_count = 0
            CSV.foreach(params[:csv_file]).with_index do |row, rownum|
                next if rownum == 0

                state = State.find_by(code: row[9])
                if !state
                    flash[:errors] << "row #{rownum}: invalid state"
                    next
                end

                town = state.towns.find_by(code: row[10])
                if !town
                    flash[:errors] << "row #{rownum}: invalid town"
                    next
                end

                employer_supplement = @employer.employer_supplements.new({
                    name: (row[0] || '').strip.upcase,
                    email: (row[2] || '').strip.upcase,
                    pic_name: (row[3] || '').strip.upcase,
                    pic_phone: (row[4] || '').strip.upcase,
                    address1: (row[5] || '').strip.upcase,
                    address2: (row[6] || '').strip.upcase,
                    address3: (row[7] || '').strip.upcase,
                    address4: (row[8] || '').strip.upcase,
                    state: state,
                    town: town,
                    postcode: (row[11] || '').strip.upcase,
                    phone: (row[12] || '').strip.upcase,
                    fax: (row[13] || '').strip.upcase,
                })

                user = @employer.users.new({
                    username: (row[1] || '').strip.upcase,
                    email: employer_supplement.email,
                    name: employer_supplement.name,
                    code: (row[1] || '').strip.upcase,
                    role: role,
                    status: "ACTIVE",
                    password: "Aa1!#{SecureRandom.hex(PasswordPolicy.find_by(name: "External User").minimum_length)}",
                    password_changed_at: (role.password_policy.password_expiry+1).months.ago
                })

                if employer_supplement.invalid?
                    flash[:errors] << "row #{rownum}: #{employer_supplement.errors.full_messages.join(', ')}"
                    next
                end

                if user.invalid?
                    flash[:errors] << "row #{rownum}: #{user.errors.full_messages.join(', ')}"
                    next
                end

                employer_supplement.save

                user.employer_supplement_id = employer_supplement.id
                user.save

                success_count += 1
            end
            flash[:notice] = "#{success_count} supplement user created"
            redirect_to internal_employer_employer_users_path
        end

        def bulk_supplement_template
            response.headers['Content-Type'] = 'text/csv'
            response.headers['Content-Disposition'] = 'attachment; filename=bulk_supplement_template.csv'
            render :template => "/internal/employer_users/bulk_supplement_template.csv.erb"
        end

        private
        def set_employer
            @employer = Employer.find(params[:employer_id])
        end

        def set_user
            @user = User.find(params[:id])
        end

        def user_params
            params.require(:user).permit(:name, :email, :status, :role_id, :username, :password, :password_changed_at, :password_confirmation, :title_id)
        end

        def employer_supplement_params
            params.require(:employer_supplement).permit(:pic_name, :pic_phone, :address1, :address2, :address3, :address4, :phone, :fax)
        end
    end
    # /class
end
# /module