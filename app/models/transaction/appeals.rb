module Transaction::Appeals
    def state_of_appeal
        # Not sure if medical result must be unsuitable or just final result.
        status == "CERTIFIED"# && medical_result == "UNSUITABLE"
    end

    def blocked_appeal_list(type)
        fw              = foreign_worker
        @med_exam       = medical_examination || doctor_examination
        @lab_exam       = laboratory_examination
        number_of_day   = SystemConfiguration.get("INIT_APPEAL_WITHIN_DAYS")

        blocked_list    = []
        blocked_list    << "Physical exam not done for this foreign worker" if physical_exam_not_done?
        blocked_list    << "Foreign worker is registered under MAID ONLINE" if is_maid_online? && fw.plks_number.to_i < 1 # NF-1547
        blocked_list    << "Cannot make appeal for cases older that #{number_of_day} days from certification" if certification_date? && certification_date < number_of_day.to_i.days.ago
        blocked_list    << "A previous appeal was made for this foreign worker" if medical_appeals.present?
        # SR20230643 - allow appeal for tuberculosis
        # blocked_list    << "Foreign worker has Tuberculosis" if @med_exam.try(:condition_tuberculosis)
        blocked_list    << "Foreign worker's lab results were REACTIVE for VDRL & REACTIVE for TPHA" if @lab_exam.try(:vdrl) && @lab_exam.try(:tpha)
        blocked_list    << "Foreign worker's lab results were POSITIVE for Malaria & POSITIVE for BFMP" if @lab_exam.try(:malaria) && @lab_exam.try(:bfmp)
        blocked_list    << "Foreign worker's lab results were POSITIVE for urine pregnancy test & POSITIVE for serum Beta - HCG" if @lab_exam.try(:pregnancy) && @lab_exam.try(:pregnancy_serum_beta_hcg)
        blocked_list    << "ABO(Rh) group discrepancy between current ABO(Rh) group with previous ABO(Rh) group. Invalid medical and foreign worker is required to do re-medical examination." if is_blood_group_discrepancy?
        blocked_list    << "Foreign worker's lab results were POSITIVE for HIV" if @med_exam.try(:condition_hiv) || @lab_exam.try(:elisa)
        return blocked_list
    end
end