class Internal::TransactionTcupiTodosController < InternalController
	before_action :set_transaction
	before_action :set_medical_review
	before_action :set_tcupi_review

	def manage_todos
		@tcupi_todos 			= @tcupi_review.transaction_tcupi_todos.includes(:tcupi_todo).order(:tcupi_todo_id)
		@tcupi_todo_list		= TcupiTodo.where(is_active: true)

		if params[:tcupi_to_dos].present?
			to_do_other_bool_exists = params[:tcupi_todo_other_bool].present? && params[:tcupi_todo_other_bool] == "YES"
			to_do_other_hash = if to_do_other_bool_exists
				{"7" => params[:tcupi_to_do_other]}
			else
				{"7" => "NO"}
			end

			TransactionTcupiTodo.update_to_dos(
				@tcupi_review,
				params[:tcupi_to_dos].merge(to_do_other_hash),
				to_do_other_bool_exists ? params[:tcupi_to_do_other] : nil
			)

			redirect_to tcupi_review_internal_medical_path(@transaction, p_tab: 'review_decision', tab: 'to_do_list'), notice: "To-Do List succesfully updated."
		end
	end

	private
		def set_transaction
			@transaction        = Transaction.find(params[:id])
		end

		def set_medical_review
			@medical_review 	= @transaction.latest_medical_review
		end

		def set_tcupi_review
			@tcupi_review 		= @transaction.latest_tcupi_review
		end
end