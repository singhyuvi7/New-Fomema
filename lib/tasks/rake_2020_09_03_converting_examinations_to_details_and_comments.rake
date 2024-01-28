namespace :migration_task do # rake migration_task:rake_2020_09_03_converting_examinations_to_details_and_comments
    desc "Converts examination columns to details and comments"
    task rake_2020_09_03_converting_examinations_to_details_and_comments: :environment do
        puts "Starting Rake Run - Converting Examinations To Details And Comments"
        puts

        @condition_code_id_map  = Condition.pluck(:code, :id).to_h
        all_conditions          = [DoctorExamination::HISTORY, DoctorExamination::PHYSICAL, DoctorExamination::SYSTEM_1, DoctorExamination::SYSTEM_2, DoctorExamination::CERTIFICATION, DoctorExamination::FOLLOW_UP, DoctorExamination::HISTORY_DATE, DoctorExamination::FOLLOW_UP_DATE, DoctorExamination::COMMENTS, LaboratoryExamination::TESTS, LaboratoryExamination::TEST_VALUES, LaboratoryExamination::COMMENTS, XrayExamination::DETAILS, XrayExamination::COMMENTS].inject(&:merge)
        @condition_id_map       = all_conditions.map {|key, value| [key, @condition_code_id_map[value]] }.to_h
        doctor_exams            = DoctorExamination.where("transaction_id > 21500862")
        medical_exams           = MedicalExamination.where("transaction_id > 21500862")

        [doctor_exams, medical_exams].each_with_index do |d_or_m_examinations, i|
            total_exams         = d_or_m_examinations.size
            puts "Starting #{ i == 0 ? "DoctorExaminations" : "MedicalExamination" }"

            d_or_m_examinations.each.with_index(1) do |de_exam, index|
                puts "Seeding ID:#{ de_exam.id } (#{ index }/#{ total_exams })"
                trans_id = de_exam.transaction_id

                [:history_hiv, :history_tuberculosis, :history_leprosy, :history_viral_hepatitis, :history_psychiatric_illness, :history_epilepsy, :history_cancer, :history_std, :history_malaria, :history_hypertension, :history_heart_diseases, :history_bronchial_asthma, :history_diabetes_mellitus, :history_peptic_ulcer, :history_kidney_diseases, :history_other, :notified_health_office, :referred_to_government_hospital, :referred_to_private_hospital, :treating_patient, :undergoing_treatment].each do |condition_type|
                    date = de_exam.try("#{ condition_type }_date")

                    if de_exam.try(condition_type) == "YES" && date.present?
                        condition_id = @condition_id_map[condition_type]

                        if i == 0
                            de_exam.doctor_examination_details.create(transaction_id: trans_id, condition_id: condition_id, date_value: date)
                        elsif i == 1
                            de_exam.medical_examination_details.create(transaction_id: trans_id, condition_id: condition_id, date_value: date)
                        end
                    end
                end

                [:history_taken_drug_recently, :system_nervous_mood_depressed, :system_nervous_mood_depressed_feeling_down, :system_nervous_mood_depressed_lost_interest, :system_nervous_mood_anxious, :system_nervous_mood_irritable, :system_nervous_thought_delusion, :system_nervous_thought_suicidality, :system_nervous_thought_suicidality_worth_living, :system_nervous_thought_suicidality_ending_life, :system_nervous_perception, :system_breast_abnormal_discharge, :system_breast_lump, :system_breast_axillary_lympth_node, :system_breast_other, :condition_hiv, :condition_tuberculosis, :condition_malaria, :condition_leprosy, :condition_std, :condition_hepatitis, :condition_cancer, :condition_epilepsy, :condition_psychiatric_disorder, :condition_other, :condition_hypertension, :condition_heart_diseases, :condition_bronchial_asthma, :condition_diabetes_mellitus, :condition_peptic_ulcer, :condition_kidney_diseases, :condition_urine_for_pregnant, :condition_urine_for_opiates, :condition_urine_for_cannabis].each do |condition_type|
                    if de_exam.try(condition_type) == "YES"
                        condition_id = @condition_id_map[condition_type]

                        if i == 0
                            de_exam.doctor_examination_details.create(transaction_id: trans_id, condition_id: condition_id)
                        elsif i == 1
                            de_exam.medical_examination_details.create(transaction_id: trans_id, condition_id: condition_id)
                        end
                    end
                end

                [:system_nervous_speech_coherent, :system_nervous_speech_relevant, :system_nervous_time, :system_nervous_place, :system_nervous_person].each do |condition_type|
                    if de_exam.try(condition_type) == "NO"
                        condition_id = @condition_id_map[condition_type]

                        if i == 0
                            de_exam.doctor_examination_details.create(transaction_id: trans_id, condition_id: condition_id)
                        elsif i == 1
                            de_exam.medical_examination_details.create(transaction_id: trans_id, condition_id: condition_id)
                        end
                    end
                end

                [:physical_other, :system_cardiovascular_heart_size, :system_cardiovascular_heart_sounds, :system_cardiovascular_other_findings, :system_respiratory_breath_sounds, :system_respiratory_other_findings, :gastrointestinal_liver, :gastrointestinal_spleen, :gastrointestinal_swelling, :gastrointestinal_lymph_nodes, :gastrointestinal_rectal_examination, :gastrointestinal_other, :system_nervous_general_mental_status, :system_nervous_speech_quality, :system_nervous_mood, :system_nervous_thought, :system_nervous_orientation, :system_nervous_speech, :system_nervous_cognitive_function, :system_nervous_size_of_peripheral_nerves, :system_nervous_motor_power, :system_nervous_sensory, :system_nervous_reflexes, :system_nervous_other, :system_genitourinary_kidney, :system_genitourinary_discharge, :system_genitourinary_sores_ulcers].each do |condition_type|
                    if de_exam.try(condition_type) == "ABNORMAL"
                        condition_id = @condition_id_map[condition_type]

                        if i == 0
                            de_exam.doctor_examination_details.create(transaction_id: trans_id, condition_id: condition_id)
                        elsif i == 1
                            de_exam.medical_examination_details.create(transaction_id: trans_id, condition_id: condition_id)
                        end
                    end
                end

                [:physical_chronic_skin_rash, :physical_anaesthetic_skin_patch, :physical_deformities_of_limbs, :physical_pallor, :physical_jaundice, :physical_lymph_node_enlargement].each do |condition_type|
                    if de_exam.try(condition_type) == "PRESENT"
                        condition_id = @condition_id_map[condition_type]

                        if i == 0
                            de_exam.doctor_examination_details.create(transaction_id: trans_id, condition_id: condition_id)
                        elsif i == 1
                            de_exam.medical_examination_details.create(transaction_id: trans_id, condition_id: condition_id)
                        end
                    end
                end

                [:physical_vision_test_unaided_left, :physical_vision_test_unaided_right, :physical_vision_test_aided_left, :physical_vision_test_aided_right, :physical_hearing_ability_left, :physical_hearing_ability_right].each do |condition_type|
                    if de_exam.try(condition_type) == "DEFECTIVE"
                        condition_id = @condition_id_map[condition_type]

                        if i == 0
                            de_exam.doctor_examination_details.create(transaction_id: trans_id, condition_id: condition_id)
                        elsif i == 1
                            de_exam.medical_examination_details.create(transaction_id: trans_id, condition_id: condition_id)
                        end
                    end
                end

                if de_exam.try(:system_nervous_general_appearance) == "UNTIDY"
                    condition_id = @condition_id_map[:system_nervous_general_appearance]

                    if i == 0
                        de_exam.doctor_examination_details.create(transaction_id: trans_id, condition_id: condition_id)
                    elsif i == 1
                        de_exam.medical_examination_details.create(transaction_id: trans_id, condition_id: condition_id)
                    end
                end

                if de_exam.try(:system_nervous_affect) == "INAPPROPRIATE"
                    condition_id = @condition_id_map[:system_nervous_affect]

                    if i == 0
                        de_exam.doctor_examination_details.create(transaction_id: trans_id, condition_id: condition_id)
                    elsif i == 1
                        de_exam.medical_examination_details.create(transaction_id: trans_id, condition_id: condition_id)
                    end
                end

                [:history_comment, :physical_comment, :system_comment, :certification_comment, :unsuitable_comment].each do |condition_type|
                    if de_exam.try(condition_type).present?
                        condition_id = @condition_id_map[condition_type]

                        if i == 0
                            de_exam.doctor_examination_comments.create(transaction_id: trans_id, condition_id: condition_id, comment: de_exam.try(condition_type))
                        elsif i == 1
                            de_exam.medical_examination_comments.create(transaction_id: trans_id, condition_id: condition_id, comment: de_exam.try(condition_type))
                        end
                    end
                end
            end
        end

        lab_exams           = LaboratoryExamination.where("transaction_id > 21500862")
        total_exams         = lab_exams.size
        puts "Starting LaboratoryExamination"

        lab_exams.each.with_index(1) do |le_exam, index|
            puts "Seeding ID:#{ le_exam.id } (#{ index }/#{ total_exams })"
            trans_id = le_exam.transaction_id

            [:elisa, :hbsag, :vdrl, :tpha].each do |condition_type|
                if le_exam.try(condition_type) == "REACTIVE"
                    condition_id = @condition_id_map[condition_type]
                    le_exam.laboratory_examination_details.create(transaction_id: trans_id, condition_id: condition_id)
                end
            end

            [:opiates, :cannabis, :malaria, :bfmp, :pregnancy, :pregnancy_serum_beta_hcg].each do |condition_type|
                if le_exam.try(condition_type) == "POSITIVE"
                    condition_id = @condition_id_map[condition_type]
                    le_exam.laboratory_examination_details.create(transaction_id: trans_id, condition_id: condition_id)
                end
            end

            [:sugar, :albumin].each do |condition_type|
                if le_exam.try(condition_type) == "PRESENT"
                    condition_id = @condition_id_map[condition_type]
                    le_exam.laboratory_examination_details.create(transaction_id: trans_id, condition_id: condition_id)
                end
            end

            [:sugar_value, :albumin_value].each do |condition_type|
                if le_exam.try(condition_type).present?
                    condition_id = @condition_id_map[condition_type]
                    le_exam.laboratory_examination_details.create(transaction_id: trans_id, condition_id: condition_id, text_value: le_exam.try(condition_type))
                end
            end

            [:blood_group_other, :blood_group_rhesus_other, :abnormal_reason].each do |condition_type|
                if le_exam.try(condition_type).present?
                    condition_id = @condition_id_map[condition_type]
                    le_exam.laboratory_examination_comments.create(transaction_id: trans_id, condition_id: condition_id, comment: le_exam.try(condition_type))
                end
            end
        end

        xray_exams          = XrayExamination.where(id: 1)#("transaction_id > 21500862")
        total_exams         = xray_exams.size
        puts "Starting XrayExamination"

        xray_exams.each.with_index(1) do |xe_exam, index|
            puts "Seeding ID:#{ xe_exam.id } (#{ index }/#{ total_exams })"
            trans_id = xe_exam.transaction_id

            [:thoracic_cage, :heart_shape_and_size, :lung_fields, :mediastinum_and_hila, :pleura_hemidiaphragms_costopherenic_angles, :focal_lesion, :other_findings].each do |condition_type|
                if  ["ABNORMAL", "YES"].include?(xe_exam.try(condition_type))
                    condition_id = @condition_id_map[condition_type]
                    xe_exam.xray_examination_details.create(transaction_id: trans_id, condition_id: condition_id)
                end
            end

            [:thoracic_cage_comment, :heart_shape_and_size_comment, :lung_fields_comment, :mediastinum_and_hila_comment, :pleura_hemidiaphragms_costopherenic_angles_comment, :focal_lesion_comment, :other_findings_comment, :impression].each do |condition_type|
                if xe_exam.try(condition_type).present?
                    condition_id = @condition_id_map[condition_type]
                    xe_exam.xray_examination_comments.create(transaction_id: trans_id, condition_id: condition_id, comment: xe_exam.try(condition_type))
                end
            end
        end

        puts "Ending Rake Run - Converting Examinations To Details And Comments"
        puts
    end
end