class MedicalOriginalCondition < ApplicationRecord
    belongs_to :medical_examination, inverse_of: :medical_original_condition, optional: true

    validates :medical_examination_id, presence: true
    validates :original_params, presence: true

    def self.new_tcupi_seed(transaction)
        med_exam            = transaction.medical_examination
        certification_codes = Condition.where(code: DoctorExamination::CERTIFICATION.values).pluck(:id)
        cert_comment_id     = Condition.find_by(code: "5501").id
        detail_conditions   = med_exam.medical_examination_details.where(condition_id: certification_codes)
        comment_condition   = med_exam.medical_examination_comments.find_by(condition_id: cert_comment_id)
        parameters          = { details: detail_conditions.map(&:condition_id), comments: comment_condition&.comment }
        MedicalOriginalCondition.find_or_create_by(medical_examination_id: med_exam.id, original_params: parameters)
    end

    def self.reset_medical_conditions(transaction)
        med_exam            = transaction.medical_examination
        certification_codes = Condition.where(code: DoctorExamination::CERTIFICATION.values).pluck(:id)
        cert_comment_id     = Condition.find_by(code: "5501").id
        original_params     = med_exam.medical_original_condition.original_params
        details             = original_params["details"]
        comments            = original_params["comments"]
        detail_conditions   = med_exam.medical_examination_details.with_deleted.where(condition_id: certification_codes)
        comment_condition   = med_exam.medical_examination_comments.with_deleted.find_by(condition_id: cert_comment_id)

        if comment_condition.present?
            comments.blank? ? comment_condition.destroy : comment_condition.update(comment: comments, deleted_at: nil)
        end

        detail_conditions.each do |detail|
            if details.include?(detail.condition_id)
                detail.update(deleted_at: nil)
            else
                detail.deleted_at ||= Time.now
                detail.save
            end
        end
    end
end