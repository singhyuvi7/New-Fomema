class RenameTransactionsXrayPendingDecisionIdToXrayPendingDecisionBy < ActiveRecord::Migration[6.0]
  def change
    rename_column :transactions, :xray_pending_decision_id, :xray_pending_decision_by
  end
end
