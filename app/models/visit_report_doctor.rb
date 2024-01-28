class VisitReportDoctor < ApplicationRecord
    RECOMMENDATIONS = {
        "NON_COMPLIANCE" => "To Send Non-Compliance Letter",
        "NON_COMPLIANCE_MSPC" => "To Send Non-Compliance Letter With MSPC Follow Up",
        "REPRIMAND_LETTER" => "To Send Reprimand Letter",
        "NON_COMPLIANCE_AND_REFER_MSPC" => "To Send Non-Compliance Letter And Refer To INSP-MSPD/MSPC Meeting",
        "REFER_MSPC" => "To Refer INSP-MSPD/MSPC Meeting For Further Action",
        "SATISFACTORY" => "Satisfactory"
    }

    ## for explanation letter
    FOREIGN_WORKERS = {
        "no_medical_examination" => "Verification of identity prior to medical examination not available",
        "without_biometric_device" => "Verification without using biometric device",
        "without_original_passport" => "Verification without using original passport",
        "using_photocopy_passport" => "Verification using photocopy passport",
        "using_id_card" => "Verification using id card / name tag",
        "using_fake_passport" => "Verification using fake passport",
        "others" => "Others"
    }

    APC = {
        "not_available_current_year" => "APC of registered doctor not available for current year",
        "not_stated_in_place" => "Place of practice registered with FOMEMA not stated in the APC",
        "different_name" => "Registered doctor name is different",
        "different_address" => "Registered address different in place of practice",
        "others" => "Others"
    }

    REGISTRATION_NUMBER = {
        "registration_not_available" => "The registration under Private Healthcare Facilities and Service Act 1998 form is not available",
        "different_name" => "Facilities name in the registration under Private Healthcare Facilities and Service Act 1998 is different",
        "different_address" => "Facilities address in the registration under Private Healthcare Facilities and Service Act 1998 is different",
        "others" => "Others"
    }

    FOREIGN_WORKER_CONSENT = {
        "not_available" => "Written consent from foreign workers not available",
        "kept_other_premise" => "Written consent from foreign workers kept at another premise",
        "not_maintained" => "Written consent from foreign workers not maintained",
        "details_not_complete" => "Written consent from foreign workers details not complete",
        "unsigned_foreign_worker" => "Written consent from foreign workers not signed by the foreign worker",
        "unsigned_examine_doctor" => "Written consent from foreign workers not signed by the examining doctor",
        "others" => "Others"
    }

    MEDICAL_RECORDS = {
        "not_available" => "Medical records of examined foreign workers not available",
        "kept_other_premise" => "Medical records of examined foreign workers kept at another premise",
        "not_maintained" => "Medical records of examined foreign workers not maintained",
        "no_blood_pressure" => "Blood pressure measurement was not recorded",
        "no_pulse_rate" => "Pulse rate reading was not recorded",
        "no_height_measurement" => "Height measurement was not recorded",
        "no_weight_measurement" => "Weight measurement was not recorded",
        "no_vision_acuity" => "Vision acuity test finding was not recorded",
        "others" => "Others"
    }

    NOTIFICATION = {
        "not_notify_to_office" => "The notification for the following cases to the nearest District Health Office has not been done.",
        "others" => "Others"
    }

    VACUTAINER = {
        "reuse_urine_container" => "Reusable of urine container",
        "expired_vacutainer" => "Expired vacutainer tube",
        "inappropriate_urine_container" => "Inappropriate urine container",
        "others" => "Others"
    }
    
    ADEQUATE_FACILITIES = {
        "blood_pressure" => "Blood Pressure measuring equipment not available",
        "vision_acuity_test" => "Snellen chart not available",
        "weight_scale" => "Weighing Scale not available",
        "height_scale" => "Height Scale not available",
        "biometric_device" => "Biometric device not available",
        "internet_access" => "Computer with internet access not available",
        "others" => "Others"
    }

    DISPATCH = {
        "not_available" => "Laboratory specimens dispatch book/record was not available",
        "kept_other_premise" => "Laboratory specimens dispatch book/record was kept at another premise",
        "not_maintained" => "Laboratory specimens dispatch book/record was not maintained",
        "details_not_complete" => "Laboratory specimens dispatch book/record details were incomplete",
        "signature_not_available" => "Laboratory dispatch personnel signature was not available",
        "stamp_not_available" => "Laboratory dispatch stamp was not available",
        "others" => "Others"
    }
    ## end explanation letter

    ## for form field
    FIELD_FOREIGN_WORKER = {
        "no_medical_examination" => "No verification of identity prior to medical examination",
        "without_biometric_device" => "Verification without using biometric device",
        "without_original_passport" => "Verification without using original passport",
        "using_photocopy_passport" => "Verification using photocopy passport",
        "using_id_card" => "Verification using ID card/name tag",
        "using_fake_passport" => "Verification using fake passport",
        "others" => "Others"
    }

    FIELD_APC = {
        "not_available_current_year" => "APC not available for current year",
        "not_stated_in_place" => "Registered facility with FOMEMA not stated in Place of practice the APC",
        "different_name" => "Different name",
        "different_address" => "Different address in place of practice",
        "others" => "Others"
    }

    FIELD_REGISTRATION_NUMBER = {
        "registration_not_available" => "The Registration under Private Healthcare Facilities and Service Act 1998 form is not available",
        "different_name" => "Different name",
        "different_address" => "Different address",
        "others" => "Others"
    }

    FIELD_FOREIGN_WORKER_CONSENT = {
        "not_available" => "Not available",
        "kept_other_premise" => "Kept at other premise",
        "not_maintained" => "Not maintained",
        "details_not_complete" => "Details not complete",
        "unsigned_foreign_worker" => "Not signed by the foreign worker",
        "unsigned_examine_doctor" => "Not signed by the examining doctor",
        "others" => "Others"
    }

    FIELD_MEDICAL_RECORDS = {
        "not_available" => "Not available",
        "kept_other_premise" => "Kept at other premise",
        "not_maintained" => "Not maintained",
        "no_blood_pressure" => "Blood pressure was not recorded",
        "no_pulse_rate" => "Pulse rate was not recorded",
        "no_height_measurement" => "Height measurement was not recorded",
        "no_weight_measurement" => "Weight measurement was not recorded",
        "no_vision_acuity" => "Vision acuity test finding was not recorded",
        "others" => "Others"
    }

    FIELD_NOTIFICATION = {
        "not_available" => "Not available",
        "kept_other_premise" => "Kept at other premise",
        "not_notify_to_office" => "Not notify the communicable diseases to the nearest Health District Office",
        "others" => "Others"
    }

    FIELD_VACUTAINER = {
        "reuse_urine_container" => "Reusable of urine container",
        "expired_vacutainer" => "Expired vacutainer tube",
        "inappropriate_urine_container" => "Inappropriate urine container",
        "others" => "Others"
    }
    
    FIELD_ADEQUATE_FACILITIES = {
        "blood_pressure" => "Blood pressure measuring equipment not available",
        "vision_acuity_test" => "Snellen chart not available/Vision acuity test equipment not available",
        "weight_scale" => "Weighing scale not available",
        "height_scale" => "Height scale not available",
        "biometric_device" => "Biometric device not available",
        "internet_access" => "Computer with internet access",
        "others" => "Others"
    }

    FIELD_DISPATCH = {
        "not_available" => "Not available",
        "kept_other_premise" => "Kept at other premise",
        "not_maintained" => "Not maintained",
        "details_not_complete" => "Details not complete",
        "signature_not_available" => "Laboratory dispatch personnel signature was not available",
        "stamp_not_available" => "Laboratory dispatch stamp was not available",
        "others" => "Others"
    }

    FIELD_OPERATION_HOURS = {
        "differ_from_system" => "Operation hours stated in clinic differ with operation hour in FOMEMA system",
        "did_not_fulfil_8h5d" => "Facility's operation hours did not fulfil 8 hours a day, 5 days a week",
        "others" => "Others",
    }

    FIELD_OTHERS = {
        "closed_during_visit" => "Clinic closed during inspectorate visit",
        "shifted_location" => "Clinic shifted to another location",
        "does_not_exist" => "Clinic does not exist at the registered premise",
        "differ_from_registration" => "Clinic name differs with 'FOMEMA' registration",
        "doctor_resigned" => "Registered doctor resigned",
        "doctor_pass_away" => "Registered doctor pass away",
        "doctor_withdraw" => "Registered doctor wants to withdraw from FOMEMA panel",
        "interrelated_facilities" => "Interrelated facilities",
        "refuse_to_cooperate" => "Doctor/staff refuse to cooperate",
        "doctor_unavailable" => "Doctor unavailable",
        "med_examination_not_done" => "All Medical examinations were not done at registered facilities",
        "inhouse_clinic" => "In-house clinic",
        "others" => "Others"
    }
    ## end form field


    NON_COMPLIANCES = {
        "satisfactory" => "(S) Satisfactory",
        "non_verify_original_passport_fw_present" => "(Y) Non Verfication with original passport- FW present",
        "non_verify_original_passport_fw_not_present" => "(N) Ver. With PP & others (PC, JIM & F.Card) - FW not present",
        "unable_to_produce_apc" => "(A) Unable To Produce APC",
        "non_notify_communicable_disease" => "(G) Non notification of communicable diseases.",
        "inadequate_equipment" => "(I) Equipment not in order.",
        "insufficient_operation_hour" => "(H) Insufficient Operation Hours (Less Than 8 Hours)",
        "inappropriate_vacutainer" => "(V) Inappropriate Vacutainer/Specimen Container",
        "no_produce_dispatch_record" => "(L) No Laboratory Dispatch Record/Book",
        "no_produce_written_consent" => "(C) Unable To Produce Written Consent",
        "no_produce_medical_record" => "(R) Unable To Produce Medical Records",
        "closed" => "(P) Clinic closed",
        "no_produce_borang_b" => "(B) Unable To Produce Borang B",
        "other" => "(K) Others"
    }

    audited
    include CaptureAuthor

    belongs_to :visit_report
    belongs_to :doctor

    def sop_compliance
        sopArr = []
        
        sopArr.push('S') if satisfactory
        sopArr.push('Y') if non_verify_original_passport_fw_present
        sopArr.push('N') if non_verify_original_passport_fw_not_present
        sopArr.push('A') if unable_to_produce_apc
        sopArr.push('G') if non_notify_communicable_disease
        sopArr.push('I') if inadequate_equipment
        sopArr.push('H') if insufficient_operation_hour
        sopArr.push('V') if inappropriate_vacutainer
        sopArr.push('L') if no_produce_dispatch_record
        sopArr.push('C') if no_produce_written_consent
        sopArr.push('R') if no_produce_medical_record
        sopArr.push('P') if closed
        sopArr.push('B') if no_produce_borang_b
        sopArr.push('K') if other

        "#{sopArr.join(',')}"
    end
end
