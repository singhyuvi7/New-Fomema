module ReportsBranchInsurance
    def details_worker_insurance
        @current = Time.now if @current.blank?
        @date = @current.strftime('%d/%m/%Y')
        @start_date = params[:start_date].presence
        @end_date = params[:end_date].presence
        @branch_id = params[:branch]
        @insurance_service_provider_id = params[:insurance_service_provider_id]
        @branches = Organization.where(:org_type => 'BRANCH')

        if @start_date && @end_date
            order_ids = OrderItem.joins(:order).get_insurance_fee.where(orders:{paid_at: @start_date.to_date.beginning_of_day..@end_date.to_date.end_of_day}).pluck('orders.id').uniq

            query = apply_scopes(Order).search_organization(@branch_id).where("orders.id in (?)", order_ids)

            if !@insurance_service_provider_id.blank?
                query = query.joins("JOIN insurance_purchases ON insurance_purchases.order_id = orders.id")
                .where("insurance_purchases.insurance_service_provider_id = #{@insurance_service_provider_id}")
            end

            @data = query.order('paid_at ASC')
        end

        respond_to do |format|
            format.html do
                render 'internal/reports/branch/details_worker_insurance/index'
            end
            format.pdf do
                @company_name = SystemConfiguration.get('COMPANY_NAME')
                @current = Time.now
                render pdf: "details_worker_insurance",
                template: 'internal/reports/branch/details_worker_insurance/pdf_template.html.erb',
                layout: "pdf.html",
                margin: {
                    top: 40,
                    left: 12,
                    right: 12,
                    bottom: 10,
                },
                page_size: nil,
                page_height: "21cm",
                page_width: "29.7cm",
                dpi: "300",
                header: {
                    html: {
                        template: '/internal/reports/branch/details_worker_insurance/pdf_template_header'
                    }
                }
            end
        end
    end
end