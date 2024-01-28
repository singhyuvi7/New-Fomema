require 'fpx'

class FpxResponse < ApplicationRecord
    RESPONSE_CATEGORIES = {
        "RESPONSE" => "Response",
        "BACKEND" => "Backend"
    }

    # enum status: { success: '00' }     # for reference only

    include CaptureAuthor

    belongs_to :fpx_request
    belongs_to :fpx_type, :foreign_key => 'msg_token', :primary_key => 'code', :optional => true

    scope :success, -> { where(debit_auth_code: '00') }
    scope :pending, -> { where(debit_auth_code: ['99', '09']) }
    scope :failed, -> { where.not(debit_auth_code: ['00', '99', '09']) }
end
