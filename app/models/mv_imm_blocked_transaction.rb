class MvImmBlockedTransaction < ApplicationRecord
    belongs_to :foreign_worker
    belongs_to :employer
end
