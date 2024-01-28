class XqccApprovalHistory < ApplicationRecord
    audited
    include CaptureAuthor

    belongs_to :approval_user, :class_name => :User, :foreign_key => "created_by"
    belongs_to :historyable, polymorphic: true

    # scopes

    scope :approval_status, -> (approval_status) {

        case approval_status

        when 'ASSIGN'
            where(status: 'PENDING_APPROVAL')

        when 'SUBMITTED'
            where.not(status: 'PENDING_APPROVAL')

        when 'SUBMITTED_APPROVED'
            where(status: 'APPROVED')

        when 'SUBMITTED_REJECTED'
            where(status: 'REJECTED')

        when 'ALL'

        else
            where(status: 'PENDING_APPROVAL')
        end
    }

    # end of scopes

end
