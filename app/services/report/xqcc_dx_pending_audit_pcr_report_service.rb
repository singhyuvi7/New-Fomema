module Report
    class XqccDxPendingAuditPcrReportService
        attr_reader :start_date, :end_date

        def initialize(start_date, end_date)
            @start_date 	 = start_date.to_datetime.beginning_of_day
            @end_date 	     = end_date.to_datetime.end_of_day
        end

        def self.to_pickup_headers
            [
                "Certify Date",
                "Pending Pickup"
            ]
        end

        def self.to_review_headers
            [
                "Certify Date",
                "Pending Review"
            ]
        end

        def pending_pickup_result
        	set_dx_pending_pickup_data
        end

        def pending_review_result
            set_dx_pending_review_data
        end

        private

        def set_dx_pending_pickup_data
            PcrPool.joins(:transactionz)
                    .pending
                    .where(
                        transactions: {
                            doctor_transmit_date: @start_date..@end_date,
                            xray_film_type: "DIGITAL"
                        }
                    )
                    .select(doctor_transmit_date_query)
                    .order(doctor_transmit_date_query)
                    .group(doctor_transmit_date_query)
                    .count
        end

        def set_dx_pending_review_data
            PcrReview.where(
                        status: 'PCR_REVIEW',
                        created_at: @start_date..@end_date
                    )
                    .select(pcr_review_transmitted_date_query)
                    .group(pcr_review_transmitted_date_query)
                    .count
        end

        def doctor_transmit_date_query
            "DATE(transactions.doctor_transmit_date)"
        end

        def pcr_review_transmitted_date_query
            "DATE(pcr_reviews.created_at)"
        end
    
    end
end
