class BankDraftAllocation < ApplicationRecord
    audited
    include CaptureAuthor

    after_save :update_allocated_amount
    after_destroy :update_allocated_amount

    belongs_to :bank_draft
    belongs_to :allocatable, polymorphic: true

    def update_allocated_amount
        bank_draft.update_allocated_amount
        if bank_draft.id != bank_draft_id
            BankDraft.find(bank_draft_id).update_allocated_amount
        end
    end
end
