module MertsExaminations
    include MedicalExaminationInitializer
    include DoctorAndMedicalExaminationConstants
    include WorkerBlocking

    def medical_examination
        @worker = @transaction.foreign_worker
        @past_exams = @worker.transactions.where.not(id: @transaction.try(:id)).where("status ='CERTIFIED'").order(transaction_date: :desc)
        flash[:errors] ||= []

        if @transaction.expired_merts?
            flash[:expired] = true
            redirect_to external_transactions_path and return
        end

        if @worker.previous_transaction_gender_different? or (@worker.has_pending_gender_amendment_approval? and @transaction.medical_examination_date.present?) or (@worker.gender != @transaction.fw_gender)
            flash[:errors] << "#{@worker.name} (#{@worker.passport_number}) is blocked in the systems due to wrong gender. Transmission of result is not allowed."
            redirect_to external_transactions_path and return
        elsif (@worker.has_pending_gender_amendment_order? or @worker.has_pending_gender_amendment_approval?) and !@transaction.medical_examination_date.present?
            flash[:errors] << "#{@worker.name} (#{@worker.passport_number}) is blocked in the systems due to wrong gender and currently in the process change of gender. You may access the worker again after 3 working days."
            redirect_to external_transactions_path and return
        end

        case current_user.userable_type
        when "Doctor"
            redirect_to examination_history_external_transaction_path(@transaction) and return if  @transaction.doctor_transmit_date?

            if @transaction.expired_merts?
                flash[:expired] = true
                redirect_to external_transactions_path and return
            end

            case @transaction.status
            when "EXAMINATION", "CERTIFICATION"
                begin
                    doc_exam = DoctorExamination.find_or_initialize_by(transaction_id: @transaction.id)
                    doc_exam.doctor_id = current_user.userable_id
                    doc_exam.save unless doc_exam.id?
                rescue ActiveRecord::RecordNotUnique # This is to prevent double save from happening.
                    if [0, 1, 2, 3].include?(params[:try].to_i)
                        try = params[:try].to_i
                        try += 1
                        redirect_to medical_examination_external_transactions_path(@transaction, try: try) and return
                    else
                        raise ActiveRecord::RecordNotUnique
                    end
                end
            end

            case @transaction.status
            when "NEW" # Only Doctors can see new examination screen
                # do not set default date for medical examination
                # @transaction.medical_examination_date = Time.now if @transaction.medical_examination_date.nil?
                render :new_medical_examination and return
            when "EXAMINATION"
                @transaction.build_doctor_examination unless @transaction.doctor_examination
                render :doctor_examination and return
            when "CERTIFICATION"
                @transaction.build_doctor_examination unless @transaction.doctor_examination
                render :certification and return
            end
        when "Laboratory"
            if @transaction.status != "NEW"
                begin
                    lab_exam = LaboratoryExamination.find_or_initialize_by(transaction_id: @transaction.id)
                    lab_exam.laboratory_id = current_user.userable_id
                    lab_exam.save unless lab_exam.id?
                rescue ActiveRecord::RecordNotUnique # This is to prevent double save from happening.
                    if [0, 1, 2, 3].include?(params[:try].to_i)
                        try = params[:try].to_i
                        try += 1
                        redirect_to medical_examination_external_transactions_path(@transaction, try: try) and return
                    else
                        raise ActiveRecord::RecordNotUnique
                    end
                end

                render "laboratory_examination#{ "_readonly" if @transaction.laboratory_examination.transmitted_at? }" and return
            end
        when "XrayFacility", "Radiologist"
            if @transaction.status != "NEW"
                check_retry = xray_examination_instances(:transactions)
                redirect_to check_retry[:url] if check_retry.class == Hash && check_retry[:error] == :xray_exam_page_retry
                return
            end
        end

        render :invalid, locals: { error: "Invalid screen" } and return
    end

    def medical_examination_update
        if @transaction.expired_merts?
            flash[:expired] = true
            redirect_to external_transactions_path and return
        end

        @transaction.transaction do
            @current_time = Time.now

            case current_user.userable_type
            when "Doctor"
                medical_examination_update_doctor
                return if @skip_redirect

                if @transaction.status == "REVIEW" && params[:commit_type] == "certification transmit"
                    flash[:transaction_index__completed]        = true
                    flash[:transaction_index__foreign_worker]   = @transaction.fw_code
                    flash[:transaction_index__review_pool]      = TransactionQuarantineReason.where(transaction_id: @transaction.id).count > 0
                    redirect_to external_transactions_path and return
                end
            when "Laboratory"
                medical_examination_update_laboratory
            when "XrayFacility", "Radiologist"
                medical_examination_update_xray_facility and return
            end

            if params[:commit] == "Save and Transmit" && ["Laboratory", "XrayFacility"].include?(current_user.userable_type)
                flash[:sp_completed]        = current_user.userable_type
                flash[:sp_completed_worker] = @transaction.fw_code
            end

            redirect_to medical_examination_external_transactions_path(@transaction, p_tab: params[:p_tab], tab: params[:tab])
        end
        # /db-transaction
    end

    def medical_examination_update_doctor
        exam_date                               = params[:transaction][:medical_examination_date] if params[:transaction].present?
        @doctor_exam                            = @transaction.doctor_examination

        begin
            @transaction.medical_examination_date = Date.parse(exam_date) if exam_date.present?

            # additional server side validation in case javascript not working at client side
            if @transaction.medical_examination_date.beginning_of_day < @transaction.transaction_date.beginning_of_day || @transaction.medical_examination_date.beginning_of_day > Time.now
                flash[:errors] ||= []
                flash[:errors] << "Medical exam date cannot be earlier than transaction date or later than current date."
                return
            elsif !@transaction.laboratory_transmit_date.blank? && @transaction.medical_examination_date.beginning_of_day > @transaction.laboratory_transmit_date&.beginning_of_day
                flash[:errors] ||= []
                flash[:errors] << "Medical exam date cannot be later than laboratory transmit date."
                return
            elsif !@transaction.xray_transmit_date.blank? && @transaction.medical_examination_date.beginning_of_day > @transaction.xray_transmit_date&.beginning_of_day
                flash[:errors] ||= []
                flash[:errors] << "Medical exam date cannot be later than xray submit date."
                return
            end
        rescue
            flash[:errors] ||= []
            flash[:errors] << "This date is invalid: #{ exam_date }, please input date following this format day/month/year."
            flash[:errors] << "Please note that there should be a calendar function for selecting dates. Please contact FOMEMA for assistance."
        end

        case @transaction.status
        when "NEW"
            @transaction.assign_attributes(transaction_new_params)

            if @transaction.medical_examination_date.present? && @transaction.worker_matched && @transaction.worker_consented && @transaction.worker_identity_confirmed
                @transaction.status = "EXAMINATION"
            else
                flash[:errors] ||= []
                flash[:errors] << "Medical exam date needed to continue" unless @transaction.medical_examination_date.present?
                flash[:errors] << "Worker must match to continue" unless @transaction.worker_matched
                flash[:errors] << "Worker must consent to continue" unless @transaction.worker_consented
                flash[:errors] << "Worker identity must be confirmed to continue" unless @transaction.worker_identity_confirmed
            end

            @transaction.transmission_expired_at = @transaction.medical_examination_date.present? ? (@transaction.medical_examination_date + SystemConfiguration.get("MERTS_TRANSMISSION_EXPIRY_DAYS").to_i.days) : nil

            # for skipping fingerprint verification
            @transaction.doctor_fp_result   = 2 if @transaction.doctor_fp_result.nil?

            # This is a special case, incase the medical exam date is accidentally removed, it will not move back to certification even if lab/xray are both done.
            @transaction.status             = "CERTIFICATION" if @transaction.status == "EXAMINATION" && @transaction.laboratory_transmit_date? && @transaction.xray_transmit_date?
            @transaction.save
        when "EXAMINATION"
            pp "Error: Doctor Examination Params is blank. Trying to submit transaction_new_params again, but already in EXAMINATION" and return if params[:de_attributes].blank?
            @transaction.save
            @doctor_exam.assign_attributes(doctor_examination_params)
            @doctor_exam.save

            @doctor_exam.save_examination_details_and_comments(
                date_fields:    de_attributes__history,
                regular_fields: [de_attributes__physical, de_attributes__system_1, de_attributes__system_2].inject(&:merge),
                value_fields:   de_attributes__values,
                comments:       de_attributes_comments
            )

            @doctor_exam.save_visited_values(de_visited_columns)
        when "CERTIFICATION"
            @doctor_exam.assign_attributes(doctor_examination_params)

            @doctor_exam.save_examination_details_and_comments(
                date_fields:    de_attributes__history.merge(de_attributes__follow_up),
                regular_fields: [de_attributes__physical, de_attributes__system_1, de_attributes__system_2, de_attributes__certification_conditions].inject(&:merge),
                value_fields:   de_attributes__values,
                comments:       de_attributes_comments
            )

            if params[:process_type] == "checking"
                review_pool_check   = @transaction.checking_for_quarantine_items
                xqcc_review_check   = @transaction.checking_for_xqcc_quarantine_items
                both_criteria       = (review_pool_check + xqcc_review_check).uniq

                render json: {
                    flagged: both_criteria.present?,
                    flagged_criteria: both_criteria.map {|criterion| "<li>#{ criterion }</li>"}.join(),
                    doctor_examination_id: @transaction.doctor_examination.id
                }

                @skip_redirect = true
            elsif params[:commit_type] == "certification transmit" && @transaction.doctor_examination.suitability.present?
                # Need to manually reload. Also, please do not use reload on @doctor_exam here, it will remove the changed params from the assign_attributes step.
                @doctor_exam.result         = DoctorExamination.find(@doctor_exam.id).result_of_exam ? "ABNORMAL" : "NORMAL"
                @doctor_exam.update(transmitted_at: @current_time)

                # condition_hiv, condition_tuberculosis, condition_malaria, condition_leprosy, condition_std, condition_hepatitis
                infectious_conditions       = Condition.where(code: ["3501", "3502", "3503", "3504", "3505", "3506"]).pluck(:id)
                communicable_diseases_check = @doctor_exam.doctor_examination_details.where(condition_id: infectious_conditions).exists?
                med_ind_count               = @transaction.med_ind_count ? @transaction.med_ind_count + 1 : 1
                @transaction.update(status: "REVIEW", certification_date: @current_time, doctor_transmit_date: @current_time, med_ind_count: med_ind_count, communicable_diseases: communicable_diseases_check)
                foreign_worker              = @transaction.foreign_worker
                fw_med_ind_count            = foreign_worker.med_ind_count ? foreign_worker.med_ind_count + 1 : 1
                foreign_worker.update(med_ind_count: fw_med_ind_count)
                @transaction.seed_unsuitable_reasons
                @transaction.seed_quarantine_items
                @transaction.seed_xqcc_quarantine_items


                if @transaction.reload.transaction_quarantine_reasons.count > 0
                    @transaction.update(medical_status: "NEW", medical_pr_source: "MERTS")

                    # medical pending review auto release
                    if can_medical_review_autorelease?
                            submit_medical_review_autorelease
                    end

                    process_abo_discrepancy
                else
                    # If doctor certified suitable with xray abnormal,PCR confirmed abnormal and transaction not in pending decision,
                    # add transaction to pending decision for MLE to tick condition & unsuitable reason
                    # This must be done before medical_result updated to avoid final result released
                    if @doctor_exam.suitability == "SUITABLE" && @transaction.xray_examination.result == "ABNORMAL" && @transaction.xray_status == "CERTIFIED" && @transaction.xray_result == "UNSUITABLE" && !@transaction.xray_pending_decision.present?
                        pending_decision_data = @transaction.copy_doctor_medical_examination
                        .merge({
                            transaction_id: @transaction.id,
                            status: "XQCC_PENDING_DECISION",
                            sourceable: @doctor_exam
                        })
                        xray_pending_decision = XrayPendingDecision.create(pending_decision_data)
                        @transaction.update(xray_status: 'XQCC_PENDING_DECISION', xray_result: nil, xray_pending_decision_id: xray_pending_decision.id)
                    end

                    condition_tb = Condition.where(code: ["3502"]).pluck(:id)
                    condition_follow_up = Condition.where(code: ["5001", "5002", "5003", "5004", "5005"]).pluck(:id)
                    count_condition = @doctor_exam.doctor_examination_details.where.not(condition_id: condition_follow_up).count
                    condition_not_follow_up = @doctor_exam.doctor_examination_details.where.not(condition_id: condition_follow_up)
                    medical_history         = DoctorExamination.find(@doctor_exam.id).check_medical_history ? "NO" : "YES"

                    if @transaction.xray_status == "CERTIFIED" && @transaction.xray_pending_decision&.decision == "SUITABLE" && @transaction.doctor_examination&.suitability == "UNSUITABLE" && @transaction.latest_medical_review.blank?
                        # THIRD CONCURRENCE for transaction with final xray result before doctor certification.
                        # If the transaction did not have a medical review (pr/tcupi) but pending decision certifies as SUITABLE, then add a medical PR to the transaction.
                        if count_condition == 1 && @doctor_exam.result == "NORMAL" && !has_other_abnormality? && @transaction.laboratory_examination&.result == "NORMAL" && @doctor_exam.doctor_examination_details.where(condition_id: condition_tb).exists?
                            # If condition only one and condition = TB ,doctor normal,lab normal and dont have other abnormality.
                            @transaction.update(medical_status: "CERTIFIED", medical_result: "SUITABLE")
                        elsif @transaction.laboratory_examination&.result == "NORMAL" && @doctor_exam.result == "ABNORMAL" && medical_history == "YES" && !has_other_abnormality?
                            #if lab normal,dont have other abnormality,doctor abnormal because doctor tick yes medical history exclude TB, LEPROSY, PSYCHIATRIC ILLNESS, EPILEPSY & CANCER
                            @transaction.update(medical_status: "CERTIFIED", medical_result: "SUITABLE")
                        elsif @doctor_exam.result == "NORMAL" && @transaction.laboratory_examination&.result == "NORMAL" && !has_other_abnormality? && condition_not_follow_up.exists?
                            # If more than one condition or other condition doctor normal,lab normal and dont have other abnormality.
                            @transaction.update(medical_status: "NEW", medical_pr_source: "XQCC", status: "REVIEW")
                            quarantine_reason = QuarantineReason.find_by(code: "10013")
                            TransactionQuarantineReason.find_or_create_by(transaction_id: @transaction.id, quarantine_reason_id: quarantine_reason.id)
                        else
                            @transaction.update(medical_status: "CERTIFIED", medical_result: @transaction.doctor_examination.suitability)
                        end
                    else
                        @transaction.update(medical_status: "CERTIFIED", medical_result: @transaction.doctor_examination.suitability)
                    end
                end

                # previous_transaction    = @transaction.foreign_worker.transactions.where.not(id: @transaction.id).order(updated_at: :desc).first
                previous_transaction    = @transaction.previous_transaction
                previous_transaction_remedical = @transaction.previous_transaction_remedical
                new_result_suitable     = @doctor_exam.suitability == "SUITABLE"
                xray_exam_unsuitable    = @transaction.xray_examination.result == "ABNORMAL"
                xray_exam_not_done      = @transaction.xray_examination.xray_examination_not_done == "YES"

                xray_pending_review_data = {
                    transaction_id: @transaction.id,
                    quarantine_type: nil,
                    quarantine_reason: nil,
                    source: 'MERTS',
                    status: 'XQCC_PENDING_REVIEW',
                }

                if previous_transaction_remedical&.is_next_transaction_re_medical == true
                    unblock_reason = BlockReason.find_by(code: "VERIFICATIONDONE", category: "UNBLOCK")
                    unblock_comment = "VERIFICATION DONE BY OPERATION TEAM."
                    unblock_imm(foreign_worker, unblock_reason, unblock_comment)
                end

                # if previous_transaction&.ignore_renewal_rule == true && @transaction.medical_examination_date.to_date > @transaction.transaction_date.to_date
                #     block_reason = BlockReason.find_by(code: "SUSPECTFRAUD", category: "BLOCK")
                #     block_comment = "Suspected fraud case. Re-medical wasn't carry out on the same day of registration. Kindly refer Operation Dept"
                #     block_imm(foreign_worker, block_reason, block_comment)
                # end

                # Please do not delete this!! It is hard to understand the conditionals below without this.
                # 1. XQCC Review -> Xray Results is Normal
                # 2. PCR Review -> GP Result is Unsuitable & Xray Results is Abnormal
                # 3. Pending Review -> GP Result is Suitable & either i) ii) or iii)
                # i) Xray Results is Abnormal
                # ii) Previous transaction GP Results is Unsuitable
                # iii) Either previous transaction Xray Pending Decision is Unsuitable OR previous transaction PCR Review is Abnormal
                # 4. Pending Review -> GP Result is Unsuitable & Xray is Abnormal & (Either previous transaction Xray Pending Decision is Unsuitable OR previous transaction PCR Review is Abnormal)

                # Please do not delete this!! New flow for x-ray screening year 2022
                # 1. To move the screening process after x-ray result transmitted
                # 2. For monitoring transactions, remain the screening process after certification

                # analog process, will not send to pending review.
                # Do not send to review on nios side if xray_examination_not_done == "YES" and result is UNSUITABLE.
                if @transaction.xray_film_type == 'ANALOG' || (!new_result_suitable && xray_exam_not_done)
                    @transaction.update(xray_status: 'CERTIFIED', xray_result: @doctor_exam.suitability)

                # digital process
                else
                    if @transaction.foreign_worker.monitoring.eql?("Y")
                        xray_pending_review_data[:quarantine_type] = 'M'
                    else
                        if @transaction.xray_transmit_date <= Time.parse(SystemConfiguration.get('XRAY_NEW_FLOW_START_DATE'))
                            # existing flow
                            # Doctor certifies => SUITABLE
                            if new_result_suitable
                                # Doctor certifies => SUITABLE & Previous PCR Review => UNSUITABLE
                                # Doctor certifies => SUITABLE & Previous Medical Review Result => UNSUITABLE
                                # Doctor certifies => SUITABLE & Previous Final Result => UNSUITABLE
                                if previous_transaction && (previous_transaction&.xray_result == "UNSUITABLE" || previous_transaction&.medical_result == "UNSUITABLE" || previous_transaction&.final_result == "UNSUITABLE")
                                    if previous_transaction.latest_medical_appeal && previous_transaction.latest_medical_appeal.result == "SUCCESSFUL"
                                        if !xray_exam_unsuitable
                                            @transaction.submit_xqcc_case
                                        else
                                            @transaction.submit_pcr_case
                                        end
                                    else
                                        xray_pending_review_data[:quarantine_type] = 'U' # Certified Suitable Previous Xray Unsuitable
                                    end
                                    # @transaction.pending_review_xqcc_unsuitable

                                # Doctor certifies => SUITABLE & Xray results => SUITABLE
                                elsif !xray_exam_unsuitable
                                    @transaction.submit_xqcc_case
                                    # transactions{xray_statys: XQCC_POOL}
                                    # new xqcc_pools{case_type: XRAY_EXAMINATION_NORMAL, status: XQCC_POOL, source: MERTS}

                                # Doctor certifies => SUITABLE & Xray Not Done => YES. This is a unique case, it will be inserted into Xray Pending Review, then auto released into Pending Decision.
                                elsif xray_exam_not_done
                                    xray_pending_review_data.merge!(
                                        quarantine_type: 'Q',
                                        status: "TRANSMITTED",
                                        reviewed_by: current_user.id,
                                        transmitted_at: Time.now,
                                        comment: "AUTO-RELEASE, XRAY NOT DONE BUT DOCTOR CERTIFIED AS SUITABLE",
                                        decision: "MANUAL_AUDIT",
                                        is_audit_comparison: "NO"
                                    )
                                # Doctor certifies => SUITABLE & Xray results => UNSUITABLE
                                elsif xray_exam_unsuitable
                                    xray_pending_review_data[:quarantine_type] = 'Q' # Certified Suitable Xray Unsuitable
                                    # @transaction.pending_review_xray_finding
                                end

                            # Doctor certifies => UNSUITABLE
                            else
                                # Doctor certifies => UNSUITABLE & Previous PCR Review => UNSUITABLE
                                if xray_exam_unsuitable && !previous_transaction.nil? && (previous_transaction&.xray_pending_decision&.decision == "UNSUITABLE" || (previous_transaction&.xray_pending_decision&.decision != "SUITABLE" && previous_transaction&.pcr_review&.result == "ABNORMAL"))
                                    xray_pending_review_data[:quarantine_type] = 'U' # Certified Unsuitable Previous Xray Unsuitable
                                    # @transaction.pending_review_unsuitable_xqcc_unsuitable

                                # Xray results => UNSUITABLE for PCR
                                elsif xray_exam_unsuitable
                                    @transaction.submit_pcr_case
                                    # transactions{xray_status: PCR_POOL}
                                    # pcr_pools{case_type: XRAY_EXAMINATION_ABNORMAL, status: PCR_POOL, source: MERTS}

                                # SUITABLE for XQCC
                                else
                                    @transaction.submit_xqcc_case
                                end
                            end
                            # /existing flow
                        else
                            # new flow
                            # Doctor certifies => SUITABLE
                            if new_result_suitable
                                # Doctor certifies => SUITABLE & Previous PCR Review => UNSUITABLE
                                # Doctor certifies => SUITABLE & Previous Final Result => UNSUITABLE
                                if previous_transaction && (previous_transaction&.xray_result == "UNSUITABLE" || previous_transaction&.final_result == "UNSUITABLE")
                                    if previous_transaction.latest_medical_appeal && previous_transaction.latest_medical_appeal.result == "SUCCESSFUL"
                                        # Do this process during xray transmit
                                    else
                                        xray_pending_review_data[:quarantine_type] = 'U' # Certified Suitable Previous Xray Unsuitable
                                    end

                                # Doctor certifies => SUITABLE & Xray results => SUITABLE
                                elsif !xray_exam_unsuitable
                                    # Do this process during xray transmit

                                # Doctor certifies => SUITABLE & Xray Not Done => YES. This is a unique case, it will be inserted into Xray Pending Review, then auto released into Pending Decision.
                                elsif xray_exam_not_done
                                    xray_pending_review_data.merge!(
                                        quarantine_type: 'Q',
                                        status: "TRANSMITTED",
                                        reviewed_by: current_user.id,
                                        transmitted_at: Time.now,
                                        comment: "AUTO-RELEASE, XRAY NOT DONE BUT DOCTOR CERTIFIED AS SUITABLE",
                                        decision: "MANUAL_AUDIT",
                                        is_audit_comparison: "NO"
                                    )
                                # Doctor certifies => SUITABLE & Xray results => UNSUITABLE
                                elsif xray_exam_unsuitable
                                    # Do this process during xray transmit
                                end

                            # Doctor certifies => UNSUITABLE
                            else
                                # Doctor certifies => UNSUITABLE & Previous X-ray Result => UNSUITABLE
                                # Doctor certifies => UNSUITABLE & Previous Final Result => UNSUITABLE
                                if previous_transaction && (previous_transaction&.xray_result == "UNSUITABLE" || previous_transaction&.final_result == "UNSUITABLE")
                                    if previous_transaction.latest_medical_appeal && previous_transaction.latest_medical_appeal.result == "SUCCESSFUL"
                                        # Do this process during xray transmit
                                    else
                                        xray_pending_review_data[:quarantine_type] = 'U' # Certified Unsuitable Previous Unsuitable / Certified Unsuitable Previous Xray Unsuitable
                                    end
                                # Previous => SUITABLE or No previous transaction
                                else
                                    if !xray_exam_unsuitable
                                        # Do this process during xray transmit
                                    elsif xray_exam_not_done
                                        # Do nothing
                                    elsif xray_exam_unsuitable
                                        # Do this process during xray transmit
                                    end
                                end
                            end
                            # /new flow
                        end
                    end
                end
                # /digital process

                # If result SUITABLE and Xray Not Done is YES, it has a different flow.
                # Will be inserted into Pending Review, then autoreleased into Pending Decision.
                if new_result_suitable && xray_exam_not_done
                    xray_pending_review     = XrayPendingReview.create(xray_pending_review_data.merge!({
                        quarantine_type: "U",
                        status: "TRANSMITTED",
                        decision: "MANUAL_AUDIT",
                        transmitted_at: Time.now
                    }))

                    xray_pending_decision   = XrayPendingDecision.create(
                        transaction_id: xray_pending_review.transaction_id,
                        status:         "XQCC_PENDING_DECISION",
                        sourceable:     xray_pending_review
                    )

                    @transaction.update(
                        xray_pending_review_id:     xray_pending_review.id,
                        xray_pending_decision_id:   xray_pending_decision.id,
                        xray_status:                "XQCC_PENDING_DECISION"
                    )
                elsif xray_pending_review_data[:quarantine_type].present?
                    xray_pending_review = XrayPendingReview.create(xray_pending_review_data)

                    @transaction.update({
                        xray_pending_review_id: xray_pending_review.id,
                        xray_status: 'XQCC_PENDING_REVIEW'
                    })
                end
            # /save and submit

                # Because all transmitted DoctorExaminations will always have true on visited fields, soft delete DoctorExaminationVisited after transmitting results.
                @doctor_exam.remove_visited_record
            else
                @doctor_exam.save_visited_values(de_visited_columns)
                @transaction.save
            end
        end
    end

    def can_medical_review_autorelease?
        previous_transaction        = @transaction.previous_transaction
        previous_blood_group        = [previous_transaction.try(:laboratory_examination).try(:blood_group), previous_transaction.try(:laboratory_examination).try(:blood_group_rhesus)]
        current_blood_group         = [@transaction.laboratory_examination.blood_group, @transaction.laboratory_examination.blood_group_rhesus]

        codes_physical = [PHYSICAL].map {|hash| hash.values }.flatten
        check_physical = Condition.where(code:codes_physical)&.ids #check physical examination

        codes_system = [SYSTEM_1,SYSTEM_2].map {|hash| hash.values }.flatten
        check_system = Condition.where(code:codes_system)&.ids #check system exam

        #do not autorelease if one lab and one general exam/system exam/abnormal in physical examination
        return false if @transaction.laboratory_examination&.result == "ABNORMAL" && @doctor_exam.doctor_examination_details.where(condition_id: check_physical).exists?
        return false if @transaction.laboratory_examination&.result == "ABNORMAL" && @doctor_exam.physical_blood_pressure_systolic && @doctor_exam.physical_blood_pressure_systolic >= 140
        return false if @transaction.laboratory_examination&.result == "ABNORMAL" && @doctor_exam.physical_blood_pressure_diastolic && @doctor_exam.physical_blood_pressure_diastolic >= 90
        return false if @transaction.laboratory_examination&.result == "ABNORMAL" && @doctor_exam.doctor_examination_details.where(condition_id: check_system).exists?

        # do not autorelease if ABO discrepancy
        return false if previous_transaction.present? && previous_blood_group != current_blood_group && !@transaction.is_blood_group_benchmark

        return true if @doctor_exam.try(:physical_vision_test_aided_left)
        return true if @doctor_exam.try(:physical_vision_test_aided_right)
        return true if @doctor_exam.physical_blood_pressure_systolic && @doctor_exam.physical_blood_pressure_systolic >= 140
        return true if @doctor_exam.physical_blood_pressure_diastolic && @doctor_exam.physical_blood_pressure_diastolic >= 90
        return true if @transaction.laboratory_examination.try(:laboratory_test_not_done) == "YES"
        return true if @transaction.laboratory_examination.try(:elisa)
        return true if @transaction.laboratory_examination.try(:hbsag)
        return true if @transaction.laboratory_examination.try(:vdrl) && @transaction.laboratory_examination.try(:tpha)
        return true if @transaction.laboratory_examination.try(:malaria) && @transaction.laboratory_examination.try(:bfmp)
        return true if @transaction.laboratory_examination.try(:opiates)
        return true if @transaction.laboratory_examination.try(:cannabis)
        return true if @transaction.laboratory_examination.try(:pregnancy) && @transaction.laboratory_examination.try(:pregnancy_serum_beta_hcg)
        return true if @transaction.laboratory_examination.sugar
        return true if @transaction.laboratory_examination.albumin
    end

    def submit_medical_review_autorelease
        @medical_exam               = @transaction.medical_examination
        @medical_review             = @transaction.medical_reviews.create if @medical_review.blank?
        admin_user = User.admin_user

        # Create MedicalExamination as a replica of DoctorExamination.
        @medical_exam = create_medical_examination(@transaction) if @medical_exam.blank?
        # Reload transaction after create medical examination
        @transaction.reload.medical_examination

        # Auto release medical pending review for mle1
        mr_conditions = de_attributes__certification_conditions
        mr_conditions = mr_conditions.merge(:condition_other => "true") if @doctor_exam.try(:physical_vision_test_aided_left) || @doctor_exam.try(:physical_vision_test_aided_right)
        mr_conditions = mr_conditions.merge(:condition_hypertension => "true") if (@doctor_exam.physical_blood_pressure_systolic && @doctor_exam.physical_blood_pressure_systolic >= 140) || (@doctor_exam.physical_blood_pressure_diastolic && @doctor_exam.physical_blood_pressure_diastolic >= 90)
        mr_conditions = mr_conditions.merge(:condition_hiv => "true") if @transaction.laboratory_examination.try(:elisa) # elisa -> HIV
        mr_conditions = mr_conditions.merge(:condition_hepatitis => "true") if @transaction.laboratory_examination.try(:hbsag) # hbsag -> Hepatitis B
        mr_conditions = mr_conditions.merge(:condition_std => "true") if @transaction.laboratory_examination.try(:vdrl) && @transaction.laboratory_examination.try(:tpha) # vdrl & tpha -> STD
        mr_conditions = mr_conditions.merge(:condition_malaria => "true") if @transaction.laboratory_examination.try(:malaria) && @transaction.laboratory_examination.try(:bfmp) # malaria & bfmp -> Malaria
        mr_conditions = mr_conditions.merge(:condition_urine_for_opiates => "true") if @transaction.laboratory_examination.try(:opiates) # opiates -> Opiates
        mr_conditions = mr_conditions.merge(:condition_urine_for_cannabis => "true") if @transaction.laboratory_examination.try(:cannabis) # cannabis -> Cannabis
        mr_conditions = mr_conditions.merge(:condition_urine_for_pregnant => "true") if @transaction.laboratory_examination.try(:pregnancy) && @transaction.laboratory_examination.try(:pregnancy_serum_beta_hcg) # pregnancy & hcg -> Pregnancy
        mr_conditions = mr_conditions.merge(:condition_diabetes_mellitus => "true") if @transaction.laboratory_examination.sugar
        mr_conditions = mr_conditions.merge(:condition_kidney_diseases => "true") if @transaction.laboratory_examination.albumin

        mr_cert_comment = "RESULT RELEASED BY SYSTEM AUTOMATICALLY."
        mr_cert_comment << "\r\nVISION TEST AIDED (L) DEFECTIVE" if @doctor_exam.try(:physical_vision_test_aided_left)
        mr_cert_comment << "\r\nVISION TEST AIDED (R) DEFECTIVE" if @doctor_exam.try(:physical_vision_test_aided_right)
        mr_cert_comment << "\r\nHYPERTENSION" if (@doctor_exam.physical_blood_pressure_systolic && @doctor_exam.physical_blood_pressure_systolic >= 140) || (@doctor_exam.physical_blood_pressure_diastolic && @doctor_exam.physical_blood_pressure_diastolic >= 90)
        mr_cert_comment << "\r\nHIV" if @transaction.laboratory_examination.try(:elisa) # elisa -> HIV
        mr_cert_comment << "\r\nHEPATITIS B" if @transaction.laboratory_examination.try(:hbsag) # hbsag -> Hepatitis B
        mr_cert_comment << "\r\nSTD" if @transaction.laboratory_examination.try(:vdrl) && @transaction.laboratory_examination.try(:tpha) # vdrl & tpha -> STD
        mr_cert_comment << "\r\nMALARIA" if @transaction.laboratory_examination.try(:malaria) && @transaction.laboratory_examination.try(:bfmp) # malaria & bfmp -> Malaria
        mr_cert_comment << "\r\nOPIATES" if @transaction.laboratory_examination.try(:opiates) # opiates -> Opiates
        mr_cert_comment << "\r\nCANNABIS" if @transaction.laboratory_examination.try(:cannabis) # cannabis -> Cannabis
        mr_cert_comment << "\r\nPREGNANT" if @transaction.laboratory_examination.try(:pregnancy) && @transaction.laboratory_examination.try(:pregnancy_serum_beta_hcg) # pregnancy & hcg -> Pregnancy
        mr_cert_comment << "\r\nDIABETES MELLITUS" if @transaction.laboratory_examination.sugar
        mr_cert_comment << "\r\nKIDNEY DISEASE" if @transaction.laboratory_examination.albumin

        mr_comments = de_attributes_comments.merge(
            "certification_comment" => mr_cert_comment,
            "unsuitable_comment" => "AUTO RELEASED"
        )

        @medical_exam.auto_save_examination_details_and_comments(
            regular_fields: mr_conditions,
            comments: mr_comments
        )

        @medical_exam.result = "ABNORMAL"
        @medical_review.assign_attributes(
            medical_mle1_decision: "UNSUITABLE",
            medical_mle1_comment: mr_cert_comment
        )

        # Seed Unsuitable Reasons
        reason_ids = []
        reason_ids << "6" if @doctor_exam.try(:physical_vision_test_aided_left) || @doctor_exam.try(:physical_vision_test_aided_right) || (@doctor_exam.physical_blood_pressure_systolic && @doctor_exam.physical_blood_pressure_systolic >= 140) || (@doctor_exam.physical_blood_pressure_diastolic && @doctor_exam.physical_blood_pressure_diastolic >= 90)

        reason_ids.each do |reason_id|
            reason                      = TransactionUnsuitableReason.with_deleted.find_or_initialize_by(transaction_id: @transaction.id, unsuitable_reason_id: reason_id)
            reason.created_by_system    ||= true
            reason.update(deleted_at: nil)
        end

        @medical_exam.update(transmitted_at: Time.now)
        @medical_review.update(medical_mle1_id: admin_user.id, medical_mle1_decision_at: Time.now)
        infectious_conditions       = Condition.where(code: ["3501", "3502", "3503", "3504", "3505", "3506"]).pluck(:id)
        communicable_diseases_check = @medical_exam.medical_examination_details.where(condition_id: infectious_conditions).exists?
        @transaction.update(medical_status: "PENDING_APPROVAL", communicable_diseases: communicable_diseases_check)

        # Auto release medical pending review for mle2
        @medical_review.assign_attributes(
            medical_mle2_decision: "APPROVE",
            medical_mle2_comment: "APPROVED"
        )

        @transaction.update(medical_status: "CERTIFIED", medical_result: @medical_review.medical_mle1_decision, medical_quarantine_release_date: Time.now)
        @medical_review.update(medical_mle2_id: admin_user.id, medical_mle2_decision_at: Time.now)
    end

    def process_abo_discrepancy
        previous_transaction = @transaction.previous_transaction
        previous_blood_group = [previous_transaction.try(:laboratory_examination).try(:blood_group), previous_transaction.try(:laboratory_examination).try(:blood_group_rhesus)]
        current_blood_group = [@transaction.laboratory_examination.blood_group, @transaction.laboratory_examination.blood_group_rhesus]

        # If is ABO discrepancy transaction
        if previous_transaction.present? && previous_blood_group != current_blood_group && !@transaction.is_blood_group_benchmark
            # block IMM send
            @transaction.update(is_imm_blocked: true)

            # insert MLE1 comment
            @medical_exam = @transaction.medical_examination
            @medical_review = @transaction.medical_reviews.create if @medical_review.blank?
            @medical_exam = create_medical_examination(@transaction) if @medical_exam.blank?

            mr_comments = "BLOOD GROUP DISCREPANCY CASE. #{previous_transaction.transaction_date.year}: #{previous_blood_group[0]}#{previous_blood_group[1]}; #{@transaction.transaction_date.year}: #{current_blood_group[0]}#{current_blood_group[1]} (IMM BLOCKED). USE NEXT ME AS BENCHMARK."
            @medical_review.update(medical_mle1_comment: mr_comments)
        end
    end

    def has_other_abnormality?
        return true if @doctor_exam.physical_blood_pressure_systolic && @doctor_exam.physical_blood_pressure_systolic >= 140
        return true if @doctor_exam.physical_blood_pressure_diastolic && @doctor_exam.physical_blood_pressure_diastolic >= 90
    end

    def medical_examination_update_laboratory
        return if @transaction.status != "EXAMINATION"
        @lab_exam               = @transaction.laboratory_examination
        @lab_exam.laboratory_id = current_user.userable_id

        # Only clear results if transmitting. NF-1712.
        if params[:le_attributes][:laboratory_test_not_done] == "YES" && params[:commit] == "Save and Transmit"
            lab_default_parameters = [:specimen_taken_date, :specimen_received_date, :blood_specimen_barcode, :urine_specimen_barcode, :blood_group, :blood_group_rhesus].map {|key| [key, nil] }.to_h
            @lab_exam.laboratory_test_not_done = "YES"
            @lab_exam.update(lab_default_parameters)
            @lab_exam.reset_all_details_and_comments

            @lab_exam.save_examination_details_and_comments(
                comments:       le_attributes__comments.slice(:abnormal_reason)
            )
        else
            @lab_exam.assign_attributes(laboratory_examination_params)

            @lab_exam.save_examination_details_and_comments(
                boolean_fields: le_attributes__boolean,
                value_fields:   le_attributes__values,
                comments:       le_attributes__comments
            )
        end

        if params[:commit] == "Save and Transmit"
            @lab_exam.transmitted_at                = @current_time
            @lab_exam.result                        = @lab_exam.result_of_exam ? "ABNORMAL" : "NORMAL"
            @transaction.laboratory_transmit_date   = @current_time
        end

        @lab_exam.save
        @transaction.save
    end

    def medical_examination_update_xray_facility
        return if @transaction.status != "EXAMINATION"
        @xray_exam = @transaction.xray_examination

        # Reset XrayExamination if Radiologist aborts transaction.
        if params[:commit] == "Abort"
            @xray_exam.radiologist_aborted_at = @current_time
            @xray_exam.update(xray_default_parameters)
            @xray_exam.reset_all_details_and_comments
            flash[:sp_aborted]          = current_user.userable_type
            flash[:sp_aborted_worker]   = @transaction.fw_code
            redirect_to medical_examination_external_transactions_path(@transaction, aborted: "yes") and return true
        end

        # Check if reporter type has been changed.
        original_radiologist    = @transaction.radiologist_id
        original_reporter       = @transaction.xray_reporter_type

        # Have moved xray_not_done to front page, and in dialog. Do not save any transaction details
        unless params[:xe_attributes].present? && params[:xe_attributes].to_unsafe_h.size == 2 && params[:xe_attributes][:xray_examination_not_done] == "YES"
            @xray_exam.assign_attributes(xray_default_parameters)
            @transaction.assign_attributes(xray_examination_params)
            @xray_exam.reset_all_details_and_comments
        end

        # If Xray Facility selects a new radiologist or changes the reporter type.
        if original_radiologist != @transaction.radiologist_id || original_reporter != @transaction.xray_reporter_type
            @xray_exam.assign_attributes(xray_default_parameters)
            @xray_exam.reset_all_details_and_comments
        end

        if params[:xe_attributes].present?
            @xray_exam.assign_attributes(xe_attributes__regular_params)

            @xray_exam.save_examination_details_and_comments(
                detail_fields:  xe_attributes__details,
                comment_fields: xe_attributes__comments
            )
        end

        # Ensure radiologist id is nil if reporter_type is SELF.
        if @transaction.xray_reporter_type == "SELF" && @transaction.radiologist_id?
            @transaction.radiologist_id         = nil
            @xray_exam.radiologist_assigned_at  = nil
        end

        @xray_exam.radiologist_assigned_at  ||= @current_time if @transaction.radiologist_id?

        # If Xray facility changes radiologists.
        @xray_exam.radiologist_aborted_at   = nil if original_radiologist != @transaction.radiologist_id && original_reporter == @transaction.xray_reporter_type
        @xray_exam.radiologist_assigned_at  = @current_time if @transaction.radiologist_id? && original_radiologist != @transaction.radiologist_id
        @xray_exam.radiologist_saved_at     = @current_time if current_user.userable_type == "Radiologist" && @transaction.xray_reporter_type == "RADIOLOGIST"
        @xray_exam.result                   = @xray_exam.result_of_exam ? "ABNORMAL" : "NORMAL"

        # for skipping fingerprint verification
        @transaction.xray_fp_result         = 2 if @transaction.xray_fp_result.nil?

        if params[:commit] == "Save and Transmit"
            if current_user.userable_type == "Radiologist" && @transaction.xray_reporter_type == "RADIOLOGIST" && params[:visited_xray] == "true"
                @xray_exam.radiologist_transmitted_at   = @current_time
                flash[:sp_completed]                    = current_user.userable_type
                flash[:sp_completed_worker]             = @transaction.fw_code
            elsif current_user.userable_type == "XrayFacility"
                @xray_exam.transmitted_at               = @current_time
                @transaction.xray_transmit_date         = @current_time

                previous_transaction    = @transaction.previous_transaction
                xray_exam_unsuitable    = @transaction.xray_examination.result == "ABNORMAL"
                xray_exam_not_done      = @transaction.xray_examination.xray_examination_not_done == "YES"

                # digital process
                if @transaction.xray_transmit_date <= Time.parse(SystemConfiguration.get('XRAY_NEW_FLOW_START_DATE'))
                    # do not follow new flow before the date
                else
                    if @transaction.xray_film_type == 'DIGITAL'
                        if @transaction.foreign_worker.monitoring.eql?("Y")
                            # process handle during certification
                        else
                            # Previous X-ray Review => UNSUITABLE
                            # Previous Final Result => UNSUITABLE
                            if previous_transaction && (previous_transaction&.xray_result == "UNSUITABLE" || previous_transaction&.final_result == "UNSUITABLE")
                                if previous_transaction.latest_medical_appeal && previous_transaction.latest_medical_appeal.result == "SUCCESSFUL"
                                    if !xray_exam_unsuitable
                                        @transaction.submit_xqcc_case
                                    else
                                        @transaction.submit_pcr_case
                                    end
                                else
                                    # process handle during certification
                                end
                            # Previous => SUITABLE or No previous transaction
                            else
                                if !xray_exam_unsuitable
                                    @transaction.submit_xqcc_case
                                elsif xray_exam_not_done
                                    # process handle during certification
                                elsif xray_exam_unsuitable
                                    @transaction.submit_pcr_case
                                end
                            end
                        end
                    end
                end
                # /digital process
            end
        end

        @xray_exam.save
        @transaction.save
        return nil
    end

    def examination_history
        return_to_transactions_index and return if current_user.userable_type == "Employer" && !has_permission?("VIEW_EXAM_HISTORY_RESULTS_AND_BUTTON")
        return_to_transactions_index and return if ["Laboratory", "XrayFacility", "Radiologist"].include?(current_user.userable_type)
        redirect_to medical_examination_external_transactions_path(@transaction) and return unless @transaction.doctor_transmit_date?
        @medical_review         = @transaction.latest_medical_review    if @transaction.latest_medical_review && @transaction.latest_medical_review.medical_mle1_decision_at?
        @tcupi_review           = @transaction.latest_tcupi_review      if @medical_review.present?
        if site == 'MERTS'
            @xray_pending_decisions = @transaction.xray_pending_decisions.where(id: @transaction.xray_pending_decision_id)
        else
            @xray_pending_decisions = @transaction.xray_pending_decisions
        end

        if current_user.userable_type == "Doctor"
            @result_updates       = @transaction.transaction_result_updates.includes(:user).order(id: :desc)
            @amendments           = @transaction.transaction_amendments.where(approval_status: "CONCURRED").includes(:user, :approved_by).order(id: :desc)
        end

        @skip_visited           = true
        render "/internal/transactions/examination_history"
    end

    def tcupi_review
        @transaction            = Transaction.find(params[:id])
        @medical_review         = @transaction.latest_medical_review
        @tcupi_review           = @transaction.latest_tcupi_review
        @xray_pending_decisions = @transaction.xray_pending_decisions
        redirect_to external_transactions_path and return unless @transaction.can_work_on_medical_review_as_doctor(current_user)
        @submit_path            = tcupi_review_post_external_transaction_path(@transaction)
        @doctor                 = true
        @skip_visited           = true
        render "internal/medical/tcupi_review"
    end

    def tcupi_review_post
        @transaction        = Transaction.find(params[:id])
        test_done           = params[:tcupi_test_done].to_unsafe_h
        dates               = params[:tcupi_date].to_unsafe_h
        comments            = params[:tcupi_comment].to_unsafe_h

        @transaction.latest_tcupi_review.transaction_tcupi_todos.each do |transaction_tcupi_todo|
            id              = transaction_tcupi_todo.id.to_s
            build_params    = { done: test_done[id], completed_date: dates[id], comment: comments[id] }
            transaction_tcupi_todo.update(build_params)
        end

        redirect_to tcupi_review_external_transaction_path(@transaction, p_tab: params[:p_tab], tab: params[:tab])
    end

    def previous_examination_history
        @transaction= Transaction.find(params[:id])

        return_to_transactions_index and return if ["Laboratory", "XrayFacility", "Radiologist", "Employer"].include?(current_user.userable_type)

        @medical_review         = @transaction.latest_medical_review    if @transaction.latest_medical_review && @transaction.latest_medical_review.medical_mle1_decision_at?
        @tcupi_review           = @transaction.latest_tcupi_review      if @medical_review.present?
        if site == 'MERTS'
            @xray_pending_decisions = @transaction.xray_pending_decisions.where(id: @transaction.xray_pending_decision_id)
        else
            @xray_pending_decisions = @transaction.xray_pending_decisions
        end

        if current_user.userable_type == "Doctor"
            @result_updates     = @transaction.transaction_result_updates.includes(:user).order(id: :desc)
            @amendments         = @transaction.transaction_amendments.where(approval_status: "CONCURRED").includes(:user, :approved_by).order(id: :desc)
        end

        @skip_visited           = true
        flash.now[:notice] = "Viewing Transaction ##{ @transaction.code }"
        render "/internal/transactions/examination_history"
    end
