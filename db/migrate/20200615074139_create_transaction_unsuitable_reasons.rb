class CreateTransactionUnsuitableReasons < ActiveRecord::Migration[6.0]
    def change
        create_table :transaction_unsuitable_reasons do |t|
            t.bigint    :transaction_id
            t.integer   :unsuitable_reason_id
            t.boolean   :created_by_system
            t.bigint    :modified_by_id
            t.datetime  :modified_at
            t.datetime  :removed_at
            t.timestamps
        end

        add_index :transaction_unsuitable_reasons, :transaction_id
        add_index :transaction_unsuitable_reasons, :unsuitable_reason_id
        add_index :transaction_unsuitable_reasons, :created_by_system
        add_index :transaction_unsuitable_reasons, :modified_by_id
        add_index :transaction_unsuitable_reasons, :modified_at
        add_index :transaction_unsuitable_reasons, :removed_at
    end
end