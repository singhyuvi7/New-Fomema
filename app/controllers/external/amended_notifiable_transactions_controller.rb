class External::AmendedNotifiableTransactionsController < ExternalController

    def index
        case current_user.userable_type
        when "Doctor", "XrayFacility"
            amended_transactions = AmendedNotifiableTransaction.where(notifiable_type: current_user.userable_type, notifiable_id: current_user.userable_id)
        else
            redirect_to external_amended_notifiable_transactions_path and return
        end

        @amended_transactions  = amended_transactions.includes(:transactionz)
            .search_fw_code(params[:worker_code])
            .search_fw_name(params[:worker_name])
            .search_fw_passport(params[:passport_number])
            .search_fw_country(params[:country_id])
            .search_code(params[:transaction_code])
            .search_certification_date_start(params[:certification_date_start])
            .search_certification_date_end(params[:certification_date_end])
            .search_amended_date_start(params[:amended_date_start])
            .search_amended_date_end(params[:amended_date_end])
            .order(id: :desc)
            .page(params[:page]).per(get_per)

        amended_transactions.each do |amended_transaction|
            @transaction = amended_transaction.transactionz
            if amended_transaction.notify_pkd_at.nil?
                amended_transaction.update(notify_pkd_at: Time.now)
            end
        end
    end
end