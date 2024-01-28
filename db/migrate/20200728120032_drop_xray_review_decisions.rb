class DropXrayReviewDecisions < ActiveRecord::Migration[6.0]
  def change
    drop_table :xray_review_decisions
  end
end
