class OrderPaymentHoldLog < ApplicationRecord
    audited
    include CaptureAuthor

    belongs_to :order_payment
    belongs_to :holder, class_name: "User", foreign_key: "holded_by", optional: true
    belongs_to :unholder, class_name: "User", foreign_key: "unholded_by", optional: true
end
