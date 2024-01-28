class MedicalAppealComment < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

	belongs_to :medical_appeal, inverse_of: :medical_appeal_comments, optional: true
	belongs_to :user, 			class_name: "User", foreign_key: "created_by", inverse_of: :medical_appeal_comments, optional: true

	validates :comment, 		presence: true
end