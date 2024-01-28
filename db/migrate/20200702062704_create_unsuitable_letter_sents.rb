class CreateUnsuitableLetterSents < ActiveRecord::Migration[6.0]
    def change
        create_table :unsuitable_letter_sents do |t|
            t.bigint    :transaction_id
            t.timestamps
        end

        add_index :unsuitable_letter_sents, :transaction_id
    end
end