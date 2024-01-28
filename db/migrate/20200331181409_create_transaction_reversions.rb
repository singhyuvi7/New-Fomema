class CreateTransactionReversions < ActiveRecord::Migration[6.0]
    def change
        create_table :transaction_reversions do |t|
            t.bigint    :transaction_id
            t.integer   :user_id
            t.string    :exam_type
            t.text      :issues
            t.timestamps
        end

        add_index :transaction_reversions, :transaction_id
        add_index :transaction_reversions, :user_id
    end
end