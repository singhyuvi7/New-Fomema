class AddIndexingForSpecificSearches < ActiveRecord::Migration[6.0]
    def change
        add_index :unsuitable_letter_sents, :created_at
        add_index :medical_reviews, :created_at
        add_index :transactions, :created_at
        add_index :transactions, :updated_at
    end
end