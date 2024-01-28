class CreateTransactionChangeSps < ActiveRecord::Migration[6.0]
    def change
        create_table :transaction_change_sps do |t|
            t.bigint :transaction_id, index: true
            t.bigint :change_sp_reason_id, index: true
            t.text :requester_comment
            t.bigint :old_doctor_id
            t.bigint :old_laboratory_id
            t.bigint :old_xray_facility_id
            t.bigint :new_doctor_id
            t.bigint :new_laboratory_id
            t.bigint :new_xray_facility_id
            t.bigint :requested_by, index: true
            t.datetime :requested_at
            t.text :approval_comment
            t.bigint :approval_by, index: true
            t.datetime :approval_at
            t.string :decision
            t.string :status, index: true
            t.timestamps
            t.bigint :created_by
            t.bigint :updated_by
        end
    end
end
