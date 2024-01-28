module DoctorExaminationConditionList
    def category_1_diseases
        {
            history_hiv: "HIV",
            history_tuberculosis: "Tuberculosis",
            history_leprosy: "Leprosy",
            history_viral_hepatitis: "Viral Hepatitis B",
            history_psychiatric_illness: "Psychiatric Illness",
            history_epilepsy: "Epilepsy",
            history_cancer: "Cancer",
            history_std: "Sexually Transmitted Diseases",
            history_malaria: "Malaria"
        }
    end

    def category_2_diseases
        {
            history_hypertension: "Hypertension",
            history_heart_diseases: "Heart Diseases",
            history_bronchial_asthma: "Bronchial Asthma",
            history_diabetes_mellitus: "Diabetes Mellitus",
            history_peptic_ulcer: "Peptic Ulcer",
            history_kidney_diseases: "Kidney Disease",
            history_other: "Other"
        }
    end

    def physical_exam_measurements
        [
            ["physical_height", "Height", "cm"],
            ["physical_weight", "Weight", "kg"],
            ["physical_pulse", "Pulse", "per minute"]
        ]
    end

    def blood_pressure
        [
            ["physical_blood_pressure_systolic", "Systolic", "mmHg"],
            ["physical_blood_pressure_diastolic", "Diastolic", "mmHg"]
        ]
    end

    def physical_exam_visible_problems
        {
            physical_chronic_skin_rash: "Chronic Skin Rash",
            physical_anaesthetic_skin_patch: "Anaesthetic Skin Patch",
            physical_deformities_of_limbs: "Deformities Of Limbs",
            physical_pallor: "Pallor",
            physical_jaundice: "Jaundice",
            physical_lymph_node_enlargement: "Lymph Node Enlargement"
        }
    end

    def vision_test
        {
            physical_vision_test_unaided_left: "Unaided Left",
            physical_vision_test_unaided_right: "Unaided Right",
            physical_vision_test_aided_left: "Aided Left",
            physical_vision_test_aided_right: "Aided Right"
        }
    end

    def hearing_ability
        {
            physical_hearing_ability_left: "Left",
            physical_hearing_ability_right: "Right"
        }
    end

    def cardiovascular
        {
            system_cardiovascular_heart_size: "Heart Size",
            system_cardiovascular_heart_sounds: "Heart Sounds",
            system_cardiovascular_other_findings: "Other Findings"
        }
    end

    def respiratory
        {
            system_respiratory_breath_sounds: "Breath Sounds",
            system_respiratory_other_findings: "Other Findings"
        }
    end

    def gastrointestinal
        {
            gastrointestinal_liver: "Liver",
            gastrointestinal_spleen: "Spleen",
            gastrointestinal_swelling: "Swelling (if abnormal, describe under \"Comments\" in the same section: item # 7)",
            gastrointestinal_lymph_nodes: "Lymph Nodes",
            gastrointestinal_rectal_examination: "Rectal Examination",
            gastrointestinal_other: "Other Findings"
        }
    end

    def system_2_section_4
        {
            system_nervous_speech: "Speech",
            system_nervous_cognitive_function: "Cognitive Function",
            system_nervous_size_of_peripheral_nerves: "Size Of Peripheral Nerves",
            system_nervous_motor_power: "Motor Power",
            system_nervous_sensory: "Sensory",
            system_nervous_reflexes: "Reflexes",
            system_nervous_other: "Others (Please specify under Comments - Item 7)"
        }
    end

    def genitourinary_system
        {
            system_genitourinary_kidney: "Kidney",
            system_genitourinary_discharge: "Discharge (if abnormal, describe under Comments below)",
            system_genitourinary_sores_ulcers: "Sores / Ulcers (if abnormal, describe under Comments below)",
        }
    end

    def breast_examinations
        {
            system_breast_abnormal_discharge: "Abnormal Discharge",
            system_breast_lump: "Lump",
            system_breast_axillary_lympth_node: "Axillary Lymph Node",
            system_breast_other: "Others (Please specify under Comments - Item 7)",
        }
    end

    def certification_conditions
        {
            condition_hiv: "HIV",
            condition_tuberculosis: "Tuberculosis",
            condition_malaria: "Malaria",
            condition_leprosy: "Leprosy",
            condition_std: "Sexually Transmitted Diseases",
            condition_hepatitis: "Hepatitis B",
            condition_cancer: "Cancer",
            condition_epilepsy: "Epilepsy",
            condition_psychiatric_disorder: "Psychiatric Illness",
            condition_hypertension: "Hypertension",
            condition_heart_diseases: "Heart Diseases",
            condition_bronchial_asthma: "Bronchial Asthma",
            condition_diabetes_mellitus: "Diabetes Mellitus",
            condition_peptic_ulcer: "Peptic Ulcer",
            condition_kidney_diseases: "Kidney Disease"
        }
    end

    def certification_conditions_consolidated
        {
            condition_hiv: "HIV",
            condition_tuberculosis: "Tuberculosis",
            condition_malaria: "Malaria",
            condition_leprosy: "Leprosy",
            condition_std: "STD",
            condition_hepatitis: "Hepatitis B",
            condition_cancer: "Cancer",
            condition_epilepsy: "Epilepsy",
            condition_psychiatric_disorder: "Psychiatric Illness",
            condition_hypertension: "Hypertension",
            condition_heart_diseases: "Heart Diseases",
            condition_bronchial_asthma: "Bronchial Asthma",
            condition_diabetes_mellitus: "Diabetes Mellitus",
            condition_peptic_ulcer: "Peptic Ulcer",
            condition_kidney_diseases: "Kidney Disease",
            condition_urine_for_pregnant: "Pregnancy",
            condition_urine_for_cannabis: "Cannabis in urine",
            condition_urine_for_opiates: "Opiates in urine",
            condition_other: "Other Condition"
        }
    end

    def certification_conditions_for_appeal_document
        condition_code_id_map = Condition.where(code: Condition.medical_certification_conditions.except("5501", "5502").keys).pluck(:code, :id).to_h

        {
            "3501" => "HIV",
            "3502" => "Tuberculosis",
            "3503" => "Malaria",
            "3504" => "Leprosy",
            "3505" => "Sexually Transmitted Diseases",
            "3506" => "Hepatitis B",
            "3507" => "Cancer",
            "3508" => "Epilepsy",
            "3509" => "Psychiatric Illness",
            "3514" => "Hypertension",
            "3515" => "Heart Diseases",
            "3516" => "Bronchial Asthma",
            "3517" => "Diabetes Mellitus",
            "3518" => "Peptic Ulcer",
            "3519" => "Kidney Disease",
            "3510" => "Pregnancy",
            "3511" => "Cannabis in urine",
            "3512" => "Opiates in urine",
            "3520" => "OTHERS" # Condition Other is special for the document. Look at what happens inside the view.
        }.transform_keys {|key| condition_code_id_map[key] }
    end

    def certification_condition_part_2
        {
            condition_urine_for_pregnant: "Her urine for pregnancy",
            condition_urine_for_opiates: "His / her urine for opiates (screening test)",
            condition_urine_for_cannabis: "His / her urine for cannabis (screening test)"
        }
    end

    def follow_up
        {
            notified_health_office: "Health Office has been notified",
            referred_to_government_hospital: "Case referred to a Government hospital",
            referred_to_private_hospital: "Case referred to a Private hospital",
            treating_patient: "I am treating the patient",
            undergoing_treatment: "The patient is undergoing treatment in another clinic / hospital"
        }
    end
end