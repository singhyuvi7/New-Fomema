class ReportDiffBloodgroupSeeder
    include Sidekiq::Worker

    # ReportDiffBloodgroupSeeder.new.perform("2000-10-02".to_date, Time.now)
    def perform(*date_range)
        @start_time = Time.now

        if date_range.present?
            start_date  = date_range.first
            end_date    = date_range.last
        else
            start_date  = Time.now - 2.hour
            end_date    = Time.now
        end

        transaction_ids = TransactionQuarantineReason.where(quarantine_reason_id: QuarantineReason.find_by(code: "10009"), created_at: start_date..end_date).pluck(:transaction_id).sort
        total_amount    = transaction_ids.size

        transaction_ids.each.with_index(1) do |transaction_id, index|
            pp "Transaction: #{ index }/#{ total_amount }"
            transaction     = Transaction.find(transaction_id)
            previous_2      = Transaction.where(foreign_worker_id: transaction.foreign_worker_id).where.not(final_result: nil, id: transaction.id).where("certification_date < ?", transaction.certification_date).order(certification_date: :desc).limit(2).includes(:doctor, :laboratory, :laboratory_examination)
            transaction_2   = previous_2[0]
            transaction_1   = previous_2[1]
            report          = ReportDiffBloodgroup.find_or_initialize_by(transaction_id: transaction.id)

            report.update(
                certification_date:     transaction.certification_date,
                foreign_worker_code:    transaction.fw_code,
                foreign_worker_name:    transaction.fw_name,
                doctor_code_1:          transaction_1&.doctor&.code,
                doctor_code_2:          transaction_2&.doctor&.code,
                doctor_code_3:          transaction.doctor.code,
                lab_code_1:             transaction_1&.laboratory&.code,
                lab_code_2:             transaction_2&.laboratory&.code,
                lab_code_3:             transaction.laboratory.code,
                transaction_code_1:     transaction_1&.code,
                transaction_code_2:     transaction_2&.code,
                transaction_code_3:     transaction.code,
                blood_group_1:          transaction_1&.laboratory_examination&.blood_group,
                blood_group_2:          transaction_2&.laboratory_examination&.blood_group,
                blood_group_3:          transaction.laboratory_examination.blood_group,
                rhesus_1:               transaction_1&.laboratory_examination&.blood_group_rhesus,
                rhesus_2:               transaction_2&.laboratory_examination&.blood_group_rhesus,
                rhesus_3:               transaction.laboratory_examination.blood_group_rhesus
            )

            pp ActiveSupport::Duration.build(Time.now - @start_time).inspect
        end
    end
end