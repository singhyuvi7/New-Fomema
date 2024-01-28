module Cart
    def add_cart
        add_count = 0
        discard_count = 0
        discard_rows = []
        (params[:foreign_worker_ids] || params[:ids]).each do |fw_id|
            # if !allow_special_renewal && (fw = ForeignWorker.find(fw_id)).special_renewal?
            #     discard_rows << "#{fw.name}, #{fw.passport_number}"
            #     discard_count += 1
            #     next
            # end

            TransactionCart.where(foreign_worker_id: fw_id, created_by: current_user.id).first_or_create do |tc|
                add_count += 1
            end
        end
        flash[:notice] = "#{add_count} worker#{add_count>1 ? 's' : ''} added"
        # if discard_count > 0
        #     flash[:error] = "Renewal is not allowed for below worker(s). Please refer to the nearest FOMEMA branch for renewal."
        #     discard_rows.each.with_index(1) do |msg,  no|
        #         flash[:error] = flash[:error] + "<br>#{no}) #{msg}"
        #     end
        # end
        @redirect_to = request.referrer || case params[:controller]
        when "external/worker_lists"
            external_worker_lists_path
        when "internal/employer_workers"
            internal_employer_employer_workers_path(@employer)
        end
    end

    def remove_cart
        count = TransactionCart.where(created_by: current_user.id, foreign_worker_id: params[:ids] || []).delete_all
        flash[:notice] = "#{count} removed"
        @redirect_to = request.referrer || case params[:controller]
        when "external/worker_lists"
            external_worker_lists_path
        when "internal/employer_workers"
            internal_employer_employer_workers_path(@employer)
        end
    end

    def cart_count
        TransactionCart.joins("join foreign_workers on transaction_carts.foreign_worker_id = foreign_workers.id join employers on foreign_workers.employer_id = employers.id").where(created_by: current_user.id).count
    end
end