class TcupiLetter < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor
    include Sequence

    belongs_to :transactionz, foreign_key: "transaction_id", class_name: "Transaction", optional: true

    validates :transaction_id,  presence: true
    validates :letter_type,     presence: true

    after_create :set_letter_id

    def set_letter_id
        self.update(letter_id: seq_nextval('tcupi_letter_seq'))
    end
end