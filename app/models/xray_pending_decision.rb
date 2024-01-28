class XrayPendingDecision < ApplicationRecord
    STATUSES = {
        "XQCC_PENDING_DECISION" => "XQCC_PENDING_DECISION",
        "XQCC_PENDING_DECISION_APPROVAL" => "XQCC PENDING DECISION APPROVAL",
        "TRANSMITTED" => "TRANSMITTED",
    }

    DECISIONS = {
        "SUITABLE" => "SUITABLE",
        "UNSUITABLE" => "UNSUITABLE",
        "PCR" => "ADDITIONAL PCR REPORT"
    }

    audited
    include PublicActivity::Common
    include CaptureAuthor
    include ParentTransactionScope
    include PendingDecisionMleFindingCol
    include OrderScope
    include XrayMovement

    belongs_to :transactionz, foreign_key: "transaction_id", class_name: "Transaction"
    belongs_to :sourceable, polymorphic: true, optional: true
    belongs_to :reviewer, class_name: "User", foreign_key: "reviewed_by", optional: true
    belongs_to :pcr_user, class_name: "User", foreign_key: "pcr_id", optional: true
    belongs_to :approval_user, class_name: "User", foreign_key: "approval_by", optional: true

    has_one :foreign_worker, through: :transactionz
    has_one :xray_review, through: :transactionz
    has_one :pcr_review, through: :transactionz
    has_one :xray_retake, through: :transactionz

    # scopes
    scope :search_status, -> (status) {
        return all if status.blank? || status == "ALL"
        case status
        when 'PENDING_DECISION'
            where(status: 'XQCC_PENDING_DECISION')
        when 'REQUESTED' # already request PCR report
            where(status: 'TRANSMITTED')
            .where(decision: "PCR")
            .where(approval_decision: 'APPROVE')
        when 'PENDING_DECISION_AUDITED' # MLE requested for additional PCR report, approved, already finish PCR report
            joins(:pcr_review)
            .where(status: 'XQCC_PENDING_DECISION')
            .where("pcr_reviews.status = ?", "TRANSMITTED")
            .where("exists (select 1 from xray_pending_decisions xpd2 where xpd2.transaction_id = xray_pending_decisions.transaction_id and xpd2.decision = 'PCR')")
        when 'SUITABLE' # MLE chosen SUITABLE, approved
            where(status: 'TRANSMITTED')
            .where(decision: 'SUITABLE')
            .where(approval_decision: "APPROVE")
        when 'UNSUITABLE' # MLE chosen UNSUITABLE, approved
            where(status: 'TRANSMITTED')
            .where(decision: 'UNSUITABLE')
            .where(approval_decision: "APPROVE")
        else
            where(status: status)
        end
    }

    scope :latest_record, -> {
        joins(:transactionz).where("transactions.xray_pending_decision_id = xray_pending_decisions.id")
    }
    # end of scopes

    # authorizations
    def can_edit?
        ['XQCC_PENDING_DECISION', 'XQCC_REJECTED'].include?(self.status)
    end
    # end of authorizations

    # accessors
    def case_review_status
        ret = self.status

        case self.status
        when "XQCC_PENDING_DECISION"
            ret = "PENDING DECISION"
            if self.transactionz.xray_pending_decisions.where.not(id: self.id).where(decision: "PCR").count > 0
                ret = "PENDING DECISION - AUDITED"
            end
        when "XQCC_PENDING_DECISION_APPROVAL"
            ret = "PENDING APPROVAL"
        when "TRANSMITTED"
            case self.decision
            when "PCR"
                ret = "REQUESTED-PCR"
                if self.try(:pcr_review_status).eql?("TRANSMITTED")
                    ret = "AUDITED"
                end
            else
                ret = "#{decision}"
            end
        end

        ret
    end

    def case_approval_status
        case self.approval_decision
        when "APPROVE"
            "APPROVED"
        when "REJECT"
            "REJECTED"
        end
    end

    def rejected_decisions
        self.transactionz.xray_pending_decisions.where(approval_decision: 'REJECT')
    end
    # end of accessors

    # methods
    def submit_pending_decision(user_id, pending_decision_data)
        pending_decision_data[:status] = 'XQCC_PENDING_DECISION_APPROVAL'
        pending_decision_data[:reviewed_by] = user_id

        self.update(pending_decision_data)
    end
end
