module WorkerBlocking
    def block_imm(foreign_worker, block_reason, block_comment, user: User.admin_user)
        foreign_worker.update({
            is_imm_blocked: true,
            blocked: true,
            block_reason_id: block_reason&.id,
            blocked_by: user.id,
            blocked_at: Time.now,
            is_imm_blocked_comment: block_comment,
        })

        foreign_worker.fw_block_logs.create({
            foreign_worker_id: foreign_worker.id,
            action: "BLOCK",
            block_reason_id: block_reason&.id,
            requested_by: user.id,
            requested_at: Time.now,
            approval_decision: "APPROVE",
            approval_at: Time.now,
            approval_by: user.id,
            is_imm_blocked: true,
            is_imm_blocked_comment: block_comment,
            is_sp_transmit_blocked: foreign_worker.is_sp_transmit_blocked,
            is_sp_transmit_blocked_comment: foreign_worker.is_sp_transmit_blocked_comment,
            is_reg_medical_blocked: foreign_worker.is_reg_medical_blocked,
            is_reg_medical_blocked_comment: foreign_worker.is_reg_medical_blocked_comment,
        })
    end

    def unblock_imm(foreign_worker, unblock_reason, unblock_comment, user: User.admin_user)
        fw_blocked_data = {
            is_imm_blocked: false,
            is_imm_blocked_comment: unblock_comment,
        }

        fw_block_log_data = {
            foreign_worker_id: foreign_worker.id,
            action: foreign_worker.blocked ? "BLOCK" : "UNBLOCK",
            block_reason_id: foreign_worker.block_reason_id,
            requested_by: user.id,
            requested_at: Time.now,
            approval_decision: "APPROVE",
            approval_at: Time.now,
            approval_by: user.id,
            is_imm_blocked: false,
            is_imm_blocked_comment: unblock_comment,
            is_sp_transmit_blocked: foreign_worker.is_sp_transmit_blocked,
            is_sp_transmit_blocked_comment: foreign_worker.is_sp_transmit_blocked_comment,
            is_reg_medical_blocked: foreign_worker.is_reg_medical_blocked,
            is_reg_medical_blocked_comment: foreign_worker.is_reg_medical_blocked_comment,
        }

        if !foreign_worker.is_reg_medical_blocked && !foreign_worker.is_sp_transmit_blocked
            fw_blocked_data = fw_blocked_data.merge({
                blocked: false,
                blocked_at: nil,
                blocked_by: nil,
                unblock_reason_id: unblock_reason&.id,
            })

            fw_block_log_data = fw_block_log_data.merge({
                action: "UNBLOCK",
                block_reason_id: unblock_reason&.id,
            })
        end

        foreign_worker.update(fw_blocked_data)

        foreign_worker.fw_block_logs.create(fw_block_log_data)
    end

    def block_reg_medical(foreign_worker, block_reason, block_comment, user: User.admin_user)
        foreign_worker.update({
            is_reg_medical_blocked: true,
            blocked: true,
            block_reason_id: block_reason&.id,
            blocked_by: user.id,
            blocked_at: Time.now,
            is_reg_medical_blocked_comment: block_comment
        })

        foreign_worker.fw_block_logs.create({
            foreign_worker_id: foreign_worker.id,
            action: "BLOCK",
            block_reason_id: block_reason&.id,
            requested_by: user.id,
            requested_at: Time.now,
            approval_decision: "APPROVE",
            approval_at: Time.now,
            approval_by: user.id,
            is_imm_blocked: foreign_worker.is_imm_blocked,
            is_imm_blocked_comment: foreign_worker.is_imm_blocked_comment,
            is_sp_transmit_blocked: foreign_worker.is_sp_transmit_blocked,
            is_sp_transmit_blocked_comment: foreign_worker.is_sp_transmit_blocked_comment,
            is_reg_medical_blocked: true,
            is_reg_medical_blocked_comment: block_comment,
        })
    end
end