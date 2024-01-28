class EmployersTransactionReminderWorker < ActionController::Base
  include Sidekiq::Worker

  def perform(*args)
    # Remind employers 3 months, 2 months and 1 month before their foreign worker's transaction expires.
    # Transaction expires in 1 year. Check for transactions dated 9 months ago for 3 months left, 10 months ago for 2
    # months left, 11 months ago for 1 month left before their transaction expires. - Justin
    months_ago = [9, 10, 11]

    months_ago.each do |m|
      nth_month_ago   = m.months.ago.beginning_of_day..m.months.ago.end_of_day

        data = Transaction.where(transaction_date: nth_month_ago, status: "CERTIFIED", final_result: "SUITABLE")
          .group_by(&:employer_id)

        data.each do |employer_id, transactions|
          @csv  = [["Passport.No", "Worker Name", "Registration Date", "Certify Date"]]
          emp   = Employer.find(employer_id)
          next if emp.blank? || emp.email.blank?

          transactions.each do |transaction|
            fw        = transaction.foreign_worker
            cert_date = transaction.certification_date
            reg_date  = transaction.transaction_date

            @csv << [
              fw.passport_number,
              fw.name,
              reg_date.strftime("#{reg_date.day.ordinalize} %b %Y"),
              cert_date.strftime("#{cert_date.day.ordinalize} %b %Y")
            ]
          end

          EmployerMailer.with({
            email:          emp.email,
            csv:            CSV.generate { |csv| @csv.map{ |row| csv << row } },
            trans_date:     m.months.ago.strftime("#{m.months.ago.day.ordinalize} %b %Y"),
            months_overdue: m
          }).fw_transaction_reminder.deliver_later
      end
    end
  end
end