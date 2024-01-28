module OrderDocument
    def invoice
        @title = "Invoice"
        # debug mode on / off

        if !@order.present?
            flash[:error] = "No Paid Registration Detected"
            redirect_to @redirect_to
        end

        @debug = false

        # enable debug by passing ?debug param in url
        template_file = case @order.customerable_type
        when 'Employer', 'Agency'
            "pdf_templates/orders/employer_invoice.html.erb"
        else
            "pdf_templates/orders/service_provider_invoice.html.erb"
        end

        if params.has_key?(:debug)
            @debug = true
            # render json: @order and return
            render template_file, layout: 'pdf' and return
        end

        render pdf: "invoice",
        template: template_file,
        layout: "pdf.html",
        margin: {
            top: 1,
            left: 1,
            right: 3,
            bottom: 0,
        },
        page_size: nil,
        page_height: "29.7cm",
        page_width: "21cm",
        dpi: "300"
    end
end
