class InsurancePayment < ApplicationRecord
    audited

    PAYMENTS = {
        "HOWDEN_CODE" => "HOWDEN",
        "FGSB_CODE" => "FGSB",
        "TFSB_CODE" => "TFSB",
    }

    belongs_to :insurance_payment_batch, optional: true
    belongs_to :order
    has_many :ip_invoices
end
