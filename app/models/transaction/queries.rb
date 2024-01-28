module Transaction::Queries
	def search_code(code)
        return all if code.blank?
        code = code.strip
        where('transactions.code = ?', code)
    end

    def search_transaction_date(transaction_date)
        return all if transaction_date.blank?
        where("date_trunc('day', transactions.transaction_date) = ?", "#{transaction_date}")
    end

    def search_status(status)
        return all if status.blank?
        where('transactions.status = ?', "#{status}")
    end

    def search_approval_status(approval_status)
        return all if approval_status.blank?
        where('transactions.approval_status = ?', "#{approval_status}")
    end

    def search_xray_status(xray_status)
        return all if xray_status.blank?
        where('transactions.xray_status = ?', "#{xray_status}")
    end

    def search_without_doctor(without_doctor)
        return all if without_doctor.blank?
        without_doctor = ['1','y','yes','true'].include?(without_doctor.to_s.downcase)
        where("transactions.doctor_id is #{without_doctor ? 'null' : 'not null'}")
    end

    def search_employer(employer)
        return all if employer.blank?
        where('transactions.employer_id = ?', "#{employer}")
    end

    def search_employer_code(employer_code)
        return all if employer_code.blank?
        employer_code = employer_code.strip
        where("exists (select 1 from employers where transactions.employer_id = employers.id and employers.code ilike ?)", "#{employer_code}")
    end

    def search_doctor_code(doctor_code)
        return all if doctor_code.blank?
        doctor_code = doctor_code.strip
        joins(:doctor).where("doctors.code" => doctor_code)
    end

    def search_doctor_name(doctor_name)
        return all if doctor_name.blank?
        doctor_name = doctor_name.strip
        joins(:doctor).where("doctors.name like ?", "%#{doctor_name}%")
    end

    def search_doctor_state(doctor_state)
        return all if doctor_state.blank?
        doctor_state = doctor_state.strip
        joins(:doctor).where("doctors.state_id" => doctor_state)
    end

    def search_doctor_postcode(doctor_postcode)
        return all if doctor_postcode.blank?
        doctor_postcode = doctor_postcode.strip
        joins(:doctor).where("doctors.postcode" => doctor_postcode)
    end

    def search_doctor_clinic_code(doctor_clinic_code)
        return all if doctor_clinic_code.blank?
        doctor_clinic_code = doctor_clinic_code.strip
        where("exists (select 1 from doctors where transactions.doctor_id = doctors.id and (doctors.name ilike ? OR doctors.clinic_name ilike ? OR doctors.code = ?))", "%#{doctor_clinic_code}%", "%#{doctor_clinic_code}%", "#{doctor_clinic_code}")
    end

    def search_laboratory_code(laboratory_code)
        return all if laboratory_code.blank?
        laboratory_code = laboratory_code.strip
        where("exists (select 1 from laboratories where transactions.laboratory_id = laboratories.id and laboratories.code = ?)", "#{laboratory_code}")
    end

    def search_xray_facility_code(xray_facility_code)
        return all if xray_facility_code.blank?
        xray_facility_code = xray_facility_code.strip
        where("exists (select 1 from xray_facilities where transactions.xray_facility_id = xray_facilities.id and xray_facilities.code = ?)", "#{xray_facility_code}")
    end

    def search_radiologist_code(radiologist_code)
        return all if radiologist_code.blank?
        radiologist_code = radiologist_code.strip
        where("exists (select 1 from radiologists where transactions.radiologist_id = radiologists.id and radiologists.code = ?)", "#{radiologist_code}")
    end

    def search_transaction_certification_date(certification_date)
        return all if certification_date.blank?
        Time.zone = "Kuala Lumpur"
        where(certification_date: certification_date.beginning_of_day..certification_date.end_of_day)
    end

    def search_transaction_final_result(suitability)
        return all if suitability.blank?
        query = suitability.upcase

        case query
        when "NEW_PENDING_SELECT_CLINIC"
            where("transactions.status = 'NEW' and transactions.doctor_id is null")
        when "PENDING_EXAMINATION"
            where("transactions.status = 'NEW' and transactions.doctor_id is not null and transactions.expired_at > ?", Time.now)
        when "EXPIRED"
            where(status: ["NEW", "EXAMINATION", "CERTIFICATION"]).where(ignore_expiry: [false,nil,'']).where("expired_at < ?", Time.now)
        when "UNSUITABLE", "SUITABLE"
            where(final_result: query)
        when "CHANGE_DOCTOR_PENDING_APPROVAL"
            where("transactions.approval_status = ? and exists (select 1 from approval_requests ar join approval_items ai on ar.id = ai.request_id where ai.resource_id = transactions.id and ai.resource_type = 'Transaction' and ar.category = 'TRANSACTION_CHANGE_DOCTOR' and ar.state = 0)", "UPDATE_PENDING_APPROVAL")
        when "NEW_SPECIAL_RENEWAL_PENDING_APPROVAL"
            where("transactions.approval_status in (?) and transactions.expired_at > ? and exists (select 1 from approval_requests ar join approval_items ai on ar.id = ai.request_id where ai.resource_id = transactions.id and ai.resource_type = 'Transaction' and ar.category = 'TRANSACTION_SPECIAL_RENEWAL' and ar.state = 0) and exists (select 1 from uploads u join transactions t on u.uploadable_id = transactions.id where u.remark ='SPECIAL_RENEWAL')", ["NEW_PENDING_APPROVAL", "UPDATE_PENDING_APPROVAL"],Time.now)
        when "NEW_SPECIAL_RENEWAL_PENDING_DOCUMENT"
            where("transactions.approval_status in (?) and transactions.expired_at > ? and exists (select 1 from approval_requests ar join approval_items ai on ar.id = ai.request_id where ai.resource_id = transactions.id and ai.resource_type = 'Transaction' and ar.category = 'TRANSACTION_SPECIAL_RENEWAL' and ar.state = 0) and not exists (select 1 from uploads u join transactions t on u.uploadable_id = transactions.id where u.remark ='SPECIAL_RENEWAL')", ["NEW_PENDING_APPROVAL", "UPDATE_PENDING_APPROVAL"],Time.now)
        when "NEW_SPECIAL_RENEWAL_REJECTED"
            where("transactions.approval_status in (?) and exists (select 1 from approval_requests ar join approval_items ai on ar.id = ai.request_id where ai.resource_id = transactions.id and ai.resource_type = 'Transaction' and ar.category = 'TRANSACTION_SPECIAL_RENEWAL' and ar.state = 3)", ["NEW_REJECTED"])
        when "NEW_SPECIAL_RENEWAL_APPROVED"
            where("transactions.approval_status in (?) and exists (select 1 from approval_requests ar join approval_items ai on ar.id = ai.request_id where ai.resource_id = transactions.id and ai.resource_type = 'Transaction' and ar.category = 'TRANSACTION_SPECIAL_RENEWAL' and ar.state = 4)", ["NEW_APPROVED"])
        when "INSPECTORATE_CASES"
            search_inspectorate_cases(true)
        when "DOCUMENT_APPROVAL_PENDING"
            where("(transactions.medical_examination_date  is not null) or (transactions.expired_at >? or transactions.ignore_expiry = true and transactions.medical_examination_date  is null)", Time.now)
            .where("transactions.status not in (?) and exists (select 1 from transaction_verify_docs tvd where status in (?) and transaction_id = transactions.id) and not exists
            (select 1 from transaction_verify_docs tvd where (status in (?) and transaction_id = transactions.id ))", ['CANCELLED', 'REJECTED'], ['APPROVAL'],['APPROVED'])
        when "DOCUMENT_APPROVAL_INCOMPLETE"
            where("transactions.status not in (?) and exists (select 1 from transaction_verify_docs tvd where status in (?) and transaction_id = transactions.id)", ['CANCELLED', 'REJECTED'], ['INCOMPLETE'])
            .where("not exists (select 1 from transaction_verify_docs tvd where status in (?) and transaction_id = transactions.id)", ['APPROVED'])
        when "DOCUMENT_APPROVAL_REJECTED"
            where("transactions.status not in (?) and exists (select 1 from transaction_verify_docs tvd where status in (?) and transaction_id = transactions.id)", ['CANCELLED', 'REJECTED'], ['REJECTED'])
        when "DOCUMENT_APPROVAL_APPROVED"
            where("transactions.status not in (?) and exists (select 1 from transaction_verify_docs tvd where status in (?) and transaction_id = transactions.id)", ['CANCELLED', 'REJECTED'], ['APPROVED'])
        when "BYPASS_FP_PENDING_APPROVAL"
            where("transactions.status not in (?) and exists (select 1 from transaction_verify_docs tvd where category in (?) and status in (?) and transaction_id = transactions.id)", ['CANCELLED', 'REJECTED'], ['DOCTOR_TRANSACTION_BYPASS_FINGERPRINT', 'XRAY_TRANSACTION_BYPASS_FINGERPRINT'], ['APPROVAL'])
        when "BYPASS_FP_APPROVED_REJECTED"
            where("transactions.status not in (?) and exists (select 1 from transaction_verify_docs tvd where category in (?) and status in (?) and transaction_id = transactions.id)", ['CANCELLED', 'REJECTED'], ['DOCTOR_TRANSACTION_BYPASS_FINGERPRINT', 'XRAY_TRANSACTION_BYPASS_FINGERPRINT'], ['APPROVED', 'REJECTED'])
        when "PENDING_LAB"
            where("transactions.status='EXAMINATION' and transactions.xray_transmit_date is not null").where("expired_at >= ? OR (expired_at < ? AND ignore_expiry = ?)", Time.now, Time.now, true)
        when "PENDING_XRAY"
            where("transactions.status='EXAMINATION' and transactions.laboratory_transmit_date is not null").where("expired_at >= ? OR (expired_at < ? AND ignore_expiry = ?)", Time.now, Time.now, true)
        when "PENDING_LAB_AND_XRAY"
            where("transactions.status='EXAMINATION' and transactions.laboratory_transmit_date is null and transactions.xray_transmit_date is null").where("expired_at >= ? OR (expired_at < ? AND ignore_expiry = ?)", Time.now, Time.now, true)
        else
            where(status: query)
        end
    end

    def search_medical_status(search_type)
        return all if search_type.blank? || search_type == "Any"

        case search_type
        when "pending_review"
            where(medical_status: ["NEW", "REVIEW"])
        when "pending_review_approval"
            where(medical_status: "PENDING_APPROVAL")
        when "pending_review_and_review_approval"
            where(medical_status: ["NEW", "REVIEW", "PENDING_APPROVAL"])
        when "tcupi"
            where(medical_tcupi: true, medical_status: "TCUPI")
        when "tcupi_approval"
            where(medical_tcupi: true, medical_status: "TCUPI_PENDING_APPROVAL")
        when "tcupi_both"
            where(medical_tcupi: true, medical_status: ["TCUPI", "TCUPI_PENDING_APPROVAL"])
        when "pending_pr_qa"
            where("medical_status='PENDING_PR_QA' and id in (select transaction_id from medical_reviews mr where mr.is_qa='true' and mr.qa_decision is null)")
        when "review_qa"
            where("medical_status='CERTIFIED' and medical_quarantine_release_date is not null and id in (select transaction_id from medical_reviews mr where mr.is_qa='true' and mr.qa_decision is not null)")
        end
    end

    def foreign_worker_general_search(query)
        return all if query.blank?
        query = query.strip
        joins(:foreign_worker).where("LOWER(foreign_workers.name) LIKE ? OR foreign_workers.code = ? OR foreign_workers.passport_number = ?", "%#{query.downcase}%", query, query)
    end

    def search_foreign_worker_name_or_code(worker_code)
        return all if worker_code.blank?
        worker_code = worker_code.strip
        joins(:foreign_worker).where("foreign_workers.code = ? OR foreign_workers.name ilike ?", worker_code, "%#{worker_code}%")
    end

    def search_foreign_worker_name(worker_name)
        return all if worker_name.blank?
        worker_name = worker_name.strip
        joins(:foreign_worker).where("foreign_workers.name ilike ?", "%#{worker_name}%")
    end

    def search_fw_name(worker_name)
        return all if worker_name.blank?
        worker_name = worker_name.strip
        where("transactions.fw_name ilike ?", "%#{worker_name}%")
    end

    def search_fw_code(worker_code)
        return all if worker_code.blank?
        worker_code = worker_code.strip
        where("transactions.fw_code = ?", worker_code)
    end
=begin
    def search_employer_name_or_code(employer_code)
        return all if employer_code.blank?
        employer_code = employer_code.strip
        joins(:employer).where("employers.code ilike ? OR employers.name ilike ?", employer_code, "%#{employer_code}%")
    end

    def search_doctor_name_or_code(doctor_code)
        return all if doctor_code.blank?
        doctor_code = doctor_code.strip
        joins(:doctor).where("doctors.code = ? OR doctors.name ilike ?", doctor_code, "%#{doctor_code}%")
    end

    def search_laboratory_name_or_code(laboratory_code)
        return all if laboratory_code.blank?
        laboratory_code = laboratory_code.strip
        joins(:laboratory).where("laboratories.code = ? OR laboratories.name ilike ?", laboratory_code, "%#{laboratory_code}%")
    end

    def search_xray_facility_name_or_code(xray_facility_code)
        return all if xray_facility_code.blank?
        xray_facility_code = xray_facility_code.strip
        joins(:xray_facility).where("xray_facilities.code = ? OR xray_facilities.name ilike ?", xray_facility_code, "%#{xray_facility_code}%")
    end

    def search_radiologist_name_or_code(radiologist_code)
        return all if radiologist_code.blank?
        radiologist_code = radiologist_code.strip
        joins(:radiologist).where("radiologists.code = ? OR radiologists.name ilike ?", radiologist_code, "%#{radiologist_code}%")
    end
=end
    def search_foreign_worker_passport(passport_number)
        return all if passport_number.blank?
        passport_number = passport_number.strip
        joins(:foreign_worker).where("foreign_workers.passport_number LIKE ?", "%#{ passport_number }%")
    end

    def search_fw_passport(passport_number)
        return all if passport_number.blank?
        passport_number = passport_number.strip
        where("fw_passport_number = ?", passport_number)
    end

    def search_order_code(order_code)
        return all if order_code.blank?
        order_code = order_code.strip
        order = Order.find_by(code: order_code)

        if ['TRANSACTION_REGISTRATION','SPECIAL_RENEWAL_TRANSACTION_REGISTRATION'].include?(order&.category)
            order_item_ids = order&.order_items.try(:pluck,'id')
            where(:order_item_id => order_item_ids)
        else
            transaction_ids = order&.order_items&.where(:order_itemable_type => 'Transaction')&.pluck(:order_itemable_id)
            where(:id => transaction_ids)
        end
    end

    def search_transaction_date_start(date_start)
        if date_start.blank?
            # 1918-03-14 is the first record.
            # where('transactions.transaction_date >= ?', "1998-03-14")
            all
        else
            where('transactions.transaction_date >= ?', date_start)
        end
    end

    def search_transaction_date_end(date_end)
        return all if date_end.blank?
        where('transactions.transaction_date < ?', Time.parse(date_end) + 1.day)
    end

    def search_medical_date_start(medical_date_start)
        return all if medical_date_start.blank?
        where('transactions.medical_examination_date >= ?', medical_date_start)
    end

    def search_medical_date_end(medical_date_end)
        return all if medical_date_end.blank?
        where('transactions.medical_examination_date < ?', Time.parse(medical_date_end) + 1.day)
    end

    def search_certification_date_start(certification_date_start)
        return all if certification_date_start.blank?
        where('transactions.certification_date >= ?', certification_date_start)
    end

    def search_certification_date_end(certification_date_end)
        return all if certification_date_end.blank?
        where('transactions.certification_date < ?', Time.parse(certification_date_end) + 1.day)
    end

    def search_foreign_worker_country(country_id)
        return all if country_id.blank?
        joins(:foreign_worker).where(foreign_workers: { country_id: country_id })
    end

    def search_fw_country(country_id)
        return all if country_id.blank?
        where(fw_country_id: country_id)
    end

    def search_foreign_worker_code(worker_code)
        return all if worker_code.blank?
        worker_code = worker_code.strip
        joins(:foreign_worker).where("foreign_workers.code = ? OR foreign_workers.name ilike ?", worker_code, "%#{worker_code}%")
    end

    def search_by_user_type(user)
        key = user.userable_type.downcase.gsub("xrayfacility", "xray_facility")
        where("#{ key }_id" => user.userable.id)
    end

    def search_transactions_external_status(status, userable_type)
        if status.blank?
            if userable_type == "Radiologist"
                return where(xray_reporter_type: "RADIOLOGIST")
            else
                return all
            end
        end

        case userable_type
        when "Laboratory"
            case status
            when "transmitted"
                where.not("laboratory_transmit_date" => nil)
            when "examination"
                where(status: "EXAMINATION").where("laboratory_transmit_date" => nil)
            when "new"
                where(status: "NEW")
            end
        when "XrayFacility", "Radiologist"
            case status
            when "transmitted"
                if userable_type == "XrayFacility"
                    where.not(xray_transmit_date: nil)
                else
                    where.not(xray_transmit_date: nil).where(xray_reporter_type: "RADIOLOGIST")
                end
            when "pending_acknowledgement"
                joins(:xray_examination).where(status: "EXAMINATION", xray_transmit_date: nil, xray_reporter_type: "RADIOLOGIST").where.not(xray_examinations: { radiologist_transmitted_at: nil })
            when "assigned_to_radiologist" # Only XrayFacility.
                joins(:xray_examination).where(status: "EXAMINATION", xray_transmit_date: nil, xray_reporter_type: "RADIOLOGIST", xray_examinations: { radiologist_transmitted_at: nil })
            when "examination"
                if userable_type == "XrayFacility"
                    joins(:xray_examination).where(status: "EXAMINATION", xray_transmit_date: nil).where("xray_reporter_type is null or xray_reporter_type != ?", "RADIOLOGIST")
                else
                    joins(:xray_examination).where(status: "EXAMINATION", xray_transmit_date: nil, xray_reporter_type: "RADIOLOGIST", xray_examinations: { radiologist_transmitted_at: nil })
                end
            when "new" # Only XrayFacility
                where(status: "NEW")
            when "bypass_fp_pending_approval"
                where("transactions.status not in (?) and exists (select 1 from transaction_verify_docs tvd where category in (?) and status in (?) and transaction_id = transactions.id order by id desc limit 1)", ['CANCELLED', 'REJECTED'], ['XRAY_TRANSACTION_BYPASS_FINGERPRINT'], ['APPROVAL'])
            when "bypass_fp_approved_rejected"
                where("transactions.status not in (?) and exists (select 1 from transaction_verify_docs tvd where category in (?) and status in (?) and transaction_id = transactions.id order by id desc limit 1)", ['CANCELLED', 'REJECTED'], ['XRAY_TRANSACTION_BYPASS_FINGERPRINT'], ['APPROVED', 'REJECTED'])
            end
        when "Doctor"
            case status
            when "pending_review"
                where(status: ["REVIEW"]).where("medical_status != ? or xray_status in (?)", "CERTIFIED", ["XQCC_PENDING_REVIEW", "XQCC_PENDING_DECISION", "XQCC_PENDING_DECISION_APPROVAL"])
            when "certified"
                where("status = ? or (status = ? and medical_status = ? and xray_status not in (?))", "CERTIFIED", "REVIEW", "CERTIFIED", ["XQCC_PENDING_REVIEW", "XQCC_PENDING_DECISION", "XQCC_PENDING_DECISION_APPROVAL"])
            when "bypass_fp_pending_approval"
                where("transactions.status not in (?) and exists (select 1 from transaction_verify_docs tvd where category in (?) and status in (?) and transaction_id = transactions.id order by id desc limit 1)", ['CANCELLED', 'REJECTED'], ['DOCTOR_TRANSACTION_BYPASS_FINGERPRINT'], ['APPROVAL'])
            when "bypass_fp_approved_rejected"
                where("transactions.status not in (?) and exists (select 1 from transaction_verify_docs tvd where category in (?) and status in (?) and transaction_id = transactions.id order by id desc limit 1)", ['CANCELLED', 'REJECTED'], ['DOCTOR_TRANSACTION_BYPASS_FINGERPRINT'], ['APPROVED', 'REJECTED'])
            when "pending_lab"
                where("transactions.status='EXAMINATION' and transactions.xray_transmit_date is not null").where("expired_at >= ? OR (expired_at < ? AND ignore_expiry = ?)", Time.now, Time.now, true)
            when "pending_xray"
                where("transactions.status='EXAMINATION' and transactions.laboratory_transmit_date is not null").where("expired_at >= ? OR (expired_at < ? AND ignore_expiry = ?)", Time.now, Time.now, true)
            when "pending_lab_and_xray"
                where("transactions.status='EXAMINATION' and transactions.laboratory_transmit_date is null and transactions.xray_transmit_date is null").where("expired_at >= ? OR (expired_at < ? AND ignore_expiry = ?)", Time.now, Time.now, true)
            else
                mapped_statuses     = {
                    new:            "NEW",
                    certification:  "CERTIFICATION",
                    examination:    "EXAMINATION",
                }.with_indifferent_access

                where(status: mapped_statuses[status])
            end
        when "Employer", "Agency"
                mapped_statuses     = {
                pending_review: "REVIEW",
                new: "NEW",
                change_doctor_pending_approval: "CHANGE_DOCTOR_PENDING_APPROVAL",
                change_doctor_rejected: "CHANGE_DOCTOR_REJECTED",
                special_renewal_pending_approval: "SPECIAL_RENEWAL_PENDING_APPROVAL",
                special_renewal_pending_document: "SPECIAL_RENEWAL_PENDING_DOCUMENT",
                special_renewal_rejected: "SPECIAL_RENEWAL_REJECTED",
                certification: "CERTIFICATION",
                examination: "EXAMINATION",
                cancelled: "CANCELLED",
                expired: "EXPIRED",
                suitable: "SUITABLE",
                unsuitable: "UNSUITABLE",
                new_pending_select_clinic: "NEW_PENDING_SELECT_CLINIC",
                bypass_fp_pending_approval: "BYPASS_FP_PENDING_APPROVAL",
                bypass_fp_approved_rejected: "BYPASS_FP_APPROVED_REJECTED",
                pending_xray: "PENDING_XRAY",
                pending_lab: "PENDING_LAB",
                pending_lab_and_xray: "PENDING_LAB_XRAY",
            }.with_indifferent_access

            case mapped_statuses[status]
            when "NEW"
                where("transactions.status = 'NEW' and transactions.doctor_id is not null and (transactions.expired_at > ? or transactions.ignore_expiry = true)", Time.now)
            when "NEW_PENDING_SELECT_CLINIC"
                where("transactions.status = 'NEW' and transactions.doctor_id is null and (transactions.expired_at > ? or transactions.ignore_expiry = true)", Time.now)
            when "UNSUITABLE", "SUITABLE"
                where(final_result: mapped_statuses[status])
            when "CHANGE_DOCTOR_PENDING_APPROVAL"
                where("transactions.approval_status = ? and exists (select 1 from approval_requests ar join approval_items ai on ar.id = ai.request_id where ai.resource_id = transactions.id and ai.resource_type = 'Transaction' and ar.category = 'TRANSACTION_CHANGE_DOCTOR' and ar.state = 0)", "UPDATE_PENDING_APPROVAL")
            when "SPECIAL_RENEWAL_PENDING_APPROVAL"
                where("transactions.approval_status in (?) and transactions.expired_at > ? and exists (select 1 from approval_requests ar join approval_items ai on ar.id = ai.request_id where ai.resource_id = transactions.id and ai.resource_type = 'Transaction' and ar.category = 'TRANSACTION_SPECIAL_RENEWAL' and ar.state = 0) and exists (select 1 from uploads u join transactions t on u.uploadable_id = transactions.id where u.remark ='SPECIAL_RENEWAL')", ["NEW_PENDING_APPROVAL", "UPDATE_PENDING_APPROVAL"],Time.now)
            when "SPECIAL_RENEWAL_PENDING_DOCUMENT"
                where("transactions.approval_status in (?) and transactions.expired_at > ? and exists (select 1 from approval_requests ar join approval_items ai on ar.id = ai.request_id where ai.resource_id = transactions.id and ai.resource_type = 'Transaction' and ar.category = 'TRANSACTION_SPECIAL_RENEWAL' and ar.state = 0) and not exists (select 1 from uploads u join transactions t on u.uploadable_id = transactions.id where u.remark ='SPECIAL_RENEWAL')", ["NEW_PENDING_APPROVAL", "UPDATE_PENDING_APPROVAL"],Time.now)
            when "CHANGE_DOCTOR_REJECTED"
                where("transactions.approval_status = ? and exists (select 1 from approval_requests ar join approval_items ai on ar.id = ai.request_id where ai.resource_id = transactions.id and ai.resource_type = 'Transaction' and ar.category = 'TRANSACTION_CHANGE_DOCTOR' and ar.state = 3)", "UPDATE_REJECTED")
            when "SPECIAL_RENEWAL_REJECTED"
                where("transactions.approval_status = ? and exists (select 1 from approval_requests ar join approval_items ai on ar.id = ai.request_id where ai.resource_id = transactions.id and ai.resource_type = 'Transaction' and ar.category = 'TRANSACTION_SPECIAL_RENEWAL' and ar.state = 3)", "NEW_REJECTED")
            when "EXPIRED"
                # where.not not working
                where(status: ["NEW", "EXAMINATION", "CERTIFICATION"]).where(ignore_expiry: [false,nil,'']).where("expired_at < ?", Time.now)
            when "EXAMINATION", "CERTIFICATION"
                where(status: mapped_statuses[status]).where("expired_at >= ? OR (expired_at < ? AND ignore_expiry = ?)", Time.now, Time.now, true)
            when "REVIEW"
                where(status: ["REVIEW"]).where("medical_status != ? or xray_status in (?)", "CERTIFIED", ["XQCC_PENDING_REVIEW", "XQCC_PENDING_DECISION", "XQCC_PENDING_DECISION_APPROVAL"])
            when "BYPASS_FP_PENDING_APPROVAL"
                where("transactions.status not in (?) and exists (select 1 from transaction_verify_docs tvd where category in (?) and status in (?) and transaction_id = transactions.id order by id desc limit 1)", ['CANCELLED', 'REJECTED'], ['DOCTOR_TRANSACTION_BYPASS_FINGERPRINT', 'XRAY_TRANSACTION_BYPASS_FINGERPRINT'], ['APPROVAL'])
            when "BYPASS_FP_APPROVED_REJECTED"
                where("transactions.status not in (?) and exists (select 1 from transaction_verify_docs tvd where category in (?) and status in (?) and transaction_id = transactions.id order by id desc limit 1)", ['CANCELLED', 'REJECTED'], ['DOCTOR_TRANSACTION_BYPASS_FINGERPRINT', 'XRAY_TRANSACTION_BYPASS_FINGERPRINT'], ['APPROVED', 'REJECTED'])
            when "PENDING_LAB"
                where("transactions.status='EXAMINATION' and transactions.xray_transmit_date is not null").where("expired_at >= ? OR (expired_at < ? AND ignore_expiry = ?)", Time.now, Time.now, true)
            when "PENDING_XRAY"
                where("transactions.status='EXAMINATION' and transactions.laboratory_transmit_date is not null").where("expired_at >= ? OR (expired_at < ? AND ignore_expiry = ?)", Time.now, Time.now, true)
            when "PENDING_LAB_XRAY"
                where("transactions.status='EXAMINATION' and transactions.laboratory_transmit_date is null and transactions.xray_transmit_date is null").where("expired_at >= ? OR (expired_at < ? AND ignore_expiry = ?)", Time.now, Time.now, true)
            else
                where(status: mapped_statuses[status])
            end
        end
    end

    def search_worker_gender(gender)
        return all if gender.blank?
        joins(:foreign_worker).where(foreign_workers: { gender: gender })
    end

    def search_fw_gender(gender)
        return all if gender.blank?
        where(fw_gender: gender)
    end

    def search_inspectorate_cases(inspectorate_cases)
        return all if inspectorate_cases.blank?
        where(communicable_diseases: true)
    end

    def search_employer_state(employer_state_id)
        return all if employer_state_id.blank?
        joins(:employer).where(employers: { state_id: employer_state_id })
    end

    def search_branch(branch_id)
        return all if branch_id.blank?

        ## organization_id /requester by - organization
        joins("left join approval_items on transactions.id = approval_items.resource_id and approval_items.id = (SELECT MAX(id) FROM approval_items temp_ai WHERE temp_ai.resource_id = transactions.id and resource_type = 'Transaction')
        left join approval_requests on approval_items.request_id = approval_requests.id and approval_items.resource_type = 'Transaction'
        left join users on request_user_id = users.id").where('transactions.organization_id = ? or users.userable_id = ?',branch_id, branch_id)
    end

    # Only used by Radiologists.
    def search_xray_facility_id(facility_id)
        return all if facility_id.blank?
        where(xray_facility_id: facility_id)
    end
end