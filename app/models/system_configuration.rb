class SystemConfiguration < ApplicationRecord
    CODES = [
        'BULLETIN_RECENT',
        'COMPANY_ADDR',
        'COMPANY_FAX',
        'COMPANY_NAME',
        'COMPANY_NAME_INVOICE',
        'COMPANY_PHONE',
        'COMPANY_REGNO',
        'COMPANY_REGNO_GLOBAL',
        'EMPLOYER_APPROVAL',
        'AGENCY_APPROVAL',
        'EMPLOYER_BULKCOMMENT',
        'PASSWORDPOLICY_APPROVAL',
        'WORKER_AMENDREQDOC',
        'PORTAL_WORKER_AMENDMENT_FOC',
        'TRANSACTION_EXPIRY_DAYS',
        'MERTS_TRANSMISSION_EXPIRY_DAYS',
        'BLOCK_TRANSACTION_RENEWAL_WITHIN_DAYS',
        'EMPLOYER_REGISTER_APPROVAL_REPLY_DAYS',
        'AGENCY_REGISTER_APPROVAL_REPLY_DAYS',
        'JIM_BIODATA_TIMEOUT',
        'JIM_ENABLE_GET_BIODATA',
        'REPRINTPLY',
        'RADIOLOGIST_AUTORELEASE_NORMAL',
        'RADIOLOGIST_AUTORELEASE_ABNORMAL',
        'XRAY_WS_TOKEN_EXPIRY',
        'PATI_NIOS',
        'PATI_PORTAL',
        'REMARK_INVOICE',
        'LAST_X_DAYS_TO_UPDATE_TRANSACTION',
        'BLOCK_EMAIL_WITH_PLUS_SIGN',
        'INSURANCE_SHARE_DATA_CONFIRMATION',
        'INSURANCE_EXPIRY_GRACE',
        'AGENCY_EXPIRY_DAYS',
        'AGENCY_RENEWAL_X_DAYS_BEFORE_EXPIRY',
        'SEND_UNSUITABLE_EMAIL_AFTER_X_DAYS_WITHOUT_APPEAL',
        'STAT_PENDING_ORDER_MONTHS',
        'INIT_APPEAL_WITHIN_DAYS',
        'CONDITIONAL_SUCCESS_REMINDER_DAYS',
        'REFUND_PAYMENT_FAILED_REMINDER_DAYS',
        'MSPD_INACTIVE_GROUP_IN_X_DAYS',
        'MSG_ENABLE_SMS',
        'MEDICAL_PR_IQA',
        'MAX_ORDER_ITEM_COUNT',
    ]

    FINANCES = [
        'DOCTOR_DEFAULT_MALE_RATE',
        'DOCTOR_DEFAULT_FEMALE_RATE',
        'LABORATORY_DEFAULT_MALE_RATE',
        'LABORATORY_DEFAULT_FEMALE_RATE',
        'XRAY_FACILITY_DEFAULT_MALE_RATE',
        'XRAY_FACILITY_DEFAULT_FEMALE_RATE',
        'DOCTOR_SERVICE_PROVIDER_GROUP_DEFAULT_MALE_RATE',
        'DOCTOR_SERVICE_PROVIDER_GROUP_DEFAULT_FEMALE_RATE',
        'LABORATORY_SERVICE_PROVIDER_GROUP_DEFAULT_MALE_RATE',
        'LABORATORY_SERVICE_PROVIDER_GROUP_DEFAULT_FEMALE_RATE',
        'XRAY_FACILITY_SERVICE_PROVIDER_GROUP_DEFAULT_MALE_RATE',
        'XRAY_FACILITY_SERVICE_PROVIDER_GROUP_DEFAULT_FEMALE_RATE',
        'INSURANCE_COMMISSION',
        'INSURANCE_RECOGNIZED_COLLECTION',
        'HOWDEN_CODE',
        'FGSB_CODE',
        'TFSB_CODE',
    ]

    XQCCS = [
        'XQCC_PICKUPMETHOD',
        'XQCC_FIFO_BUNDLEASSIGN',
        'XQCC_MAID_BUNDLEASSIGN',
        'XQCC_IQA',
    ]

    ALL_CODES = CODES + FINANCES + XQCCS

    XQCC_PICKUP_METHODS = {
        "FACILITY" => "Pick up by facility",
        "FIFO" => "Pick up by earliest inserted to pool date (FIFO)",
        "FIFO_CERTIFICATION" => "Pick up by earliest certification date (FIFO)",
        "MAID" => "Pick up by Maid Online"
    }

    audited
    include CaptureAuthor

    def self.get(code, default = nil)
        where(code: code).first&.value || default
    end
end