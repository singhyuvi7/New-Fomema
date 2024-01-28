class CreateFwAmendments < ActiveRecord::Migration[6.0]
    def change
        create_table :fw_amendments do |t|
            t.bigint :approval_item_id, index: true
            t.bigint :foreign_worker_id, index: true
            t.text :comment
            t.text :approval_comment
            t.timestamps
            t.bigint :created_by
            t.bigint :updated_by
        end
    end
end
