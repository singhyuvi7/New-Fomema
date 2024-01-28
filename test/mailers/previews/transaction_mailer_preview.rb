# Preview all emails at http://localhost:3000/rails/mailers/transaction_mailer
class TransactionMailerPreview < ActionMailer::Preview
    def a__send_unsuitable_letter
        transaction = Transaction.where(final_result: "UNSUITABLE").order("RANDOM()").limit(1).first
        TransactionMailer.send_unsuitable_letter(transaction.id)
    end

    def b__cancel_email
    	t 	= Transaction.last
		TransactionMailer.with({transaction: t}).cancel_email
    end

    def c1__transaction_amend_email_change_of_clinic_approved
        t   = Transaction.where("transaction_date >= ?", "Aug 08, 2020".to_datetime).where(approval_status: ['NEW_APPROVED','UPDATE_APPROVED']).first
		TransactionMailer.with({transaction: t, employer: t.employer, do_refund: "Y"}).transaction_amend_email
    end

    def c2__transaction_amend_email_change_of_clinic_rejected
        t   = Transaction.where("transaction_date >= ?", "Aug 08, 2020".to_datetime).where.not(approval_status: ['NEW_APPROVED','UPDATE_APPROVED']).first
        TransactionMailer.with({transaction: t, employer: t.employer, do_refund: "Y"}).transaction_amend_email
    end
end