class TransactionCart < ApplicationRecord
    include CaptureAuthor
    
    belongs_to :foreign_worker
end
