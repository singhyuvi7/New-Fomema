class Internal::MedicalController < InternalController
    include MedicalExaminationInitializer

    before_action -> { can_access?("VIEW_PENDING_REVIEWS") },   only: [:index, :show]
    before_action -> { can_access?("EDIT_PENDING_REVIEWS", "EDIT_PENDING_REVIEW_APPROVALS") }, only: [:index, :show, :medical_review]
    before_action -> { can_access?("EDIT_PENDING_REVIEWS") },   only: [:index, :show, :mle_review_1]
    before_action -> { can_access?("EDIT_PENDING_REVIEWS_QA") },   only: [:index, :show, :medical_pr_qa]
    before_action -> { can_access?("EDIT_PENDING_REVIEW_APPROVALS") }, only: [:index, :show, :mle_review_2]
    before_action -> { can_access?("VIEW_TCUPI_REVIEWS") },     only: [:index, :show]
    before_action -> { can_access?("EDIT_TCUPI_REVIEWS") },     only: [:index, :show, :tcupi_review, :tcupi_review_1]
    before_action -> { can_access?("VIEW_TCUPI_APPROVALS") },   only: [:index, :show]
    before_action -> { can_access?("EDIT_TCUPI_APPROVALS") },   only: [:index, :show, :tcupi_review_approval, :tcupi_review_2]
    before_action :set_transaction,                             only: [:medical_review, :mle_review_1, :mle_review_2, :tcupi_review, :tcupi_review_1, :tcupi_review_approval, :tcupi_review_2, :medical_pr_qa, :medical_mle_qa_status]
    before_action :set_medical_review,                          only: [:medical_review, :mle_review_1, :mle_review_2, :tcupi_review, :tcupi_review_approval, :medical_pr_qa, :medical_mle_qa_status]
    before_action :set_tcupi_review,                            only: [:tcupi_review, :tcupi_review_1, :tcupi_review_approval, :tcupi_review_2]
    before_action :set_previous_transactions_list,              only: [:medical_review, :tcupi_review, :tcupi_review_approval, :medical_pr_qa]

    def index # Needed for breadcrumbs.
        redirect_to internal_transactions_path(review_status: "pending_review_and_review_approval", cookied_path: "y")
    end

    def show # Needed for breadcrumbs.
        redirect_to internal_transaction_path(params[:id])
    end

    def medical_review
        redirect_to internal_transactions_path(review_status: "pending_review_and_review_approval", cookied_path: "y") and return if !["REVIEW"].include?(@transaction.status)
        @medical_review             = @transaction.medical_reviews.create if @medical_review.blank?
        redirect_to internal_transactions_path(review_status: "pending_review_and_review_approval", cookied_path: "y") and return unless @transaction.can_work_on_medical_review(current_user) || @transaction.can_work_on_medical_review_approval(current_user)
        @tcupi_todos                = @medical_review.transaction_tcupi_todos
        @medical_exam               = @transaction.medical_examination

        # Only for third concurrence.
        if @transaction.medical_pr_source == "XQCC"
            @pcr_comments           = @transaction.pcr_reviews
            @xray_pending_decisions = @transaction.xray_pending_decisions
        end

        if @transaction.reload.can_work_on_medical_review(current_user)
            @mle_2_approval         = false
        elsif @transaction.can_work_on_medical_review_approval(current_user)
            @mle_2_approval         = true
            @readonly               = true
        end

        # Create MedicalExamination as a replica of DoctorExamination.
        @medical_exam = create_medical_examination(@transaction) if @medical_exam.blank?
    end

    def medical_pr_qa
        redirect_to internal_transactions_path(review_status: "pending_pr_qa", cookied_path: "y") and return unless @transaction.can_work_on_medical_review_qa(current_user)
        @medical_exam           = @transaction.medical_examination
        @pcr_comments           = @transaction.pcr_reviews
        @xray_pending_decisions = @transaction.xray_pending_decisions

        if @transaction.medical_review_qa
            @qa_review = true
        elsif
            @qa_review = false
        end

        if @transaction.reload.can_work_on_medical_review_qa(current_user)
            @readonly               = false
        end
    end

    def medical_mle_qa_status
        @medical_exam           = @transaction.medical_examination
        @medical_review.assign_attributes(medical_review_qa_params)

        case medical_review_qa_params[:qa_status]
        when "ACCURATE" #accurate follow mle 1 decision
            @medical_review.update(qa_decision: @medical_review.medical_mle1_decision, qa_by: current_user.id, qa_decision_at: Time.now)
            @transaction.update(medical_status: "CERTIFIED", medical_result: @medical_review.medical_mle1_decision, medical_quarantine_release_date: Time.now)

        when "INACCURATE" #follow qa decision
            @medical_exam.save_examination_details_and_comments(
                regular_fields: de_attributes__certification_conditions,
                comments:       de_attributes_comments
            )
            seed_unsuitable_reasons
            @medical_review.update(qa_by: current_user.id,qa_decision_at: Time.now)
            @transaction.update(medical_status: "CERTIFIED", medical_result: medical_review_qa_params[:qa_decision], medical_quarantine_release_date: Time.now)
        end
            flash[:notice] = "Review QA decision for Worker #{ @transaction.fw_code } has been transmitted"
            redirect_to internal_transactions_path(review_status: "medical_pr_qa", cookied_path: "y")
    end

    def mle_review_1
        redirect_to internal_transactions_path(review_status: "pending_review_and_review_approval", cookied_path: "y") and return unless @transaction.can_work_on_medical_review(current_user)
        @medical_exam           = @transaction.medical_examination

        @medical_exam.save_examination_details_and_comments(
            regular_fields: de_attributes__certification_conditions,
            comments:       de_attributes_comments
        )

        @medical_exam.result    = MedicalExamination.find(@medical_exam.id).result_of_exam ? "ABNORMAL" : "NORMAL"
        @medical_review.assign_attributes(medical_review_params)
        seed_unsuitable_reasons

        # Create associated TcupiTodo only if TCUPI. Otherwise destroy all associated TransactionTcupiTodo.
            if medical_review_params[:medical_mle1_decision] == "TCUPI"
                tcupi_to_do_ids     = params[:tcupi_to_dos].to_unsafe_h.select {|to_do, value| value == "YES"}.map(&:first).map(&:to_i)
                tcupi_to_do_ids     << 7 if params[:tcupi_todo_other_bool] == "YES" # Check if Others is "YES"

                # Delete unselected transaction_tcupi_todos.
                @medical_review.transaction_tcupi_todos.where.not(tcupi_todo_id: tcupi_to_do_ids).destroy_all

                # Create transaction_tcupi_todos.
                tcupi_to_do_ids.each do |to_do_id|
                    description     = to_do_id == 7 && params[:tcupi_to_do_other].present? ? params[:tcupi_to_do_other].strip : nil
                    tran_tcupi_todo = @medical_review.transaction_tcupi_todos.find_or_initialize_by(tcupi_todo_id: to_do_id)
                    tran_tcupi_todo.update(description_other: description)
                end
            else
                @medical_review.transaction_tcupi_todos.destroy_all
            end

        @medical_exam.update(transmitted_at: Time.now)
        @medical_review.update(medical_mle1_id: current_user.id, medical_mle1_decision_at: Time.now)

        if medical_review_params[:medical_mle1_decision] == "TCUPI"

            @transaction.update(medical_status: "TCUPI", medical_tcupi: true, tcupi_date: Time.now)
            @transaction.tcupi_reviews.create
            latest_tcupi    = @transaction.reload.latest_tcupi_review

            @medical_review.transaction_tcupi_todos.order(:tcupi_todo_id).each do |tran_tcupi_todo|
                latest_tcupi.transaction_tcupi_todos.find_or_create_by(tcupi_todo_id: tran_tcupi_todo.tcupi_todo_id, description_other: tran_tcupi_todo.description_other)
            end

            tcupi_todo_ids  = latest_tcupi.transaction_tcupi_todos.pluck(:tcupi_todo_id)
            TcupiLetter.find_or_create_by(transaction_id: @transaction.id, letter_type: "audit") if tcupi_todo_ids.include?(6)
            TcupiLetter.find_or_create_by(transaction_id: @transaction.id, letter_type: "nonaudit") if (tcupi_todo_ids - [6]).present?
            MedicalOriginalCondition.new_tcupi_seed(@transaction)

        else
            infectious_conditions       = Condition.where(code: ["3501", "3502", "3503", "3504", "3505", "3506"]).pluck(:id)
            communicable_diseases_check = @medical_exam.medical_examination_details.where(condition_id: infectious_conditions).exists?
            #medical_review_iqa
            #checking iqa
            qa_total = SystemConfiguration.get("MEDICAL_PR_IQA").to_i
            qa_next_sequence = MedicalReview.next_qa_sequence

            if qa_next_sequence % qa_total == 0
                @medical_review.update(is_qa: true)
                @transaction.update(medical_status: "PENDING_PR_QA", communicable_diseases: communicable_diseases_check)
            else
                @transaction.update(medical_status: "CERTIFIED", communicable_diseases: communicable_diseases_check, medical_result: @medical_review.medical_mle1_decision, medical_quarantine_release_date: Time.now)
            end
        end

        flash[:notice] = "Pending review case for Worker #{ @transaction.fw_code } has been transmitted"
        redirect_to internal_transactions_path(review_status: "pending_review_and_review_approval", cookied_path: "y")
    end

    def mle_review_2
        redirect_to internal_transactions_path(review_status: "pending_review_and_review_approval", cookied_path: "y") and return unless @transaction.can_work_on_medical_review_approval(current_user)
        @medical_review.assign_attributes(medical_review_approval_params)

        case medical_review_approval_params[:medical_mle2_decision]
        when "REJECT"
            doc_exam        = @transaction.doctor_examination
            med_exam        = @transaction.medical_examination

            # Defaults the values to be the same as doctor_examinations.
            condition_ids   = Condition.where(code: DoctorExamination::CERTIFICATION.values).pluck(:id)
            doctor_details  = doc_exam.doctor_examination_details.where(condition_id: condition_ids).pluck(:condition_id)
            medical_details = med_exam.medical_examination_details.with_deleted.where(condition_id: condition_ids)
            medical_details.where(condition_id: doctor_details).update(deleted_at: nil)
            medical_details.where.not(condition_id: doctor_details).destroy_all
            comment_id      = Condition.find_by(code: "5501").id # certification_comment
            doctor_comment  = doc_exam.doctor_examination_comments.find_by(condition_id: comment_id)&.comment
            medical_comment = med_exam.medical_examination_comments.with_deleted.find_by(condition_id: comment_id)

            if medical_comment&.comment.present? && doctor_comment.blank?
                medical_comment.destroy
            elsif doctor_comment.present?
                medical_comment ||= MedicalExaminationComment.new(transaction_id: @transaction.id, condition_id: comment_id, medical_examination_id: med_exam.id)
                medical_comment.update(comment: doctor_comment, deleted_at: nil)
            end

            @transaction.update(medical_status: "REVIEW")
            @transaction.medical_reviews.create
            flash[:review_rejected] = "Pending Review case for Worker #{ @transaction.fw_code } has been successfully rejected"
        when "APPROVE"
            if @medical_review.medical_mle1_decision == "TCUPI"
                @transaction.update(medical_status: "TCUPI", medical_tcupi: true, tcupi_date: Time.now)
                @transaction.tcupi_reviews.create
                latest_tcupi    = @transaction.reload.latest_tcupi_review

                @medical_review.transaction_tcupi_todos.order(:tcupi_todo_id).each do |tran_tcupi_todo|
                    latest_tcupi.transaction_tcupi_todos.find_or_create_by(tcupi_todo_id: tran_tcupi_todo.tcupi_todo_id, description_other: tran_tcupi_todo.description_other)
                end

                tcupi_todo_ids  = latest_tcupi.transaction_tcupi_todos.pluck(:tcupi_todo_id)
                TcupiLetter.find_or_create_by(transaction_id: @transaction.id, letter_type: "audit") if tcupi_todo_ids.include?(6)
                TcupiLetter.find_or_create_by(transaction_id: @transaction.id, letter_type: "nonaudit") if (tcupi_todo_ids - [6]).present?
                MedicalOriginalCondition.new_tcupi_seed(@transaction)
            else
                @transaction.update(medical_status: "CERTIFIED", medical_result: @medical_review.medical_mle1_decision, medical_quarantine_release_date: Time.now)
            end

            flash[:notice] = "Pending review case for Worker #{ @transaction.fw_code } has been approved"
        end

        @medical_review.update(medical_mle2_decision_at: Time.now, medical_mle2_id: current_user.id)
        redirect_to internal_transactions_path(review_status: "pending_review_and_review_approval", cookied_path: "y")
    end

    def tcupi_review
        @submit_path        = tcupi_review_1_internal_medical_path(@transaction)
        @doctor             = false

        if @tcupi_review.blank?
            @transaction.tcupi_reviews.create
            @tcupi_review   = @transaction.reload.latest_tcupi_review
            @medical_review = @transaction.latest_medical_review

            @medical_review.transaction_tcupi_todos.order(:tcupi_todo_id).each do |tran_tcupi_todo|
                @tcupi_review.transaction_tcupi_todos.find_or_create_by(tcupi_todo_id: tran_tcupi_todo.tcupi_todo_id, description_other: tran_tcupi_todo.description_other)
            end

            tcupi_todo_ids  = @tcupi_review.transaction_tcupi_todos.pluck(:tcupi_todo_id)
            TcupiLetter.find_or_create_by(transaction_id: @transaction.id, letter_type: "audit") if tcupi_todo_ids.include?(6)
            TcupiLetter.find_or_create_by(transaction_id: @transaction.id, letter_type: "nonaudit") if (tcupi_todo_ids - [6]).present?
            @tcupi_review.reload
        end
    end

    def tcupi_review_1
        @medical_exam       = @transaction.medical_examination
        test_done           = params[:tcupi_test_done].to_unsafe_h
        dates               = params[:tcupi_date].to_unsafe_h
        comments            = params[:tcupi_comment].to_unsafe_h

        @medical_exam.save_examination_details_and_comments(
            regular_fields: de_attributes__certification_conditions,
            comments:       de_attributes_comments
        )

        @tcupi_review.assign_attributes(tcupi_review_params)
        seed_unsuitable_reasons

        @tcupi_review.transaction_tcupi_todos.each do |transaction_tcupi_todo|
            id              = transaction_tcupi_todo.id.to_s
            build_params    = { done: test_done[id], completed_date: dates[id], comment: comments[id] }
            transaction_tcupi_todo.update(build_params)
        end

        if params[:commit] == "Transmit"
            @tcupi_review.update(medical_mle1_id: current_user.id, medical_mle1_decision_at: Time.now)
            @transaction.update(medical_status: "TCUPI_PENDING_APPROVAL")
            flash[:notice] = "TCUPI case for Worker #{ @transaction.fw_code } has been transmitted"
            redirect_to internal_transactions_path(review_status: "tcupi", field_set: "tcupi")
        else
            @tcupi_review.save
            redirect_to tcupi_review_internal_medical_path(@transaction, p_tab: params[:p_tab], tab: params[:tab])
        end
    end

    def tcupi_review_approval
        @can_review = @tcupi_review.medical_mle1_id != current_user.id
    end

    def tcupi_review_2
        @tcupi_review.assign_attributes(medical_mle2_id: current_user.id, medical_mle2_decision_at: Time.now)
        @tcupi_review.update(tcupi_review_approval_params)
        seed_unsuitable_reasons

        case @tcupi_review.medical_mle2_decision
        when "REJECT"
            tcupi_todos     = @tcupi_review.transaction_tcupi_todos.order(:tcupi_todo_id)
            @transaction.tcupi_reviews.create
            latest_tcupi    = @transaction.reload.latest_tcupi_review

            tcupi_todos.each do |tran_tcupi_todo|
                latest_tcupi.transaction_tcupi_todos.find_or_create_by(tcupi_todo_id: tran_tcupi_todo.tcupi_todo_id, description_other: tran_tcupi_todo.description_other)
            end

            @transaction.update(medical_status: "TCUPI")
            MedicalOriginalCondition.reset_medical_conditions(@transaction)
            flash[:review_rejected] = "TCUPI case for Worker #{ @transaction.fw_code } has been successfully rejected"
        when "APPROVE"
            @transaction.update(medical_status: "CERTIFIED", medical_result: @tcupi_review.medical_mle1_decision, medical_quarantine_release_date: Time.now)
            flash[:notice] = "TCUPI case for Worker #{ @transaction.fw_code } has been approved"
        end

        redirect_to internal_transactions_path(review_status: "tcupi_approval", field_set: "tcupi")
    end
