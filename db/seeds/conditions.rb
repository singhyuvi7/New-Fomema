@comment_list = Condition.comment_conditions

medical_conditions = [Condition.medical_history_conditions, Condition.medical_physical_conditions, Condition.medical_system_conditions_1, Condition.medical_system_conditions_2, Condition.medical_certification_conditions, Condition.medical_follow_up_conditions]

medical_conditions.each do |medical_hash|
    medical_hash.each do |code, description|
        condition = Condition.with_deleted.find_or_initialize_by(code: code, exam_type: "DOC")
        condition.description = description
        condition.field_type = @comment_list.include?(code) ? "COMMENT" : "DETAIL"
        condition.save
    end
end

Condition.laboratory_exam_conditions.each do |code, description|
    condition = Condition.with_deleted.find_or_initialize_by(code: code, exam_type: "LAB")
    condition.description = description
    condition.field_type = @comment_list.include?(code) ? "COMMENT" : "DETAIL"
    condition.save
end

Condition.xray_examination_conditions.each do |code, description|
    condition = Condition.with_deleted.find_or_initialize_by(code: code, exam_type: "XRAY")
    condition.description = description
    condition.field_type = @comment_list.include?(code) ? "COMMENT" : "DETAIL"
    condition.save
end

Condition.fomema_old_exam_conditions.each do |code, description|
    condition = Condition.with_deleted.find_or_initialize_by(code: code, exam_type: "OLD")
    condition.description = description
    condition.field_type = @comment_list.include?(code) ? "COMMENT" : "DETAIL"
    condition.deleted_at ||= Time.now
    condition.save
end

# xray_reviews
XrayReview::CONDITION_DETAILS.each do |code, description|
    condition = Condition.where(code: code, exam_type: "XRAY_REVIEW", field_type: "DETAIL").first_or_create
    condition.update({
        description: description
    })
end

# pcr_reviews
PcrReview::CONDITION_DETAILS.each do |code, description|
    condition = Condition.where(code: code, exam_type: "PCR_REVIEW", field_type: "DETAIL", category: "REPORTING").first_or_create
    condition.update({
        description: description
    })
end
PcrReview::CONDITION_COMMENTS.each do |code, description|
    condition = Condition.where(code: code, exam_type: "PCR_REVIEW", field_type: "COMMENT", category: "REPORTING").first_or_create
    condition.update({
        description: description
    })
end
PcrReview::QUALITY_DETAILS.each do |code, description|
    condition = Condition.where(code: code, exam_type: "PCR_REVIEW", field_type: "DETAIL", category: "QUALITY").first_or_create
    condition.update({
        description: description
    })
end
PcrReview::QUALITY_COMMENTS.each do |code, description|
    condition = Condition.where(code: code, exam_type: "PCR_REVIEW", field_type: "COMMENT", category: "QUALITY").first_or_create
    condition.update({
        description: description
    })
end

puts "conditions seeded"