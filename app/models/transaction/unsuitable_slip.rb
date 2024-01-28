module Transaction::UnsuitableSlip
    def seed_unsuitable_reasons
        @unsuitable_reasons = []
        reasons_mapping     = UnsuitableReason.all.pluck(:reason_en, :id).to_h
        lab_hiv_check       = laboratory_examination.try(:elisa) || laboratory_examination.try(:hbsag)

        if lab_hiv_check ||
            (laboratory_examination.try(:vdrl) && laboratory_examination.try(:tpha)) ||
            (laboratory_examination.try(:malaria) && laboratory_examination.try(:bfmp))
            @unsuitable_reasons << reasons_mapping["The worker has failed the blood screening test for communicable diseases."]
        end

        if laboratory_examination.try(:opiates) || laboratory_examination.try(:cannabis)
            @unsuitable_reasons << reasons_mapping["The worker has failed the urine screening test for drugs."]
        end

        if laboratory_examination.try(:pregnancy) && laboratory_examination.try(:pregnancy_serum_beta_hcg)
            @unsuitable_reasons << reasons_mapping["The worker has failed the urine screening test for pregnancy."]
        end

        if laboratory_examination.try(:sugar) || laboratory_examination.try(:albumin)
            @unsuitable_reasons << reasons_mapping["The worker has failed the screening test for urine."]
        end

        chest_xray_check = [:thoracic_cage, :heart_shape_and_size, :lung_fields, :mediastinum_and_hila, :pleura_hemidiaphragms_costopherenic_angles, :focal_lesion, :other_findings].map {|type| xray_examination.try(type) }.include?(true)
        @unsuitable_reasons << reasons_mapping["The worker's chest x-ray has abnormal findings."] if chest_xray_check && (!xray_pending_decision&.status == 'XQCC_PENDING_DECISION_APPROVAL' || !xray_pending_decision&.status == 'TRANSMITTED')

        all_conditions = [
            :condition_leprosy,
            :condition_cancer,
            :condition_epilepsy,
            :condition_psychiatric_disorder,
            :condition_hypertension,
            :condition_heart_diseases,
            :condition_bronchial_asthma,
            :condition_peptic_ulcer,
            :condition_other,
        ]

        exam_with_conditions    = medical_examination || doctor_examination
        all_conditions_check    = all_conditions.map {|type| exam_with_conditions.try(type) }.include?(true)
        hiv_condition_check     = exam_with_conditions.try(:condition_hiv) && !lab_hiv_check # If Lab HIV test is non reactive.
        tb_condition_check      = exam_with_conditions.try(:condition_tuberculosis) && !chest_xray_check # If Chest X-Ray all normal.
        @unsuitable_reasons     << reasons_mapping["The worker has abnormal physical findings."] if all_conditions_check || hiv_condition_check || tb_condition_check

        @unsuitable_reasons.compact.each do |reason_id|
            TransactionUnsuitableReason.find_or_create_by(transaction_id: id, unsuitable_reason_id: reason_id, created_by_system: true)
        end
    end
end