class MedicalAppealApproval < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    belongs_to :medical_appeal, inverse_of: :medical_appeal_approvals, optional: true
    belongs_to :medical_mle1,   class_name: "User", foreign_key: "medical_mle1_id", inverse_of: :appeal_mle2_approvals, optional: true
    belongs_to :medical_mle2,   class_name: "User", foreign_key: "medical_mle2_id", inverse_of: :appeal_mle2_approvals, optional: true

    validates :medical_appeal_id,           presence: true
end