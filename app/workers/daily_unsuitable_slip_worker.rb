class DailyUnsuitableSlipWorker
    include Sidekiq::Worker
    include Transaction::Appeals

    def perform(*args)
        # This will send unsuitable slips at 5 minutes past midnight everyday, for all cases with final_result = "UNSUITABLE".
        date            = Date.yesterday
        transactions    = Transaction.select("transactions.*, employers.email employer_email").joins(:queued_unsuitable_slips, :employer).where(queued_unsuitable_slips: { created_at: date...date.tomorrow.end_of_day})

        # Must uniq, incase there are multiple queued instances.
        transactions.uniq.each do |transaction|
            sent_count = UnsuitableLetterSent.where(transaction_id: transaction.id, send_type: ['FINAL_RESULT', 'APPEAL_REMINDER']).count

            if transaction.status == "CERTIFIED" && transaction.final_result == "UNSUITABLE" && transaction.employer_email.present? && sent_count <= 0
                if transaction.blocked_appeal_list("Doctor").present? && !(transaction.blocked_appeal_list("Doctor").include? "A previous appeal was made for this foreign worker")
                    # Transaction not allow to appeal
                    TransactionMailer.send_unsuitable_letter_cannot_appeal(transaction.id).deliver_later
                    UnsuitableLetterSent.create(transaction_id: transaction.id, send_type: "FINAL_RESULT", email: transaction.employer_email)
                else
                    # Transaction allow to appeal, send appeal reminder
                    TransactionMailer.send_unsuitable_appeal_reminder(transaction.id).deliver_later
                    UnsuitableLetterSent.create(transaction_id: transaction.id, send_type: "APPEAL_REMINDER", email: transaction.employer_email)
                end
            end
        end

        # Transaction without appeal within 14 days
        no_appeal_within_x_days = SystemConfiguration.find_by(code: "SEND_UNSUITABLE_EMAIL_AFTER_X_DAYS_WITHOUT_APPEAL").value;
        transactions_without_appeal = Transaction.select("transactions.*, employers.email employer_email").joins(:queued_unsuitable_slips, :employer).where(queued_unsuitable_slips: { created_at: no_appeal_within_x_days.to_i.days.ago.beginning_of_day..no_appeal_within_x_days.to_i.days.ago.end_of_day })

        transactions_without_appeal.uniq.each do |transaction|
            if transaction.status == "CERTIFIED" && transaction.final_result == "UNSUITABLE" && !transaction.latest_medical_appeal.present? && transaction.employer_email.present?
                if !transaction.blocked_appeal_list("Doctor").present?
                    TransactionMailer.send_unsuitable_letter(transaction.id).deliver_later
                    UnsuitableLetterSent.create(transaction_id: transaction.id, send_type: "FINAL_RESULT", email: transaction.employer_email)
                end
            end
        end

        # Transaction with appeal, send unsuitable letter after appeal completed
        transactions_with_appeal = Transaction.select("transactions.*, employers.email employer_email").where(final_result: 'UNSUITABLE').joins(:queued_unsuitable_slips, :employer).where(queued_unsuitable_slips: { created_at: 6.months.ago...Date.today.end_of_day }).joins("left join medical_appeals medical_appeals on transactions.id=medical_appeals.transaction_id").where(medical_appeals: {result: ['CANCEL/CLOSE', 'SUCCESSFUL', 'UNSUCCESSFUL'], latest_appeal: :true})

        transactions_with_appeal.uniq.each do |transaction|
            sent_count = UnsuitableLetterSent.where(transaction_id: transaction.id, send_type: ['FINAL_RESULT']).count

            if transaction.status == "CERTIFIED" && transaction.final_result == "UNSUITABLE" && transaction.employer_email.present? && sent_count <= 0
                TransactionMailer.send_unsuitable_letter(transaction.id).deliver_later
                UnsuitableLetterSent.create(transaction_id: transaction.id, send_type: "FINAL_RESULT", email: transaction.employer_email)
            end
        end
    end
end