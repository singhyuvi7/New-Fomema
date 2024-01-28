class AddingDeletedAtAndAuthorFieldsToVariousJoeyTables < ActiveRecord::Migration[6.0]
    def change
        add_column :medical_reviews, :created_by, :bigint
        add_column :medical_reviews, :updated_by, :bigint
        add_column :medical_reviews, :deleted_at, :datetime
        add_index :medical_reviews, :created_by
        add_index :medical_reviews, :updated_by
        add_index :medical_reviews, :deleted_at

        add_column :quarantine_reasons, :created_by, :bigint
        add_column :quarantine_reasons, :updated_by, :bigint
        add_column :quarantine_reasons, :deleted_at, :datetime
        add_index :quarantine_reasons, :created_by
        add_index :quarantine_reasons, :updated_by
        add_index :quarantine_reasons, :deleted_at
        remove_column :quarantine_reasons, :is_active # will be using deleted_at

        add_column :transaction_quarantine_reasons, :created_by, :bigint
        add_column :transaction_quarantine_reasons, :updated_by, :bigint
        add_column :transaction_quarantine_reasons, :deleted_at, :datetime
        add_index :transaction_quarantine_reasons, :created_by
        add_index :transaction_quarantine_reasons, :updated_by
        add_index :transaction_quarantine_reasons, :deleted_at

        add_column :tcupi_reviews, :created_by, :bigint
        add_column :tcupi_reviews, :updated_by, :bigint
        add_column :tcupi_reviews, :deleted_at, :datetime
        add_index :tcupi_reviews, :created_by
        add_index :tcupi_reviews, :updated_by
        add_index :tcupi_reviews, :deleted_at
        rename_column :tcupi_reviews, :review_decision, :medical_mle1_decision
        rename_column :tcupi_reviews, :justification, :medical_mle1_comment
        rename_column :tcupi_reviews, :approval_decision, :medical_mle2_decision
        rename_column :tcupi_reviews, :approval_remark, :medical_mle2_comment

        add_column :tcupi_todos, :deleted_at, :datetime
        add_index :tcupi_todos, :deleted_at
        rename_column :tcupi_todos, :others, :is_active
        remove_column :tcupi_todos, :code # no use at all

        add_column :transaction_tcupi_todos, :deleted_at, :datetime
        add_index :transaction_tcupi_todos, :deleted_at
        remove_column :transaction_tcupi_todos, :transaction_id # not used anymore

        add_column :tcupi_letters, :created_by, :bigint
        add_column :tcupi_letters, :updated_by, :bigint
        add_column :tcupi_letters, :deleted_at, :datetime
        add_index :tcupi_letters, :created_by
        add_index :tcupi_letters, :updated_by
        add_index :tcupi_letters, :deleted_at

        add_column :transaction_reversions, :updated_by, :bigint
        add_column :transaction_reversions, :deleted_at, :datetime
        add_index :transaction_reversions, :updated_by
        add_index :transaction_reversions, :deleted_at
        rename_column :transaction_reversions, :user_id, :created_by

        add_column :transaction_amendments, :updated_by, :bigint
        add_column :transaction_amendments, :deleted_at, :datetime
        add_index :transaction_amendments, :updated_by
        add_index :transaction_amendments, :deleted_at
        rename_column :transaction_amendments, :user_id, :created_by

        add_column :transaction_result_updates, :updated_by, :bigint
        add_column :transaction_result_updates, :deleted_at, :datetime
        add_index :transaction_result_updates, :updated_by
        add_index :transaction_result_updates, :deleted_at
        rename_column :transaction_result_updates, :user_id, :created_by

        add_column :transaction_unsuitable_reasons, :created_by, :bigint
        add_index :transaction_unsuitable_reasons, :created_by
        rename_column :transaction_unsuitable_reasons, :modified_by_id, :updated_by
        remove_column :transaction_unsuitable_reasons, :modified_at # no point knowing this
        rename_column :transaction_unsuitable_reasons, :removed_at, :deleted_at

        add_column :unsuitable_reasons, :created_by, :bigint
        add_column :unsuitable_reasons, :updated_by, :bigint
        add_column :unsuitable_reasons, :deleted_at, :datetime
        add_index :unsuitable_reasons, :created_by
        add_index :unsuitable_reasons, :updated_by
        add_index :unsuitable_reasons, :deleted_at

        add_column :unsuitable_letter_sents, :created_by, :bigint
        add_column :unsuitable_letter_sents, :updated_by, :bigint
        add_column :unsuitable_letter_sents, :deleted_at, :datetime
        add_index :unsuitable_letter_sents, :created_by
        add_index :unsuitable_letter_sents, :updated_by
        add_index :unsuitable_letter_sents, :deleted_at

        add_column :moh_notifications, :deleted_at, :datetime
        add_index :moh_notifications, :deleted_at

        add_column :transaction_statics, :created_by, :bigint
        add_column :transaction_statics, :updated_by, :bigint
        add_column :transaction_statics, :deleted_at, :datetime
        add_index :transaction_statics, :created_by
        add_index :transaction_statics, :updated_by
        add_index :transaction_statics, :deleted_at

        add_column :report_cronjobs, :created_by, :bigint
        add_column :report_cronjobs, :updated_by, :bigint
        add_index :report_cronjobs, :created_by
        add_index :report_cronjobs, :updated_by

        add_column :report_cronjob_emails, :created_by, :bigint
        add_column :report_cronjob_emails, :updated_by, :bigint
        add_index :report_cronjob_emails, :created_by
        add_index :report_cronjob_emails, :updated_by

        add_column :report_cronjob_mail_sents, :created_by, :bigint
        add_column :report_cronjob_mail_sents, :updated_by, :bigint
        add_column :report_cronjob_mail_sents, :deleted_at, :datetime
        add_index :report_cronjob_mail_sents, :created_by
        add_index :report_cronjob_mail_sents, :updated_by
        add_index :report_cronjob_mail_sents, :deleted_at

        rename_column :appeal_todos, :removed_at, :deleted_at
        remove_column :appeal_todos, :code # does not map to anything on our side

        add_column :medical_appeal_todos, :created_by, :bigint
        add_column :medical_appeal_todos, :updated_by, :bigint
        add_index :medical_appeal_todos, :created_by
        add_index :medical_appeal_todos, :updated_by
        rename_column :medical_appeal_todos, :removed_at, :deleted_at
        rename_column :medical_appeal_todos, :doctor_remarks, :comment

        add_column :medical_appeal_comments, :updated_by, :bigint
        add_index :medical_appeal_comments, :updated_by
        rename_column :medical_appeal_comments, :user_id, :created_by
        rename_column :medical_appeal_comments, :removed_at, :deleted_at

        add_column :medical_appeal_assignments, :updated_by, :bigint
        add_index :medical_appeal_assignments, :updated_by
        add_column :medical_appeal_assignments, :deleted_at, :bigint
        add_index :medical_appeal_assignments, :deleted_at
        rename_column :medical_appeal_assignments, :whodidit_id, :created_by
        rename_column :medical_appeal_assignments, :user_type, :original_user_type
        rename_column :medical_appeal_assignments, :user_id, :original_user_id

        add_column :medical_appeal_approvals, :created_by, :bigint
        add_column :medical_appeal_approvals, :updated_by, :bigint
        add_column :medical_appeal_approvals, :deleted_at, :datetime
        add_index :medical_appeal_approvals, :created_by
        add_index :medical_appeal_approvals, :updated_by
        add_index :medical_appeal_approvals, :deleted_at
        rename_column :medical_appeal_approvals, :result, :medical_mle1_decision
        rename_column :medical_appeal_approvals, :status, :medical_mle2_decision
        rename_column :medical_appeal_approvals, :mle1_decision_at, :medical_mle1_decision_at
        rename_column :medical_appeal_approvals, :mle2_decision_at, :medical_mle2_decision_at
        rename_column :medical_appeal_approvals, :mle1_appeal_remarks, :medical_mle1_comment
        rename_column :medical_appeal_approvals, :mle2_appeal_remarks, :medical_mle2_comment

        add_column :medical_appeals, :updated_by, :bigint
        add_column :medical_appeals, :deleted_at, :datetime
        add_index :medical_appeals, :updated_by
        add_index :medical_appeals, :deleted_at
        rename_column :medical_appeals, :registered_by_id, :created_by
        rename_column :medical_appeals, :medical_mle1_id, :officer_in_charge_id
        remove_column :medical_appeals, :registration_date
    end
end