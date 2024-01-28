class WorkerBlockSplit < ActiveRecord::Migration[6.0]
    def change
        # blocked
        add_column :foreign_workers, :is_reg_medical_blocked, :boolean, default: false
        add_column :foreign_workers, :is_reg_medical_blocked_comment, :text
        add_column :foreign_workers, :is_sp_transmit_blocked, :boolean, default: false
        add_column :foreign_workers, :is_sp_transmit_blocked_comment, :text
        add_column :foreign_workers, :is_imm_blocked, :boolean, default: false
        add_column :foreign_workers, :is_imm_blocked_comment, :text

        add_column :transactions, :is_sp_transmit_blocked, :boolean, default: false
        # add_column :transactions, :is_imm_blocked, :boolean, default: false

        add_column :fw_block_logs, :is_reg_medical_blocked, :boolean, default: false
        add_column :fw_block_logs, :is_reg_medical_blocked_comment, :text
        add_column :fw_block_logs, :is_sp_transmit_blocked, :boolean, default: false
        add_column :fw_block_logs, :is_sp_transmit_blocked_comment, :text
        add_column :fw_block_logs, :is_imm_blocked, :boolean, default: false
        add_column :fw_block_logs, :is_imm_blocked_comment, :text
    end
end
