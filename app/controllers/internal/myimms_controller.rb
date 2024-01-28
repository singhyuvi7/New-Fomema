class Internal::MyimmsController < InternalController
    before_action -> { can_access?("VIEW_MYIMMS") }, only: [:index]
    before_action -> { can_access?("SUBMIT_TO_JIM") }, only: [:submit_to_jim]

    def index
        @myimms_transactions = MyimmsTransaction.search_code(params[:code])
        .search_status(params[:status])
        .search_passport_number(params[:passport_number])
        .search_date_send_start(params[:date_send_start])
        .search_date_send_end(params[:date_send_end])
        .order(updated_at: :desc)
        .page(params[:page])
        .per(get_per)

        @myimms_requests = MyimmsRequest.search_code(params[:code])
        .search_status(params[:status])
        .search_passport_number(params[:passport_number])
        .search_date_send_start(params[:date_send_start])
        .search_date_send_end(params[:date_send_end])
        .order(created_at: :desc)
        .page(params[:page])
        .per(get_per)
    end

    def submit_to_jim
        response = MyimmsGateway.call(params[:ids])
        if response.success
            flash[:notice] = response.flash
        else
            flash[:warning] = response.flash
        end
        redirect_to internal_myimms_path and return
    end
end
