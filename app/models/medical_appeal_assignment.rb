class MedicalAppealAssignment < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

	belongs_to :medical_appeal, inverse_of: :medical_appeal_assignments, optional: true
    belongs_to :user,  			polymorphic: true, 	inverse_of: :medical_appeal_assignments, optional: true

	validates :medical_appeal_id, 	presence: true
	validates :original_user_type,  presence: true
    validates :original_user_id,    presence: true
end