module Transaction::MedicalProcesses
    def can_work_on_medical_review_as_doctor(user)
        medical_tcupi? && medical_status == "TCUPI" && user.userable_type == "Doctor" && doctor_id == user.userable_id
    end

    def can_work_on_medical_review(user)
        @review = latest_medical_review
        ["NEW", "REVIEW"].include?(medical_status) && (@review.blank? || @review.medical_mle1_id.blank? || @review.medical_mle1_id == user.id)
    end

    def can_work_on_medical_review_approval(user)
        @review = latest_medical_review
        ["PENDING_APPROVAL"].include?(medical_status) && @review.present? && @review.medical_mle1_id != user.id && (@review.medical_mle2_id.blank? || @review.medical_mle2_id == user.id)
    end

    def can_work_on_medical_review_qa(user)
        @review = latest_medical_review
        ["PENDING_PR_QA"].include?(medical_status) && @review.present? && @review.medical_mle1_id != user.id
    end

    def can_view_medical_review_history
        @review = latest_medical_review
        @review.present? && @review.medical_mle1_decision_at
    end

    def can_work_on_tcupi_review(user)
        medical_tcupi? && medical_status == "TCUPI"
    end

    def can_work_on_tcupi_review_approval(user)
        @review = latest_tcupi_review
        medical_tcupi? && medical_status == "TCUPI_PENDING_APPROVAL" && @review.present?
    end

    def can_view_tcupi?
        @review = latest_tcupi_review
        medical_tcupi? && @review.present? && @review.medical_mle1_decision? && @review.medical_mle2_decision?
    end

    def check_for_communicable_diseases(communicable_diseases_conditions = [])
        if ["REVIEW", "CERTIFIED"].include?(status)
            med_exam    = medical_examination || doctor_examination

            conditions  =
                if med_exam.class.to_s == "MedicalExamination"
                    med_exam.medical_examination_details.pluck(:condition_id)
                elsif doctor_examination.class.to_s == "DoctorExamination"
                    med_exam.doctor_examination_details.pluck(:condition_id)
                end

            communicable_diseases_conditions = Condition.where(code: ["3501", "3502", "3503", "3504", "3505", "3506"]).pluck(:id) if communicable_diseases_conditions.blank?
            self.update(communicable_diseases: (conditions & communicable_diseases_conditions).present?)
        end
    end
    def medical_review_qa
        @review = latest_medical_review
        ["PENDING_PR_QA"].include?(medical_status) && (@review.blank? || @review.qa_decision.blank? || @review.qa_by.blank?)
    end

    def is_qa
        @review = latest_medical_review
        ["PENDING_PR_QA"].include?(medical_status) && (@review.present? && @review.is_qa == true)
    end
private
    def check_certification_status
        if status == "REVIEW" && medical_status == "CERTIFIED" && xray_status == "CERTIFIED"
            # (Start) Check for changes in conditions due to Xray Pending Decision.
                pending_decision    = xray_pending_decisions.where(status: "TRANSMITTED", approval_decision: "APPROVE").order(:id).last

                if pending_decision.present?
                    conditional_yes = [pending_decision.condition_tuberculosis, pending_decision.condition_heart_diseases, pending_decision.condition_other]

                    if conditional_yes.include?("YES")
                        # reload # Need to reload to query medical_examination
                        check_medical_exam = medical_examination

                        if check_medical_exam.blank?
                            check_medical_exam = create_medical_examination(self)
                        end

                        check_medical_exam = update_xray_review_conditions(
                            {
                                condition_tuberculosis:     pending_decision.condition_tuberculosis == "YES",
                                condition_heart_diseases:   pending_decision.condition_heart_diseases == "YES",
                                condition_other:            pending_decision.condition_other == "YES"
                            },
                            check_medical_exam
                        )

                        # This method here is the same as check_for_communicable_diseases. Except to prevent infinite loops, it needs to be done differently.
                        conditions  = check_medical_exam.medical_examination_details.pluck(:condition_id)
                        communicable_diseases_conditions = Condition.where(code: ["3501", "3502", "3503", "3504", "3505", "3506"]).pluck(:id)
                        self.communicable_diseases = (conditions & communicable_diseases_conditions).present?
                    end
                end
            # (End)

            self.status = "CERTIFIED"
            self.final_result = xray_result == "SUITABLE" && medical_result == "SUITABLE" ? "SUITABLE" : "UNSUITABLE"
        end
    end

    def check_final_result
        has_final_result_date = final_result_date?
        self.final_result_date = final_result? ? Time.now : nil

        # If Suitable, set all unsuitable reasons back to nil.
        if final_result == "SUITABLE"
            transaction_unsuitable_reasons.destroy_all
        elsif final_result == "UNSUITABLE" && !is_imm_blocked
            QueuedUnsuitableSlip.create(transaction_id: id)
        end

        # Do not send if physical_exam_not_done, but send if there are amendments. Do not need to check for approval, because this callback only occurs after final result changes.
        if !physical_exam_not_done? || transaction_amendments.present?
            MyimmsGateway.call(id.to_s, nil, final_result)
        end

        # Only captures moh notification the first time it has final result. Not affected by final amendment or appeals.
        if !has_final_result_date && final_result == "UNSUITABLE"
            notification_check  = MohNotificationCheck.find_or_initialize_by(transaction_id: id)
            notification_check.update(final_result: final_result, final_result_date: final_result_date) unless notification_check.id? # Do not save more than once.
        end

        # Only captures amended communicable disease the first time it has final result. Final amendment or result update will be checked upon condition_amended_at updated.
        if !has_final_result_date && final_result == "UNSUITABLE"
            check_amended_communicable_disease
        end
    end

    def check_amended_communicable_disease
        communicable_diseases_list = Condition.where(code: ["3501", "3502", "3503", "3504", "3505", "3506"]).pluck(:id)
        xray_communicable_diseases_list = Condition.where(code: ["3502"]).pluck(:id)

        # For transaction in pending review or pending decision need to get the latest medical_examination
        # Do not use reload here as xray_status will not updated correctly.
        t = Transaction.find(id)
        med_detail = t.medical_examination&.medical_examination_details&.pluck(:condition_id)
        doc_detail = t.doctor_examination&.doctor_examination_details&.pluck(:condition_id)

        # Get all conditions amended by fomema
        amended_conditions = []
        amended_conditions = med_detail - doc_detail unless med_detail.blank?

        amended_conditions.each do |amended_condition|

            disease = AmendedNotifiableTransaction.communicable_diseases[Condition.find(amended_condition).code]

            if communicable_diseases_list.include?(amended_condition)
                amended = AmendedNotifiableTransaction.find_or_create_by(
                    transaction_id: id,
                    condition_id: amended_condition,
                    notifiable_id: doctor_id,
                    notifiable_type: 'Doctor',
                    disease: disease,
                )
            end
            # Notify xray facility if it is tuberculosis
            if xray_communicable_diseases_list.include?(amended_condition)
                    amended = AmendedNotifiableTransaction.find_or_create_by(
                        transaction_id: id,
                        condition_id: amended_condition,
                        notifiable_id: xray_facility_id,
                        notifiable_type: 'XrayFacility',
                        disease: disease,
                    )
            end
        end
    end
end