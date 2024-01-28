module XqccLetter::LetterExtensions
    def search_by_xray_code(query)
        return all if query.blank?
        where("xray_code ilike ?", "%#{ query }%")
    end

    def search_by_xray_name(query)
        return all if query.blank?
        where("xray_name ilike ?", "%#{ query }%")
    end

    def search_by_transaction_code(query)
        return all if query.blank?
        where("transaction_code ilike ?", "%#{ query }%")
    end

    def search_by_worker_code(query)
        return all if query.blank?
        where("worker_code ilike ?", "%#{ query }%")
    end
end