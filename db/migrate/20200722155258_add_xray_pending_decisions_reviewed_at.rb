class AddXrayPendingDecisionsReviewedAt < ActiveRecord::Migration[6.0]
  def change
    add_column :xray_pending_decisions, :reviewed_at, :datetime
  end
end
