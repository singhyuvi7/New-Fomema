class Role < ApplicationRecord
    MODULE_PERMISSIONS = {
        system_configuration: [
            "VIEW_SYSTEM_CONFIGURATION",
            "VIEW_XQCC_SYSTEM_CONFIGURATION",
            "VIEW_FINANCE_SYSTEM_CONFIGURATION",
            "EDIT_SYSTEM_CONFIGURATION",
            "EDIT_XQCC_SYSTEM_CONFIGURATION",
            "EDIT_FINANCE_SYSTEM_CONFIGURATION",
            "APPROVAL_SYSTEM_CONFIGURATION",
            "APPROVAL_XQCC_SYSTEM_CONFIGURATION",
            "VIEW_AUDIT_SYSTEM_CONFIGURATION",
        ],
        country: [
            "VIEW_COUNTRY",
            "CREATE_COUNTRY",
            "EDIT_COUNTRY",
            "DELETE_COUNTRY",
            "VIEW_AUDIT_COUNTRY"
        ],
        state: [
            "VIEW_STATE",
            "CREATE_STATE",
            "EDIT_STATE",
            "DELETE_STATE",
            "VIEW_AUDIT_STATE"
        ],
        town: [
            "VIEW_TOWN",
            "CREATE_TOWN",
            "EDIT_TOWN",
            "DELETE_TOWN",
            "VIEW_AUDIT_TOWN"
        ],
        zone: [
            "VIEW_ZONE",
            "CREATE_ZONE",
            "EDIT_ZONE",
            "DELETE_ZONE",
            "VIEW_AUDIT_ZONE"
        ],
        bank: [
            "VIEW_BANK",
            "CREATE_BANK",
            "EDIT_BANK",
            "DELETE_BANK",
            "VIEW_AUDIT_BANK"
        ],
        district_health_office: [
            "VIEW_DISTRICT_HEALTH_OFFICE",
            "CREATE_DISTRICT_HEALTH_OFFICE",
            "EDIT_DISTRICT_HEALTH_OFFICE",
            "DELETE_DISTRICT_HEALTH_OFFICE",
            "VIEW_AUDIT_DISTRICT_HEALTH_OFFICE"
        ],
        role: [
            "VIEW_ROLE",
            "CREATE_ROLE",
            "EDIT_ROLE",
            "DELETE_ROLE"
        ],
        employer_type: [
            "VIEW_EMPLOYER_TYPE",
            "CREATE_EMPLOYER_TYPE",
            "EDIT_EMPLOYER_TYPE",
            "DELETE_EMPLOYER_TYPE",
            "VIEW_AUDIT_EMPLOYER_TYPE"
        ],
        job_type: [
            "VIEW_JOB_TYPE",
            "CREATE_JOB_TYPE",
            "EDIT_JOB_TYPE",
            "DELETE_JOB_TYPE",
            "VIEW_AUDIT_JOB_TYPE"
        ],
        laboratory_type: [
            "VIEW_LABORATORY_TYPE",
            "CREATE_LABORATORY_TYPE",
            "EDIT_LABORATORY_TYPE",
            "DELETE_LABORATORY_TYPE",
            "VIEW_AUDIT_LABORATORY_TYPE"
        ],
        laboratory_certified_transactions: [
            "VIEW_LABORATORY_CERTIFIED_TRANSACTIONS"
        ],
        race: [
            "VIEW_RACE",
            "CREATE_RACE",
            "EDIT_RACE",
            "DELETE_RACE",
            "VIEW_AUDIT_RACE"
        ],
        title: [
            "VIEW_TITLE",
            "CREATE_TITLE",
            "EDIT_TITLE",
            "DELETE_TITLE",
            "VIEW_AUDIT_TITLE"
        ],
        tcupi_todo: [
            "VIEW_TCUPI_TODO",
            "CREATE_TCUPI_TODO",
            "EDIT_TCUPI_TODO",
            "DELETE_TCUPI_TODO",
            "VIEW_AUDIT_TCUPI_TODO"
        ],
        appeal_todo: [
            "VIEW_APPEAL_TODO",
            "CREATE_APPEAL_TODO",
            "EDIT_APPEAL_TODO",
            "DELETE_APPEAL_TODO",
            "VIEW_AUDIT_APPEAL_TODO"
        ],
        fp_device: [
            "VIEW_FP_DEVICE",
            "CREATE_FP_DEVICE",
            "EDIT_FP_DEVICE",
            "DELETE_FP_DEVICE"
        ],
        password_policy: [
            "VIEW_PASSWORD_POLICY",
            "CREATE_PASSWORD_POLICY",
            "EDIT_PASSWORD_POLICY",
            "DELETE_PASSWORD_POLICY",
            "APPROVAL_PASSWORD_POLICY"
        ],
        status_schedule: [
            "VIEW_STATUS_SCHEDULE",
            "CREATE_STATUS_SCHEDULE",
            "EDIT_STATUS_SCHEDULE",
            "DELETE_STATUS_SCHEDULE"
        ],
        group_schedule: [
            "VIEW_GROUP_SCHEDULE",
            "CREATE_GROUP_SCHEDULE",
            "EDIT_GROUP_SCHEDULE",
            "DELETE_GROUP_SCHEDULE"
        ],
        fee: [
            "VIEW_FEE",
            "CREATE_FEE",
            "EDIT_FEE",
            "DELETE_FEE",
            "VIEW_AUDIT_FEE"
        ],
        payment_method: [
            "VIEW_PAYMENT_METHOD",
            "CREATE_PAYMENT_METHOD",
            "EDIT_PAYMENT_METHOD",
            "DELETE_PAYMENT_METHOD",
            "VIEW_AUDIT_PAYMENT_METHOD"
        ],
        block_reason: [
            "VIEW_BLOCK_REASON",
            "CREATE_BLOCK_REASON",
            "EDIT_BLOCK_REASON",
            "DELETE_BLOCK_REASON",
            "VIEW_AUDIT_BLOCK_REASON"
        ],
        bypass_fingerprint_reason: [
            "VIEW_BYPASS_FINGERPRINT_REASON",
            "CREATE_BYPASS_FINGERPRINT_REASON",
            "EDIT_BYPASS_FINGERPRINT_REASON",
            "DELETE_BYPASS_FINGERPRINT_REASON",
            "VIEW_AUDIT_BYPASS_FINGERPRINT_REASON"
        ],
        monitor_reason: [
            "VIEW_MONITOR_REASON",
            "CREATE_MONITOR_REASON",
            "EDIT_MONITOR_REASON",
            "DELETE_MONITOR_REASON",
            "VIEW_AUDIT_MONITOR_REASON"
        ],
        retake_reason: [
            "VIEW_RETAKE_REASON",
            "CREATE_RETAKE_REASON",
            "EDIT_RETAKE_REASON",
            "DELETE_RETAKE_REASON",
            "VIEW_AUDIT_RETAKE_REASON"
        ],
        amendment_reason: [
            "VIEW_AMENDMENT_REASON",
            "CREATE_AMENDMENT_REASON",
            "EDIT_AMENDMENT_REASON",
            "DELETE_AMENDMENT_REASON",
            "VIEW_AUDIT_AMENDMENT_REASON"
        ],
        change_sp_reason: [
            "VIEW_CHANGE_SP_REASON",
            "CREATE_CHANGE_SP_REASON",
            "EDIT_CHANGE_SP_REASON",
            "DELETE_CHANGE_SP_REASON",
            "VIEW_AUDIT_CHANGE_SP_REASON"
        ],
        organization: [
            "VIEW_ORGANIZATION",
            "CREATE_ORGANIZATION",
            "EDIT_ORGANIZATION",
            "DELETE_ORGANIZATION",
            "VIEW_AUDIT_ORGANIZATION"
        ],
        user: [
            "VIEW_USER",
            "CREATE_USER",
            "EDIT_USER",
            "DELETE_USER",
            "APPROVAL_USER",
            "RESET_PASSWORD_USER",
            "EXPORT_USER_ROLE_PERMISSION",
            "RESEND_CONFIRMATION_INSTRUCTION_USER"
        ],

        doctor: [
            "VIEW_DOCTOR",
            "VIEW_NON_FINANCE_INFO_DOCTOR",
            "VIEW_FINANCE_INFO_DOCTOR",
            "VIEW_DOCUMENT_DOCTOR",
            "CREATE_DRAFT_DOCTOR", # has save as draft
            "CREATE_SUBMIT_APPROVAL_DOCTOR", # has submit for approval
            "EDIT_NON_FINANCE_INFO_DOCTOR",
            "EDIT_FINANCE_INFO_DOCTOR",
            "EDIT_DRAFT_DOCTOR", # has save as draft
            "EDIT_SUBMIT_APPROVAL_DOCTOR",
            "EDIT_PAIRING_DOCTOR",
            "DELETE_DOCTOR",
            "APPROVAL_DOCTOR",
            "CONCUR_DOCTOR",
            "ACTIVATE_DOCTOR",
            "VIEW_AUDIT_DOCTOR",
            "BULK_ASSIGN_QUOTA_DOCTOR",
            "VIEW_OPERATION_HOUR_DOCTOR",
            "VIEW_INSPECTORATE_DETAILS",
            "DOWNLOAD_WALL_LIST_DOCTOR",
            "VIEW_COUPLING_HISTORY"
        ],
        laboratory: [
            "VIEW_LABORATORY",
            "VIEW_NON_FINANCE_INFO_LABORATORY",
            "VIEW_FINANCE_INFO_LABORATORY",
            "VIEW_DOCUMENT_LABORATORY",
            "CREATE_DRAFT_LABORATORY",
            "CREATE_SUBMIT_APPROVAL_LABORATORY",
            "EDIT_NON_FINANCE_INFO_LABORATORY",
            "EDIT_PASSPHRASE_LABORATORY",
            "EDIT_FINANCE_INFO_LABORATORY",
            "EDIT_DRAFT_LABORATORY",
            "EDIT_SUBMIT_APPROVAL_LABORATORY",
            "DELETE_LABORATORY",
            "APPROVAL_LABORATORY",
            "CONCUR_LABORATORY",
            "ACTIVATE_LABORATORY",
            "VIEW_AUDIT_LABORATORY",
            "BULK_REALLOCATION_LABORATORY",
            "VIEW_OPERATION_HOUR_LABORATORY"
        ],
        xray_facility: [
            "VIEW_XRAY_FACILITY",
            "VIEW_NON_FINANCE_INFO_XRAY_FACILITY",
            "VIEW_FINANCE_INFO_XRAY_FACILITY",
            "VIEW_DOCUMENT_XRAY_FACILITY",
            "CREATE_DRAFT_XRAY_FACILITY",
            "CREATE_SUBMIT_APPROVAL_XRAY_FACILITY",
            "EDIT_NON_FINANCE_INFO_XRAY_FACILITY",
            "EDIT_FINANCE_INFO_XRAY_FACILITY",
            "EDIT_DRAFT_XRAY_FACILITY",
            "EDIT_SUBMIT_APPROVAL_XRAY_FACILITY",
            "DELETE_XRAY_FACILITY",
            "APPROVAL_XRAY_FACILITY",
            "CONCUR_XRAY_FACILITY",
            "ACTIVATE_XRAY_FACILITY",
            "VIEW_AUDIT_XRAY_FACILITY",
            "BULK_REALLOCATION_XRAY_FACILITY",
            "VIEW_OPERATION_HOUR_XRAY_FACILITY",
            "VIEW_MERTS_XRAY_TO_RADIOLOGIST_REPORTED_CASES",
            "VIEW_QUALITY_SUMMARY_REPORTS",
            "SEND_ARL_REQUEST"
        ],
        radiologist: [
            "VIEW_RADIOLOGIST",
            "VIEW_DOCUMENT_RADIOLOGIST",
            "CREATE_DRAFT_RADIOLOGIST",
            "CREATE_SUBMIT_APPROVAL_RADIOLOGIST",
            "EDIT_RADIOLOGIST",
            "DELETE_RADIOLOGIST",
            "APPROVAL_RADIOLOGIST",
            "CONCUR_RADIOLOGIST",
            "ACTIVATE_RADIOLOGIST",
            "VIEW_AUDIT_RADIOLOGIST",
            "VIEW_MERTS_RADIOLOGIST_TO_XRAY_REPORTED_CASES"
        ],
        favourite_radiologist: [
            "VIEW_FAVOURITE_RADIOLOGIST",
            "CREATE_FAVOURITE_RADIOLOGIST",
            "DELETE_FAVOURITE_RADIOLOGIST",
            "EDIT_FAVOURITE_RADIOLOGIST",
        ],
        service_provider_group: [
            "VIEW_SERVICE_PROVIDER_GROUP",
            "VIEW_AUDIT_SERVICE_PROVIDER_GROUP",
            "VIEW_NON_FINANCE_INFO_SERVICE_PROVIDER_GROUP",
            "VIEW_FINANCE_INFO_SERVICE_PROVIDER_GROUP",
            "CREATE_SERVICE_PROVIDER_GROUP",
            "EDIT_NON_FINANCE_INFO_SERVICE_PROVIDER_GROUP",
            "EDIT_FINANCE_INFO_SERVICE_PROVIDER_GROUP",
            "DELETE_SERVICE_PROVIDER_GROUP",
            "CREATE_MEMBER_SERVICE_PROVIDER_GROUP",
            "DELETE_MEMBER_SERVICE_PROVIDER_GROUP"
        ],
        employer: [
            "VIEW_ALL_EMPLOYER",
            "VIEW_BRANCH_EMPLOYER",
            "VIEW_OWN_EMPLOYER",
            "VIEW_NON_FINANCE_INFO_EMPLOYER",
            "VIEW_FINANCE_INFO_EMPLOYER",
            "CREATE_EMPLOYER",
            "EDIT_NON_FINANCE_INFO_EMPLOYER",
            "EDIT_FINANCE_INFO_EMPLOYER",
            "EDIT_FINANCE_EMPLOYER_CORPORATE",
            "DELETE_EMPLOYER",
            "APPROVAL_EMPLOYER",
            "APPROVAL_EMPLOYER_CRITICAL_INFO",
            "CREATE_USER_EMPLOYER",
            "EDIT_USER_EMPLOYER",
            "DELETE_USER_EMPLOYER",
            "CREATE_SUPPLEMENTAL_USER_EMPLOYER",
            "EDIT_SUPPLEMENTAL_USER_EMPLOYER",
            "DELETE_SUPPLEMENTAL_USER_EMPLOYER",
            "VIEW_UPLOAD_DOCUMENT_EMPLOYER",
            "CREATE_UPLOAD_DOCUMENT_EMPLOYER",
            "DELETE_UPLOAD_DOCUMENT_EMPLOYER",
            "VIEW_AUDIT_EMPLOYER",
            "VIEW_EXAM_HISTORY_RESULTS_AND_BUTTON"
        ],
        agency: [
            "VIEW_ALL_AGENCY",
            "VIEW_OWN_AGENCY",
            "VIEW_NON_FINANCE_INFO_AGENCY",
            "VIEW_FINANCE_INFO_AGENCY",
            "CREATE_AGENCY",
            "EDIT_NON_FINANCE_INFO_AGENCY",
            "EDIT_FINANCE_INFO_AGENCY",
            "DELETE_AGENCY",
            "APPROVAL_AGENCY",
            "CREATE_USER_AGENCY",
            "EDIT_USER_AGENCY",
            "DELETE_USER_AGENCY",
            "VIEW_UPLOAD_DOCUMENT_AGENCY",
            "CREATE_UPLOAD_DOCUMENT_AGENCY",
            "DELETE_UPLOAD_DOCUMENT_AGENCY",
            "VIEW_AUDIT_AGENCY"
        ],
        foreign_worker: [
            "VIEW_ALL_FOREIGN_WORKER",
            "VIEW_BRANCH_FOREIGN_WORKER",
            "VIEW_OWN_FOREIGN_WORKER",
            "CREATE_FOREIGN_WORKER",
            "EDIT_FOREIGN_WORKER",
            "EDIT_GENDER_FOREIGN_WORKER",
            "EDIT_EMPLOYER_FOREIGN_WORKER",
            "EDIT_EMPLOYER_SUPPLEMENT_FOREIGN_WORKER",
            "DELETE_FOREIGN_WORKER",
            "APPROVAL_FOREIGN_WORKER",
            "BLACKLIST_FOREIGN_WORKER",
            "LIFT_BLACKLIST_FOREIGN_WORKER",
            "BLOCK_FOREIGN_WORKER",
            "UNBLOCK_FOREIGN_WORKER",
            "MONITOR_FOREIGN_WORKER",
            "UNMONITOR_FOREIGN_WORKER",
            "ACTIVATE_FOREIGN_WORKER",
            "DEACTIVATE_FOREIGN_WORKER",
            "VIEW_AUDIT_FOREIGN_WORKER",
            "SEARCH_FOREIGN_WORKER",
            "DELETE_UPLOAD_DOCUMENT_FOREIGN_WORKER",
            "VIEW_FW_CHANGE_EMPLOYER",
            "CHANGE_EMPLOYER_APPROVAL_FOREIGN_WORKER",
        ],
        transaction: [
            "VIEW_ALL_TRANSACTION",
            "VIEW_BRANCH_TRANSACTION",
            "VIEW_OWN_TRANSACTION",
            "CREATE_TRANSACTION",
            "CREATE_SPECIAL_RENEWAL_TRANSACTION",
            "CREATE_FOC_TRANSACTION",
            "EDIT_TRANSACTION",
            "EDIT_BYPASS_FINGERPRINT_TRANSACTION",
            "DELETE_TRANSACTION",
            "EXTEND_TRANSACTION",
            "CANCEL_TRANSACTION",
            "ASSIGN_DOCTOR_TRANSACTION",
            "CHANGE_DOCTOR_TRANSACTION",
            "APPROVAL_CHANGE_DOCTOR_TRANSACTION",
            "APPROVAL_DOCUMENT_TRANSACTION",
            "APPROVAL_SPECIAL_RENEWAL_TRANSACTION",
            "VIEW_APPROVAL_SPECIAL_RENEWAL_TRANSACTION",
            "MEDICAL_EXAMINATION_TRANSACTION",
            "MEDICAL_PICKUP_TRANSACTION",
            "MEDICAL_APPROVAL_TRANSACTION",
            "MEDICAL_ASSIGN_TRANSACTION",
            "VIEW_AUDIT_TRANSACTION",
            "EDIT_COUPLING_TRANSACTION",
            "BULK_EDIT_COUPLING_TRANSACTION",
            "SET_IGNORE_CANCELLATION_RULE",
            "RESEND_UNSUITABLE_LETTER",
            "SET_IMM_BLOCK",
            "AGENCY_UPLOAD_TRANSACTION_DOCUMENT",
            "SPECIAL_RENEWAL_UPLOAD_TRANSACTION_DOCUMENT",
            "EXPORT_TRANSACTION",
            "CREATE_BYPASS_FINGERPRINT_REQUEST",
            "APPROVAL_BYPASS_FINGERPRINT_TRANSACTION",
            "VIEW_APPROVAL_BYPASS_FINGERPRINT_TRANSACTION",
            "DELETE_BYPASS_FINGERPRINT_TRANSACTION_DOCUMENT",
            "UPDATE_PASSPORT_FOR_PREVIOUS_TRANSACTION",
        ],
        xqcc_pending_review: [
            "VIEW_XQCC_PENDING_REVIEW",
            "EDIT_XQCC_PENDING_REVIEW",
            "DELETE_XQCC_PENDING_REVIEW",
            "PICKUP_XQCC_PENDING_REVIEW",
            "VIEW_AUDIT_XQCC_PENDING_REVIEW",
        ],
        xqcc_pending_decision: [
            "VIEW_XQCC_PENDING_DECISION",
            "EDIT_XQCC_PENDING_DECISION",
            "DELETE_XQCC_PENDING_DECISION",
            "VIEW_AUDIT_XQCC_PENDING_DECISION",
            "VIEW_APPROVAL_XQCC_PENDING_DECISION",
            "EDIT_APPROVAL_XQCC_PENDING_DECISION",
        ],
        xqcc_pool: [
            "PICKUP_XQCC_POOL",
            "REASSIGN_XQCC_POOL",
        ],
        xqcc_review: [
            "VIEW_XQCC_REVIEW",
            "CREATE_XQCC_REVIEW",
            "EDIT_XQCC_REVIEW",
            "DELETE_XQCC_REVIEW",
            "VIEW_AUDIT_XQCC_REVIEW",
        ],
        xqcc_letters: [
            "VIEW_XQCC_LETTERS",
            "CREATE_XQCC_LETTERS"
        ],
        pcr_pool: [
            "PICKUP_PCR_POOL",
            "REASSIGN_PCR_POOL",
        ],
        pcr_review: [
            "VIEW_PCR_REVIEW",
            "CREATE_PCR_REVIEW",
            "EDIT_PCR_REVIEW",
            "DELETE_PCR_REVIEW",
            "VIEW_AUDIT_PCR_REVIEW",
        ],
        xqcc_pcr: [
            "XRAY_PENDING_REVIEW_PICKUP_TRANSACTION",
            "XRAY_XQCC_POOL_REVIEW_TRANSACTION",
            "XRAY_PENDING_DECISION_TRANSACTION",
            "XRAY_PENDING_DECISION_APPROVAL_TRANSACTION",
            "XRAY_IMAGE_MOVEMENT_TRANSACTION"
        ],
        view_transactional_data_and_modules: [
            "VIEW_DOCTOR_DATA_TRANSACTION",
            "VIEW_LABORATORY_DATA_TRANSACTION",
            "VIEW_XRAY_DATA_TRANSACTION",
            "VIEW_CERTIFICATION_DATA_TRANSACTION",
            "VIEW_PENDING_REVIEW_AND_TCUPI_DATA_TRANSACTION",
            "VIEW_XQCC_DATA_TRANSACTION",
            "VIEW_APPEAL_DATA_TRANSACTION",
            "VIEW_AMENDMENT_UPDATE_RESULT_DATA_TRANSACTION",
            "VIEW_AMENDMENT_FINAL_RESULT_DATA_TRANSACTION",
            "VIEW_UNSUITABLE_REASONS_DATA_TRANSACTIONS",
            "VIEW_COMMUNICABLE_DISEASES_FILTER_OPTIONS",
        ],
        transactional_status_update: [
            "SET_PHYSICAL_NOT_DONE_FOR_TRANSACTION",
            "SET_IGNORE_MERTS_EXPIRY_FOR_TRANSACTION",
            "SET_IGNORE_REPRINT_RULES_FOR_TRANSACTION",
            "SET_IGNORE_RENEWAL_RULES_FOR_TRANSACTION",
            "ABORT_RADIOLOGIST_TRANSACTION",
            "REVERT_LAB_RESULTS_FOR_TRANSACTION",
            "REVERT_XRAY_RESULTS_FOR_TRANSACTION",
            "REMOVE_EXAM_DATE_FOR_TRANSACTION",
            "UPDATE_TRANSACTION_RESULT_FOR_TRANSACTION",
            "AMEND_FINAL_RESULT_FOR_TRANSACTION",
            "CONCUR_FINAL_RESULT_FOR_TRANSACTION",
            "EDIT_UNSUITABLE_REASONS_FOR_TRANSACTION",
            "SET_IGNORE_SPECIAL_RENEWAL_RULES_FOR_TRANSACTION"
        ],
        general_details: [
            "VIEW_AGENCY_INFO_IN_WORKER_INFORMATION",
            "VIEW_DOCUMENT_APPROVAL_IN_WORKER_INFORMATION",
            "VIEW_DOCTOR_INFO_IN_WORKER_INFORMATION",
            "VIEW_LABORATORY_INFO_IN_WORKER_INFORMATION",
            "VIEW_XRAY_INFO_IN_WORKER_INFORMATION",
            "VIEW_RADIOLOGIST_INFO_IN_WORKER_INFORMATION",
            "VIEW_MERTS_RESULTS_AND_STATUS_IN_WORKER_INFORMATION",
            "VIEW_MEDICAL_STATUS_IN_WORKER_INFORMATION",
            "VIEW_XQCC_RESULTS_AND_STATUS_IN_WORKER_INFORMATION",
            "VIEW_PLKS_NUMBER_IN_GENERAL_INFORMATION_WORKER_INFORMATION",
            "VIEW_ADDITIONAL_INFO_ABOVE_WORKER_INFORMATION",
            "VIEW_BLOCKED_MONITORING_TAG_IN_WORKER_INFORMATION"
        ],
        pending_reviews_and_tcupi: [
            "VIEW_PENDING_REVIEWS",
            "EDIT_PENDING_REVIEWS",
            "EDIT_PENDING_REVIEW_APPROVALS",
            "EDIT_PENDING_REVIEWS_QA",
            "VIEW_TCUPI_REVIEWS",
            "EDIT_TCUPI_REVIEWS",
            "VIEW_TCUPI_APPROVALS",
            "EDIT_TCUPI_APPROVALS",
        ],
        print_transactional_materials: [
            "PRINT_MEDICAL_EXAMINATION_FORM",
            "PRINT_MEDICAL_EXAMINATION_REPORT",
            "PRINT_XRAY_EXAMINATION_REPORT",
            "PRINT_TCUPI_AUDIT_LETTER",
            "PRINT_TCUPI_NON_AUDIT_LETTER"
        ],
        xray_retakes: [
            "PCR_XRAY_RETAKE",
            "XQCC_XRAY_RETAKE",
            "PCR_APPROVAL_XRAY_RETAKE",
            "XQCC_APPROVAL_XRAY_RETAKE"
        ],
        xqcc_pcr_reassign: [
            "REASSIGN_APPEAL_PCR_REVIEWS"
        ],
        appeals: [
            "VIEW_APPEALS",
            "REVIEW_APPEALS",
            "APPROVE_APPEALS",
            "CREATE_APPEALS",
            "COMMENT_IN_APPEALS",
            "VIEW_ALL_UPLOAD_DOCUMENT_APPEALS",
            "VIEW_OWN_UPLOAD_DOCUMENT_APPEALS",
            "CREATE_UPLOAD_DOCUMENT_APPEALS",
            "DELETE_UPLOAD_DOCUMENT_APPEALS",
            "REVIEW_MOH_APPEALS",
            "UPLOAD_MOH_APPEAL_LETTER",
            "DELETE_MOH_APPEAL_LETTER",
        ],
        bulletin: [
            "VIEW_BULLETIN",
            "CREATE_BULLETIN",
            "EDIT_BULLETIN",
            "DELETE_BULLETIN"
        ],
        order: [
            "VIEW_EMPLOYER_ORDER",
            "VIEW_AGENCY_ORDER",
            "VIEW_MSPD_ORDER",
            "CREATE_ORDER",
            "EDIT_ORDER",
            "DELETE_ORDER",
            "APPROVAL_ORDER",
            "PRINT_INVOICE_ORDER",
            "PRINT_HOWDEN_INVOICE_ORDER",
            "REQUERY_ORDER_PAYMENT",
            "VIEW_REQUERY_ORDER_PAYMENT",
            "EDIT_ORDER_STATUS",
        ],
        refund: [
            "VIEW_REFUND",
            "CREATE_REFUND",
            "EDIT_REFUND",
            "EDIT_STATUS_REFUND",
            "DELETE_REFUND",
            "APPROVAL_REFUND",
            "CANCEL_REFUND",
            "VIEW_AUDIT_REFUND",
            "PRINT_CREDIT_NOTE",
            "REPROCESS_REFUND",
            "EXPORT_REFUND",
        ],
        refund_batch: [
            "VIEW_REFUND_BATCH",
            "CREATE_REFUND_BATCH",
            "DELETE_REFUND_BATCH",
            "PROCESS_REFUND_BATCH"
        ],
        bank_draft: [
            "VIEW_BANK_DRAFT",
            "VIEW_EMPLOYER_BANK_DRAFT",
            "VIEW_SERVICE_PROVIDER_BANK_DRAFT",
            "CREATE_BANK_DRAFT",
            "EDIT_BANK_DRAFT",
            "DELETE_BANK_DRAFT",
            "HOLD_BANK_DRAFT",
            "UNHOLD_BANK_DRAFT",
            "SET_BAD_BANK_DRAFT",
            # "UNSET_BAD_BANK_DRAFT",
            "REPLACE_BANK_DRAFT",
            "REFUND_BANK_DRAFT"
        ],
        service_provider_payment:[
            "VIEW_SERVICE_PROVIDER_PAYMENT",
            "CREATE_SERVICE_PROVIDER_PAYMENT",
            # "BULK_UPDATE_SERVICE_PROVIDER_PAYMENT",
            "REPROCESS_SERVICE_PROVIDER_PAYMENT",
            "PROCESS_SERVICE_PROVIDER_PAYMENT",
            # "DELETE_SERVICE_PROVIDER_PAYMENT",
            "VIEW_MANUAL_PAYMENT",
            "EDIT_MANUAL_PAYMENT",
            "VIEW_PAYMENT_LISTING"
        ],
        xray_dispatch: [
            "VIEW_XRAY_DISPATCH",
            "CREATE_XRAY_DISPATCH",
            "EDIT_XRAY_DISPATCH",
            "DELETE_XRAY_DISPATCH"
        ],
        xray_storage: [
            "VIEW_XRAY_STORAGE",
            "CREATE_XRAY_STORAGE",
            "EDIT_XRAY_STORAGE",
            "DELETE_XRAY_STORAGE"
        ],
        insurance_purchase: [
            "VIEW_INSURANCE_PURCHASE",
            "CREATE_INSURANCE_PURCHASE",
            # "EDIT_INSURANCE_PURCHASE",
            # "DELETE_INSURANCE_PURCHASE",
            "RESUBMIT_PAID_INSURANCE_PURCHASE",
        ],
        doctor_visit_plan: [
            "VIEW_DOCTOR_VISIT_PLAN",
            "CREATE_DOCTOR_VISIT_PLAN",
            "EDIT_DOCTOR_VISIT_PLAN",
            "DELETE_DOCTOR_VISIT_PLAN",
            "APPROVAL_LEVEL_1_DOCTOR_VISIT_PLAN",
            "APPROVAL_LEVEL_2_DOCTOR_VISIT_PLAN"
        ],
        xray_facility_visit_plan: [
            "VIEW_XRAY_FACILITY_VISIT_PLAN",
            "CREATE_XRAY_FACILITY_VISIT_PLAN",
            "EDIT_XRAY_FACILITY_VISIT_PLAN",
            "DELETE_XRAY_FACILITY_VISIT_PLAN",
            "APPROVAL_LEVEL_1_XRAY_FACILITY_VISIT_PLAN",
            "APPROVAL_LEVEL_2_XRAY_FACILITY_VISIT_PLAN"
        ],
        laboratory_visit_plan: [
            "VIEW_LABORATORY_VISIT_PLAN",
            "CREATE_LABORATORY_VISIT_PLAN",
            "EDIT_LABORATORY_VISIT_PLAN",
            "DELETE_LABORATORY_VISIT_PLAN",
            "APPROVAL_LEVEL_1_LABORATORY_VISIT_PLAN",
            "APPROVAL_LEVEL_2_LABORATORY_VISIT_PLAN"
        ],
        doctor_visit_report: [
            "VIEW_DOCTOR_VISIT_REPORT",
            "CREATE_DOCTOR_VISIT_REPORT",
            "EDIT_DOCTOR_VISIT_REPORT",
            "DELETE_DOCTOR_VISIT_REPORT",
            "APPROVAL_LEVEL_1_DOCTOR_VISIT_REPORT",
            "APPROVAL_LEVEL_2_DOCTOR_VISIT_REPORT"
        ],
        xray_facility_visit_report: [
            "VIEW_XRAY_FACILITY_VISIT_REPORT",
            "CREATE_XRAY_FACILITY_VISIT_REPORT",
            "EDIT_XRAY_FACILITY_VISIT_REPORT",
            "DELETE_XRAY_FACILITY_VISIT_REPORT",
            "APPROVAL_LEVEL_1_XRAY_FACILITY_VISIT_REPORT",
            "APPROVAL_LEVEL_2_XRAY_FACILITY_VISIT_REPORT"
        ],
        laboratory_visit_report: [
            "VIEW_LABORATORY_VISIT_REPORT",
            "CREATE_LABORATORY_VISIT_REPORT",
            "EDIT_LABORATORY_VISIT_REPORT",
            "DELETE_LABORATORY_VISIT_REPORT",
            "APPROVAL_LEVEL_1_LABORATORY_VISIT_REPORT",
            "APPROVAL_LEVEL_2_LABORATORY_VISIT_REPORT"
        ],
        lqcc_letter: [
            "VIEW_LQCC_LETTER",
            "CREATE_LQCC_LETTER",
            "EDIT_LQCC_LETTER",
            "APPROVAL_LQCC_LETTER",
            "DELETE_LQCC_LETTER"
        ],
        myimms: [
            "VIEW_MYIMMS",
            "SUBMIT_TO_JIM"
        ],
        application_log: [
            "VIEW_ACTIVITY_LOG",
            "VIEW_AUDIT_LOG"
        ],
        template_variable: [
            "VIEW_TEMPLATE_VARIABLE",
            "EDIT_TEMPLATE_VARIABLE",
            "VIEW_AUDIT_TEMPLATE_VARIABLE"
        ],
        call_log: [
            "VIEW_CALL_LOG",
            "VIEW_FOLLOW_UP_CALL_LOG",
            "CREATE_CALL_LOG",
            "CREATE_FOLLOW_UP_CALL_LOG",
            "EDIT_CALL_LOG",
            "EDIT_FOLLOW_UP_CALL_LOG",
            "DELETE_CALL_LOG",
            "DELETE_FOLLOW_UP_CALL_LOG",
        ],
        call_log_case_type: [
            "VIEW_CALL_LOG_CASE_TYPE",
            "CREATE_CALL_LOG_CASE_TYPE",
            "EDIT_CALL_LOG_CASE_TYPE",
            "DELETE_CALL_LOG_CASE_TYPE",
            "VIEW_AUDIT_CALL_LOG_CASE_TYPE"
        ],
        digital_xray_provider: [
            "VIEW_DIGITAL_XRAY_PROVIDER",
            "CREATE_DIGITAL_XRAY_PROVIDER",
            "EDIT_DIGITAL_XRAY_PROVIDER",
            "DELETE_DIGITAL_XRAY_PROVIDER",
            "VIEW_AUDIT_DIGITAL_XRAY_PROVIDER"
        ],
        insurance_service_provider: [
            "VIEW_INSURANCE_SERVICE_PROVIDER",
            "CREATE_INSURANCE_SERVICE_PROVIDER",
            "EDIT_INSURANCE_SERVICE_PROVIDER",
            "DELETE_INSURANCE_SERVICE_PROVIDER",
            "VIEW_AUDIT_INSURANCE_SERVICE_PROVIDER"
        ],
        reports: [
            "EDIT_REPORT_CRONJOBS",
            'FINANCE_REPORTS',
            "MSPD_REPORTS",
            "MEDICAL_REPORTS",
            'OPERATION_REPORTS',
            "BRANCH_REPORTS",
            "IT_REPORTS",
            'XQCC_REPORTS',
            'XQCC_DX_AUDIT_STATISTICS',
            'XQCC_DX_TAT_REVIEW_REPORT',
            'XQCC_TOTAL_XRAY_RECEIVED',
            'XQCC_PENDING_RADIOGRAPHER_REPORT',
            'XQCC_MONTHLY_XRAY_RECEIVED_AND_VIEWED',
            'XQCC_MONTHLY_NON_COMPLIANCE_REPORT',
            'XQCC_DX_FILM_CONFIRMED_AS_ABNORMAL',
            'XQCC_PENDING_AUDIT_PCR_REPORT',
            'XQCC_DAILY_SUMMARY_PENDING_REVIEW_REPORT',
            'PCR_REPORTS',
            'PCR_AUDIT_SUMMARY_REPORT_INDIVIDUAL',
            'INSPECTORATE_REPORTS',
            'LQCC_REPORTS',
            'CUSTOMER_SERVICE_REPORTS',
            'HCM_REPORTS',
            'INSURANCE_REPORTS',
            'PCR_AUDIT_SUMMARY_REPORTS',
            'VIEW_EXAMINATION_REPORT'
        ],
        salinee: [
            "DELETE_DIGITAL_XRAY_IMAGE_FROM_SALINEE"
        ],
        unsuitable_slip: [
            "PRINT_UNSUITABLE_SLIP",
            "EDIT_UNSUITABLE_SLIP_DOWNLOAD_IN_PORTAL"
        ],
        medical_report_letter: [
            "PRINT_MEDICAL_REPORT_LETTER",
            "EDIT_MEDICAL_REPORT_LETTER_DOWNLOAD_IN_PORTAL"
        ],
        finance_settings: [
            "VIEW_FINANCE_SETTING",
            "CREATE_FINANCE_SETTING",
            "EDIT_FINANCE_SETTING",
            "DELETE_FINANCE_SETTING",
            "VIEW_AUDIT_FINANCE_SETTING",
        ],
        moh_notifications: [
            "VIEW_MOH_NOTIFICATIONS",
            "EDIT_MOH_NOTIFICATIONS"
        ],
        other_payment: [
            "VIEW_OTHER_PAYMENT",
            "EDIT_OTHER_PAYMENT",
            "UNHOLD_OTHER_PAYMENT",
            "HOLD_OTHER_PAYMENT",
            "REPLACE_OTHER_PAYMENT",
            "SET_BAD_OTHER_PAYMENT"
        ],
        insurance_payment: [
            "VIEW_INSURANCE_PAYMENT",
            "CREATE_INSURANCE_PAYMENT",
            "DELETE_INSURANCE_PAYMENT",
            "PROCESS_INSURANCE_PAYMENT"
        ],
        sage: [
            "PUSH_COLLECTION_DATA_TO_SAGE",
            "PUSH_VOID_COLLECTION_DATA_TO_SAGE",
            "PUSH_REVENUE_DATA_TO_SAGE"
        ],
        approval_approver: [
            "VIEW_APPROVAL_APPROVER",
            "CREATE_APPROVAL_APPROVER",
            "EDIT_APPROVAL_APPROVER",
            "DELETE_APPROVAL_APPROVER",
            "VIEW_AUDIT_APPROVAL_APPROVER"
        ],
        association: [
            "VIEW_ASSOCIATION",
            "CREATE_ASSOCIATION",
            "EDIT_ASSOCIATION",
            "DELETE_ASSOCIATION",
            "VIEW_AUDIT_ASSOCIATION",
        ],
        amended_notifiable_transactions: [
            "VIEW_NOTIFIABLE_CASES",
        ],
        dashboard_fw_information:[
           "DASHBOARD_FW_REGISTRATION",
           "DASHBOARD_FW_REGISTRATION_STATE",
           "DASHBOARD_FW_REGISTRATION_COUNTRY",
           "DASHBOARD_FW_REGISTRATION_SECTOR",
           "DASHBOARD_FW_REGISTRATION_TREND",
           "DASHBOARD_FW_EXPORT",
           "DASHBOARD_FW_REFRESH",
        ],
        dashboard_geographical:[
           "DASHBOARD_GEO_REFRESH",
           "DASHBOARD_GEOGRAPHICAL",
        ],
        dashboard_department_info:[
           "DASHBOARD_DEPT_MSP",
           "DASHBOARD_DEPT_HCM",
           "DASHBOARD_DEPT_INSPECTORATE",
           "DASHBOARD_DEPT_XQCC",
           "DASHBOARD_DEPT_MRA",
           "DASHBOARD_DEPT_FINANCE",
           "DASHBOARD_DEPT_REGIONAL_OFFICE",
           "DASHBOARD_DEPT_CUSTOMER_SERVICE",
           "DASHBOARD_DEPT_LQCC",
           "DASHBOARD_DEPT_SUPORT_SERVICE",
           "DASHBOARD_DEPT_REFRESH",
        ],
        dashboard_customer_satisfaction:[ 
           "DASHBOARD_CS_RESPONDENT_NUMBER_BY_AGE",
           "DASHBOARD_CS_RESPONDENT_NUMBER",
           "DASHBOARD_CS_SECTOR",
           "DASHBOARD_CS_REGISTRATION_RATING",
           "DASHBOARD_CS_MEDICAL_EXAMINATION",
           "DASHBOARD_CS_APPEAL_PROCESS",
           "DASHBOARD_CS_SOCIAL_MEDIA_PREFERENCE",
           "DASHBOARD_CS_SOCIAL_MEDIA_ANNOUNCEMENT",
           "DASHBOARD_CS_SOCIAL_MEDIA_AWARENESS",
           "DASHBOARD_CS_SOCIAL_MEDIA_REMINDER",
           "DASHBOARD_CS_NPS_WEB_REGISTRATION",
           "DASHBOARD_CS_NPS_BRANCH_REGISTRATION",
           "DASHBOARD_CS_NPS_MEDICAL_EXAMINATION",
           "DASHBOARD_CS_NPS_APPEAL_PROCESS",
           "DASHBOARD_CS_NPS_OVERALL",
           "DASHBOARD_CS_REFRESH",
        ],
        dashboard_service_provider:[
           "DASHBOARD_SP_DOCTOR",
           "DASHBOARD_SP_LABORATORY",
           "DASHBOARD_SP_XRAY_FACILITY",
           "DASHBOARD_SP_RADIOLOGIST",
           "DASHBOARD_SP_QUOTA_USAGE",
           "DASHBOARD_SP_CERTIFICATION",
           "DASHBOARD_SP_TRANSMISSION_ACCURACY",
           "DASHBOARD_SP_LAB_TRANSMISSION",
           "DASHBOARD_SP_XRAY_QUALITY_COMPLIANCE",
           "DASHBOARD_SP_XRAY_TRANSMISSION",
           "DASHBOARD_SP_REFRESH",
        ],
    }

    PERMISSIONS = [
    ]

    MODULE_PERMISSIONS.each do |sym, perms|
        PERMISSIONS.concat MODULE_PERMISSIONS[sym]
    end

    STATUS_ACTIVE = "ACTIVE"
    STATUS_INACTIVE = "INACTIVE"
    STATUSES = [STATUS_ACTIVE, STATUS_INACTIVE]

    CATEGORIES = {
        'Laboratory' => 'Laboratory',
        'Doctor' => 'Doctor',
        'Radiologist' => 'Radiologist',
        'Employer' => 'Employer',
        'XrayFacility' => 'X-Ray Facility',
        'Organization' => 'FOMEMA',
        'Agency' => 'Agency'
    }

    audited
    include CaptureAuthor

    belongs_to :password_policy
    has_many :role_permissions
    has_many :users

    accepts_nested_attributes_for :role_permissions

    validates :code, presence: true, uniqueness: true
    validates :name, presence: true, uniqueness: true

    def sync_role_permissions(permissions)
        if permissions.nil?
            permissions = []
        end
        if !permissions.kind_of?(Array)
            permissions = [permissions]
        end
        RolePermission.where(role_id: id).where.not(permission: permissions).destroy_all
        permissions.each do |perm|
            RolePermission.where(role_id: id).where(permission: perm).first_or_create
        end
    end

    def add_role_permissions(permissions)
        if permissions.nil?
            permissions = []
        end
        if !permissions.kind_of?(Array)
            permissions = [permissions]
        end
        permissions.each do |perm|
            RolePermission.where(role_id: id).where(permission: perm).first_or_create
        end
    end

    def current_permissions
        if (!defined? @permissions)
            @permissions = role_permissions.pluck(:permission)
        end
        @permissions
    end

    def has_all_permission?(permissions)
        permissions.each do |permission|
            if !current_permissions.include? permission
                return false
            end
        end
        true
    end

    def self.search_name(name)
        return all if name.blank?
        name = name.strip
        where('roles.name ILIKE ?', "%#{name}%")
    end

    def self.search_status(status)
        return all if status.blank?
        where('roles.status in (?)', status)
    end

    def self.search_password_policy(password_policy)
        return all if password_policy.blank?
        where('roles.password_policy_id in (?)', password_policy)
    end

    def self.search_site(site)
        return all if site.blank?
        where('roles.site in (?)', site)
    end

    def self.active
        where('roles.status = ?', STATUS_ACTIVE)
    end

    def self.disabled
        where('roles.status = ?', STATUS_DISABLED)
    end
end
