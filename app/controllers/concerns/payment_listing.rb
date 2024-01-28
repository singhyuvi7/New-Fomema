module PaymentListing

    def view_payment_listing

        transactions = generateTransactions(params)
        @service_provider = params[:service_provider]
        @transactions   = transactions.page(params[:page]).per(get_per)

        render 'internal/service_provider_payments/payment_listing/index'
    end

    def export_payment_listing

        @transactions = generateTransactions(params)
        service_provider = params[:service_provider]
        start_date = params[:certification_date_start]
        end_date = params[:certification_date_end]

        filename = "#{service_provider}_Transactions.csv"
        respond_to do |format|
          format.csv { send_data SpFinBatchItem.to_csv(@transactions,service_provider), filename: filename }
        end
    end

private
    def generateTransactions (params)
        service_provider = params[:service_provider]
        certification_date_start = params[:certification_date_start]
        certification_date_end = params[:certification_date_end]
        payment_date_start = params[:payment_date_start]
        payment_date_end = params[:payment_date_end]
        group_id = params[:group]
        service_provider_code = params[:service_provider_code]
        payment_type = params[:payment_type]
        trans_date = "1998-03-14"
        
        transactions = auto_transactions = manual_transactions = Transaction.none

        if service_provider.present?
        
            service_provider_id = service_provider_code.present? ? service_provider.constantize.where(:code => service_provider_code).pluck(:id).first : ''
            sp_fin_batch_items = []

            if payment_type == 'all' || payment_type == 'auto'

                if group_id.present? 
                    auto_transactions = Transaction.search_transaction_date_start(trans_date)
                    .joins(:sp_fin_batch_item)
                    .joins( "INNER JOIN sp_fin_batches ON sp_fin_batch_items.sp_fin_batch_id = sp_fin_batches.id" )
                    .where('sp_fin_batches.batchable_id = ? and sp_fin_batches.batchable_type = ?',group_id, ServiceProviderGroup.to_s)
                    .where(sp_fin_batch_items: {itemable_type: service_provider})
                else
                    auto_transactions = Transaction.search_transaction_date_start(trans_date)
                    .joins(:sp_fin_batch_item)
                    .joins( "INNER JOIN sp_fin_batches ON sp_fin_batch_items.sp_fin_batch_id = sp_fin_batches.id" )
                    .where('sp_fin_batches.batchable_type = ?', service_provider)
                    .where(sp_fin_batch_items: {itemable_type: service_provider})
                end

                if payment_date_start.present?
                    auto_transactions = auto_transactions.where("sp_fin_batch_items.created_at >= ? AND sp_fin_batch_items.created_at <= ?", payment_date_start, payment_date_end)
                end
            
                if service_provider_code.present?
                    auto_transactions = auto_transactions.where("sp_fin_batch_items.itemable_id = ?", service_provider_id)
                end

            end

            # manual payment
            if payment_type == 'all' || payment_type == 'manual'

                if group_id.present?
                    manual_transactions = Transaction.search_transaction_date_start(trans_date)
                    .joins(:sp_transactions_payments)
                    .where(sp_transactions_payments: {service_provider_group_id: group_id})
                else
                    manual_transactions = Transaction.search_transaction_date_start(trans_date)
                    .joins(:sp_transactions_payments)
                    .where(sp_transactions_payments: {service_providable_type: service_provider, service_provider_group_id: [nil, '']})
                end

                if payment_date_start.present?
                    manual_transactions = manual_transactions.where("sp_transactions_payments.pay_at >= ? AND sp_transactions_payments.pay_at <= ?", payment_date_start, payment_date_end)
                end

                if service_provider_code.present?
                    manual_transactions = manual_transactions.where("sp_transactions_payments.service_providable_id = ?", service_provider_id)
                end

            end
            # end manual

            case payment_type
            when 'manual'
                transactions = manual_transactions
            when 'auto'
                transactions = auto_transactions
            else
                transactions = Transaction.from("(#{auto_transactions.to_sql} UNION ALL #{manual_transactions.to_sql}) AS transactions")
            end
        
            if certification_date_start.present? 
                transactions = transactions.certified_between(certification_date_start,certification_date_end)
            end
            transactions = transactions.order(:certification_date)

        end
        
        return transactions
    end
end