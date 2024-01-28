module Approvalable
    extend ActiveSupport::Concern

    STATUSES = {
        "NEW_DRAFT" => "NEW DRAFT",
        "UPDATE_DRAFT" => "UPDATE DRAFT",
        "NEW_REVERTED" => "NEW REVERTED",
        "UPDATE_REVERTED" => "UPDATE REVERTED",
        "NEW_PENDING_APPROVAL" => "NEW PENDING APPROVAL",
        "UPDATE_PENDING_APPROVAL" => "UPDATE PENDING APPROVAL",
        "NEW_PENDING_APPROVAL2" => "NEW PENDING APPROVAL 2",
        "UPDATE_PENDING_APPROVAL2" => "UPDATE PENDING APPROVAL 2",
        "NEW_APPROVED" => "NEW APPROVED",
        "UPDATE_APPROVED" => "UPDATE APPROVED",
        "NEW_REJECTED" => "NEW REJECTED",
        "UPDATE_REJECTED" => "UPDATE REJECTED",
        "UPDATE_CANCELLED" => "UPDATE CANCELLED",
        "READY " => "READY"
    }

    CATEGORIES = {
        "LABORATORY_AMENDMENT" => "LABORATORY_AMENDMENT",
        "XRAY_FACILITY_AMENDMENT" => "XRAY_FACILITY_AMENDMENT",
        "XRAY_FACILITY_REGISTRATION" => "XRAY_FACILITY_REGISTRATION",
        "TRANSACTION_CHANGE_DOCTOR" => "TRANSACTION_CHANGE_DOCTOR",
        "DOCTOR_AMENDMENT" => "DOCTOR_AMENDMENT",
        "UNBLOCK_FOREIGN_WORKER" => "UNBLOCK_FOREIGN_WORKER",
        "FOREIGN_WORKER_AMENDMENT" => "FOREIGN_WORKER_AMENDMENT",
        "TRANSACTION_SPECIAL_RENEWAL" => "TRANSACTION_SPECIAL_RENEWAL",
        "LABORATORY_REGISTRATION" => "LABORATORY_REGISTRATION",
        "BLOCK_FOREIGN_WORKER" => "BLOCK_FOREIGN_WORKER",
        "DOCTOR_REGISTRATION" => "DOCTOR_REGISTRATION",
        "RADIOLOGIST_REGISTRATION" => "RADIOLOGIST_REGISTRATION",
    }

    # approval_requests.state: { pending: 0, cancelled: 1, approved: 2, rejected: 3, executed: 4 }

    # approval related
    # approval_status :
    # NEW_DRAFT, UPDATE_DRAFT,
    # NEW_REVERTED, UPDATE_REVERTED,
    # NEW_PENDING_APPROVAL, UPDATE_PENDING_APPROVAL,
    # NEW_PENDING_APPROVAL2, UPDATE_PENDING_APPROVAL2,
    # NEW_APPROVED, UPDATE_APPROVED,
    # NEW_REJECTED, UPDATE_REJECTED,
    # UPDATE_CANCELLED, READY

    def approval_new_request(record, user: current_user, comment: nil, draft: false, record_update_attributes: {}, category: nil, additional_information: false, assigned_to_user_id: nil)
        # vd "approval_new_request called"
        if comment.blank?
            comment = "New request by #{user&.name} (#{user&.id})"
        end
        record.assign_attributes({
            approval_remark: comment
        })

        request = user.request_for_update(record, reason: comment)

        approval_status = 'NEW_PENDING_APPROVAL'
        if draft
            request.request.is_draft = true
            approval_status = 'NEW_DRAFT'
        end
        if !category.blank?
            request.request.category = category
        end
        if additional_information != false
            request.request.additional_information = additional_information
        end
        if !assigned_to_user_id.blank?
            request.request.assigned_to_user_id = assigned_to_user_id
        end
        request.save!

        record.update_attributes({
            approval_status: approval_status
        }.merge(record_update_attributes))
    end

    def approval_update_request(record, user: current_user, comment: nil, draft: false, record_update_attributes: {}, category: nil, additional_information: false, assigned_to_user_id: nil)
        # vd "approval_update_request called"
        # new update request
        if (['READY', 'NEW_APPROVED', 'UPDATE_APPROVED', 'UPDATE_REJECTED', 'UPDATE_CANCELLED'].include?record.approval_status or (!record.id.nil? && record.approval_status.nil?))
            # vd "approval_update_request mark 1"
            if comment.blank?
                comment = "Update request by #{user&.name} (#{user&.id})"
            end
            request = user.request_for_update(record, reason: comment)
            if !category.blank?
                request.request.category = category
            end
            if additional_information != false
                request.request.additional_information = additional_information
            end
            if !assigned_to_user_id.blank?
                request.request.assigned_to_user_id = assigned_to_user_id
            end

            approval_status = 'UPDATE_PENDING_APPROVAL'
            if draft
                request.request.is_draft = true
                approval_status = 'UPDATE_DRAFT'
            end
            request.save!

            record.restore_attributes
            record.update_attributes({
                approval_status: approval_status
            }.merge(record_update_attributes))

        # continue previous drafted new request
        elsif (['NEW_DRAFT', 'NEW_REVERTED'].include?(record.approval_status))
            if draft
                approval_status = 'NEW_DRAFT'
            else
                approval_status = 'NEW_PENDING_APPROVAL'
                ok = record.approval_request.update_attributes({
                    is_draft: false
                })
            end
            ok = record.approval_item.update_attributes({
                params: record.approval_item.params.merge(
                    record.update_params_for_approval
                )
            })

            record.update_attributes({
                approval_status: approval_status
            }.merge(record_update_attributes))

        # continue previous drafted update request
        elsif (['UPDATE_DRAFT', 'UPDATE_REVERTED'].include?(record.approval_status))
            if draft
                approval_status = 'UPDATE_DRAFT'
            else
                approval_status = 'UPDATE_PENDING_APPROVAL'
                ok = record.approval_request.update_attributes({
                    is_draft: false
                })
            end
            ok = record.approval_item.update_attributes!({
                params: record.update_params_for_approval
            })

            record.restore_attributes
            record.update_attributes({
                approval_status: approval_status
            }.merge(record_update_attributes))
        elsif (['NEW_CANCELLED', 'NEW_REJECTED'].include?(record.approval_status))
            approval_new_request(record, user: user, comment: comment, draft: draft, record_update_attributes: record_update_attributes, category: category)
        else
            raise "status #{record.approval_status} is not supported in approval_update_request"
        end
    end

    def approval_approve_request(record, user: current_user, comment: nil, record_update_attributes: {}, final_approval: true)
        # vd "approval_approve_request called"
        approvaltier = approval_get_approval_tier_string(record.approval_status)
        request = record.approval_request
        request.update_attributes({
            "approval#{approvaltier}_user_id" => user&.id,
            "approval#{approvaltier}_decision" => 'APPROVE',
            "approval#{approvaltier}_at" => DateTime.now,
        })

        if final_approval
            if comment.blank?
                comment = "Request approved by #{user&.name} (#{user&.id})"
            end
            respond = user.approve_request(request, reason: comment)
            respond.save!
            record.reload.update_attributes({
                approval_status: "#{(record.approval_status || "UPDATE_APPROVED").split('_').first}_APPROVED"
            }.merge(record_update_attributes))
        else
            record.update_attributes({
                approval_status: approval_next_pending_approval_status(record.approval_status)
            }.merge(record_update_attributes))
            if !comment.blank?
                request = record.approval_request
                user.approval_comments.create(request: request, content: comment)
            end
        end

        if record_update_attributes.count > 0
            record.update_attributes(record_update_attributes)
        end
    end

    def approval_reject_request(record, user: current_user, comment: nil, record_update_attributes: {}, revert: false)
        # vd "approval_reject_request called"
        approvaltier = approval_get_approval_tier_string(record.approval_status)
        request = record.approval_request
        request.update_attributes({
            "approval#{approvaltier}_user_id" => user&.id,
            "approval#{approvaltier}_decision" => revert ? 'REVERT' : 'REJECT',
            "approval#{approvaltier}_at" => DateTime.now,
        })

        if revert
            ret = record.update_attributes({
                approval_status: "#{record.approval_status.split('_').first}_REVERTED"
            })
            if !comment.blank?
                request = record.approval_request
                user.approval_comments.create(request: request, content: comment)
            end
        else
            if comment.blank?
                comment = "Request rejected by #{user&.name} (#{user&.id})"
            end
            request = record.approval_request
            raise "approval request is nil" if request.nil?
            user.approval_comments.create(request: request, content: comment)

            respond = user.reject_request(request, reason: comment)
            ret = respond.save
            if ret === false
                ActiveRecord::Base.connection.execute("update approval_requests set state = 3,
                    respond_user_id = #{ActiveRecord::Base.sanitize_sql(user&.id)},
                    rejected_at = now(),
                    approval#{approvaltier}_user_id = #{ActiveRecord::Base.sanitize_sql(user&.id)},
                    approval#{approvaltier}_decision = 'REJECT',
                    approval#{approvaltier}_at = now(),
                    updated_at = now()
                    where id = #{ActiveRecord::Base.sanitize_sql(request.id)}")
            end
            record.update_attributes({
                approval_status: "#{record.approval_status.split('_').first}_REJECTED"
            }.merge(record_update_attributes))
        end
    end

    def approval_revert_request(record, user: current_user, comment: nil, record_update_attributes: {})
        # vd "approval_revert_request called"
        approval_reject_request(record, user: user, comment: comment, record_update_attributes: record_update_attributes, revert: true)
    end

    def approval_cancel_request(record, user: current_user, comment: nil, record_update_attributes: {})
        if comment.blank?
            comment = "Request cancelled by #{user&.name} (#{user&.id})"
        end
        request = record.approval_request
        respond = user.cancel_request(request, reason: comment)
        respond.save!
        record.update_attributes({
            approval_status: "#{record.approval_status.split('_').first}_CANCELLED"
        }.merge(record_update_attributes))
    end

    def can_request_update?(record)
        ['READY', 'NEW_APPROVED', 'UPDATE_APPROVED', 'NEW_REJECTED', 'UPDATE_REJECTED', 'NEW_CANCELLED', 'UPDATE_CANCELLED'].include?(record.approval_status) or record.approval_status.nil?
    end

    def can_continue_draft?(record, any_user: false)
        ['NEW_DRAFT', 'UPDATE_DRAFT', 'NEW_REVERTED', 'UPDATE_REVERTED'].include?(record.approval_status) and (any_user or record.approval_request.request_user_id == current_user.id)
    end

    def can_cancel_approval?(record)
        ['NEW_DRAFT', 'UPDATE_DRAFT', 'NEW_REVERTED', 'UPDATE_REVERTED', 'NEW_REJECTED', 'UPDATE_REJECTED'].include?(record.approval_status) && !record.approval_request.nil? && record.approval_request.request_user_id == current_user.id
    end

    def can_do_approval?(record)
        ['NEW_PENDING_APPROVAL', 'UPDATE_PENDING_APPROVAL'].include?(record.approval_status) && !record.approval_request.nil? && record.approval_request.request_user_id != current_user.id
    end

    def can_do_approval2?(record)
        ['NEW_PENDING_APPROVAL2', 'UPDATE_PENDING_APPROVAL2'].include?(record.approval_status) && !record.approval_request.nil? && record.approval_request.approval_user_id != current_user.id
    end

    private
    def approval_params
        params.require(:approval).permit(:comment, :decision)
    end

    def approval_get_approval_tier(status_string)
        scan = status_string.scan(/\d+$/).first
        if scan.nil?
            return 1
        end
        return scan.to_i
    end

    def approval_get_approval_tier_string(status_string)
        return approval_get_approval_tier(status_string) > 1 ? '2' : ''
    end

    def approval_status_next_number(status_string)
        scan = status_string.scan(/\d+$/).first
        if scan.nil?
            return 2
        end
        return scan.to_i + 1
    end

    def approval_next_pending_approval_status(current_status)
        "#{current_status.gsub(/\d+$/, '')}#{approval_status_next_number(current_status)}"
    end
end