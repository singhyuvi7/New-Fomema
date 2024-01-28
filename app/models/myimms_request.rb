class MyimmsRequest < ApplicationRecord
    include CaptureAuthor

    belongs_to :myimms_transaction
    belongs_to :myimm
    has_one :myimms_response

    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where('myimms_requests.txn_id = ?',code)
    end

    def self.search_passport_number(passport_number)
        return all if passport_number.blank?
        passport_number = passport_number.strip
        where('myimms_requests.doc_no = ?',passport_number)
    end

    def self.search_status(status)
        return all if status.blank?
        if status == '0'
            joins(:myimms_response).where('myimms_responses.status != ?',"1")
        else
            joins(:myimms_response).where('myimms_responses.status = ?',"#{status}")
        end
    end

    def self.search_date_send_start(date_start)
        return all if date_start.blank?
        where('myimms_requests.created_at >= ?', date_start)
    end

    def self.search_date_send_end(date_end)
        return all if date_end.blank?
        where('myimms_requests.created_at < ?', Time.parse(date_end) + 1.day)
    end

end