private
    def transaction_new_params
        if !params.key?(:transaction)
            return {}
        end
        params.require(:transaction).permit(:medical_examination_date, :worker_matched, :worker_consented, :worker_identity_confirmed, :worker_image_confirmed)
    end

    def doctor_examination_params
        params[:de_attributes].slice(:physical_height, :physical_weight, :physical_pulse, :physical_blood_pressure_systolic, :physical_blood_pressure_diastolic, :physical_last_menstrual_period_date, :suitability).to_unsafe_h
    end

    def de_visited_columns
        params[:de_attributes].slice(:visited_history_1, :visited_history_2, :visited_physical, :visited_system_1, :visited_system_2, :visited_laboratory_result, :visited_xray_facility_result, :visited_condition, :visited_certification, :visited_follow_up).to_unsafe_h
    end

    def de_attributes__history
        params[:de_attributes].slice(:history_hiv, :history_tuberculosis, :history_leprosy, :history_viral_hepatitis, :history_psychiatric_illness, :history_epilepsy, :history_cancer, :history_std, :history_malaria, :history_hypertension, :history_heart_diseases, :history_bronchial_asthma, :history_diabetes_mellitus, :history_peptic_ulcer, :history_kidney_diseases, :history_other, :history_hiv_date, :history_tuberculosis_date, :history_leprosy_date, :history_viral_hepatitis_date, :history_psychiatric_illness_date, :history_epilepsy_date, :history_cancer_date, :history_std_date, :history_malaria_date, :history_hypertension_date, :history_heart_diseases_date, :history_bronchial_asthma_date, :history_diabetes_mellitus_date, :history_peptic_ulcer_date, :history_kidney_diseases_date, :history_other_date, :history_taken_drug_recently).to_unsafe_h
    end

    def de_attributes__physical
        params[:de_attributes].slice(:physical_chronic_skin_rash, :physical_anaesthetic_skin_patch, :physical_deformities_of_limbs, :physical_pallor, :physical_jaundice, :physical_lymph_node_enlargement, :physical_vision_test_unaided_left, :physical_vision_test_unaided_right, :physical_vision_test_aided_left, :physical_vision_test_aided_right, :physical_hearing_ability_left, :physical_hearing_ability_right, :physical_other).to_unsafe_h
    end

    def de_attributes__values
        params[:de_attributes].slice(:physical_vision_test_aided_left_a_value, :physical_vision_test_aided_left_b_value, :physical_vision_test_aided_right_a_value, :physical_vision_test_aided_right_b_value, :physical_vision_test_unaided_left_a_value, :physical_vision_test_unaided_left_b_value, :physical_vision_test_unaided_right_a_value, :physical_vision_test_unaided_right_b_value).to_unsafe_h
    end

    def de_attributes__system_1
        params[:de_attributes].slice(:system_cardiovascular_heart_size, :system_cardiovascular_heart_sounds, :system_cardiovascular_other_findings, :system_respiratory_breath_sounds, :system_respiratory_other_findings, :gastrointestinal_liver, :gastrointestinal_spleen, :gastrointestinal_swelling, :gastrointestinal_lymph_nodes, :gastrointestinal_rectal_examination, :gastrointestinal_other).to_unsafe_h
    end

    def de_attributes__system_2
        params[:de_attributes].slice(:system_nervous_general_mental_status, :system_nervous_general_appearance, :system_nervous_speech_quality, :system_nervous_speech_coherent, :system_nervous_speech_relevant, :system_nervous_mood, :system_nervous_mood_depressed, :system_nervous_mood_depressed_feeling_down, :system_nervous_mood_depressed_lost_interest, :system_nervous_mood_anxious, :system_nervous_mood_irritable, :system_nervous_affect, :system_nervous_thought, :system_nervous_thought_delusion, :system_nervous_thought_suicidality, :system_nervous_thought_suicidality_worth_living, :system_nervous_thought_suicidality_ending_life, :system_nervous_perception, :system_nervous_orientation, :system_nervous_time, :system_nervous_place, :system_nervous_person, :system_nervous_speech, :system_nervous_cognitive_function, :system_nervous_size_of_peripheral_nerves, :system_nervous_motor_power, :system_nervous_sensory, :system_nervous_reflexes, :system_nervous_other, :system_genitourinary_kidney, :system_genitourinary_discharge, :system_genitourinary_sores_ulcers, :system_breast_abnormal_discharge, :system_breast_lump, :system_breast_axillary_lympth_node, :system_breast_other, :system_nervous_abnormal_behaviour).to_unsafe_h
    end

    def de_attributes__certification_conditions
        params[:de_attributes].slice(:condition_hiv, :condition_tuberculosis, :condition_malaria, :condition_leprosy, :condition_std, :condition_hepatitis, :condition_cancer, :condition_epilepsy, :condition_psychiatric_disorder, :condition_hypertension, :condition_heart_diseases, :condition_bronchial_asthma, :condition_diabetes_mellitus, :condition_peptic_ulcer, :condition_kidney_diseases, :condition_urine_for_pregnant, :condition_urine_for_opiates, :condition_urine_for_cannabis, :condition_other).to_unsafe_h
    end

    def de_attributes__follow_up
        params[:de_attributes].slice(:notified_health_office, :referred_to_government_hospital, :referred_to_private_hospital, :treating_patient, :undergoing_treatment, :notified_health_office_date, :referred_to_government_hospital_date, :referred_to_private_hospital_date, :treating_patient_date, :undergoing_treatment_date).to_unsafe_h
    end

    def de_attributes_comments
        params[:de_attributes].slice(:history_comment, :physical_comment, :system_comment, :certification_comment, :unsuitable_comment).to_unsafe_h
    end

    def laboratory_examination_params
        params[:le_attributes].slice(:laboratory_test_not_done, :specimen_taken_date, :specimen_received_date, :blood_specimen_barcode, :urine_specimen_barcode, :blood_group, :blood_group_rhesus).to_unsafe_h
    end

    def le_attributes__boolean
        params[:le_attributes].slice(:elisa, :hbsag, :vdrl, :tpha, :malaria, :bfmp, :opiates, :cannabis, :pregnancy, :pregnancy_serum_beta_hcg, :sugar, :albumin).to_unsafe_h
    end

    def le_attributes__values
        params[:le_attributes].slice(:sugar_value, :albumin_value).to_unsafe_h
    end

    def le_attributes__comments
        params[:le_attributes].slice(:blood_group_other, :blood_group_rhesus_other, :abnormal_reason).to_unsafe_h
    end

    def xray_examination_params
        params[:transaction].slice(:xray_worker_identity_confirmed, :xray_film_type, :xray_reporter_type, :radiologist_id, :xray_worker_image_confirmed).to_unsafe_h
    end

    def xe_attributes__regular_params
        params[:xe_attributes].slice(:xray_examination_not_done, :xray_taken_date, :xray_ref_number).to_unsafe_h
    end

    def xe_attributes__details
        params[:xe_attributes].slice(:thoracic_cage, :heart_shape_and_size, :lung_fields, :mediastinum_and_hila, :pleura_hemidiaphragms_costopherenic_angles, :focal_lesion, :other_findings).to_unsafe_h
    end

    def xe_attributes__comments
        params[:xe_attributes].slice(:thoracic_cage_comment, :heart_shape_and_size_comment, :lung_fields_comment, :mediastinum_and_hila_comment, :pleura_hemidiaphragms_costopherenic_angles_comment, :focal_lesion_comment, :other_findings_comment, :impression).to_unsafe_h
    end

    def xray_default_parameters
        default_parameters = [:xray_examination_not_done, :xray_taken_date, :xray_ref_number, :radiologist_started_at, :radiologist_saved_at].map {|key| [key, nil]}.to_h
    end
end