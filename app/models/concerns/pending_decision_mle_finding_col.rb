module PendingDecisionMleFindingCol
    extend ActiveSupport::Concern

    def mle_finding_fields
        field_names_and_remarks = {
            condition_tuberculosis: "Tuberculosis",
            condition_heart_diseases: "Heart Diseases",
            condition_other: "Unsuitable condition Others",
        }
    end

    def mle_finding_updateable_fields
        %w(condition_tuberculosis condition_other condition_heart_diseases)
    end

    def mle_finding_other_fields
        %w(condition_hypertension condition_heart_diseases condition_bronchial_asthma condition_diabetes_mellitus condition_peptic_ulcer condition_kidney_diseases condition_urine_for_pregnant condition_urine_for_opiates condition_urine_for_cannabis)
    end

    def mle_toggle_other_field
        'condition_other'
    end

end