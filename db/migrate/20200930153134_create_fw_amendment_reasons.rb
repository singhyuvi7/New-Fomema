class CreateFwAmendmentReasons < ActiveRecord::Migration[6.0]
    def change
        create_table :fw_amendment_reasons do |t|
            t.bigint :fw_amendment_id, index: true
            t.bigint :amendment_reason_id, index: true
            t.timestamps
            t.bigint :created_by
            t.bigint :updated_by
        end
    end
end
