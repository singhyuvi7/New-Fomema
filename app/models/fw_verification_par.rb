class FwVerificationPar < ApplicationRecord
    include CaptureAuthor

    validates :name, :code, presence: true
end