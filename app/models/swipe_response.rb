# frozen_string_literal: true

require 'swipe'

class SwipeResponse < ApplicationRecord
    RESPONSE_CATEGORIES = {
        "RESPONSE" => "Response",
        "BACKEND" => "Backend"
    }

    # enum status: { success: '1' }     # for reference only

    audited
    include CaptureAuthor

    belongs_to :swipe_request
    belongs_to :swipe_type, :foreign_key => 'payment_id', :primary_key => 'code', :optional => true

    scope :success, -> { where(status: '1') }

    def calculate_signature(payment_method)
        signature_string = [Swipe.merchant_key(payment_method), merchant_code, payment_id, reference_number, (amount*100).to_i, currency, status].join("")
        Swipe.sha256(signature_string)
    end
end
