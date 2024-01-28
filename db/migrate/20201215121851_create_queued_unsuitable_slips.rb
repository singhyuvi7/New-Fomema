class CreateQueuedUnsuitableSlips < ActiveRecord::Migration[6.0]
    def change
        create_table :queued_unsuitable_slips do |t|
            t.bigint :transaction_id
            t.timestamps
        end

        add_index :queued_unsuitable_slips, :transaction_id
        add_index :queued_unsuitable_slips, :created_at
    end
end