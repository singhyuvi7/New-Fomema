module Report
    class XqccMonthlyNonComplianceReportService
        attr_reader :query_month, :xray_code

        def initialize(query_month, xray_code)
            @query_month    = query_month
            @xray_code      = xray_code
        end

        def self.headers
            [
                "X-ray Facility Code", 
                "X-ray Facility Name", 
                "Total X-ray Viewed", 
                "% Non-Compliance", 
                "Details of Non-Compliance"
            ]
        end

        def result
            result_hash     = Hash.new
            xray_facility   = set_xray_facility

            result_hash[:xf_code]                   = xray_facility.code
            result_hash[:xf_name]                   = xray_facility.name
            result_hash[:total_xray_viewed]         = total_xray_viewed.size
            result_hash[:non_compliance_percentage] = non_compliance_percentage.present? ? "#{non_compliance_percentage}%" : ""
            result_hash[:non_compliance_details]    = non_compliance_details

            result_hash
        end

        def result_csv
            xray_facility   = set_xray_facility
            
            [
                xray_facility.code,
                xray_facility.name,
                total_xray_viewed.size,
                non_compliance_percentage.present? ? "#{non_compliance_percentage}%" : "", 
                non_compliance_details.join("\n")
            ]
        end

        private

        def set_xray_facility
            XrayFacility.find_by_code(@xray_code)
        end

        def total_xray_viewed
            XrayReview.with_xray_code(@xray_code).with_transmitted_at_month(@query_month)
        end

        def non_compliance_details
            details = total_xray_viewed.joins(
                            :xray_review_details, 
                            xray_review_details: [:condition]
                        )
                        .select(
                            "conditions.description description"
                        )
                        .map(&:description)
                        .uniq
        end

        def non_compliance_percentage
            xray_reviews    = total_xray_viewed
            non_comply      = xray_reviews.map(&:non_comply?).count(true)
            ((non_comply.to_f/xray_reviews.size.to_f)*100).round(2) if non_comply != 0
        end
    
    end
end
