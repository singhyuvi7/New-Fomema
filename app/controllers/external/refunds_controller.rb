class External::RefundsController < ExternalController
    include ProfileInfoCheck
    include AgencySopAcknowledgeCheck

    before_action :set_refund, only: [:show]
    before_action -> { pending_profile_update?(Employer.find_by(id: current_user.userable_id)) }, if: -> { current_user.userable_type == 'Employer' }, only: [ :index]
    before_action -> { agency_sop_acknowledge_check?(Agency.find_by(id: current_user.userable_id)) }, if: -> { current_user.userable_type == 'Agency' }, only: [ :index]

    def index
        query = Refund.where(customerable: current_user.userable)
        .search_code(params[:code])
        .search_status(params[:refund_status])
        .order('refunds.created_at DESC')

        if !params[:start_date].blank?
            query = query.where("refunds.date >= ?", params[:start_date])
        end
        if !params[:end_date].blank?
            query = query.where("refunds.date < ?", params[:end_date].to_date + 1.day)
        end

        @refunds = query.page(params[:page])
        .per(get_per)
    end

    def show
        @refund_items = @refund.refund_items.order('refund_itemable_type DESC')
    end

    private
    def set_refund
        @refund = Refund.find(params[:id])
    end
end