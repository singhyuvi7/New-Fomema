class Internal::XqccLettersController < InternalController
    include XqccLetterWrongTransmissions
    include XqccLetterMisreads
    include XqccLetterAuditResults
    include XqccLetterActiveTbs
    include XqccLetterAuditRadiographers
    include XqccLetterNonCompliances
    include XqccLetterIdenticals
    include XqccLetterFraudCases
    include XqccLetterAckFraudCases

    before_action -> { can_access?("VIEW_XQCC_LETTERS") }
    before_action :set_new_and_save_access

    def index
        letters = [
           # { title: "Wrong Transmission Letter",   path: wrong_transmission_letter_index_internal_xqcc_letters_path },
            { title: "Fraud Case Letter",                   path: xqcc_fraud_case_letter_index_internal_xqcc_letters_path },
            { title: "Acknowledgement-Fraud Case Letter",   path: xqcc_acknowledgement_fraud_case_letter_index_internal_xqcc_letters_path },
           # { title: "Misread Letter",              path: xqcc_misread_letter_index_internal_xqcc_letters_path },
            { title: "Audit Results Letter",                 path: xqcc_audit_result_letter_index_internal_xqcc_letters_path },
            { title: "Active PTB Letter",                     path: xqcc_active_ptb_letter_index_internal_xqcc_letters_path },
            { title: "Audit Radiograph Letter",              path: xqcc_audit_radiograph_letter_index_internal_xqcc_letters_path },
            { title: "Non Compliance Letter",                path: xqcc_non_compliance_letter_index_internal_xqcc_letters_path },
            { title: "Identical Letter",                      path: xqcc_identical_letter_index_internal_xqcc_letters_path }
        ]

        # Please ignore the wording @reports, since using same template as reports pages.
        @reports = [
            { title: "XQCC Letters", reports: letters },
        ]

        render "shared/reports/index"
    end
private
    def default_preview_page
        respond_to do |format|
            format.html { render "internal/xqcc_letters/default_preview_page" }
        end
    end

    def set_new_and_save_access
        can_access?("CREATE_XQCC_LETTERS") if request.path.include?("_new") || request.path.include?("_save")
    end
end