module MedicalAppeal::Queries
    def search_by_id(appeal_id)
        return all if appeal_id.blank?
        where(id: appeal_id)
    end

    def search_by_status(status_type, appeal_id, worker_code)
        if status_type.blank?
            if appeal_id.present? || worker_code.present?
                all
            else
                where.not(status: "CLOSED")
            end
        elsif status_type == "EXAMINATIONS_ONLY"
            where.not(status: ["PENDING_APPROVAL", "CLOSED"])
        elsif status_type == "DOCUMENT_UPLOADED_BY_SP"
            where(status: "EXAMINATION")
            .where("(doctor_document_uploaded = true and laboratory_document_uploaded is not false) or (doctor_document_uploaded is not false and laboratory_document_uploaded = true)")
        elsif status_type == "CLOSED_MOH_APPEAL"
            where(status: "CLOSED", is_moh: true)
        else
            where(status: status_type)
        end
    end

	def search_foreign_worker_name_or_code(worker_code)
        return all if worker_code.blank?
        joins(:transactionz).where("transactions.fw_code = ? OR transactions.fw_name ilike ?", worker_code, "%#{worker_code}%")
    end

    def search_foreign_worker_name(worker_name)
        return all if worker_name.blank?
        worker_name = worker_name.strip
        joins(:foreign_worker).where("foreign_workers.name ilike ?", "%#{worker_name}%")
    end

    def search_doctor_name_or_code(doctor_code)
        return all if doctor_code.blank?
        joins(:doctor).where("doctors.code = ? OR doctors.name ilike ?", doctor_code, "%#{doctor_code}%")
    end

    # If used with includes(:registered_by), will cause errors, so need to alias the doctors. So far only happens in External::AppealsController.
    def search_clinic_or_doctor_name(name)
        return all if name.blank?
        joins("JOIN doctors doc on doc.id = medical_appeals.doctor_id").where("doc.clinic_name ilike ? OR doc.name ilike ?", "%#{ name }%", "%#{ name }%")
    end

    # If used with includes(:registered_by), will cause errors, so need to alias the users. So far only happens in External::AppealsController.
    def search_officer_name_or_code(mle1_code)
        return all if mle1_code.blank?
        joins("JOIN users oic on oic.id = medical_appeals.officer_in_charge_id").where("oic.code ilike ? OR oic.name ilike ?", mle1_code, "%#{ mle1_code }%")
    end

    def search_appeal_date_start(date_start)
        return all if date_start.blank?
        where("medical_appeals.created_at >= ?", date_start)
    end

    def search_appeal_date_end(date_end)
        return all if date_end.blank?
        where("medical_appeals.created_at <= ?", Time.parse(date_end) + 1.day)
    end

    def search_by_appeal_status_external(status)
        return all if status.blank?

        if ["SUCCESSFUL", "UNSUCCESSFUL", "CANCEL/CLOSE"].include?(status)
            where(status: "CLOSED", result: status)
        else
            where(status: status)
        end
    end

    def search_registered_by_type(registered_by_type)
        return all if registered_by_type.blank?
        where(registered_by_type: registered_by_type)
    end

    def search_moh_appeal(is_moh)
       return all if is_moh.blank?
       where(is_moh: is_moh)
    end

    def search_is_specialist(is_specialist)
        return all if is_specialist.blank?
        where(is_specialist: is_specialist)
    end
end