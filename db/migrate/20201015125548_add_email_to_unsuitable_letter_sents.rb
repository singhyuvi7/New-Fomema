class AddEmailToUnsuitableLetterSents < ActiveRecord::Migration[6.0]
    def change
        add_column :unsuitable_letter_sents, :email, :string
    end
end
