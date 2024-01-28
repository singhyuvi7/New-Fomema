class RenameFwVerificationCriterionToFwVerificationCriteria < ActiveRecord::Migration[6.0]
  def change
    rename_table  :fw_verification_criterions, :fw_verification_pars
    rename_column :fw_block_logs, :fw_verification_criterion_id, :fw_verification_par_id
  end
end
