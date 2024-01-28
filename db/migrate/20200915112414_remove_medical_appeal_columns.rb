class RemoveMedicalAppealColumns < ActiveRecord::Migration[6.0]
    def change
        remove_column :medical_appeals, :medical_mle2_id
        remove_column :medical_appeals, :mle1_appeal_remarks
        remove_column :medical_appeals, :mle2_appeal_remarks
        remove_column :medical_appeals, :mle1_decision_at
        remove_column :medical_appeals, :mle2_decision_at
        remove_column :medical_appeals, :reject_comment
        remove_column :medical_appeals, :rejected_at
        remove_column :medical_appeals, :rejected_by_id
        remove_column :medical_appeals, :cancel_request_at
    end
end