private
    def set_transaction
        @transaction        = Transaction.find(params[:id])
    end

    def set_medical_review
        @medical_review     = @transaction.latest_medical_review
        @skip_visited       = true
    end

    def set_tcupi_review
        @tcupi_review       = @transaction.latest_tcupi_review

        case action_name
        when "tcupi_review", "tcupi_review_1"
            redirect_to internal_transactions_path(review_status: "tcupi", field_set: "tcupi") and return unless @transaction.can_work_on_tcupi_review(current_user)
        when "tcupi_review_approval", "tcupi_review_2"
            redirect_to internal_transactions_path(review_status: "tcupi_approval", field_set: "tcupi") and return unless @transaction.can_work_on_tcupi_review_approval(current_user)
        end
    end

    def set_previous_transactions_list
        @transactions_list  = Transaction.where(foreign_worker_id: @transaction.foreign_worker_id).where.not(id: @transaction.id).order(transaction_date: :desc)
    end

    def de_attributes__certification_conditions
        params[:de_attributes].slice(:condition_hiv, :condition_tuberculosis, :condition_malaria, :condition_leprosy, :condition_std, :condition_hepatitis, :condition_cancer, :condition_epilepsy, :condition_psychiatric_disorder, :condition_hypertension, :condition_heart_diseases, :condition_bronchial_asthma, :condition_diabetes_mellitus, :condition_peptic_ulcer, :condition_kidney_diseases, :condition_urine_for_pregnant, :condition_urine_for_opiates, :condition_urine_for_cannabis, :condition_other).to_unsafe_h
    end

    def de_attributes_comments
        params[:de_attributes].slice(:certification_comment, :unsuitable_comment).to_unsafe_h
    end

    def medical_review_params
        params.require(:transaction).permit(latest_medical_review_attributes: [:medical_mle1_decision, :medical_mle1_comment])[:latest_medical_review_attributes]
    end

    def medical_review_approval_params
        params.require(:transaction).permit(latest_medical_review_attributes: [:medical_mle2_decision, :medical_mle2_comment])[:latest_medical_review_attributes]
    end

    def medical_review_qa_params
        params.require(:transaction).permit(latest_medical_review_attributes: [:qa_decision, :qa_status, :qa_comment])[:latest_medical_review_attributes]
    end

    def tcupi_review_params
        params.require(:transaction).permit(latest_tcupi_review_attributes: [:medical_mle1_decision, :medical_mle1_comment])[:latest_tcupi_review_attributes]
    end

    def tcupi_review_approval_params
        params.require(:transaction).permit(latest_tcupi_review_attributes: [:medical_mle2_decision, :medical_mle2_comment])[:latest_tcupi_review_attributes]
    end

    def seed_unsuitable_reasons
        # Seed Unsuitable Reasons
        reason_ids          = params[:unsuitable_reason_ids] || []
        @transaction.transaction_unsuitable_reasons.where.not(unsuitable_reason_id: reason_ids).destroy_all

        reason_ids.each do |reason_id|
            reason                      = TransactionUnsuitableReason.with_deleted.find_or_initialize_by(transaction_id: @transaction.id, unsuitable_reason_id: reason_id)
            reason.created_by_system    ||= false
            reason.update(deleted_at: nil)
        end
    end
end