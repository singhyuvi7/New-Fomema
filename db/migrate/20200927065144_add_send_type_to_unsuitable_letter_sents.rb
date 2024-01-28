class AddSendTypeToUnsuitableLetterSents < ActiveRecord::Migration[6.0]
    def change
        add_column :unsuitable_letter_sents, :send_type, :string
    end
end