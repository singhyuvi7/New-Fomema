module Transaction::XqccProcesses
    # mark transaction as pending review if previous transaction pcr_reviews.result & xray_pending_decision.decision results are abnormal but this year is normal
=begin # don't think still got use 16/12/2020
    def pending_review_xqcc_unsuitable
        pending_review_data =  {
            transaction_id: self.id,
            quarantine_type: 'XNPXA',
            quarantine_reason: nil,
            source: 'MERTS',
            status: 'XQCC_PENDING_REVIEW',
        }
        xray_pending_review = XrayPendingReview.create(pending_review_data)

        self.update({
            xray_status: 'XQCC_PENDING_REVIEW',
            xray_pending_review_id: xray_pending_review.id
        })
    end
=end

    # mark transaction as pending review if doctor certified abnormal, previous transaction xray review abnormal, and current year xray certify abnormal
=begin # don't think still got use 16/12/2020
    def pending_review_unsuitable_xqcc_unsuitable
        pending_review_data =  {
            transaction_id: self.id,
            quarantine_type: 'XAPXA',
            quarantine_reason: nil,
            source: 'MERTS',
            status: 'XQCC_PENDING_REVIEW',
        }
        xray_pending_review = XrayPendingReview.create(pending_review_data)

        self.update({
            xray_status: 'XQCC_PENDING_REVIEW',
            xray_pending_review_id: xray_pending_review.id
        })
    end
=end

    # mark transaction as pending review if previous transaction medical results unsuitable but this year doctor mark as suitable
=begin # don't think still got use 16/12/2020
    def pending_review_medical_unsuitable
        pending_review_data =  {
            transaction_id: self.id,
            quarantine_type: 'DSPMA',
            quarantine_reason: nil,
            source: 'MERTS',
            status: 'XQCC_PENDING_REVIEW',
        }
        xray_pending_review = XrayPendingReview.create(pending_review_data)

        self.update({
            xray_status: 'XQCC_PENDING_REVIEW',
            xray_pending_review_id: xray_pending_review.id
        })
    end
=end

    # mark transaction as pending review if xray abnormal but doctor certifies as suitable
=begin # don't think still got use 16/12/2020
    def pending_review_xray_finding
        pending_review_data =  {
            transaction_id: self.id,
            quarantine_type: 'NORMAL_QUARANTINE',
            quarantine_reason: nil,
            source: 'MERTS',
            status: 'XQCC_PENDING_REVIEW',
        }
        xray_pending_review = XrayPendingReview.create(pending_review_data)

        self.update({
            xray_status: 'XQCC_PENDING_REVIEW',
            xray_pending_review_id: xray_pending_review.id
        })
    end
=end

    # submit transaction as xqcc case
    def submit_xqcc_case
        if self.can_radiologist_autorelease?("NORMAL")
            return self.submit_xqcc_case_autorelease
        end

        self.update({
            xray_status: 'XQCC_POOL'
        })

        xqcc_pool_data = {
            transaction_id: self.id,
            case_type: 'XRAY_EXAMINATION_NORMAL',
            status: 'XQCC_POOL',
            source: 'MERTS'
        }
        # xqcc_pool = XqccPool.find_or_create_by(xqcc_pool_data)
        xqcc_pool = XqccPool.find_or_create_by(transaction_id: xqcc_pool_data[:transaction_id])
        xqcc_pool.update(xqcc_pool_data)

        digital_xray_movements.create(transaction_id: self.id, status: 'NEW')
    end

    def submit_xqcc_case_autorelease
        system_user = User.system_user

        xqcc_pool_data = {
            transaction_id: self.id,
            case_type: 'XRAY_EXAMINATION_NORMAL',
            status: 'ASSIGN',
            source: 'MERTS',
            picked_up_by: system_user.id,
            picked_up_at: Time.now,
            sourceable: self
        }

        xqcc_pool = XqccPool.find_by(transaction_id: xqcc_pool_data[:transaction_id])
        return nil if xqcc_pool.present? # Return early, so that xray review is not created. This is to prevent double submissions.
        XqccPool.create(xqcc_pool_data) # Allow create too, so that if it really does try to double submit, this will prevent it due to unique index.

        xray_review = XrayReview.create({
            transaction_id: self.id,
            case_type: "XRAY_EXAMINATION_NORMAL",
            status: "TRANSMITTED",
            result: "NORMAL",
            transmitted_at: Time.now,
            radiographer_id: system_user.id,
            poolable: xqcc_pool
        })

        self.update({
            xray_review_id: xray_review.id,
            xray_status: "CERTIFIED",
            xray_result: "SUITABLE"
        })

        digital_xray_movements.create(transaction_id: self.id, status: 'AUTORELEASED')
    end

    # create pcr_review case when xray examination transmit ABNORMAL result
    def submit_pcr_case
        if self.can_radiologist_autorelease?("ABNORMAL")
            return self.submit_pcr_case_autorelease
        end

        self.update({
            xray_status: 'PCR_POOL'
        })

        pcr_pool_data = {
            transaction_id: self.id,
            case_type: 'XRAY_EXAMINATION_ABNORMAL',
            status: 'PCR_POOL',
            source: 'MERTS'
        }
        # pcr_pool = PcrPool.find_or_create_by(pcr_pool_data)
        pcr_pool = PcrPool.find_or_create_by(transaction_id: pcr_pool_data[:transaction_id])
        pcr_pool.update(pcr_pool_data)

        digital_xray_movements.create(transaction_id: self.id, status: 'NEW')
    end

    def submit_pcr_case_autorelease
        system_user = User.system_user
        pcr_pool_data = {
            transaction_id: self.id,
            case_type: 'XRAY_EXAMINATION_ABNORMAL',
            status: 'ASSIGN',
            source: 'MERTS',
            picked_up_by: system_user.id,
            picked_up_at: Time.now,
            sourceable: self
        }
        pcr_pool = PcrPool.create(pcr_pool_data)

        pcr_review = PcrReview.create({
            transaction_id: self.id,
            case_type: "XRAY_EXAMINATION_ABNORMAL",
            status: "TRANSMITTED",
            result: "ABNORMAL",
            transmitted_at: Time.now,
            pcr_id: system_user.id,
            poolable: pcr_pool
        })

        self.update({
            pcr_review_id: pcr_review.id,
            xray_status: "CERTIFIED",
            xray_result: "UNSUITABLE"
        })

        digital_xray_movements.create(transaction_id: self.id, status: 'AUTORELEASED')
    end

    # TODO: refactor this to create Xccc Pool row
