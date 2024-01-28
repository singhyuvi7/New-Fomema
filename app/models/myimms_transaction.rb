class MyimmsTransaction < ApplicationRecord
    audited
    include CaptureAuthor

    belongs_to :transactionz, foreign_key: "transaction_id", class_name: "Transaction"

    RESPONSE_STATUS = {
        '1' => "SUCCESS",
        '0' => "FAILED",
        '96' => 'IMM BLOCKED',
        '97' => 'YET TO PROCEED',
        '98' => "FOREIGN WORKER BLOCKED",
        "99" => "PHYSICAL NOT DONE"
    }

    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        # where('exists (select 1 from transactions where transactions.id = myimms_transactions.transaction_id and transactions.code = ?)', "#{code}")
        joins(:transactionz).where(transactions: { code: code })
    end

    def self.search_status(status)
        return all if status.blank?
        if status == '0'
            where('myimms_transactions.status != ?', "1")
        else
            where('myimms_transactions.status = ?', "#{status}")
        end
    end

    def self.search_passport_number(passport_number)
        return all if passport_number.blank?
        passport_number = passport_number.strip
        joins(:transactionz).where(transactions: { fw_passport_number: passport_number })
    end

    def self.search_date_send_start(date_start)
        return all if date_start.blank?
        where('myimms_transactions.updated_at >= ?', date_start)
    end

    def self.search_date_send_end(date_end)
        return all if date_end.blank?
        where('myimms_transactions.updated_at < ?', Time.parse(date_end) + 1.day)
    end

    def displayed_status
       RESPONSE_STATUS[status]
    end

    def is_success_failed?
        ['1','0'].include?(status)
    end
end
