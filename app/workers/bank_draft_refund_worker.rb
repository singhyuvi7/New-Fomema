class BankDraftRefundWorker
    include Sidekiq::Worker
    include Sage

    def perform(*args)
        BankDraft.joins('inner join employers on bank_drafts.payerable_id = employers.id')
        .where("bank_drafts.payerable_type = 'Employer' and employers.is_corporate = 'false' and bank_drafts.created_at < ? and bank_drafts.bad = 'false' and bank_drafts.holded = 'false' and bank_drafts.amount > bank_drafts.amount_allocated", 90.days.ago).each do |bank_draft|

            if bank_draft.payerable.bank_id.blank? || bank_draft.payerable.bank_account_number.blank?
                if !bank_draft.payerable&.email.blank?
                    RefundMailer.with({
                        customerable: bank_draft.payerable,
                        bank_draft: bank_draft,
                    }).auto_refund_fail_email.deliver_later
                end
            else
                refund = Refund.create({
                    customerable: bank_draft.payerable,
                    amount: (bank_draft.amount || 0) - (bank_draft.amount_allocated || 0),
                    category: "AUTOMATIC",
                    request_at: Time.now,
                    date: Time.now.strftime("%Y-%m-%d"),
                    status: "PENDING_SEND",
                    organization_id: bank_draft.organization_id,
                    unutilised: true,
                    reference: bank_draft.number,
                    payment_date: bank_draft.issue_date,
                    payment_method_id: PaymentMethod.find_by_code('BANKDRAFT')&.id
                })

                refund_item = refund.refund_items.create({
                    refund_itemable: bank_draft,
                    amount: refund.amount
                })

                ## send refund as batch instead of realtime
                # submit_refund (refund)

                BankDraftAllocation.create({
                    bank_draft_id: bank_draft.id,
                    allocatable: refund,
                    amount: refund_item.amount
                })

                if !refund.customerable&.email.blank?
                    RefundMailer.with({
                        customerable: refund.customerable,
                        bank_draft_number: bank_draft.number,
                        refund_amount: refund_item.amount,
                    }).auto_refund_email.deliver_later
                end
            end
        end
    end
end
