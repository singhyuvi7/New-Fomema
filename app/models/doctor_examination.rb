class DoctorExamination < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor
    include DoctorAndMedicalExaminationConstants
    include DoctorExaminationVisitedValues
    extend DoctorExaminationConditionList

    belongs_to :doctor
    belongs_to :transactionz, foreign_key: "transaction_id", class_name: "Transaction"

    has_many :doctor_examination_details,   inverse_of: :doctor_examination
    has_many :doctor_examination_comments,  inverse_of: :doctor_examination
    has_many :detail_conditions,            through: :doctor_examination_details,  source: :condition, inverse_of: :de_detail_exams
    has_many :comment_conditions,           through: :doctor_examination_comments, source: :condition, inverse_of: :de_comment_exams
    has_one  :doctor_examination_visited,   inverse_of: :doctor_examination

    def result_of_exam
        codes = [HISTORY, PHYSICAL, SYSTEM_1, SYSTEM_2].map {|hash| hash.values }.flatten
        vision_aided_left_id    = Condition.find_by(code: ["3407"])&.id # vision test aided left
        vision_aided_right_id   = Condition.find_by(code: ["3408"])&.id # vision test aided right
        vision_unaided_left_id  = Condition.find_by(code: ["3409"])&.id # vision test unaided left
        vision_unaided_right_id = Condition.find_by(code: ["3410"])&.id # vision test unaided right
        check_detail_condition = Condition.where(code:detail_conditions.pluck(:code) & codes)&.ids #check detail condition
        vision_aided_left=doctor_examination_details.where(transaction_id: transaction_id).where(condition_id: vision_aided_left_id).present?
        vision_aided_right=doctor_examination_details.where(transaction_id: transaction_id).where(condition_id: vision_aided_right_id).present?
        vision_unaided_left=doctor_examination_details.where(transaction_id: transaction_id).where(condition_id: vision_unaided_left_id).present?
        vision_unaided_right=doctor_examination_details.where(transaction_id: transaction_id).where(condition_id: vision_unaided_right_id).present?
        other_abnormal_not_vision_unaided_left=doctor_examination_details.where(transaction_id: transaction_id).where(condition_id: check_detail_condition).where.not(condition_id: vision_unaided_left_id).present?
        other_abnormal_not_vision_unaided_right=doctor_examination_details.where(transaction_id: transaction_id).where(condition_id: check_detail_condition).where.not(condition_id: vision_unaided_right_id).present?
        other_abnormal_not_both_vision_unaided_right_left=doctor_examination_details.where(transaction_id: transaction_id).where(condition_id: check_detail_condition).where.not(condition_id: vision_unaided_right_id).where.not(condition_id: vision_unaided_left_id).present?

        if  vision_aided_left == false && vision_unaided_left == true && other_abnormal_not_vision_unaided_left == false
            return false
        elsif vision_aided_right == false  && vision_unaided_right == true && other_abnormal_not_vision_unaided_right == false
            return false
        elsif vision_unaided_left == true &&  vision_unaided_right == true &&  vision_aided_left == false &&  vision_aided_right == false && other_abnormal_not_both_vision_unaided_right_left == false
            return false
        else
            (detail_conditions.pluck(:code) & codes).present?
        end
    end

    def check_medical_history
        #use for 3rd concurrence checking
        #IF MEDICAL HISTORY DOCTOR CLICK AS YES (FOR TB, LEPROSY, PSYCHIATRIC ILLNESS, EPILEPSY & CANCER) -
        #TO AUTO RELEASE AS UNSUITABLE. IF OTHER THAN ABOVE, TO AUTO RELEASE AS SUITABLE (ONLY IF THERE IS NO OTHER ABNORMALITY IN PHYSICAL
        #& LAB FINDING).
        codes = [HISTORY, PHYSICAL, SYSTEM_1, SYSTEM_2].map {|hash| hash.values }.flatten
        history_suitable = [HISTORY_SUITABLE].map {|hash| hash.values }.flatten
        check_all_condition = Condition.where(code:detail_conditions.pluck(:code) & codes)&.ids #check all condition
        check_history = Condition.where(code:detail_conditions.pluck(:code) & history_suitable)&.ids #check medical history
        if check_all_condition == check_history
        #check if doctor click yes in medical history exclude (TB, LEPROSY, PSYCHIATRIC ILLNESS, EPILEPSY & CANCER) return as normal
            return false
        else
            return true
        end
    end

    # Please do not use this to update detail or comments outside of the normal flow.
    # It will destroy records if you do not specify correctly.
    def save_examination_details_and_comments(hashes = {})
        @saved_conditions_list          = []
        save_details_for_dates          hashes[:date_fields]
        save_details_for_regular_fields hashes[:regular_fields]
        save_details_for_values         hashes[:value_fields]
        save_comments                   hashes[:comments]
        doctor_examination_details.where(transaction_id: transaction_id).where.not(condition_id: @saved_conditions_list).destroy_all
        doctor_examination_comments.where(transaction_id: transaction_id).where.not(condition_id: @saved_conditions_list).destroy_all
    end

    def save_details_for_dates(hash)
        return if hash.blank?
        present_details = hash.select {|key, value| (key.include?("_date") && value.present?) || value == "true" }
        bool_fields     = present_details.select {|key, value| !key.include?("_date")}.keys
        date_fields     = present_details.select {|key, value| key.include?("_date")}.keys.map {|key| key.gsub("_date", "")}
        conditions      = (bool_fields & date_fields)
        conditions      << "history_taken_drug_recently" if bool_fields.include?("history_taken_drug_recently")
        code_key_map    = HISTORY.merge(FOLLOW_UP).invert
        key_id_map      = get_key_id_map_hash(code_key_map, conditions)
        details         = doctor_examination_details.with_deleted.where(transaction_id: transaction_id, condition_id: key_id_map.values).to_a

        key_id_map.each do |detail_key, condition_id|
            de_detail               = details.find {|detail| detail.condition_id == condition_id }
            de_detail               ||= doctor_examination_details.new(transaction_id: transaction_id, condition_id: condition_id)
            de_detail.deleted_at    = nil
            de_detail.date_value    = present_details["#{ detail_key }_date"]
            @saved_conditions_list << condition_id if de_detail.save
        end
    end

    def save_details_for_regular_fields(hash)
        return if hash.blank?
        conditions      = hash.select {|key, value| value == "true" }.keys
        code_key_map    = [PHYSICAL, SYSTEM_1, SYSTEM_2, CERTIFICATION].inject(&:merge).invert
        key_id_map      = get_key_id_map_hash(code_key_map, conditions)
        details         = doctor_examination_details.with_deleted.where(transaction_id: transaction_id, condition_id: key_id_map.values).to_a

        key_id_map.each do |detail_key, condition_id|
            de_detail               = details.find {|detail| detail.condition_id == condition_id }
            de_detail               ||= doctor_examination_details.new(transaction_id: transaction_id, condition_id: condition_id)
            de_detail.deleted_at    = nil
            @saved_conditions_list  << condition_id if de_detail.save
        end
    end

    def save_details_for_values(hash)
        return if hash.blank?
        conditions              = hash.select {|key, value| value.present? }.keys
        code_key_map            = [PHYSICAL_VALUES].inject(&:merge).invert
        key_id_map              = get_key_id_map_hash(code_key_map, conditions)
        vision_aided_left_id    = Condition.find_by(code: ["3407"])&.id # vision test aided left
        vision_aided_right_id   = Condition.find_by(code: ["3408"])&.id # vision test aided right
        vision_unaided_left_id  = Condition.find_by(code: ["3409"])&.id # vision test unaided left
        vision_unaided_right_id = Condition.find_by(code: ["3410"])&.id # vision test unaided right

        # Remove aided left & right values if conditions are false.
        #key_id_map.delete("physical_vision_test_aided_left_a_value") unless @saved_conditions_list.include?(vision_aided_left_id)
        #key_id_map.delete("physical_vision_test_aided_left_b_value") unless @saved_conditions_list.include?(vision_aided_left_id)
        #key_id_map.delete("physical_vision_test_aided_right_a_value") unless @saved_conditions_list.include?(vision_aided_right_id)
        #key_id_map.delete("physical_vision_test_aided_right_b_value") unless @saved_conditions_list.include?(vision_aided_right_id)
        key_id_map.delete("physical_vision_test_unaided_left_a_value") unless @saved_conditions_list.include?(vision_unaided_left_id)
        key_id_map.delete("physical_vision_test_unaided_left_b_value") unless @saved_conditions_list.include?(vision_unaided_left_id)
        key_id_map.delete("physical_vision_test_unaided_right_a_value") unless @saved_conditions_list.include?(vision_unaided_right_id)
        key_id_map.delete("physical_vision_test_unaided_right_b_value") unless @saved_conditions_list.include?(vision_unaided_right_id)

        details = doctor_examination_details.with_deleted.where(transaction_id: transaction_id, condition_id: key_id_map.values).to_a

        key_id_map.each do |detail_key, condition_id|
            de_detail               = details.find {|detail| detail.condition_id == condition_id }
            de_detail               ||= doctor_examination_details.new(transaction_id: transaction_id, condition_id: condition_id)
            de_detail.deleted_at    = nil
            de_detail.text_value    = hash[detail_key]
            @saved_conditions_list  << condition_id if de_detail.save
        end
    end

    def save_comments(hash)
        return if hash.blank?
        conditions      = hash.select {|key, value| value.present? }.keys
        key_id_map      = get_key_id_map_hash(COMMENTS.invert, conditions)
        comments        = doctor_examination_comments.with_deleted.where(transaction_id: transaction_id, condition_id: key_id_map.values).to_a

        key_id_map.each do |detail_key, condition_id|
            de_comment              = comments.find {|comment| comment.condition_id == condition_id }
            de_comment              ||= doctor_examination_comments.new(transaction_id: transaction_id, condition_id: condition_id)
            de_comment.deleted_at   = nil
            de_comment.comment      = hash[detail_key]
            @saved_conditions_list  << condition_id if de_comment.save
        end
    end

    def get_key_id_map_hash(code_key_map, conditions)
        condition_codes = code_key_map.select {|code, key| conditions.include?(key.to_s) }
        code_id_map     = Condition.where(code: condition_codes.keys).pluck(:code, :id)
        code_id_map.map {|code, id| [code_key_map[code], id] }.to_h.with_indifferent_access
    end

    def set_initial_certification_conditions
        transactionz.update(status: "CERTIFICATION")
        lab_detail_conditions       = transactionz.le_detail_conditions.pluck(:code)
        @certification_conditions   = []
        doc_detail_conditions       = detail_conditions.pluck(:code)

        # Matching the conditions
            @certification_conditions << "3501" if lab_detail_conditions.include?("1041") # elisa -> HIV
            @certification_conditions << "3506" if lab_detail_conditions.include?("1042") # hbsag -> Hepatitis B
            @certification_conditions << "3505" if lab_detail_conditions.include?("1043") && lab_detail_conditions.include?("10431") # vdrl & tpha -> STD
            @certification_conditions << "3503" if lab_detail_conditions.include?("1044") && lab_detail_conditions.include?("10441") # malaria & bfmp -> Malaria
            @certification_conditions << "3512" if lab_detail_conditions.include?("1057") # opiates -> Opiates
            @certification_conditions << "3511" if lab_detail_conditions.include?("1058") # cannabis -> Cannabis
            @certification_conditions << "3510" if lab_detail_conditions.include?("1059") && lab_detail_conditions.include?("10591") # pregnancy & hcg -> Pregnancy
            @certification_conditions << "3515" if doc_detail_conditions.include?("3012") # system_cardiovascular_heart_sounds -> Heart Disease
            @certification_conditions << "3514" if (physical_blood_pressure_systolic && physical_blood_pressure_systolic >= 140) || (physical_blood_pressure_diastolic && physical_blood_pressure_diastolic >= 90)

        Condition.where(code: @certification_conditions).pluck(:id).each do |condition_id|
            de_detail = doctor_examination_details.with_deleted.find_or_initialize_by(transaction_id: transaction_id, condition_id: condition_id)
            de_detail.update(deleted_at: nil)
        end
    end
end
