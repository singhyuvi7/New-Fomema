class DigitalXrayMovement < ApplicationRecord

  audited
  include CaptureAuthor
  include ParentTransactionScope
  include OrderScope

  belongs_to :transactionz, foreign_key: "transaction_id", class_name: "Transaction", optional: true
  belongs_to :medical_appeal, foreign_key: "medical_appeal_id", class_name: "MedicalAppeal", optional: true

  belongs_to :moveable, polymorphic: true, optional: true

end
