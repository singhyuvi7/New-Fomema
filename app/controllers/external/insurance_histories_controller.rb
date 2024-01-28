class External::InsuranceHistoriesController < ExternalController
    include ProfileInfoCheck
    include AgencySopAcknowledgeCheck

    before_action :set_insurance_purchase, only: [:show, :edit, :update, :destroy]
    before_action -> { pending_profile_update?(Employer.find_by(id: current_user.userable_id)) }, if: -> { current_user.userable_type == 'Employer' }, only: [ :index]
    before_action -> { agency_sop_acknowledge_check?(Agency.find_by(id: current_user.userable_id)) }, if: -> { current_user.userable_type == 'Agency' }, only: [ :index]

    def index
        if current_user.userable_type == 'Employer'
            query = InsurancePurchase.where(employer_id: current_user.userable_id)
            .includes(:order).includes(:fw_country)
            .search_fw_code(params[:fw_code])
            .search_fw_name(params[:fw_name])
            .search_fw_passport_number(params[:fw_passport_number])
            .search_policy_date(params[:filter_policy_date_start], params[:filter_policy_date_end])
            .search_order_status(params[:order_status])
            .search_order_code(params[:order_code])

                 if current_user.userable_type == 'Employer' and !current_user.employer_supplement_id.blank?
                    query = query.joins(:order).where("orders.created_by = ?", current_user.id)
                 else
                    query = query.joins(:order).where("orders.customerable_type = ?", current_user.userable_type)
                 end
        else
            query = InsurancePurchase.includes(:order).includes(:fw_country)
            .search_fw_code(params[:fw_code])
            .search_fw_name(params[:fw_name])
            .search_fw_passport_number(params[:fw_passport_number])
            .search_policy_date(params[:filter_policy_date_start], params[:filter_policy_date_end])
            .search_order_status(params[:order_status])
            .search_order_code(params[:order_code])
             query = query.joins(:order).where("orders.created_by = ?", current_user.id)
        end

        @insurance_purchases = query.order('insurance_purchases.created_at DESC').page(params[:page]).per(get_per)
    end

    def show
    end

    private
    def set_insurance_purchase
        if current_user.userable_type == 'Employer'
            @insurance_purchase = InsurancePurchase.where(employer_id: current_user.userable_id).find(params[:id])
        else
            @insurance_purchase = InsurancePurchase.find(params[:id])
        end
    end
end
