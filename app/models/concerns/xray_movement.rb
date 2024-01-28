module XrayMovement
    extend ActiveSupport::Concern

    included do
        has_many :digital_xray_movements, as: :moveable
    end

    def submit_movement(action, description = nil)
        if [PcrPool, PcrReview].include?(self.class) && medical_appeal_id?
            digital_xray_movements.create(
                transaction_id:     medical_appeal.transaction_id,
                status:             action,
                description:        description,
                moveable_type:      "XrayRetake",
                moveable_id:        self.class == PcrReview ? poolable.xray_retake_id : xray_retake_id
            )
        else
            digital_xray_movements.create(transaction_id: transaction_id, status: action, description: description)
        end
    end
end