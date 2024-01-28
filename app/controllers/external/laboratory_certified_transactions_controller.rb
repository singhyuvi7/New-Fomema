class External::LaboratoryCertifiedTransactionsController < ExternalController
	before_action -> { can_access?("VIEW_LABORATORY_CERTIFIED_TRANSACTIONS") },   only: [:index]

	def index
		if params[:certification_date_start].present? || params[:certification_date_end].present?
			start_date 				= params[:certification_date_start]
			end_date 				= params[:certification_date_end]
			laboratory 				= Laboratory.find_by(code: current_user.code)
			service_provider_group 	= laboratory.service_provider_group
			lab_ids 		 		= service_provider_group.present? ? service_provider_group.laboratories.ids : laboratory.id

			transactions 		= Transaction.where(laboratory_id: lab_ids).where.not(certification_date: nil)
				.select("transactions.code trans_code, transactions.certification_date trans_certification_date, transactions.fw_gender fw_gender, transaction_details.lab_code lab_code, foreign_workers.code fw_code, foreign_workers.name fw_name, case when transactions.fw_gender = 'M' then lab_male_rate else lab_female_rate end amount")
				.joins(:transaction_detail, :foreign_worker)
				.search_certification_date_start(start_date)
				.search_certification_date_end(end_date)
		end

		respond_to do |format|
			format.html {
				@transactions = transactions.order("lab_code ASC, trans_certification_date ASC").page(params[:page]).per(get_per) if transactions
			}

			format.csv 	{
				redirect_to external_laboratory_certified_transactions_path, alert: "Please select date range and filter first" and return if transactions.blank?

				send_data Laboratory.export_invoice_to_csv(
					transactions.order("transaction_details.lab_code ASC, transactions.certification_date ASC"),
					current_user,
					start_date,
					end_date
				),
				filename: "certification_#{start_date.to_date.try(:strftime, "%Y%m%d")}_#{end_date.to_date.try(:strftime, "%Y%m%d")}.csv"
			}
        end
	end

end