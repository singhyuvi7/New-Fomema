module MedicalExaminationInitializer
    def create_medical_examination(transaction)
        doctor_attributes       = transaction.doctor_examination.attributes.with_indifferent_access.except(:id, :doctor_id, :created_at, :updated_at, :created_by, :updated_by, :transmitted_at)

        # If exam rollbacks on uniqueness, will requery instead.
        begin
            medical_exam        = MedicalExamination.create(doctor_attributes)
        rescue ActiveRecord::RecordNotUnique
            medical_exam        = transaction.reload.medical_examination
        end

        transaction.doctor_examination_details.each do |de_detail|
            detail_parameters   = de_detail.slice(:transaction_id, :condition_id, :date_value, :text_value)
            medical_exam.medical_examination_details.find_or_create_by(detail_parameters)
        end

        transaction.doctor_examination_comments.each do |de_comment|
            comment_parameters  = de_comment.slice(:transaction_id, :condition_id, :comment)
            medical_exam.medical_examination_comments.find_or_create_by(comment_parameters)
        end

        medical_exam
    end
end
