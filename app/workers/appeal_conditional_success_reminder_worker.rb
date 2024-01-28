class AppealConditionalSuccessReminderWorker
    include Sidekiq::Worker

    def perform(*args)
        # Send reminder email to employer to send back the fw
        reminder_day = SystemConfiguration.find_by(code: "CONDITIONAL_SUCCESS_REMINDER_DAYS").value

        t = Transaction.select("transactions.*, employers.email employer_email").joins(:employer)
        .joins("inner join medical_appeals medical_appeals on transactions.id=medical_appeals.transaction_id")
        .where(medical_appeals: {result: ['CONDITIONAL_SUCCESSFUL'], latest_appeal: :true})
        .where("transaction_date between ? and ?", reminder_day.to_i.days.ago.beginning_of_day, reminder_day.to_i.days.ago.end_of_day)

        t.each do |transaction|
            if transaction.employer_email.present?
                AppealMailer.with({
                    transaction: transaction,
                }).conditional_success_reminder_email.deliver_later
            end
        end
    end
end