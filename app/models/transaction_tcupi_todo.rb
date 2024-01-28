class TransactionTcupiTodo < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    belongs_to :tcupi_todo, optional: true
    belongs_to :tcupi_review, optional: true
    belongs_to :medical_review, optional: true

    def self.update_to_dos(tcupi_review, to_do_ids, other_to_do=nil)
    	tcupi_to_do_ids     = to_do_ids.to_unsafe_h

		tcupi_to_do_ids.each do |to_do_id|
			to_do 			= tcupi_review.transaction_tcupi_todos.find_or_initialize_by(tcupi_todo_id: to_do_id[0].to_i)
			deleted_todo 	= tcupi_review.transaction_tcupi_todos.only_deleted.find_by(tcupi_todo_id: to_do.tcupi_todo_id)

			if to_do_id[1] == "YES"
				if deleted_todo.present?
					deleted_todo.update(deleted_at: nil)
				else
					to_do.save
				end
			elsif to_do_id[1] == "NO"
				to_do.destroy
			elsif to_do_id[0] == "7" # Check for to do list ~ Other reason
				description 	= other_to_do.present? ? other_to_do : nil

				if deleted_todo.present?
					deleted_todo.update(deleted_at: nil, description_other: description)
				else
					to_do.update(description_other: description)
				end
			end		
		end
    end

end