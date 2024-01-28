class Internal::BdRefundsController < InternalController
    before_action :set_bank_draft

    def new
        @refund = Refund.new({
            customerable: @bank_draft.payerable,
            amount: (@bank_draft.amount || 0) - (@bank_draft.amount_allocated || 0),
            category: "MANUAL",
            payment_method_id: PaymentMethod.find_by_code('BANKDRAFT').id
        })
    end

    def create
        @refund = Refund.new({
            customerable: @bank_draft.payerable,
            amount: (@bank_draft.amount || 0) - (@bank_draft.amount_allocated || 0),
            category: "MANUAL",
            request_by: current_user.id,
            request_at: Time.now,
            date: Time.now.strftime("%Y-%m-%d"),
            status: "APPROVAL",
            organization_id: @bank_draft.organization_id,
            unutilised: true,
            reference: @bank_draft.number,
            payment_date: @bank_draft.issue_date
        })
        @refund.assign_attributes(refund_params)

        if @refund.save
            refund_item = @refund.refund_items.create({
                refund_itemable: @bank_draft,
                amount: @refund.amount
            })
            BankDraftAllocation.create({
                bank_draft_id: @bank_draft.id,
                allocatable: @refund,
                amount: refund_item.amount
            })
            redirect_to internal_bank_drafts_path, notice: "Refund request #{@refund.code} successfully created, pending for approval"
        else
            render :new
        end
    end

    def edit
    end

    def update
    end

    private
    def set_bank_draft
        @bank_draft = BankDraft.find(params[:bank_draft_id])
    end

    def refund_params
        params.require(:refund).permit(:payment_method_id, :comment)
    end
end
