class CreateFirstTransactions < ActiveRecord::Migration[6.0]
    def change
        create_table :first_transactions do |t|
            t.string    :passport_number
            t.date      :date_of_birth
            t.string    :gender
            t.integer   :country_id
            t.bigint    :transaction_id
            t.timestamps
        end

        add_index :first_transactions, :passport_number
        add_index :first_transactions, :date_of_birth
        add_index :first_transactions, :gender
        add_index :first_transactions, :country_id
        add_index :first_transactions, :transaction_id
    end
end