class Condition < ApplicationRecord
    acts_as_paranoid

    EXAM_TYPES = {
        "DOC"   => "Doctor or Medical examinations",
        "LAB"   => "Laboratory examinations",
        "XRAY"  => "Xray examinations",
        "OLD"   => "Old system (removed)"
    }

    FIELD_TYPES = {
        "DETAIL"    => "Detail",
        "COMMENT"   => "Comment",
    }

    # MedicalExamination
    has_many :medical_examination_details,  inverse_of: :condition
    has_many :medical_examination_comments, inverse_of: :condition
    has_many :me_detail_exams,              through: :medical_examination_details,  source: :medical_examination,   inverse_of: :detail_conditions
    has_many :me_comment_exams,             through: :medical_examination_comments, source: :medical_examination,   inverse_of: :comment_conditions
    has_many :me_detail_transactions,       through: :medical_examination_details,  source: :transactionz,          inverse_of: :me_detail_conditions
    has_many :me_comment_transactions,      through: :medical_examination_comments, source: :transactionz,          inverse_of: :me_comment_conditions

    # DoctorExamination
    has_many :doctor_examination_details,   inverse_of: :condition
    has_many :doctor_examination_comments,  inverse_of: :condition
    has_many :de_detail_exams,              through: :doctor_examination_details,  source: :doctor_examination, inverse_of: :detail_conditions
    has_many :de_comment_exams,             through: :doctor_examination_comments, source: :doctor_examination, inverse_of: :comment_conditions
    has_many :de_detail_transactions,       through: :doctor_examination_details,  source: :transactionz,       inverse_of: :de_detail_conditions
    has_many :de_comment_transactions,      through: :doctor_examination_comments, source: :transactionz,       inverse_of: :de_comment_conditions

    # LaboratoryExamination
    has_many :laboratory_examination_details,   inverse_of: :condition
    has_many :laboratory_examination_comments,  inverse_of: :condition
    has_many :le_detail_exams,                  through: :laboratory_examination_details,  source: :laboratory_examination, inverse_of: :detail_conditions
    has_many :le_comment_exams,                 through: :laboratory_examination_comments, source: :laboratory_examination, inverse_of: :comment_conditions
    has_many :le_detail_transactions,           through: :laboratory_examination_details,  source: :transactionz,           inverse_of: :le_detail_conditions
    has_many :le_comment_transactions,          through: :laboratory_examination_comments, source: :transactionz,           inverse_of: :le_comment_conditions

    # XrayExamination
    has_many :xray_examination_details,     inverse_of: :condition
    has_many :xray_examination_comments,    inverse_of: :condition
    has_many :xe_detail_exams,              through: :xray_examination_details,  source: :xray_examination, inverse_of: :detail_conditions
    has_many :xe_comment_exams,             through: :xray_examination_comments, source: :xray_examination, inverse_of: :comment_conditions
    has_many :xe_detail_transactions,       through: :xray_examination_details,  source: :transactionz,     inverse_of: :xe_detail_conditions
    has_many :xe_comment_transactions,      through: :xray_examination_comments, source: :transactionz,     inverse_of: :xe_comment_conditions

    # MedicalAppeal - Is generated when an appeal starts. It is only used to record what the unsuitable certification conditions for the transaction are when starting an appeal. This is because certification conditions of MedicalExaminations are all set to NO when an appeal is successful.
    has_many :medical_appeal_conditions,    inverse_of: :condition

    validates :code,        presence: true, uniqueness: true
    validates :exam_type,   presence: true
    validates :field_type,  presence: true
    validates :description, presence: true
    # validates :category,    presence: true

    # (Start) Medical Conditions - For both doctor_examinations & medical_examinations.
        def self.medical_history_conditions
            {
                "3101" => "HIV/AIDS",
                "3102" => "Tuberculosis",
                "3103" => "Leprosy",
                "3104" => "Viral Hepatitis",
                "3105" => "Psychiatric Illness",
                "3106" => "Epilepsy",
                "3107" => "Cancer",
                "3108" => "Sexually Transmitted Disease",
                "3201" => "Malaria",
                "3202" => "Hypertension",
                "3203" => "Heart Diseases",
                "3204" => "Bronchial Asthma",
                "3205" => "Diabetes Mellitus",
                "3206" => "Peptic Ulcer",
                "3207" => "Kidney Diseases",
                "3209" => "Others",
                "3210" => "Taken medications/drugs within the last 2 weeks?",
                "5101" => "Medical History Comments"
            }
        end

        def self.medical_physical_conditions
            {
                "3401" => "Chronic Skin Rash",
                "3402" => "Anaesthetic Skin Patch",
                "3403" => "Deformities of Limbs",
                "3404" => "Anaemia//Pallor",
                "3405" => "Jaundice",
                "3406" => "Lymph Node Enlargement",
                "3407" => "Vision Test - Aided ( L )",
                "34071" => "Vision Test - Aided ( L ) Acuity (A)",
                "34072" => "Vision Test - Aided ( L ) Acuity (B)",
                "3408" => "Vision Test - Aided ( R )",
                "34081" => "Vision Test - Aided ( R ) Acuity (A)",
                "34082" => "Vision Test - Aided ( R ) Acuity (B)",
                "3409" => "Vision Test - Unaided ( L )",
                "34091" => "Vision Test - Unaided ( L ) Acuity (A)",
                "34092" => "Vision Test - Unaided ( L ) Acuity (B)",
                "3410" => "Vision Test - Unaided ( R )",
                "34101" => "Vision Test - Unaided ( R ) Acuity (A)",
                "34102" => "Vision Test - Unaided ( R ) Acuity (B)",
                "3411" => "Hearing Ability ( L )",
                "3412" => "Hearing Ability ( R )",
                "3413" => "Other Findings (Systems Examination)",
                "5103" => "General Physical Exam Comments"
            }
        end

        def self.medical_system_conditions_1
            {
                "3011" => "Heart Size",
                "3012" => "Heart Sounds",
                "3013" => "Other Findings (Cardiovascular)",
                "3021" => "Breath Sounds",
                "3022" => "Other Findings (Respiratory)",
                "3031" => "Liver",
                "3032" => "Spleen",
                "3034" => "Swelling (Gastrointestinal. If abnormal, describe under comments)",
                "3035" => "Lymph Nodes",
                "3036" => "Rectal Examination",
                "3037" => "Other Findings (Gastrointestinal)"
            }
        end

        def self.medical_system_conditions_2
            {
                "3041" => "General Mental Status",
                "3053" => "General Appearance",
                "3054" => "Speech Quality (this is newer 1)",
                "3055" => "Speech Coherent",
                "3056" => "Speech Relevant",
                "3057" => "Mood",
                "3077" => "Depressed",
                "3058" => "Feeling Down",
                "3059" => "Lost Interest",
                "3060" => "Feeling Anxious",
                "3061" => "Feeling Irritable",
                "3062" => "Affect",
                "3063" => "Thoughts",
                "3064" => "Delusions",
                "3078" => "Suicidality",
                "3065" => "Suicidality (Life not worth living)",
                "3066" => "Suicidality (Thoughts about ending life)",
                "3067" => "Perception (Hallucinations)",
                "3068" => "Orientation",
                "3069" => "Orientation (Time)",
                "3070" => "Orientation (Place)",
                "3071" => "Orientation (Person)",
                "3042" => "Speech",
                "3043" => "Cognitive Functions",
                "3044" => "Size of Peripheral Nerves",
                "3045" => "Motor Power",
                "3046" => "Sensory",
                "3047" => "Reflexes",
                "3072" => "Nervous - Other",
                "3033" => "Kidney",
                "3051" => "Discharge (Genitourinary. If abnormal, describe under comments)",
                "3052" => "Sores/Ulcers (Genitourinary. If abnormal describe under comments)",
                "3073" => "Breast - Abnormal Discharge",
                "3074" => "Breast - Lump",
                "3075" => "Breast - Axillary Lymph Node",
                "3076" => "Breast - Other",
                "5102" => "System Exam Comments",
                "3079" => "Abnormal Behaviour"
            }
        end

        def self.medical_certification_conditions
            {
                "3501" => "HIV / AIDS",
                "3502" => "Tuberculosis",
                "3503" => "Malaria",
                "3504" => "Leprosy",
                "3505" => "Sexually Transmitted Diseases",
                "3506" => "Hepatitis",
                "3507" => "Cancer",
                "3508" => "Epilepsy",
                "3509" => "Psychiatric Illness",
                "3514" => "Hypertension",
                "3515" => "Heart Diseases",
                "3516" => "Bronchial Asthma",
                "3517" => "Diabetes Mellitus",
                "3518" => "Peptic Ulcer",
                "3519" => "Kidney Disease",
                "3510" => "She is pregnant",
                "3511" => "His / her urine contains Cannabis",
                "3512" => "His / her urine contains Opiates",
                "3520" => "Condition - Other",
                "5501" => "Condition Comments",
                "5502" => "If considered not fit for employment please state the reason"
            }
        end

        def self.medical_follow_up_conditions
            {
                "5001" => "Health Office has being notified",
                "5002" => "Case referred to a Government hospital",
                "5003" => "Case referred to a Private hospital",
                "5004" => "I am treating the patient",
                "5005" => "The patient is undergoing treatment in another clinic / hospital"
            }
        end
    # (End)

    # Laboratory Conditions.
    def self.laboratory_exam_conditions
        {
            "10411" => "Blood Group Other",
            "10412" => "Blood Group Rhesus Other",
            "1041" => " HIV Antibody (ELISA)",
            "1042" => " HBsAg",
            "1043" => " VDRL",
            "10431" => "TPHA",
            "1044" => " Malaria",
            "10441" => "BRMP",
            "1057" => " Urine - Opiates",
            "1058" => " Urine - Cannabis",
            "1059" => " Urine - Pregnancy Test",
            "10591" => "HCG",
            "1053" => " Urine - Sugar",
            "10535" => "Urine - Sugar : Millimoles per litre",
            "1054" => " Urine - Albumin",
            "10545" => "Urine - Sugar Albumin : Millimoles per litre",
            "1056" => "Laboratory Comment/Abnormal reason"
        }
    end

    # Xray Conditions.
    def self.xray_examination_conditions
        {
            "2001" => "Thoracic Cage",
            "2101" => "Thoracic Cage - Details of abnormalities",
            "2002" => "Heart Shape and Size (CTR if applicable)",
            "2102" => "Heart Shape and Size - Details of abnormalities",
            "2011" => "Lung Fields",
            "2111" => "Lung Fields - Details of abnormalities",
            "2003" => "Mediastinum and Hila",
            "2103" => "Mediastinum and Hila - Details of abnormalities",
            "2004" => "Pleura / Hemidiaphragms / Costopherenic Angles",
            "2104" => "Pleura / Hemidiaphragms / Costopherenic Angles - Details of abnormalities",
            "2012" => "Focal Lesion (E.g. Old/New PTB, Maglinancy)",
            "2112" => "Focal Lesion (E.g. Old/New PTB, Maglinancy) - Details of abnormalities",
            "2013" => "Any Other Findings",
            "2113" => "Any Other Findings - Details of abnormalities",
            "2014" => "Impression"
        }
    end

    # Old/Unused.
    def self.fomema_old_exam_conditions
        {
            "1051" => "Urine - Color",
            "1052" => "Urine - Specific Gravity",
            "1055" => "Urine - Microscopic Examination",
            "10551" => "Microscopic Examination Comment",
            "10531" => "Urine - Sugar : Level 1+",
            "10532" => "Urine - Sugar : Level 2+",
            "10533" => "Urine - Sugar : Level 3+",
            "10534" => "Urine - Sugar : Level 4+",
            "10541" => "Urine - Sugar Albumin : Level 1+",
            "10542" => "Urine - Sugar Albumin : Level 2+",
            "10543" => "Urine - Sugar Albumin : Level 3+",
            "10544" => "Urine - Sugar Albumin : Level 4+",
            "10521" => "L1_LABSGVALUE",
            # "3513" => "Others(please epecify under 16 below", # Merged with 3520.
            "666" => "L1_IBTV2",
            "777" => "L1_IBTV3",
            "888" => "Web Service Indicator"
        }
    end

    # List of conditions that are used in comments instead of details.
    def self.comment_conditions
        ["1056", "2014", "2101", "2102", "2103", "2104", "2111", "2112", "2113", "5101", "5102", "5103", "5501", "5502", "10411", "10412", "10551"]
    end
end