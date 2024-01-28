class EmployerSupplement < ApplicationRecord
    audited
    include CaptureAuthor

    belongs_to :employer
    belongs_to :state, optional: true
    belongs_to :town, optional: true
    has_many :users
end
