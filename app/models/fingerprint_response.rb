class FingerprintResponse < ApplicationRecord
    belongs_to :visitable, polymorphic: true, optional: true
    belongs_to :foreign_worker
    belongs_to :fingerprint_request
    belongs_to :fw_transaction, class_name: "Transaction", foreign_key: "fw_transaction_id", optional: true
    belongs_to :responsable, polymorphic: true, optional: true

    scope :is_doctor_examination, -> {
        where(visitable_type: 'Doctor')
    }

    scope :is_xray_examination, -> {
        where(visitable_type: 'XrayFacility')
    }

end
