class RefundItem < ApplicationRecord
    audited
    include CaptureAuthor

    after_save :update_refund_amount
    
    belongs_to :refund
    belongs_to :refund_itemable, polymorphic: true, optional: true

    def update_refund_amount
        refund.update_total_amount
    end
end
