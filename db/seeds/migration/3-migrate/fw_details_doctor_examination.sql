\echo "fw_details.sql loaded"

/*
FROM condition_master
parameter_code => description

Medical History -> All these are medical history (31xx & 32xx)
    3101    HIV/AIDS
        => doctor_examinations.history_hiv "YES|NO" & doctor_examinations.history_hiv_date

    3102    Tuberculosis
        => doctor_examinations.history_tuberculosis "YES|NO" & doctor_examinations.history_tuberculosis_date

    3103    Leprosy
        => doctor_examinations.history_leprosy "YES|NO" & doctor_examinations.history_leprosy_date

    3104    Viral Hepatitis
        => doctor_examinations.history_viral_hepatitis "YES|NO" & doctor_examinations.history_viral_hepatitis_date

    3105    Psychiatric Illness
        => doctor_examinations.history_psychiatric_illness "YES|NO" & doctor_examinations.history_psychiatric_illness_date

    3106    Epilepsy
        => doctor_examinations.history_epilepsy "YES|NO" & doctor_examinations.history_epilepsy_date

    3107    Cancer
        => doctor_examinations.history_cancer "YES|NO" & doctor_examinations.history_cancer_date

    3108    Sexually Transmitted Disease
        => doctor_examinations.history_std "YES|NO" & doctor_examinations.history_std_date

    3201    Malaria
        => doctor_examinations.history_malaria "YES|NO" & doctor_examinations.history_malaria_date (Yes there are 2. This is the newer 1)

    3202    Hypertension
        => doctor_examinations.history_hypertension "YES|NO" & doctor_examinations.history_hypertension_date

    3203    Heart Diseases
        => doctor_examinations.history_heart_diseases "YES|NO" & doctor_examinations.history_heart_diseases_date

    3204    Bronchial Asthma
        => doctor_examinations.history_bronchial_asthma "YES|NO" & doctor_examinations.history_bronchial_asthma_date

    3205    Diabetes Mellitus
        => doctor_examinations.history_diabetes_mellitus "YES|NO" & doctor_examinations.history_diabetes_mellitus_date

    3206    Peptic Ulcer
        => doctor_examinations.history_peptic_ulcer "YES|NO" & doctor_examinations.history_peptic_ulcer_date

    3207    Kidney Diseases
        => doctor_examinations.history_kidney_diseases "YES|NO" & doctor_examinations.history_kidney_diseases_date

    3209    Others
        => doctor_examinations.history_other "YES|NO" & doctor_examinations.history_other_date

    5101    Medical History Comments
        => doctor_examinations.history_comment

Physical Examinations -> All these are Physical exams (34xx)
    3401    Chronic Skin Rash
        => doctor_examinations.physical_chronic_skin_rash "PRESENT|ABSENT"

    3402    Anaesthetic Skin Patch
        => doctor_examinations.physical_anaesthetic_skin_patch "PRESENT|ABSENT"

    3403    Deformities of Limbs
        => doctor_examinations.physical_deformities_of_limbs "PRESENT|ABSENT"

    3404    Anaemia
        => doctor_examinations.physical_pallor "PRESENT|ABSENT"

    3405    Jaundice
        => doctor_examinations.physical_jaundice "PRESENT|ABSENT"

    3406    Lymph Node Enlargement
        => doctor_examinations.physical_lymph_node_enlargement "PRESENT|ABSENT"

    3407    Vision Test - Aided ( L )
        => doctor_examinations.physical_vision_test_aided_left "DEFECTIVE|NORMAL"

    3408    Vision Test - Aided ( R )
        => doctor_examinations.physical_vision_test_aided_right "DEFECTIVE|NORMAL"

    3409    Vision Test - Unaided ( L )
        => doctor_examinations.physical_vision_test_unaided_left "DEFECTIVE|NORMAL"

    3410    Vision Test - Unaided ( R )
        => doctor_examinations.physical_vision_test_unaided_right "DEFECTIVE|NORMAL"

    3411    Hearing Ability ( L )
        => doctor_examinations.physical_hearing_ability_left "DEFECTIVE|NORMAL"

    3412    Hearing Ability ( R )
        => doctor_examinations.physical_hearing_ability_right "DEFECTIVE|NORMAL"

    3413    Other Findings (Systems Examination)
        => doctor_examinations.physical_other: "ABNORMAL|NORMAL"

    5103    General Physical Exam Comments
        => doctor_examinations.physical_comment

System Examinations -> All these are System Exam (30xx)
    3011    Heart Size
        => doctor_examinations.system_cardiovascular_heart_size: "ABNORMAL|NORMAL"

    3012    Heart Sounds
        => doctor_examinations.system_cardiovascular_heart_sounds: "ABNORMAL|NORMAL"

    3013    Other Findings (Cardiovascular)
        => doctor_examinations.system_cardiovascular_other_findings: "ABNORMAL|NORMAL"

    3021    Breath Sounds
        => doctor_examinations.system_respiratory_breath_sounds: "ABNORMAL|NORMAL"

    3022    Other Findings (Respiratory)
        => doctor_examinations.system_respiratory_other_findings: "ABNORMAL|NORMAL"

    3031    Liver
        => doctor_examinations.gastrointestinal_liver: "ABNORMAL|NORMAL"

    3032    Spleen
        => doctor_examinations.gastrointestinal_spleen: "ABNORMAL|NORMAL"

    3033    Kidney
        => doctor_examinations.system_genitourinary_kidney: "ABNORMAL|NORMAL"

    3034    Swelling (Gastrointestinal. If abnormal, describe under comments)
        => doctor_examinations.gastrointestinal_swelling: "ABNORMAL|NORMAL"

    3035    Lymph Nodes
        => doctor_examinations.gastrointestinal_lymph_nodes: "ABNORMAL|NORMAL"

    3036    Rectal Examination
        => doctor_examinations.gastrointestinal_rectal_examination: "ABNORMAL|NORMAL"

    3037    System Other Findings
        => doctor_examinations.gastrointestinal_other 'ABNORMAL|NORMAL'

    3041    General Mental Status
        => doctor_examinations.system_nervous_general_mental_status: "ABNORMAL|NORMAL"

    3042    Speech
        => doctor_examinations.system_nervous_speech: "ABNORMAL|NORMAL"

    3043    Cognitive Functions
        => doctor_examinations.system_nervous_cognitive_function: "ABNORMAL|NORMAL"

    3044    Size of Peripheral Nerves
        => doctor_examinations.system_nervous_size_of_peripheral_nerves: "ABNORMAL|NORMAL"

    3045    Motor Power
        => doctor_examinations.system_nervous_motor_power: "ABNORMAL|NORMAL"

    3046    Sensory
        => doctor_examinations.system_nervous_sensory: "ABNORMAL|NORMAL"

    3047    Reflexes
        => doctor_examinations.system_nervous_reflexes: "ABNORMAL|NORMAL"

    3051    Discharge (Genitourinary. If abnormal, describe under comments)
        => doctor_examinations.system_genitourinary_discharge: "ABNORMAL|NORMAL"

    3052    Sores/Ulcers (Genitourinary. If abnormal describe under comments)
        => doctor_examinations.system_genitourinary_sores_ulcers: "ABNORMAL|NORMAL"

    5102    System Exam Comments
        => doctor_examinations.system_comment

    3053    General Appearance
        => doctor_examinations.system_nervous_general_appearance "UNTIDY|TIDY"

    3054    Speech Quality (this is newer 1)
        => doctor_examinations.system_nervous_speech_quality "ABNORMAL|NORMAL"

    3055    Speech Coherent
        => doctor_examinations.system_nervous_speech_coherent "NO|YES"

    3056    Speech Relevant
        => doctor_examinations.system_nervous_speech_relevant "NO|YES"

    3057    Mood
        => doctor_examinations.system_nervous_mood "ABNORMAL|NORMAL"

    3077    Depressed
        => doctor_examinations.system_nervous_mood_depressed "YES|NO"

    3058    Feeling Down
        => doctor_examinations.system_nervous_mood_depressed_feeling_down "YES|NO"

    3059    Lost Interest
        => doctor_examinations.system_nervous_mood_depressed_lost_interest "YES|NO"

    3060    ANXIOUS
        => doctor_examinations.system_nervous_mood_anxious "YES|NO"

    3061    IRRITABLE
        => doctor_examinations.system_nervous_mood_irritable "YES|NO"

    3062    AFFECT
        => doctor_examinations.system_nervous_affect "INAPPROPRIATE|APPROPRIATE"

    3063    THOUGHT
        => doctor_examinations.system_nervous_thought "YES|NO"

    3064    DELUSION
        => doctor_examinations.system_nervous_thought_delusion "YES|NO"

    3078    SUICIDALITY
        => doctor_examinations.system_nervous_thought_suicidality "YES|NO"

    3065    SUICIDALITY1
        => doctor_examinations.system_nervous_thought_suicidality_worth_living "YES|NO"

    3066    SUICIDALITY2
        => doctor_examinations.system_nervous_thought_suicidality_ending_life "YES|NO"

    3067    PERCEPTION
        => doctor_examinations.system_nervous_perception "YES|NO"

    3068    ORIENTATION
        => doctor_examinations.system_nervous_orientation "ABNORMAL|NORMAL"

    3069    TIME
        => doctor_examinations.system_nervous_time "NO|YES"

    3070    PLACE
        => doctor_examinations.system_nervous_place "NO|YES"

    3071    PERSON
        => doctor_examinations.system_nervous_person "NO|YES"

    3072    OTHER
        => doctor_examinations.system_nervous_other "ABNORMAL|NORMAL"

    3073    DISCHARGE
        => doctor_examinations.system_breast_abnormal_discharge "YES|NO"

    3074    LUMP
        => doctor_examinations.system_breast_lump "YES|NO"

    3075    AXILLARY
        => doctor_examinations.system_breast_axillary_lympth_node "YES|NO"

    3076    OTHER6
        => doctor_examinations.system_breast_other "YES|NO"

Condition Examinations -> All these are certification conditions (35xx)
    3501    HIV / AIDS
        => doctor_examinations.condition_hiv "YES|NO"

    3502    Tuberculosis
        => doctor_examinations.condition_tuberculosis "YES|NO"

    3503    Malaria
        => doctor_examinations.condition_malaria "YES|NO"

    3504    Leprosy
        => doctor_examinations.condition_leprosy "YES|NO"

    3505    Sexually Transmitted Diseases
        => doctor_examinations.condition_std "YES|NO"

    3506    Hepatitis
        => doctor_examinations.condition_hepatitis "YES|NO"

    3507    Cancer
        => doctor_examinations.condition_cancer "YES|NO"

    3508    Epilepsy
        => doctor_examinations.condition_epilepsy "YES|NO"

    3509    Psychiatric Illness
        => doctor_examinations.condition_psychiatric_disorder "YES|NO"

    3510    She is pregnant
        => doctor_examinations.condition_urine_for_pregnant "YES|NO"

    3511    His / her urine contains Cannabis
        => doctor_examinations.condition_urine_for_cannabis "YES|NO"

    3512    His / her urine contains Opiates
        => doctor_examinations.condition_urine_for_opiates "YES|NO"

    3520    OTHERS10
        => doctor_examinations.condition_other "YES|NO"

    3514    HYPERTENSION
        => doctor_examinations.condition_hypertension "YES|NO"

    3515    HEARTDISEASES
        => doctor_examinations.condition_heart_diseases "YES|NO"

    3516    ASTHMA
        => doctor_examinations.condition_bronchial_asthma "YES|NO"

    3517    MELLITUS
        => doctor_examinations.condition_diabetes_mellitus "YES|NO"

    3518    ULCER
        => doctor_examinations.condition_peptic_ulcer "YES|NO"

    3519    KIDNEY
        => doctor_examinations.condition_kidney_diseases "YES|NO"

    5501    No description. This is certification comments.
        => doctor_examinations.certification_comment

    5502    If considered not fit for employment please state the reason
        => doctor_examinations.unsuitable_comment

Follow ups -> All these are certification follow ups (50xx)
    5001    Health Office is being notified
        => doctor_examinations.notified_health_office "YES|NO" & doctor_examinations.notified_health_office_date

    5002    I am referring the case to Government Hostipal (eg. Mental illness)
        => doctor_examinations.referred_to_government_hospital "YES|NO" & doctor_examinations.referred_to_government_hospital_date

    5003    I am referring the case to a private hospital
        => doctor_examinations.referred_to_private_hospital "YES|NO" & doctor_examinations.referred_to_private_hospital_date

    5004    I am continuing with the treatment
        => doctor_examinations.treating_patient "YES|NO" & doctor_examinations.treating_patient_date

    5005    The patient is still undergoing treatment
        => doctor_examinations.undergoing_treatment "YES|NO" & doctor_examinations.undergoing_treatment_date

None of these are in use. Please ignore.
    2015    Sputum AFB (to be done if indicated)
    2021    Rectal Swab for Salmonella (Food Industry ONLY)
    3208    Hearing Problems
    12016   Digital X-Ray
    12000   Hypertension
    12001   Heart Diseases
    12002   Bronchial Asthma
    12003   Diabetes Mellitus
    12004   Peptic Ulcer
    12005   Kidney Disease
    12006   Gall Blader Disease
    12007   Gynecological Cases
    12008   Anaemia
    12009   Injury Cases
    12010   Orthopedic Cases
    12011   U/FEME Cases
    12012   Thyroid Cases
    12013   Defective Vision
    12014   Raised/Elevation of Hemidiaphragm
    12015   Others
    5503    Other miscellaneous comments
    5105    Certifying Physician Comments
    3109    Malaria

    3513    Others(please specify under 16 below)
        3513 is interesting. In the old system, if 3513 is selected, must also select one of the following from 3514 to 3520. In old system can only select one of these with 3513. But in new system, can select any of these 7.
        3514    HYPERTENSION
        3515    HEARTDISEASES
        3516    ASTHMA
        3517    MELLITUS
        3518    ULCER
        3519    KIDNEY
        3520    OTHERS10


- Columns migrated
    doctor_examinations.history_taken_drug_recently 'YES|NO'
        => fw_transaction.taken_drugs

    doctor_examinations.result
        => 'ABNORMAL|NORMAL' -> Sets as Abnormal if any history, physical or system, is abnormal. Don't need to check condition.

    doctor_examinations.suitability
        => fw_transaction.dfit_ind -> 1 is unfit, 0 is fit

    doctor_examinations.transmitted_at
        => fw_transaction.certify_date

    doctor_examinations.transaction_id
        => set when inserting

    doctor_examinations.doctor_id
        => set when inserting

    doctor_examinations.physical_height
        => fw_transaction.height

    doctor_examinations.physical_weight
        => fw_transaction.weight

    doctor_examinations.physical_pulse
        => fw_transaction.pulse

    doctor_examinations.physical_blood_pressure_systolic
        => fw_transaction.systolic

    doctor_examinations.physical_blood_pressure_diastolic
        => fw_transaction.diastolic

    doctor_examinations.physical_last_menstrual_period_date
        => fw_transaction.last_pms_date

    doctor_examinations.created_at
        => fw_transaction.exam_date

    doctor_examinations.updated_at
        => fw_transaction.certify_date

From fw_comment
    ('5101', '5102', '5103', '5501', '5502')
*/


