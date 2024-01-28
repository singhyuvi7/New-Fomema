class CreateTransactionQuarantineReasons < ActiveRecord::Migration[6.0]
    def change
        create_table :transaction_quarantine_reasons do |t|
            t.bigint    :transaction_id
            t.bigint    :quarantine_reason_id
            t.timestamps
        end

        add_index :transaction_quarantine_reasons, :transaction_id
        add_index :transaction_quarantine_reasons, :quarantine_reason_id
    end
end