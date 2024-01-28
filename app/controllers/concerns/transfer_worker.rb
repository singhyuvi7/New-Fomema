module TransferWorker
    def transfer_worker
        supplements = Employer.select("es.id, es.name, es.address1, es.address2, es.address3, es.address4, es.postcode, es.town_id, es.state_id")
        .joins("JOIN employer_supplements es on employers.id = es.employer_id")
        .where("employers.id = ?", @employer.id)
        .joins("JOIN users u on u.employer_supplement_id = es.id")
        .where("u.status = ?", 'ACTIVE')

        employer = Employer.select("null as id, employers.name, address1, address2, address3, address4, postcode, town_id, state_id")
        .where("employers.id = ?", @employer.id)

        if current_user.employer_supplement_id.blank?
            @employer_supplements = Employer.from("(#{employer.to_sql} UNION ALL #{supplements.to_sql}) AS employers")
            .order("state_id, town_id, name")
        else
            @employer_supplements = supplements.where("es.id = ?", current_user.employer_supplement_id).order("es.state_id, es.town_id, es.name")
        end

        foreign_worker_ids = params[:foreign_worker_ids] || params[:ids]
        @foreign_workers = ForeignWorker.where("foreign_workers.id in (?) and foreign_workers.employer_id = ?", foreign_worker_ids, @employer.id)

        @redirect_to = false

        case site
        when "NIOS"
            render "internal/employer_workers/bulk_transfer_worker"
        when "PORTAL"
            render "external/worker_lists/bulk_transfer_worker"
        end
    end
end
