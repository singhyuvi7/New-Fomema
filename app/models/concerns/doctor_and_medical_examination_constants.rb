module DoctorAndMedicalExaminationConstants
    HISTORY = {
        history_hiv: "3101",
        history_tuberculosis: "3102",
        history_leprosy: "3103",
        history_viral_hepatitis: "3104",
        history_psychiatric_illness: "3105",
        history_epilepsy: "3106",
        history_cancer: "3107",
        history_std: "3108",
        history_malaria: "3201",
        history_hypertension: "3202",
        history_heart_diseases: "3203",
        history_bronchial_asthma: "3204",
        history_diabetes_mellitus: "3205",
        history_peptic_ulcer: "3206",
        history_kidney_diseases: "3207",
        history_other: "3209",
        history_taken_drug_recently: "3210"
    }

    HISTORY_SUITABLE = {
        history_hiv: "3101",
        history_viral_hepatitis: "3104",
        history_std: "3108",
        history_malaria: "3201",
        history_hypertension: "3202",
        history_heart_diseases: "3203",
        history_bronchial_asthma: "3204",
        history_diabetes_mellitus: "3205",
        history_peptic_ulcer: "3206",
        history_kidney_diseases: "3207",
        history_other: "3209",
        history_taken_drug_recently: "3210"
    }

    PHYSICAL = {
        physical_chronic_skin_rash: "3401",
        physical_anaesthetic_skin_patch: "3402",
        physical_deformities_of_limbs: "3403",
        physical_pallor: "3404",
        physical_jaundice: "3405",
        physical_lymph_node_enlargement: "3406",
        physical_vision_test_aided_left: "3407",
        physical_vision_test_aided_right: "3408",
        physical_vision_test_unaided_left: "3409",
        physical_vision_test_unaided_right: "3410",
        physical_hearing_ability_left: "3411",
        physical_hearing_ability_right: "3412",
        physical_other: "3413"
    }

    SYSTEM_1 = {
        system_cardiovascular_heart_size: "3011",
        system_cardiovascular_heart_sounds: "3012",
        system_cardiovascular_other_findings: "3013",
        system_respiratory_breath_sounds: "3021",
        system_respiratory_other_findings: "3022",
        gastrointestinal_liver: "3031",
        gastrointestinal_spleen: "3032",
        gastrointestinal_swelling: "3034",
        gastrointestinal_lymph_nodes: "3035",
        gastrointestinal_rectal_examination: "3036",
        gastrointestinal_other: "3037",
    }

    SYSTEM_2 = {
        system_nervous_general_mental_status: "3041",
        system_nervous_general_appearance: "3053",
        system_nervous_speech_quality: "3054",
        system_nervous_speech_coherent: "3055",
        system_nervous_speech_relevant: "3056",
        system_nervous_mood: "3057",
        system_nervous_mood_depressed: "3077",
        system_nervous_mood_depressed_feeling_down: "3058",
        system_nervous_mood_depressed_lost_interest: "3059",
        system_nervous_mood_anxious: "3060",
        system_nervous_mood_irritable: "3061",
        system_nervous_affect: "3062",
        system_nervous_thought: "3063",
        system_nervous_thought_delusion: "3064",
        system_nervous_thought_suicidality: "3078",
        system_nervous_thought_suicidality_worth_living: "3065",
        system_nervous_thought_suicidality_ending_life: "3066",
        system_nervous_perception: "3067",
        system_nervous_orientation: "3068",
        system_nervous_time: "3069",
        system_nervous_place: "3070",
        system_nervous_person: "3071",
        system_nervous_speech: "3042",
        system_nervous_cognitive_function: "3043",
        system_nervous_size_of_peripheral_nerves: "3044",
        system_nervous_motor_power: "3045",
        system_nervous_sensory: "3046",
        system_nervous_reflexes: "3047",
        system_nervous_other: "3072",
        system_genitourinary_kidney: "3033",
        system_genitourinary_discharge: "3051",
        system_genitourinary_sores_ulcers: "3052",
        system_breast_abnormal_discharge: "3073",
        system_breast_lump: "3074",
        system_breast_axillary_lympth_node: "3075",
        system_breast_other: "3076",
        system_nervous_abnormal_behaviour: "3079"
    }

    CERTIFICATION = {
        condition_hiv: "3501",
        condition_tuberculosis: "3502",
        condition_malaria: "3503",
        condition_leprosy: "3504",
        condition_std: "3505",
        condition_hepatitis: "3506",
        condition_cancer: "3507",
        condition_epilepsy: "3508",
        condition_psychiatric_disorder: "3509",
        condition_hypertension: "3514",
        condition_heart_diseases: "3515",
        condition_bronchial_asthma: "3516",
        condition_diabetes_mellitus: "3517",
        condition_peptic_ulcer: "3518",
        condition_kidney_diseases: "3519",
        condition_urine_for_pregnant: "3510",
        condition_urine_for_opiates: "3512",
        condition_urine_for_cannabis: "3511",
        condition_other: "3520"
    }

    FOLLOW_UP = {
        notified_health_office: "5001",
        referred_to_government_hospital: "5002",
        referred_to_private_hospital: "5003",
        treating_patient: "5004",
        undergoing_treatment: "5005"
    }

    HISTORY_DATE = HISTORY.map do |key, value|
        ["#{ key }_date".to_sym, value]
    end.to_h


    FOLLOW_UP_DATE = FOLLOW_UP.map do |key, value|
        ["#{ key }_date".to_sym, value]
    end.to_h

    COMMENTS = {
        history_comment: "5101",
        physical_comment: "5103",
        system_comment: "5102",
        certification_comment: "5501",
        unsuitable_comment: "5502"
    }

    PHYSICAL_VALUES = {
        physical_vision_test_aided_left_a_value: "34071",
        physical_vision_test_aided_left_b_value: "34072",
        physical_vision_test_aided_right_a_value: "34081",
        physical_vision_test_aided_right_b_value: "34082",
        physical_vision_test_unaided_left_a_value: "34091",
        physical_vision_test_unaided_left_b_value: "34092",
        physical_vision_test_unaided_right_a_value: "34101",
        physical_vision_test_unaided_right_b_value: "34102"
    }

    DISEASES = Psych.load_file(Rails.root.join('lib', 'seeds', 'doctor_examination', 'diseases.yaml')).freeze

    # Creating methods to determine if conditions are in details or comments.
    [HISTORY, PHYSICAL, SYSTEM_1, SYSTEM_2, CERTIFICATION, FOLLOW_UP, HISTORY_DATE, FOLLOW_UP_DATE, COMMENTS, PHYSICAL_VALUES].map do |mapping_list|
        mapping_list.keys
    end.flatten.each do |method_name|
        define_method("#{ method_name }") do
            set_detail_comment_hash unless defined?(@detail_comment_hash)
            @detail_comment_hash[method_name]
        end
    end

    def set_detail_comment_hash
        @detail_comment_hash    = Hash.new
        @condition_code_map     = Condition.where(exam_type: "DOC").pluck(:id, :code).to_h

        case self.class.to_s
        when "DoctorExamination"
            all_details         = doctor_examination_details
            all_comments        = doctor_examination_comments
        when "MedicalExamination"
            all_details         = medical_examination_details
            all_comments        = medical_examination_comments
        end

        @mapped_details         = all_details.to_a.map {|detail| [@condition_code_map[detail.condition_id], detail.text_value] }.to_h
        @mapped_dates           = all_details.to_a.map {|detail| [@condition_code_map[detail.condition_id], detail.date_value] }.to_h
        @mapped_comments        = all_comments.to_a.map {|comment| [@condition_code_map[comment.condition_id], comment.comment] }.to_h
        @detail_codes           = @mapped_dates.keys
        set_boolean_inclusion_fields
        set_date_related_fields
        set_misc_fields
        set_value_related_fields
    end

    def diseases
        DISEASES.each_with_object([]) do |(condition, condition_display), array|
            array << condition_display if send(condition)
        end
    end

private
    def set_boolean_inclusion_fields
        [HISTORY, PHYSICAL, SYSTEM_1, SYSTEM_2, CERTIFICATION, FOLLOW_UP].each do |key_code_set|
            key_code_set.each do |key, code|
                next unless @detail_codes.include?(code)
                @detail_comment_hash[key] = @detail_codes.include?(code)
            end
        end
    end

    def set_date_related_fields
        [HISTORY_DATE, FOLLOW_UP_DATE].each do |key_code_set|
            key_code_set.each do |key, code|
                next unless @detail_codes.include?(code)
                @detail_comment_hash[key] = @mapped_dates[code]
            end
        end
    end

    def set_misc_fields
        COMMENTS.each do |key, code|
            next unless @mapped_comments[code].present?
            @detail_comment_hash[key] = @mapped_comments[code]
        end
    end

    def set_value_related_fields
        [PHYSICAL_VALUES].each do |key_code_set|
            key_code_set.each do |key, code|
                next unless @detail_codes.include?(code)
                @detail_comment_hash[key] = @mapped_details[code]
            end
        end
    end
end