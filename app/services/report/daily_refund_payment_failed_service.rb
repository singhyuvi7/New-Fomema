module Report
    class DailyRefundPaymentFailedService
        attr_reader :query_date, :failed_refunds

        def initialize(query_date)
            @query_date = format_date(query_date)
            @failed_refunds = set_refunds
        end

        def self.headers
            [
                "Refund Code",
                "Refund Created Date",
                "Category",
                "Amount",
                "Status",
                "Failed Reason",
                "Updated Date",
                "Customer Code",
                "Customer Name",
                "Customer Contact",
                "Customer Email",
            ]
        end

        def csv_result
            csv = [DailyRefundPaymentFailedService.headers]

            if @failed_refunds.present?
                @failed_refunds.each do |refund|
                    csv << [
                        refund.code,
                        refund.date&.strftime("%d/%m/%Y"),
                        Refund::CATEGORIES[refund.category],
                        ActionController::Base.helpers.number_to_currency(refund.amount, unit: ""),
                        Refund::STATUSES[refund.status],
                        refund.fail_reason,
                        refund.updated_at&.strftime("%d/%m/%Y"),
                        refund.customerable&.code,
                        refund.customerable&.name,
                        refund.customerable&.phone,
                        refund.customerable&.email,
                    ]
                end
            end

            csv
        end

        def result
            @failed_refunds
        end

        private

        def set_refunds
            Refund.where(status: "PAYMENT_FAILED")
            .where(updated_at: @query_date.beginning_of_day..@query_date.end_of_day)
            .order(updated_at: :asc)
        end
        
        def format_date(date)
            return date.to_date if date.is_a? DateTime
            return date.to_date if date.is_a? ActiveSupport::TimeWithZone
            return date if date.is_a? Date
            date
        end

    end
end
