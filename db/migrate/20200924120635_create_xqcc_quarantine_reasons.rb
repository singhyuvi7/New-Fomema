class CreateXqccQuarantineReasons < ActiveRecord::Migration[6.0]
    def change
        create_table :xqcc_quarantine_reasons do |t|
            t.bigint :transaction_id, index: true
            t.bigint :quarantine_reason_id, index: true
            t.timestamps
            t.bigint :created_by
            t.bigint :updated_by
            t.datetime :deleted_at
        end
    end
end
