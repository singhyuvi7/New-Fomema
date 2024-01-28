class Internal::InsuranceHistoriesController < InternalController
    before_action :set_insurance_purchase, only: [:show, :edit, :update, :destroy, :resubmit_paid]
    before_action -> { can_access?("VIEW_INSURANCE_PURCHASE") }, only: [:index, :show]
    before_action -> { can_access?("RESUBMIT_PAID_INSURANCE_PURCHASE") }, only: [:resubmit_paid]

    def index
        @insurance_purchases = InsurancePurchase.includes(:order).includes(:fw_country).includes(:employer)
        .search_employer_code(params[:employer_code])
        .search_employer_name(params[:employer_name])
        .search_fw_code(params[:fw_code])
        .search_fw_name(params[:fw_name])
        .search_fw_passport_number(params[:fw_passport_number])
        .search_policy_date(params[:filter_policy_date_start], params[:filter_policy_date_end])
        .search_order_status(params[:order_status])
        .search_order_code(params[:order_code])
        .search_order_branch(params[:branch_id])
        .search_order_paid_date(params[:filter_paid_start_date], params[:filter_paid_end_date])
        .order('insurance_purchases.created_at DESC').page(params[:page]).per(get_per)
    end

    def show
    end

    def resubmit_paid
        SubmitPaidInsuranceJob.perform_later(order: @insurance_purchase.order, response_url: policy_external_insurances_url, backend_url: policy_external_insurances_url)
        flash_add(:notice, "Resubmit job scheduled")
        redirect_to internal_insurance_histories_path
    end

    private
    def set_insurance_purchase
        @insurance_purchase = InsurancePurchase.find(params[:id])
    end
end
