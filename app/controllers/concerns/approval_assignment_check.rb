module ApprovalAssignmentCheck

    def approval_assigned_to(approval_assignment_category)
        approval_assignment = ApprovalAssignment.find_by(category: approval_assignment_category)
        if approval_assignment.nil?
            ApprovalAssignment.create({
                category: approval_assignment_category,
                last_approval_approver_id: 0
            })
        end
        approvers = ApprovalApprover.active.where(category: approval_assignment_category).order(id: :asc)
        
        if approvers.blank?
            @assigned_to_user_id = nil
        else
            current_approval_approver_id = ApprovalAssignment.find_by(category: approval_assignment_category).last_approval_approver_id
            current_approver_index = approvers.find_index(approvers.find_by(id: current_approval_approver_id)) || -1
            if approvers.count > 1
                current_approver_index = -1 if approvers.count - 1 == current_approver_index    # reset the current_approver_index if it is the last approver in the list
                next_approval_approver_id = approvers[current_approver_index + 1].id
            else
                next_approval_approver_id = approvers[current_approver_index].id
            end
            ApprovalAssignment.where(category: approval_assignment_category).update({
                last_approval_approver_id: next_approval_approver_id
            })
            @assigned_to_user_id = approvers.find_by(id: next_approval_approver_id).user_id
        end
    end

end