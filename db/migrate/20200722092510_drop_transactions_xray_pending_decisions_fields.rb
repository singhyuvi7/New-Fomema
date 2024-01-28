class DropTransactionsXrayPendingDecisionsFields < ActiveRecord::Migration[6.0]
  def change
    remove_column :transactions, :xray_pending_decision_by, :bigint, index: true
    remove_column :transactions, :xray_pending_decision_decision, :string
    remove_column :transactions, :xray_pending_decision_comment, :text
  end
end
