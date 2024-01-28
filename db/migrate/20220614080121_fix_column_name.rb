class FixColumnName < ActiveRecord::Migration[6.0]
    def change
        rename_column :medical_reviews, :medical_mle_qa_by, :qa_by
        rename_column :medical_reviews, :medical_mle_qa_status, :qa_decision
        rename_column :medical_reviews, :medical_mle_qa_comment, :qa_comment
        rename_column :medical_reviews, :medical_mle_qa_status_at, :qa_decision_at
        rename_column :medical_reviews, :is_iqa, :is_qa
    end
end
