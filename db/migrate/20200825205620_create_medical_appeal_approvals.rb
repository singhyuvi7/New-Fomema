class CreateMedicalAppealApprovals < ActiveRecord::Migration[6.0]
    def change
        create_table :medical_appeal_approvals do |t|
            t.integer :medical_appeal_id
            t.string :result
            t.string :status
            t.integer :medical_mle1_id
            t.integer :medical_mle2_id
            t.datetime :mle1_decision_at
            t.datetime :mle2_decision_at
            t.text :mle1_appeal_remarks
            t.text :mle2_appeal_remarks
            t.timestamps
        end

        add_index :medical_appeal_approvals, :medical_appeal_id
        add_index :medical_appeal_approvals, :result
        add_index :medical_appeal_approvals, :status
        add_index :medical_appeal_approvals, :medical_mle1_id
        add_index :medical_appeal_approvals, :medical_mle2_id
        add_index :medical_appeal_approvals, :mle1_decision_at
        add_index :medical_appeal_approvals, :mle2_decision_at
    end
end