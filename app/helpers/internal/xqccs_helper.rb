module Internal::XqccsHelper
    def xqcc_result_badge(result)
        unless result.nil?
            if result.downcase.include?("abnormal")
                raw "<button type=\"button\" class= \"btn btn-danger btn-sm py-0\"><i class=\"fa fa-times\"></i> #{result.upcase}</button>"
            elsif result.downcase.include?("unsuitable") || result.downcase.include?("reject")
                raw "<button type=\"button\" class= \"btn btn-danger btn-sm py-0\"><i class=\"fa fa-thumbs-down\"></i> #{result.upcase}</button>"
            elsif result.downcase.include?("normal")
                raw "<button type=\"button\" class= \"btn btn-success btn-sm py-0\"><i class=\"fa fa-check\"></i> #{result.upcase}</button>"
            elsif result.downcase.include?("suitable") || result.downcase.include?("approve")
                raw "<button type=\"button\" class= \"btn btn-success btn-sm py-0\"><i class=\"fa fa-thumbs-up\"></i> #{result.upcase}</button>"
            else
                raw "<button type=\"button\" class= \"btn btn-warning btn-sm py-0\"><i class=\"fa fa-exclamation\"></i> #{result.upcase}</button>"
            end
        end
    end

    # check XQCC / PCR case came from XQCC Pending Review
    def is_xqcc_pending_review_case(case_type)
        result = false

        unless case_type.nil?
            if case_type.include? "XQCC_PENDING_REVIEW"
                result = true
            end
        end
    end

    def have_completed_retake(transaction)
        result = false

        if transaction.xray_retake.present? && transaction.xray_retake.requestable_type == XrayReview.to_s
            if transaction.xray_retake.status === 'COMPLETED'
                result = true
            end
        end

        result
    end

    def initialize_numbering_and_subnumbering
        @examination_hashmap    = Hash.new(nil)
        @sub_numbering          = Hash.new(0)
    end

    def generate_sub_numbering(pcr_review)
        if pcr_review.poolable&.xray_retake_id?
            numbering = @examination_hashmap["XrayRetake__#{ pcr_review.poolable&.xray_retake_id }"]
        else
            numbering = @examination_hashmap["Transaction__#{ pcr_review.transaction_id }"]
        end

        sub_numbering = @sub_numbering[numbering] += 1
        "#{ numbering }#{ (:a..:z).to_a[sub_numbering - 1] }"
    end

    def retrieve_pcr_review_transaction_code(pcr_review)
        if pcr_review.poolable_type.blank?
            pcr_review.transactionz&.code
        elsif pcr_review.poolable&.xray_retake_id?
            pcr_review.poolable&.xray_retake&.code
        end
    end
end