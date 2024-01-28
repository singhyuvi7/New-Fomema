class AddFwVerificationCriterionIdToFwBlockLogs < ActiveRecord::Migration[6.0]
  def change
    add_column :fw_block_logs, :fw_verification_criterion_id, :json
  end
end
