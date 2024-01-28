class VisitReportXrayFacility < ApplicationRecord
    RECOMMENDATIONS = {
        "NON_COMPLIANCE" => "To Send Non-Compliance Letter",
        "NON_COMPLIANCE_MSPC" => "To Send Non-Compliance Letter With MSPC Follow Up",
        "REPRIMAND_LETTER" => "To Send Reprimand Letter",
        "NON_COMPLIANCE_AND_REFER_MSPC" => "To Send Non-Compliance Letter And Refer To INSP-MSPD/MSPC Meeting",
        "REFER_MSPC" => "To Refer INSP-MSPD/MSPC Meeting For Further Action",
        "SATISFACTORY" => "Satisfactory"
    }

    NON_COMPLIANCES = {
        "non_verify_original_passport_fw_present" => "(Y) Non Verfication with original passport",
        "non_verify_original_passport_fw_not_present" => "(N) Ver. With PP & others (PC, JIM & F.Card) - FW not present",
        "unable_to_produce_apc" => "(A) Unable to produce APC",
        "no_xray_license_for_mengguna" => "(M) No X-Ray license  for 'Mengguna'",
        "inadequate_equipment" => "(I) Inadequate Facility",
        "insufficient_operation_hour" => "(H) Insufficient Operation Hours (Less Than 8 Hours)",
        "expired_license_menstor_mengguna" => "(E) Expired License For 'Menstor' And 'Mengguna'",
        "no_produce_medical_record" => "(R) Unable To Produce Medical Records",
        "closed" => "(P) Clinic Closed",
        "no_produce_borang_b" => "(B) Unable To Produce Borang B",
        "other" => "(O) Others",
        "dispatch_record_to_xqcc" => "(X) X-Ray Films Dispatch Record to XQCC",
        "satisfactory" => "(S )Satisfactory"
    }

    ## for form field
    FIELD_FOREIGN_WORKER = {
        "no_xray_examination" => "No verification of identity prior to x-ray examination",
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

    FIELD_XRAY_CENTRE_LICENSE = {
        "license_not_available" => "The x-ray license is not available",
        "license_expired" => "The x-ray license is expired",
        "different_name" => "Different name",
        "different_address" => "Different address",
        "others" => "Others"
    }

    FIELD_MEDICAL_RECORDS = {
        "not_available" => "Not available",
        "kept_other_premise" => "Kept at other premise",
        "not_maintained" => "Not maintained",
        "others" => "Others"
    }

    FIELD_ADEQUATE_FACILITIES = {
        "device_not_available" => "X-ray machine/device is not available",
        "device_not_functioning" => "X-ray machine/device is not functioning",
        "biometric_device" => "Biometric device not available",
        "others" => "Others"
    }

    FIELD_DISPATCH = {
        "not_available" => "Not available",
        "kept_other_premise" => "Kept at other premise",
        "not_maintained" => "Not maintained",
        "details_not_complete" => "Details not complete",
        "others" => "Others"
    }

    FIELD_OPERATION_HOURS = {
        "differ_from_system" => "Operation hours stated in clinic differ with operation hour in FOMEMA system",
        "did_not_fulfil_8h5d" => "Facility's operation hours did not fulfil 8 hours a day, 5 days a week",
        "others" => "Others",
    }

    FIELD_OTHERS = {
        "closed_during_visit" => "X-ray facility closed during inspectorate visit",
        "shifted_location" => "Clinic shifted to another location",
        "does_not_exist" => "Clinic does not exist at the registered premise",
        "differ_from_registration" => "Clinic name differs with 'FOMEMA' registration",
        "license_resigned" => "Registered x-ray license resigned",
        "license_pass_away" => "Registered x-ray license passed away",
        "license_withdraw" => "Registered x-ray license wants to withdraw as FOMEMA panel",
        "interrelated_facilities" => "Interrelated facilities",
        "refuse_to_cooperate" => "Doctor/staff refuse to cooperate",
        "xray_examination_not_done" => "All x-ray examination were not done at registered facilities",
        "inhouse_facility" => "In-house x-ray facility",
        "others" => "Others"
    }
    ## end form field

    ## explanation letter
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
    
    MEDICAL_RECORDS = {
        "not_available" => "Medical records of examined foreign workers not available",
        "kept_other_premise" => "Medical records of examined foreign workers kept at another premise",
        "not_maintained" => "Medical records of examined foreign workers not maintained",
        "others" => "Others"
    }

    audited
    include CaptureAuthor

    belongs_to :visit_report
    belongs_to :xray_facility

    def sop_compliance
        sopArr = []
        
        sopArr.push('S') if satisfactory
        sopArr.push('Y') if non_verify_original_passport_fw_present
        sopArr.push('N') if non_verify_original_passport_fw_not_present
        sopArr.push('A') if unable_to_produce_apc
        sopArr.push('M') if no_xray_license_for_mengguna
        sopArr.push('I') if inadequate_equipment
        sopArr.push('H') if insufficient_operation_hour
        sopArr.push('E') if expired_license_menstor_mengguna
        sopArr.push('R') if no_produce_medical_record
        sopArr.push('P') if closed
        sopArr.push('B') if no_produce_borang_b
        sopArr.push('K') if other
        sopArr.push('X') if dispatch_record_to_xqcc

        "#{sopArr.join(',')}"
    end
end
