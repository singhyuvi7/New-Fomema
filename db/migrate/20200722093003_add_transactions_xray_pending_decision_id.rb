class AddTransactionsXrayPendingDecisionId < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :xray_pending_decision_id, :bigint, index: true
  end
end
