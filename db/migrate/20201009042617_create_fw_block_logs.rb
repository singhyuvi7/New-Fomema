class CreateFwBlockLogs < ActiveRecord::Migration[6.0]
    def change
        create_table :fw_block_logs do |t|
            t.belongs_to :foreign_worker, index: true
            t.string :action
            t.bigint :block_reason_id, index: true
            t.text :comment
            t.bigint :requested_by, index: true
            t.datetime :requested_at
            t.string :approval_decision
            t.text :approval_comment
            t.bigint :approval_by, index: true
            t.datetime :approval_at
            t.timestamps
            t.bigint :created_by, index: true
            t.bigint :updated_by, index: true
        end
    end
end
