class InsurancePaymentBatch < ApplicationRecord
    audited
    include CaptureAuthor

    STATUSES = {
        "NOT_PROCESS" => "Not Process",
        "PROCESSING" => "Processing",
        "PROCESS_FAILED" => "Process Failed",
        "PENDING" => "Pending",
        "SUCCESS" => "Success",
        "FAILED" => "Failed Payment Found"
    }

    has_many :insurance_payments
    has_many :ip_invoices, as: :batchable

    after_create :update_code

    def update_code
        self.update({
          code: sprintf("#{Time.now.strftime("%Y%m%d")}%06d", self.id)
        })
    end

    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where('insurance_payment_batches.code = ?', "#{code}")
    end

    def self.search_status(status)
        return all if status.blank?
        joins(:ip_invoices).where('ip_invoices.status = ?',status)
    end

    def self.search_date_range(start_date,end_date)
        return all if (start_date.blank? && end_date.blank?)

        if start_date.blank? || end_date.blank? 
            return where.not('DATE(insurance_payment_batches.end_date) < ?',start_date) if start_date.present?
            return where.not('DATE(insurance_payment_batches.start_date) > ?',end_date) if end_date.present?
        else 
            where.not('DATE(insurance_payment_batches.end_date) < ? or DATE(insurance_payment_batches.start_date) > ?', start_date, end_date)
        end
    end
end
