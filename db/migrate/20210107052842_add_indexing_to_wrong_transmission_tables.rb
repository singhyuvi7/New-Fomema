class AddIndexingToWrongTransmissionTables < ActiveRecord::Migration[6.0]
    def change
        add_index :transaction_result_updates, :created_at
        add_index :transaction_reversions, :exam_type
        add_index :transaction_reversions, :created_at
    end
end