class MedicalReview < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    belongs_to :transactionz, class_name: "Transaction",    foreign_key: "transaction_id",  inverse_of: :medical_reviews
    belongs_to :medical_mle1, class_name: "User",           foreign_key: "medical_mle1_id", inverse_of: :medical_mle1_reviews, optional: true
    belongs_to :medical_mle2, class_name: "User",           foreign_key: "medical_mle2_id", inverse_of: :medical_mle2_reviews, optional: true
    belongs_to :qa_by_id,        class_name: "User",           foreign_key: "qa_by",           inverse_of: :qa_by_reviews,        optional: true

    has_many :transaction_tcupi_todos
    has_many :tcupi_todos, through: :transaction_tcupi_todos

    validates :transaction_id, presence: true

    def displayed_status
        if medical_mle2_decision_at?
            "Reviewed"
        elsif medical_mle1_decision_at? && transactionz.medical_status != "CERTIFIED" && transactionz.medical_status != "TCUPI" && transactionz.medical_status != "PENDING_PR_QA"
            "Pending 2nd MLE's Review Decision"
        elsif medical_mle1_decision_at? && transactionz.medical_status == "PENDING_PR_QA" && is_qa?
            "Pending QA's Review"
        else
           "-"
        end
    end

    def status_in_reports
        if medical_mle2_decision_at?
            medical_mle2_decision
        elsif medical_mle1_decision_at?
            "SUBMITTED BY MLE1"
        else
            "NEW_CASE"
        end
    end

    # methods
    def self.next_qa_sequence
        ActiveRecord::Base.connection.execute("SELECT nextval('medical_pr_qa_seq')")[0]["nextval"]
    end

    def self.current_qa_sequence
        ActiveRecord::Base.connection.execute("select last_value FROM medical_pr_qa_seq")[0]["last_value"]
    end

    # DECODE(FW.STATUS,'R','REJECTED','A','APPROVED','N','NEW_CASE','S','SUBMITTED BY MLE1')

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