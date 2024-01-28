class ApprovalApprover < ApplicationRecord
    audited
    include CaptureAuthor

    STATUSES = {
        "ACTIVE" => "Active",
        "INACTIVE" => "Inactive"
    }

    # Categories should be same with approval_requests
    CATEGORIES = {
        "FOREIGN_WORKER_AMENDMENT" => "FOREIGN WORKER AMENDMENT / GENDER AMENDMENT",
        "EMPLOYER_REGISTRATION" => "EMPLOYER REGISTRATION",
        "TRANSACTION_SPECIAL_RENEWAL" => "TRANSACTION SPECIAL RENEWAL",
        "CHANGE_OF_EMPLOYER" => "CHANGE OF EMPLOYER",
        "EMPLOYER_AMENDMENT" => "EMPLOYER AMENDMENT",
        "TRANSACTION_BYPASS_FINGERPRINT" => "TRANSACTION BYPASS FINGERPRINT",
    }

    belongs_to :approval_approver_user, class_name: "User", foreign_key: "user_id", inverse_of: :approval_approvers, optional: true

    validates :user_id, presence: true, uniqueness: { scope: :category }

    scope :active, -> {where("approval_approvers.status = 'ACTIVE'")}
    scope :inactive, -> {where("approval_approvers.status = 'INACTIVE'")}
    scope :active_and_recently_inactive, -> {where("approval_approvers.status = 'ACTIVE' or (approval_approvers.status = 'INACTIVE' and approval_approvers.updated_at >= ?)", Time.now - 14.days)}

    def self.search_category(category)
        return all if category.blank?
        category = category.strip
        where('approval_approvers.category = ?', "#{category}")
    end

    def self.search_status(status)
        return all if status.blank?
        status = status.strip
        where('approval_approvers.status = ?', "#{status}")
    end
end