\echo "Insert doctor_examinations - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('doctor_examinations.sql - inserting doctor_examinations defaults') into v_log_id;
        commit;

        insert into doctor_examinations (
            transaction_id, doctor_id,
            transmitted_at,
            created_at, updated_at,
            physical_height,
            physical_weight,
            physical_pulse,
            physical_blood_pressure_systolic,
            physical_blood_pressure_diastolic,
            physical_last_menstrual_period_date,
            result,
            suitability
        )
        select
            local_trans.id, local_trans.doctor_id,
            local_trans.certification_date,
            coalesce(nios_trans.exam_date, nios_trans.transdate, clock_timestamp()), coalesce(nios_trans.certify_date, nios_trans.exam_date, nios_trans.transdate, clock_timestamp()),
            case when trim(regexp_replace(nios_trans.height, '[^0-9]+', '', 'g')) = '' then null else cast(trim(regexp_replace(nios_trans.height, '[^0-9]+', '', 'g')) as float) end,
            case when trim(regexp_replace(nios_trans.weight, '[^0-9]+', '', 'g')) = '' then null else cast(trim(regexp_replace(nios_trans.weight, '[^0-9]+', '', 'g')) as float) end,
            case when trim(regexp_replace(nios_trans.pulse, '[^0-9]+', '', 'g')) = '' then null else cast(trim(regexp_replace(nios_trans.pulse, '[^0-9]+', '', 'g')) as float) end,
            case when trim(regexp_replace(nios_trans.systolic, '[^0-9]+', '', 'g')) = '' then null else cast(trim(regexp_replace(nios_trans.systolic, '[^0-9]+', '', 'g')) as float) end,
            case when trim(regexp_replace(nios_trans.diastolic, '[^0-9]+', '', 'g')) = '' then null else cast(trim(regexp_replace(nios_trans.diastolic, '[^0-9]+', '', 'g')) as float) end,
            nios_trans.last_pms_date,
            'NORMAL',
            case when nios_trans.dfit_ind = 1 then 'UNSUITABLE' when nios_trans.dfit_ind = 0 then 'SUITABLE' end
        from
            transactions local_trans join fomema_backup_nios.fw_transaction nios_trans on local_trans.code = nios_trans.trans_id
        order by
            local_trans.transaction_date;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Insert doctor_examinations - End"

\echo "fw_details.sql ended"