module XqccLetter::LetterMethods
    def letter_date
        created_at.strftime("%d/%m/%Y")
    end

    def created_by_user
        creator&.code
    end

    def approver_name_and_designation
        approver    = try(:issuer_name)
        designation = try(:issuer_title)

        if approver.present? && designation.present?
            "<b>#{ approver }</b><br>#{ designation }"
        end
    end

    def xray_code_and_name
        "<b>#{ xray_code }</b><br>#{ xray_name }"
    end

    def worker_code_name_and_passport
        "<b>#{ worker_code }</b><br>#{ worker_name }<br>(#{ worker_passport })"
    end

    def letter_xray_and_employer_ref_number
        "<b>Xray: </b>#{ xray_ref_no }<br><b>Emp: </b>#{ employer_ref_no }"
    end

    def letter_xray_ref_number
        "<b>Xray: </b>#{ xray_ref_no }"
    end
end