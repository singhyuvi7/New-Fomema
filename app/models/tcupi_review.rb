class TcupiReview < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    belongs_to :transactionz,   foreign_key: "transaction_id", class_name: "Transaction", inverse_of: :tcupi_reviews

    belongs_to :medical_mle1,   class_name: "User", foreign_key: "medical_mle1_id", inverse_of: :mle1_tcupi_reviews, optional: true
    belongs_to :medical_mle2,   class_name: "User", foreign_key: "medical_mle2_id", inverse_of: :mle2_tcupi_reviews, optional: true

    has_many :transaction_tcupi_todos
    has_many :tcupi_todos, through: :transaction_tcupi_todos

    validates :transaction_id, presence: true

    def displayed_status
        if medical_mle2_decision_at?
            "Reviewed"
        elsif medical_mle1_decision_at?
            "Pending 2nd MLE's Review Decision"
        else
            "Pending 1st MLE's Review"
        end
    end

    def approved_result
        medical_mle1_decision if medical_mle2_decision_at? && medical_mle2_decision == "APPROVE"
    end

    def list_of_tcupi_todos
        transaction_tcupi_todos.order(:tcupi_todo_id).includes(:tcupi_todo).map do |tran_tcupi_todo|
            if tran_tcupi_todo.tcupi_todo_id == 7
                "#{ tran_tcupi_todo.tcupi_todo&.description } - #{ tran_tcupi_todo.description_other }"
            else
                tran_tcupi_todo.tcupi_todo&.description
            end
        end
    end
end