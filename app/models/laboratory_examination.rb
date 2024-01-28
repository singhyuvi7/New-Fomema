class LaboratoryExamination < ApplicationRecord
    TESTS = {
        elisa: "1041",
        hbsag: "1042",
        vdrl: "1043",
        tpha: "10431",
        malaria: "1044",
        bfmp: "10441",
        opiates: "1057",
        cannabis: "1058",
        pregnancy: "1059",
        pregnancy_serum_beta_hcg: "10591",
        sugar: "1053",
        albumin: "1054"
    }

    TEST_VALUES = {
        sugar_value: "10535",
        albumin_value: "10545"
    }

    COMMENTS = {
        blood_group_other: "10411",
        blood_group_rhesus_other: "10412",
        abnormal_reason: "1056"
    }

    audited
    acts_as_paranoid
    include CaptureAuthor

    belongs_to :laboratory
    belongs_to :transactionz, foreign_key: "transaction_id", class_name: "Transaction"

    has_many :laboratory_examination_details,   inverse_of: :laboratory_examination
    has_many :laboratory_examination_comments,  inverse_of: :laboratory_examination
    has_many :detail_conditions,                through: :laboratory_examination_details,  source: :condition, inverse_of: :le_detail_exams
    has_many :comment_conditions,               through: :laboratory_examination_comments, source: :condition, inverse_of: :le_comment_exams

    after_save :check_to_update_certification_state, if: -> { saved_changes[:transmitted_at] }

    def result_of_exam
        return true if laboratory_test_not_done == "YES"
        detail_codes = detail_conditions.where(code: TESTS.values).pluck(:code)

        # Checks for elisa, hbsag, sugar, albumin, opiates, cannabis, vdrl & tpha, malaria & bfmp, pregnancy & hcg
        (detail_codes & ["1041", "1042","1053", "1054", "1057", "1058"]).present? ||
            detail_codes.include?("1043") && detail_codes.include?("10431") ||
            detail_codes.include?("1044") && detail_codes.include?("10441") ||
            detail_codes.include?("1059") && detail_codes.include?("10591")
    end

    def self.blood_groups
        ["A", "B", "AB", "O", "Other"]
    end

    def self.blood_tests
        {
            elisa: "HIV",
            hbsag: "HBsAg",
            vdrl: "Syphilis (VDRL/RPR)",
            tpha: "TPHA/TPPA", # Show if VDRL is positive
            malaria: "Malaria (Screening)",
            bfmp: "BFMP" # Show if malaria is positive
        }
    end

    def self.urine_test
        {
            opiates: "Opiates",
            cannabis: "Cannabis"
        }
    end

    def self.sugar_and_albumin
        {
            sugar: "Sugar",
            albumin: "Albumin"
        }
    end

    # Creating methods to determine if conditions are in details or comments.
    [TESTS, TEST_VALUES, COMMENTS].map do |mapping_list|
        mapping_list.keys
    end.flatten.each do |method_name|
        define_method("#{ method_name }") do
            set_detail_comment_hash unless defined?(@detail_comment_hash)
            @detail_comment_hash[method_name]
        end
    end

    def set_detail_comment_hash
        @detail_comment_hash    = Hash.new
        @condition_code_map     = Condition.where(exam_type: "LAB").pluck(:id, :code).to_h
        @mapped_details         = laboratory_examination_details.to_a.map {|detail| [@condition_code_map[detail.condition_id], detail.text_value] }.to_h
        @detail_codes           = @mapped_details.keys
        @mapped_comments        = laboratory_examination_comments.to_a.map {|comment| [@condition_code_map[comment.condition_id], comment.comment] }.to_h
        set_boolean_inclusion_fields
        set_value_related_fields
        set_comment_fields
    end

    # Please do not use this to update detail or comments outside of the normal flow.
    # It will destroy records if you do not specify correctly.
    def save_examination_details_and_comments(hashes = {})
        @saved_conditions_list    = []
        save_details_for_booleans hashes[:boolean_fields]
        save_details_for_values   hashes[:value_fields]
        save_comments             hashes[:comments]
        laboratory_examination_details.where(transaction_id: transaction_id).where.not(condition_id: @saved_conditions_list).destroy_all
        laboratory_examination_comments.where(transaction_id: transaction_id).where.not(condition_id: @saved_conditions_list).destroy_all
    end

    def save_details_for_booleans(hash)
        return if hash.blank?
        conditions      = hash.select {|key, value| value == "true" }.keys
        key_id_map      = get_key_id_map_hash(TESTS.invert, conditions)

        # It is validated in front end, but including it here as well.
        # These fields are set to negative if the primary is also negative.
            key_id_map.delete("tpha") unless key_id_map.include?("vdrl")
            key_id_map.delete("bfmp") unless key_id_map.include?("malaria")
            key_id_map.delete("pregnancy_serum_beta_hcg") unless key_id_map.include?("pregnancy")

        details         = laboratory_examination_details.with_deleted.where(transaction_id: transaction_id, condition_id: key_id_map.values).to_a

        key_id_map.each do |detail_key, condition_id|
            le_detail               = details.find {|detail| detail.condition_id == condition_id }
            le_detail               ||= laboratory_examination_details.new(transaction_id: transaction_id, condition_id: condition_id)
            le_detail.deleted_at    = nil
            @saved_conditions_list  << condition_id if le_detail.save
        end
    end

    def save_details_for_values(hash)
        return if hash.blank?
        conditions      = hash.select {|key, value| value.present? }.keys
        key_id_map      = get_key_id_map_hash(TEST_VALUES.invert, conditions)
        sugar_id        = Condition.find_by(code: ["1053"])&.id # Sugar
        albumin_id      = Condition.find_by(code: ["1054"])&.id # Albumin

        # Remove sugar & albumin values if conditions are false.
            key_id_map.delete("sugar_value") unless @saved_conditions_list.include?(sugar_id)
            key_id_map.delete("albumin_value") unless @saved_conditions_list.include?(albumin_id)

        details         = laboratory_examination_details.with_deleted.where(transaction_id: transaction_id, condition_id: key_id_map.values).to_a

        key_id_map.each do |detail_key, condition_id|
            le_detail               = details.find {|detail| detail.condition_id == condition_id }
            le_detail               ||= laboratory_examination_details.new(transaction_id: transaction_id, condition_id: condition_id)
            le_detail.deleted_at    = nil
            le_detail.text_value    = hash[detail_key]
            @saved_conditions_list  << condition_id if le_detail.save
        end
    end

    def save_comments(hash)
        return if hash.blank?
        conditions      = hash.select {|key, value| value.present? }.keys
        key_id_map      = get_key_id_map_hash(COMMENTS.invert, conditions)

        # Remove blood/rhesus other if OTHER is not selected.
            key_id_map.delete("blood_group_other") unless blood_group == "OTHER"
            key_id_map.delete("blood_group_rhesus_other") unless blood_group_rhesus == "OTHER"

        comments        = laboratory_examination_comments.with_deleted.where(transaction_id: transaction_id, condition_id: key_id_map.values).to_a

        key_id_map.each do |detail_key, condition_id|
            le_comment              = comments.find {|comment| comment.condition_id == condition_id }
            le_comment              ||= laboratory_examination_comments.new(transaction_id: transaction_id, condition_id: condition_id)
            le_comment.deleted_at   = nil
            le_comment.comment      = hash[detail_key]
            @saved_conditions_list  << condition_id if le_comment.save
        end
    end

    def get_key_id_map_hash(code_key_map, conditions)
        condition_codes = code_key_map.select {|code, key| conditions.include?(key.to_s) }
        code_id_map     = Condition.where(code: condition_codes.keys).pluck(:code, :id)
        code_id_map.map {|code, id| [code_key_map[code], id] }.to_h.with_indifferent_access
    end

    def reset_all_details_and_comments
        reason_condition = Condition.find_by(code: "1056").try(:id)
        laboratory_examination_details.where(transaction_id: transaction_id).destroy_all
        laboratory_examination_comments.where(transaction_id: transaction_id).where.not(condition_id: reason_condition).destroy_all
    end
private
    def set_boolean_inclusion_fields
        TESTS.each do |key, code|
            next unless @detail_codes.include?(code)
            @detail_comment_hash[key] = @detail_codes.include?(code)
        end
    end

    def set_value_related_fields
        TEST_VALUES.each do |key, code|
            next unless @detail_codes.include?(code)
            @detail_comment_hash[key] = @mapped_details[code]
        end
    end

    def set_comment_fields
        COMMENTS.each do |key, code|
            next unless @mapped_comments[code].present?
            @detail_comment_hash[key] = @mapped_comments[code]
        end
    end

    def check_to_update_certification_state
        if transactionz.status == "EXAMINATION" && transactionz.xray_transmit_date? && transmitted_at?
            doc_exam = transactionz.doctor_examination
            doc_exam = DoctorExamination.find_or_create_by(transaction_id: transactionz.id, doctor_id: transactionz.doctor_id) if doc_exam.blank?
            doc_exam.set_initial_certification_conditions
        end
    end
end