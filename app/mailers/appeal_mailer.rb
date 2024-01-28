# bundle exec sidekiq -q default -q mailers

class AppealMailer < ApplicationMailer
	def employer_appeal_reminder_email
		@appeal = params[:appeal]
		@doctor = Doctor.find_by(id: @appeal.doctor_id)

		if ["Employer", "User"].include?(@appeal.registered_by_type)
			mail(to: @appeal.transactionz.employer.email, subject: "REMINDER OF NEW APPEAL CASE")
		elsif @appeal.registered_by_type == "Agency"
			mail(to: @appeal.transactionz.agency.email, subject: "REMINDER OF NEW APPEAL CASE")
		end
	end

	def doctor_appeal_reminder_email
		@appeal = params[:appeal]
        @url = params[:url]
		@doctor = Doctor.find_by(id: @appeal.doctor_id)

		mail(to: @doctor.email, subject: "REMINDER OF NEW APPEAL CASE")
	end

	def conditional_success_reminder_email
		@transaction = params[:transaction]
		@employer = Employer.find_by(id: @transaction.employer_id)
		mail(to: @employer.email, subject: "PERINGATAN MESRA UNTUK MENGHANTAR PULANG PEKERJA ASING SELEPAS PELEPASAN UNTUK TEMPOH SATU (1) TAHUN BERAKHIR")
    end
end