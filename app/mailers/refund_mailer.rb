class RefundMailer < ApplicationMailer
    def failed_email
        @refund = params[:refund]
        @customer = @refund.customerable
        mail(to: @customer&.email, subject: "Refund Payment Failed")
    end

    def auto_refund_email
        @customer = params[:customerable]
        @bank_draft_number = params[:bank_draft_number]
        @refund_amount = params[:refund_amount]
        mail(to: @customer.email, subject: "Refund For Unutilised Draft")
    end

    def manual_refund_reject_email
        @refund = params[:refund]
        @customer = @refund.customerable
        mail(to: @customer.email, subject: "Refund Request")
    end

    def manual_refund_created_email
        @refund = params[:refund]
        @customer = @refund.customerable
        mail(to: @customer.email, subject: "Refund Request")
    end

    def auto_refund_fail_email
        # when customer bank info is incomplete
        @customer = params[:customerable]
        @bank_draft = params[:bank_draft]
        mail(to: @customer.email, subject: "Refund For Unutilised Draft")
    end

    def bank_detail_updated_email
        @employer = params[:employer]
        @bank_name = params[:bank_name]
        mail(to: SystemConfiguration.get('FINANCE_EMAIL'), subject: "Employer's Bank Detail Updated")
    end
end
