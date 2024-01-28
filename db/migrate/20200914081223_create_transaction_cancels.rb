class CreateTransactionCancels < ActiveRecord::Migration[6.0]
    def change
        create_table :transaction_cancels do |t|
            t.bigint :transaction_id, index: true
            t.bigint :cancelled_by, index: true
            t.datetime :cancelled_at
            t.text :reason
            t.bigint :fee_id, index: true
            t.string :status, index: true
            t.timestamps
            t.bigint :created_by
            t.bigint :updated_by
        end
    end
end
