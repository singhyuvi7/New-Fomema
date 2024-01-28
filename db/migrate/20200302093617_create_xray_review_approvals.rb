class CreateXrayReviewApprovals < ActiveRecord::Migration[6.0]
  def change
    create_table :xray_review_approvals do |t|
      t.belongs_to :transaction
      t.belongs_to :xray_pending_decision
      t.text :comment
      t.string :status, index: true
      t.datetime :transmitted_at, index: true
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
      t.bigint :reviewed_by, index: true
    end
  end
end
