require 'boleh'

class BolehResponse < ApplicationRecord
    RESPONSE_CATEGORIES = {
        "RESPONSE" => "Response",
        "BACKEND" => "Backend"
    }

    # enum status: { success: 'approved' }     # for reference only

    include CaptureAuthor

    belongs_to :boleh_request

    scope :success, -> { where(status: 'approved') }
    scope :pending, -> { where(status: ['pending', 'pending_auth', 'processing']) }
    scope :failed, -> { where.not(status: ['approved', 'pending', 'pending_auth', 'processing']) }

    def calculate_signature
        # signature string = combining of order_id, ref_id and the api_key without any space
        signature_string = [order_number, transaction_id, status, ActionController::Base.helpers.number_to_currency(amount, unit: ''), Boleh.api_key].join("")
        Boleh.sha256(signature_string)
    end
end