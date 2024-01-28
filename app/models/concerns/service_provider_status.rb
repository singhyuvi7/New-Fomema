module ServiceProviderStatus extend ActiveSupport::Concern
    STATUSES = {
        "ACTIVE" => "Active",
        "INACTIVE" => "Inactive",
        "TEMPORARY_INACTIVE" => "Temporary Inactive"
    }

    STATUS_REASONS = {
        "INACTIVE" => {
            "01" => "Resignation",
            "02" => "Withdrawal",
            "06" => "Non-compliance",
            "07" => "Passed away",
            "03" => "Unethical practice"
        },
        "TEMPORARY_INACTIVE" => {
            "08" => "Change of address",
            "04" => "GP on leave",
            "05" => "Facility close",
            "06" => "Non-compliance",
            "03" => "Unethical practice",
            "09" => "X-Ray Service Not Available"
        }
    }

    ALL_STATUS_REASONS = STATUS_REASONS["INACTIVE"].merge(STATUS_REASONS["TEMPORARY_INACTIVE"])

    def status_display
        if ["NEW_DRAFT", "EDIT_DRAFT", "UPDATE_DRAFT"].include?(self.approval_status)
            display = "Draft"
        elsif ["NEW_PENDING_APPROVAL", "EDIT_PENDING_APPROVAL","UPDATE_PENDING_APPROVAL"].include?(self.approval_status)
            display = "Pending Approval"
        elsif ["UPDATE_REJECTED"].include?(self.approval_status)
            display = "Update Rejected"
        elsif ["NEW_REVERTED", "EDIT_REVERTED","UPDATE_REVERTED"].include?(self.approval_status)
            display = "Reverted"
        elsif ["NEW_PENDING_APPROVAL2", "EDIT_PENDING_APPROVAL2","UPDATE_PENDING_APPROVAL2"].include?(self.approval_status)
            display = "Pending Concur"
        elsif !self.registration_paid?
            display = "Pending Payment"
        elsif self.status.eql?("INACTIVE") and self.activated_at.blank?
            display = "To Activate"
        end
    end

    def latest_status_reason_display
        return unless latest_status_schedule

        latest_status_schedule.status_reason_display
    end
end
