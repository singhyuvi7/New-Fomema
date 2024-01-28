class CreateDoctorExaminations < ActiveRecord::Migration[5.2]
  def change
    create_table :doctor_examinations do |t|
      t.belongs_to :transaction, index: {unique: true}
      t.belongs_to :doctor

      t.string :history_hiv # changed 2019-12-05, was history_hiv_aids
      t.date  :history_hiv_date # changed 2019-12-05, was history_hiv_aids_date
      t.string :history_tuberculosis
      t.date  :history_tuberculosis_date
      t.string :history_leprosy
      t.date  :history_leprosy_date
      t.string :history_viral_hepatitis
      t.date  :history_viral_hepatitis_date
      t.string :history_psychiatric_illness
      t.date  :history_psychiatric_illness_date
      t.string :history_epilepsy
      t.date  :history_epilepsy_date
      t.string :history_cancer
      t.date  :history_cancer_date
      t.string :history_std
      t.date  :history_std_date
      t.string :history_malaria
      t.date  :history_malaria_date
      t.string :visited_history_1

      t.string :history_hypertension
      t.date  :history_hypertension_date
      t.string :history_heart_diseases
      t.date  :history_heart_diseases_date
      t.string :history_bronchial_asthma
      t.date  :history_bronchial_asthma_date
      t.string :history_diabetes_mellitus
      t.date  :history_diabetes_mellitus_date
      t.string :history_peptic_ulcer
      t.date  :history_peptic_ulcer_date
      t.string :history_kidney_diseases
      t.date  :history_kidney_diseases_date
      t.string :history_other # changed 2019-12-05, was history_others
      t.date  :history_other_date # changed 2019-12-05, was history_others_date
      t.string :history_taken_drug_recently
      t.text  :history_comment
      t.string :visited_history_2

      t.decimal :physical_height
      t.decimal :physical_weight
      t.integer :physical_pulse
      t.integer :physical_blood_pressure_systolic
      t.integer :physical_blood_pressure_diastolic
      t.date :physical_last_menstrual_period_date
      t.string :physical_chronic_skin_rash
      t.string :physical_anaesthetic_skin_patch
      t.string :physical_deformities_of_limbs
      t.string :physical_pallor # changed 2019-12-05, was physical_anaemia
      t.string :physical_jaundice
      t.string :physical_lymph_node_enlargement
      t.string :physical_vision_test_unaided_left
      t.string :physical_vision_test_unaided_right
      t.string :physical_vision_test_aided_left
      t.string :physical_vision_test_aided_right
      t.string :physical_hearing_ability_left
      t.string :physical_hearing_ability_right
      t.string :physical_other # changed 2019-12-05, was physical_others
      t.text :physical_comment
      t.string :visited_physical

      t.string :system_cardiovascular_heart_size
      t.string :system_cardiovascular_heart_sounds
      t.string :system_cardiovascular_other_findings
      t.string :system_respiratory_breath_sounds
      t.string :system_respiratory_other_findings
      t.string :gastrointestinal_liver
      t.string :gastrointestinal_spleen
      t.string :gastrointestinal_swelling
      t.string :gastrointestinal_lymph_nodes
      t.string :gastrointestinal_rectal_examination
      t.string :gastrointestinal_other # added 2019-12-05
      t.string :visited_system_1

      t.string :system_nervous_general_mental_status
      t.string :system_nervous_general_appearance # added 2019-12-05
      t.string :system_nervous_speech_quality # added 2019-12-05
      t.string :system_nervous_speech_coherent # added 2019-12-05
      t.string :system_nervous_speech_relevant # added 2019-12-05
      t.string :system_nervous_mood # added 2019-12-05
      t.string :system_nervous_mood_depressed # added 2019-12-05
      t.string :system_nervous_mood_depressed_feeling_down # added 2019-12-05
      t.string :system_nervous_mood_depressed_lost_interest # added 2019-12-05
      t.string :system_nervous_mood_anxious # added 2019-12-05
      t.string :system_nervous_mood_irritable # added 2019-12-05
      t.string :system_nervous_affect # added 2019-12-05
      t.string :system_nervous_thought # added 2019-12-05
      t.string :system_nervous_thought_delusion # added 2019-12-05
      t.string :system_nervous_thought_suicidality # added 2019-12-05
      t.string :system_nervous_thought_suicidality_worth_living # added 2019-12-05
      t.string :system_nervous_thought_suicidality_ending_life # added 2019-12-05
      t.string :system_nervous_perception # added 2019-12-05
      t.string :system_nervous_orientation # added 2019-12-05
      t.string :system_nervous_time # added 2019-12-05
      t.string :system_nervous_place # added 2019-12-05
      t.string :system_nervous_person # added 2019-12-05

      t.string :system_nervous_speech
      t.string :system_nervous_cognitive_function
      t.string :system_nervous_size_of_peripheral_nerves
      t.string :system_nervous_motor_power
      t.string :system_nervous_sensory
      t.string :system_nervous_reflexes
      t.string :system_nervous_other # added 2019-12-05
      t.string :system_genitourinary_kidney
      t.string :system_genitourinary_discharge
      t.string :system_genitourinary_sores_ulcers
      t.string :system_breast_abnormal_discharge # added 2019-12-05
      t.string :system_breast_lump # added 2019-12-05
      t.string :system_breast_axillary_lympth_node # added 2019-12-05
      t.string :system_breast_other # added 2019-12-05
      t.text :system_comment
      t.string :visited_system_2

      t.string :visited_laboratory_result
      t.string :visited_xray_facility_result

      t.string :condition_hiv # changed 2019-12-05, was certification_hiv_aids
      t.string :condition_tuberculosis # changed 2019-12-05, was certification_tuberculosis
      t.string :condition_malaria # changed 2019-12-05, was certification_malaria
      t.string :condition_leprosy # changed 2019-12-05, was certification_leprosy
      t.string :condition_std # changed 2019-12-05, was certification_std
      t.string :condition_hepatitis # changed 2019-12-05, was certification_hepatitis
      t.string :condition_cancer # changed 2019-12-05, was certification_cancer
      t.string :condition_epilepsy # changed 2019-12-05, was certification_epilepsy
      t.string :condition_psychiatric_disorder # changed 2019-12-05, was certification_psychiatric_illness
      t.string :condition_other # changed 2019-12-05, was certification_others
      t.string :condition_hypertension         # changed 2019-12-24 history_2 categories added to condition check
      t.string :condition_heart_diseases       # changed 2019-12-24 history_2 categories added to condition check
      t.string :condition_bronchial_asthma     # changed 2019-12-24 history_2 categories added to condition check
      t.string :condition_diabetes_mellitus    # changed 2019-12-24 history_2 categories added to condition check
      t.string :condition_peptic_ulcer         # changed 2019-12-24 history_2 categories added to condition check
      t.string :condition_kidney_diseases      # changed 2019-12-24 history_2 categories added to condition check
      t.string :condition_urine_for_pregnant # changed 2019-12-05, was certification_pregnant
      t.string :condition_urine_for_opiates # changed 2019-12-05, was certification_opiates
      t.string :condition_urine_for_cannabis # changed 2019-12-05, was certification_cannabis
      t.string :visited_condition
      t.string :result, index: true
      t.string :suitability # changed 2019-12-05, was suitable
      t.text :certification_comment
      t.text :unsuitable_comment
      t.string :visited_certification

      t.datetime :transmitted_at, index: true

      t.string :notified_health_office
      t.date :notified_health_office_date
      t.string :referred_to_government_hospital
      t.date :referred_to_government_hospital_date
      t.string :referred_to_private_hospital
      t.date :referred_to_private_hospital_date
      t.string :treating_patient
      t.date :treating_patient_date
      t.string :undergoing_treatment
      t.date :undergoing_treatment_date
      t.string :visited_follow_up

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
