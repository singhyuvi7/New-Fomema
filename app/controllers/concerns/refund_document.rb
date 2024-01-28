module RefundDocument
    def credit_note
        @title = "CREDIT NOTE"
        # debug mode on / off

        if !@refund.present? 
            redirect_to @redirect_to, error: "Refund not found" and return
        end

        template_file = "pdf_templates/refunds/credit_notes/credit_note.html.erb"

        case @refund.category
        when "TRANSACTION_CANCELLATION"
            @transaction = @refund.refund_items.where("refund_itemable_type = ?", "Transaction").first&.refund_itemable
            @refund_reason = @transaction&.transaction_cancels&.order(created_at: :desc)&.first&.reason
            @order_item = @transaction&.order_item
            @order = @order_item&.order
            template_file = "pdf_templates/refunds/credit_notes/transaction_cancellation.html.erb"

        else
            if @refund.refund_items.where("refund_itemable_type = ?", "BankDraft").first
                @description = "Bank Draft"
            end
        end
    
        @debug = false
        # enable debug by passing ?debug param in url
        if params.has_key?(:debug)
            @debug = true
            # render json: @order and return
            render template_file, layout: 'pdf' and return
        end

        render pdf: "credit_note",
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
