module Transaction::SeedQuarantine
    def pending_review_criteria_check
        # Please note, this takes from both medical & xqcc quarantine reasons. Please check seed_xqcc_quarantine.rb for xqcc seeding.
        # qr_ids              = (transaction_quarantine_reasons.pluck(:quarantine_reason_id) + xqcc_quarantine_reasons.pluck(:quarantine_reason_id)).uniq
        # displayed_reasons   = QuarantineReason.where(id: qr_ids).pluck(:reason).sort

        # if displayed_reasons.include?("In-House PCR does not agree with the Digital X-Ray finding. Case transferred by XQCC Department.") && displayed_reasons.include?("In-House PCR does not agree with the Digital X-Ray finding.")
        #     displayed_reasons -= ["In-House PCR does not agree with the Digital X-Ray finding."]
        # end

        # displayed_reasons

        # Looks like they only want to show quarantine reasons for PR. - NF-1739 (2020-10-13)
        quarantine_reasons.pluck(:reason).sort
    end

    def checking_for_quarantine_items
        @skip_seeding   = true
        @items          = []
        seed_quarantine_items
        QuarantineReason.where(code: @items).pluck(:reason).sort
    end

    def seed_quarantine_items
        if doctor_examination.present? && xray_examination.present? && laboratory_examination.present?
            @qr_reason_id_map = QuarantineReason.pluck(:code, :id).to_h

            case doctor_examination.try(:suitability)
            when "SUITABLE"
                criteria_history_check
                criteria_physical_check
                criteria_bp_check
                criteria_defective_check
                criteria_abnormal_check
                criteria_breast_check
                criteria_condition_check
                criteria_laboratory_check
                criteria_xray_check
                criteria_others
            when "UNSUITABLE"
                criteria_unsuitable_check
            end
        end
    end
