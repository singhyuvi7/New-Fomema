module ParentTransactionScope
    extend ActiveSupport::Concern

    included do
        scope :transaction_code, -> transaction_code {
            if transaction_code.present?
                joins(:transactionz).where(transactions: { code: transaction_code.strip })
            end
        }

        scope :certify_start, -> certify_start {
            unless certify_start.blank?
                joins(:transactionz).where("transactions.doctor_transmit_date >= ?", certify_start)
            end
        }

        scope :certify_end, -> certify_end {
            unless certify_end.blank?
                joins(:transactionz).where("transactions.doctor_transmit_date < ?", Time.parse(certify_end) + 1.day)
            end
        }

        scope :xray_code, -> xray_code {
            unless xray_code.blank?
                joins(:transactionz).where("exists (select 1 from xray_facilities where transactions.xray_facility_id = xray_facilities.id and xray_facilities.code ilike ?)", xray_code.strip)
            end
        }

        scope :worker_code, -> worker_code {
            unless worker_code.blank?
                joins(:foreign_worker).where(foreign_workers: { code: worker_code.strip })
            end
        }

        scope :passport_number, -> passport_number {
            unless passport_number.blank?
                joins(:foreign_worker).where(foreign_workers: { passport_number: passport_number.strip })
            end
        }
    end
end