=begin # don't think still got use 16/12/2020
    def pickup_physical_xqcc_case(user_id)
        xqcc_pool_data = {
            transaction_id: self.id,
            case_type: nil, # 'XRAY_EXAMINATION_NORMAL',
            status: 'XQCC_POOL',
            source: nil, # 'MERTS'
        }
        # xqcc_pool = XqccPool.find_or_create_by(xqcc_pool_data)
        xqcc_pool = XqccPool.find_or_create_by(transaction_id: xqcc_pool_data[:transaction_id])
        xqcc_pool.update(xqcc_pool_data)
        xqcc_pool.pickup_xqcc(nil, user_id)
 =begin
        xqcc_review_data = {
            transaction_id: self.id,
            status: 'XQCC_REVIEW',
            case_type: 'XRAY_EXAMINATION_NORMAL',
            radiographer_id: user_id
        }
        xray_review = XrayReview.create(xqcc_review_data)

        self.update({
            xray_review_id: xray_review.id,
            xray_status: 'XQCC_REVIEW',
        })
 =end
    end
=end

    # TODO: refactor this to create PCR Pool row
=begin # don't think still got use 16/12/2020
    def pickup_physical_pcr_case(user_id)
        pcr_pool_data = {
            transaction_id: self.id,
            case_type: 'XRAY_EXAMINATION_ABNORMAL',
            status: 'PCR_POOL',
            source: 'MERTS'
        }
        # pcr_pool = PcrPool.find_or_create_by(pcr_pool_data)
        pcr_pool = PcrPool.find_or_create_by(transaction_id: pcr_pool_data[:transaction_id])
        pcr_pool.update(pcr_pool_data)
        pcr_pool.pickup_pcr(user_id)
    end
=end

=begin # don't think still got use 16/12/2020
    def complete_xray_retake
        # update the xray_review / pcr review result to nil
        if xray_retake.retake_review_type === 'XQCC'
            requestable_status = 'XQCC_REVIEW'
            reset_cols_data = reset_xray_review_cols
        else
            requestable_status = 'PCR_REVIEW'
            reset_cols_data = reset_pcr_review_cols
        end

        reset_cols_data[:status] = requestable_status

        # reset the xray_review / pcr_value to default value
        xray_retake.requestable.update(reset_cols_data)

        # update the xray retake to completed
        xray_retake.update({
            status: 'COMPLETED',
            completed_at: Time.now
        })
    end
=end

    def reset_xray_review_cols
        xray_review_cols = XrayReview.column_names

        reset_cols = {}
        except_cols = %w(id transaction_id batch_id case_type radiographer_id poolable_type poolable_id is_legacy trans_id legacy_id created_by updated_by created_at updated_at transmitted_at )

        xray_review_cols.each do |col|
            if except_cols.exclude?(col)
                reset_cols[col] = nil
            end
        end

        reset_cols
    end

    def can_radiologist_autorelease?(xray_result)
        SystemConfiguration.get("RADIOLOGIST_AUTORELEASE_#{xray_result}").eql?("1") && (self.xray_reporter_type.eql?("RADIOLOGIST") || (self.xray_reporter_type.eql?("SELF") && self.xray_facility.radiologist_operated))
    end

    # In Controller
    # @transaction.update_xray_review_conditions(
    #     condition_tuberculosis: @xray_pending_decision.condition_tuberculosis == "YES",
    #     condition_heart_diseases: @xray_pending_decision.condition_heart_diseases == "YES",
    #     condition_other: @xray_pending_decision.condition_other == "YES"
    # )

    def update_xray_review_conditions(conditions = {}, passed_medical_examination = nil)
        exam                = passed_medical_examination || medical_examination
        remap               = DoctorExamination::CERTIFICATION.with_indifferent_access
        updating_conditions = conditions.map {|condition, boolean| [Condition.find_by(code: remap[condition]).id, boolean] }.to_h

        updating_conditions.each do |condition_id, boolean|
            detail          = exam.medical_examination_details.with_deleted.find_or_initialize_by(transaction_id: id, condition_id: condition_id)

            if boolean
                detail.update(deleted_at: nil)
            else
                detail.update(deleted_at: Time.now) if detail.id? && detail.deleted_at.blank?
            end
        end

        exam
        # check_for_communicable_diseases This has been moved to Transaction.check_certification_status
    end
end