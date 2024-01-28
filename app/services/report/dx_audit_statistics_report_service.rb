module Report
    class DxAuditStatisticsReportService
        attr_reader :start_date, :end_date

        def initialize(start_date, end_date)
            @start_date     = start_date.to_datetime.beginning_of_day
            @end_date       = end_date.to_datetime.end_of_day
        end

        def self.abnormal_headers
            [
                "Audit Date",
                "GP (ABNORMAL) > PCR (ABNORMAL)",
                "GP (ABNORMAL) > PCR (NORMAL)",
                "TOTAL GP (ABNORMAL)"
            ]
        end

        def self.suspicious_headers
            [
                "Audit Date",
                "SUSPICIOUS > PCR (ABNORMAL)",
                "SUSPICIOUS > PCR (NORMAL)",
                "TOTAL SUSPICIOUS"
            ]
        end

        def result
            [set_dx_abnormal_data, set_dx_suspicious_data]
        end

        private

        def set_dx_abnormal_data
            PcrReview.where(
                            transmitted_at: @start_date..@end_date, 
                            case_type: "XRAY_EXAMINATION_ABNORMAL"
                        )
                        .select(
                            "to_char(transmitted_at, 'DD-Mon-YYYY') audit_date", 
                            "count(case when result = 'ABNORMAL' then 1 end) abnormal", 
                            "count(case when result = 'NORMAL' then 1 end) normal", 
                            "count(*) total"
                        )
                        .group("audit_date")
                        .order("audit_date")
        end

        def set_dx_suspicious_data
            PcrReview.where(
                            transmitted_at: @start_date..@end_date, 
                            case_type: "XQCC_REVIEW_SUSPICIOUS"
                        )
                        .select(
                            "to_char(transmitted_at, 'DD-Mon-YYYY') audit_date", 
                            "count(case when result = 'ABNORMAL' then 1 end) abnormal", 
                            "count(case when result = 'NORMAL' then 1 end) normal", 
                            "count(*) total"
                        )
                        .group("audit_date")
                        .order("audit_date")
        end

    end
end
