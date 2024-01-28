class ApInvoiceBatch < ApplicationRecord
    belongs_to :batchable, polymorphic: true
end
