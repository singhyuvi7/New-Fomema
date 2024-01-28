class Internal::ReassignXqccPcrController < InternalController
    before_action -> { can_access?("REASSIGN_APPEAL_PCR_REVIEWS") }

    def appeal_pcr_reviews # Index - MedicalAppeal related PcrReview & PcrPool
        refined_search = false

        if params[:worker_code].present?
            transactions        = Transaction.where(fw_code: params[:worker_code].strip).pluck(:id)
            ids_from_trans      = MedicalAppeal.where(transaction_id: transactions).pluck(:id)
            @appeal_pcrs        = PcrReview.none.page(params[:page]).per(get_per) and return if ids_from_trans.blank?
            refined_search      = true
        end

        if params[:retake_code].present?
            ids_from_retake     = XrayRetake.where(code: params[:retake_code].strip, requestable_type: "MedicalAppeal").pluck(:requestable_id)
            @appeal_pcrs        = PcrReview.none.page(params[:page]).per(get_per) and return if ids_from_retake.blank?
            refined_search      = true
        end

        appeal_ids  =
            if params[:worker_code].present? && params[:retake_code].present?
                ids_from_trans & ids_from_retake
            elsif params[:worker_code].present?
                ids_from_trans
            elsif params[:retake_code].present?
                ids_from_retake
            end

        if params[:status] == "PCR_REVIEW" || params[:status].blank?
            builder             = PcrReview.where(status: "PCR_REVIEW")
            pcr_reviews         = refined_search ? builder.where(medical_appeal_id: appeal_ids) : builder.where.not(medical_appeal_id: nil)
            @appeal_pcrs        = pcr_reviews.includes(:pcr_user, medical_appeal: [:transactionz], poolable: [xray_retake: [:xray_facility]])
                                    .page(params[:page]).per(get_per)
        elsif params[:status] == "PCR_POOL"
            builder             = PcrPool.where(status: "PCR_POOL")
            pcr_pools           = refined_search ? builder.where(medical_appeal_id: appeal_ids) : builder.where.not(medical_appeal_id: nil)
            @appeal_pcrs        = pcr_pools.includes(medical_appeal: [:transactionz], xray_retake: [:xray_facility])
                                    .page(params[:page]).per(get_per)
        end
    end

    def appeal_pcr_review # Edit - MedicalAppeal related PcrReview
        appeal_pcr_review   = PcrReview.find_by(id: params[:id])
        transaction         = appeal_pcr_review.medical_appeal.transactionz
        xray_retake         = appeal_pcr_review.poolable.xray_retake
        xray_facility       = xray_retake.xray_facility
        pcr_user            = appeal_pcr_review.pcr_user
        @title              = "Appeal PCR Review - Reassign"
        @updating_model     = appeal_pcr_review
        @submit_url         = appeal_pcr_review_update_internal_reassign_xqcc_pcr_path(id: appeal_pcr_review.id)
        @back_url           = appeal_pcr_reviews_internal_reassign_xqcc_pcr_index_path
        @select_options     = User.active.where(role_id: Role.find_by(name: "PCR").id).pluck(:name, :id).sort
        @selected           = pcr_user&.id
        @displayed_msg      = "- Displays users with the role <b>PCR</b>"

        @data = {
            "Review ID"             => appeal_pcr_review.id,
            "Status"                => appeal_pcr_review.status,
            "Appeal ID"             => appeal_pcr_review.medical_appeal_id,
            "Transaction Code"      => transaction.code,
            "Retake Code"           => xray_retake.code,
            "Worker Code"           => transaction.fw_code,
            "Worker Name"           => transaction.fw_name,
            "Worker Gender"         => ForeignWorker::GENDERS[transaction.fw_gender],
            "Worker Passport"       => transaction.fw_passport_number,
            "Worker Country"        => transaction.fw_country&.name,
            "Xray Facility Code"    => xray_facility&.code,
            "Xray Facility Name"    => xray_facility&.name,
            "PCR User Code"         => pcr_user&.code,
            "PCR User Name"         => pcr_user&.name
        }

        render :reassign_xqcc_pcr_form
    end

    def appeal_pcr_review_update
        appeal_pcr_review   = PcrReview.find_by(id: params[:id])

        if appeal_pcr_review.pcr_id != params[:pcr_id].to_i
            pcr_user1   = appeal_pcr_review.pcr_user
            pcr_user2   = User.find_by(id: params[:pcr_id])
            appeal_pcr_review.update(pcr_id: params[:pcr_id])
            appeal_pcr_review.submit_movement("REASSIGNED - APPEALS PCR REVIEW", "PCR Reassigned from #{ pcr_user1&.code } to #{ pcr_user2&.code }")
            redirect_to appeal_pcr_reviews_internal_reassign_xqcc_pcr_index_path, notice: "Pcr review reassigned from #{ pcr_user1&.name } to #{ pcr_user2&.name }"
        else
            redirect_to appeal_pcr_reviews_internal_reassign_xqcc_pcr_index_path, error: "Pcr selected for Retake #{ params["Retake Code"] } was the same, results not updated."
        end
    end

    def appeal_pcr_pool # Edit - MedicalAppeal related PcrPool
        appeal_pcr_pool = PcrPool.find_by(id: params[:id])
        transaction     = appeal_pcr_pool.medical_appeal.transactionz
        xray_retake     = appeal_pcr_pool.xray_retake
        xray_facility   = xray_retake.xray_facility
        @title          = "Appeal PCR Pool - Assign"
        @updating_model = appeal_pcr_pool
        @submit_url     = appeal_pcr_pool_update_internal_reassign_xqcc_pcr_path(id: appeal_pcr_pool.id)
        @back_url       = appeal_pcr_reviews_internal_reassign_xqcc_pcr_index_path
        @select_options = User.active.where(role_id: Role.find_by(name: "PCR").id).pluck(:name, :id).sort
        @selected       = nil
        @displayed_msg  = "- Displays users with the role <b>PCR</b>"

        @data = {
            "Pool ID"               => appeal_pcr_pool.id,
            "Status"                => appeal_pcr_pool.status,
            "Appeal ID"             => appeal_pcr_pool.medical_appeal_id,
            "Transaction Code"      => transaction.code,
            "Retake Code"           => xray_retake.code,
            "Worker Code"           => transaction.fw_code,
            "Worker Name"           => transaction.fw_name,
            "Worker Gender"         => ForeignWorker::GENDERS[transaction.fw_gender],
            "Worker Passport"       => transaction.fw_passport_number,
            "Worker Country"        => transaction.fw_country&.name,
            "Xray Facility Code"    => xray_facility&.code,
            "Xray Facility Name"    => xray_facility&.name
        }

        render :reassign_xqcc_pcr_form
    end

    def appeal_pcr_pool_update
        appeal_pcr_pool = PcrPool.find_by(id: params[:id])
        pcr_user        = User.find_by(id: params[:pcr_id])
        appeal_pcr_pool.pickup_pcr(pcr_user.id)
        appeal_pcr_pool.submit_movement('PICKED-UP', 'PCR Picked Up')
        appeal_pcr_pool.create_activity key: 'pcr_pool.pickedup_on', owner: pcr_user
        redirect_to appeal_pcr_reviews_internal_reassign_xqcc_pcr_index_path(status: "PCR_POOL"), notice: "Pcr review assigned to #{ pcr_user.name }"
    end
end