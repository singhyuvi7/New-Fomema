class QuarantineReason < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    has_many :transaction_quarantine_reasons
    has_many :transactions, through: :transaction_quarantine_reasons, source: :transactionz

    validates :code,        presence: true
    validates :reason,      presence: true
end