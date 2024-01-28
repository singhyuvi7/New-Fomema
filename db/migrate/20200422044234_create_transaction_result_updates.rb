class CreateTransactionResultUpdates < ActiveRecord::Migration[6.0]
    def change
        create_table :transaction_result_updates do |t|
            t.bigint    :transaction_id
            t.integer   :user_id
            t.text      :amendment_reason
            t.boolean   :wrong_transmission_doctor
            t.boolean   :wrong_transmission_lab
            t.boolean   :wrong_transmission_xray
            t.timestamps
        end

        add_index :transaction_result_updates, :transaction_id
        add_index :transaction_result_updates, :user_id
        add_index :transaction_result_updates, :wrong_transmission_doctor
        add_index :transaction_result_updates, :wrong_transmission_lab
        add_index :transaction_result_updates, :wrong_transmission_xray
    end
end