private
    def add_reason(code)
        if @skip_seeding
            @items << code
        else
            TransactionQuarantineReason.find_or_create_by(transaction_id: id, quarantine_reason_id: @qr_reason_id_map[code])
        end
    end

    def criteria_history_check
        {
            history_hiv: "1010",
            history_tuberculosis: "1012",
            history_leprosy: "1013",
            history_viral_hepatitis: "1014",
            history_psychiatric_illness: "1015",
            history_epilepsy: "1016",
            history_cancer: "1017",
            history_std: "1018",
            history_malaria: "1020"
        }.each do |field_name, code|
            add_reason(code) if doctor_examination.try(field_name)
        end
    end

    def criteria_physical_check
        {
            physical_chronic_skin_rash: "2050",
            physical_anaesthetic_skin_patch: "2060",
            physical_deformities_of_limbs: "2070",
            physical_pallor: "2080",
            physical_jaundice: "2090",
            physical_lymph_node_enlargement: "2100"
        }.each do |field_name, code|
            add_reason(code) if doctor_examination.try(field_name)
        end
    end

    def criteria_bp_check
        systolic_check  = doctor_examination.try(:physical_blood_pressure_systolic)
        diastolic_check = doctor_examination.try(:physical_blood_pressure_diastolic)
        add_reason("2043") if systolic_check && systolic_check >= 140
        add_reason("2042") if diastolic_check && diastolic_check >= 90
    end

    def criteria_defective_check
        {
            # physical_vision_test_unaided_left: "2111",
            # physical_vision_test_unaided_right: "2112",
            physical_vision_test_aided_left: "2113",
            physical_vision_test_aided_right: "2114",
            physical_hearing_ability_left: "2121",
            physical_hearing_ability_right: "2122"
        }.each do |field_name, code|
            add_reason(code) if doctor_examination.try(field_name)
        end
    end

    def criteria_abnormal_check
        {
            physical_other: "2130",
            system_cardiovascular_heart_size: "3101",
            system_cardiovascular_heart_sounds: "3102",
            system_cardiovascular_other_findings: "3103",
            system_respiratory_breath_sounds: "3201",
            system_respiratory_other_findings: "3202",
            gastrointestinal_liver: "3301",
            gastrointestinal_spleen: "3302",
            gastrointestinal_swelling: "3303",
            gastrointestinal_lymph_nodes: "3304",
            gastrointestinal_rectal_examination: "3305",
            gastrointestinal_other: "3306",
            system_nervous_general_mental_status: "3401",
            system_nervous_speech: "3402",
            system_nervous_speech_quality: "7110",
            system_nervous_cognitive_function: "3403",
            system_nervous_size_of_peripheral_nerves: "3404",
            system_nervous_motor_power: "3405",
            system_nervous_sensory: "3406",
            system_nervous_reflexes: "3407",
            system_nervous_other: "3408",
            system_genitourinary_kidney: "3501",
            system_genitourinary_discharge: "3502",
            system_genitourinary_sores_ulcers: "3503"
        }.each do |field_name, code|
            add_reason(code) if doctor_examination.try(field_name)
        end
    end

    def criteria_breast_check
        {
            system_breast_abnormal_discharge: "3525",
            system_breast_lump: "3526",
            system_breast_axillary_lympth_node: "3527",
            system_breast_other: "3528"
        }.each do |field_name, code|
            add_reason(code) if doctor_examination.try(field_name)
        end
    end

    def criteria_condition_check
        {
            condition_hiv: "6010",
            condition_tuberculosis: "6020",
            condition_malaria: "6030",
            condition_leprosy: "6040",
            condition_std: "6050",
            condition_hepatitis: "6060",
            condition_cancer: "6070",
            condition_epilepsy: "6080",
            condition_psychiatric_disorder: "6090",
            condition_other: "6100",
            condition_hypertension: "7180",
            condition_heart_diseases: "7190",
            condition_bronchial_asthma: "7200",
            condition_diabetes_mellitus: "7210",
            condition_peptic_ulcer: "7220",
            condition_kidney_diseases: "7230",
            condition_urine_for_pregnant: "6110",
            condition_urine_for_opiates: "7060",
            condition_urine_for_cannabis: "7070"
        }.each do |field_name, code|
            add_reason(code) if doctor_examination.try(field_name)
        end
    end

    def criteria_laboratory_check
        add_reason("4000") if laboratory_examination.try(:laboratory_test_not_done) == "YES"
        add_reason("6011") if laboratory_examination.try(:elisa)
        add_reason("6012") if laboratory_examination.try(:hbsag)
        add_reason("7100") if laboratory_examination.try(:vdrl) && laboratory_examination.try(:tpha)
        add_reason("1019") if laboratory_examination.try(:malaria) && laboratory_examination.try(:bfmp)
        add_reason("6120") if laboratory_examination.try(:opiates)
        add_reason("6130") if laboratory_examination.try(:cannabis)
        add_reason("7080") if laboratory_examination.try(:pregnancy) && laboratory_examination.try(:pregnancy_serum_beta_hcg)
        add_reason("4110") if laboratory_examination.sugar
        add_reason("4120") if laboratory_examination.albumin
    end

    def criteria_xray_check
        # Please note 5000 is removed, from user discussion. Refer to NF-1542.
        # add_reason("5000") if xray_examination.try(:xray_examination_not_done) == "YES"

        # This check is specific only for ANALOG cases.
        if xray_film_type == "ANALOG"
            {
                thoracic_cage: "5010",
                heart_shape_and_size: "5020",
                lung_fields: "5030",
                mediastinum_and_hila: "5060",
                pleura_hemidiaphragms_costopherenic_angles: "5070",
                focal_lesion: "5040",
                other_findings: "5050"
            }.each do |field_name, code|
                add_reason(code) if xray_examination.try(field_name)
            end
        end
    end

    def criteria_unsuitable_check
        add_reason("10004") if doctor_examination.result == "NORMAL" && laboratory_examination.result == "NORMAL" && xray_examination.result == "NORMAL"
        add_reason("7040") if laboratory_examination.try(:vdrl) && !laboratory_examination.try(:tpha)
        add_reason("7150") if laboratory_examination.try(:malaria) && !laboratory_examination.try(:bfmp)
        add_reason("7170") if laboratory_examination.try(:pregnancy) && !laboratory_examination.try(:pregnancy_serum_beta_hcg)


        # Checking for previous transaction
        previous_transaction    = Transaction.where(foreign_worker_id: foreign_worker_id, status: ["REVIEW", "CERTIFIED"]).where.not(final_result: nil, id: id).order(certification_date: :desc).first
        add_reason("10007") if previous_transaction.try(:final_result) == "UNSUITABLE"

        # Previous Blood Group
        previous_blood_group    = [previous_transaction.try(:laboratory_examination).try(:blood_group), previous_transaction.try(:laboratory_examination).try(:blood_group_rhesus)]
        current_blood_group     = [laboratory_examination.blood_group, laboratory_examination.blood_group_rhesus]
        add_reason("10009") if previous_transaction.present? && previous_blood_group != current_blood_group && !is_blood_group_benchmark
    end

    def criteria_others
        # Previous Transaction unsuitable
        previous_transaction    = Transaction.where(foreign_worker_id: foreign_worker_id, status: ["REVIEW", "CERTIFIED"]).where.not(final_result: nil, id: id).order(certification_date: :desc).first
        add_reason("10000") if previous_transaction.try(:final_result) == "UNSUITABLE" && !is_blood_group_benchmark

        # Previous Blood Group
        previous_blood_group    = [previous_transaction.try(:laboratory_examination).try(:blood_group), previous_transaction.try(:laboratory_examination).try(:blood_group_rhesus)]
        current_blood_group     = [laboratory_examination.blood_group, laboratory_examination.blood_group_rhesus]
        add_reason("10009") if previous_transaction.present? && previous_blood_group != current_blood_group && !is_blood_group_benchmark

        # Manuall Tagging for monitoring
        add_reason("10003") if foreign_worker.monitoring == "Y"

        # Reused Passport - Medical Result for previous worker is UNSUITABLE & also must have the same Passport Number.
        reused_passport         = Transaction.joins(:foreign_worker).where(final_result: "UNSUITABLE", foreign_workers: { passport_number: foreign_worker.passport_number }).where.not(foreign_worker_id: foreign_worker_id).count
        add_reason("10006") if reused_passport > 0

    end
end