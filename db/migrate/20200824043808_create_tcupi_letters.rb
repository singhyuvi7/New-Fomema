class CreateTcupiLetters < ActiveRecord::Migration[6.0]
    def change
        create_table :tcupi_letters do |t|
            t.bigint    :transaction_id
            t.string    :letter_type
            t.integer   :letter_id
            t.timestamps
        end

        add_index :tcupi_letters, :transaction_id
        add_index :tcupi_letters, :letter_type
        add_index :tcupi_letters, :letter_id
    end
end