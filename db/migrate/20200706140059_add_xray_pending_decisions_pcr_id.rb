class AddXrayPendingDecisionsPcrId < ActiveRecord::Migration[6.0]
  def change
    add_column :xray_pending_decisions, :pcr_id, :bigint, index: true
  end
end
