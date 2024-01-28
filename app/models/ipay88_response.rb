# frozen_string_literal: true

require 'ipay88'

class Ipay88Response < ApplicationRecord
    RESPONSE_CATEGORIES = {
        "RESPONSE" => "Response",
        "BACKEND" => "Backend"
    }

    # enum status: { success: '1' }     # for reference only

    include CaptureAuthor

    belongs_to :ipay88_request
    belongs_to :ipay88_type, :foreign_key => 'payment_id', :primary_key => 'code', :optional => true

    scope :success, -> { where(status: '1') }

    def calculate_signature(payment_method)
        signature_string = [IPay88.merchant_key(payment_method), merchant_code, payment_id, reference_number, (amount*100).to_i, currency, status].join("")
        IPay88.sha256(signature_string)
    end
end
