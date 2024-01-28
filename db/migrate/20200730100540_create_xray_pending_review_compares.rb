class CreateXrayPendingReviewCompares < ActiveRecord::Migration[6.0]
  def change
    create_table :xray_pending_review_compares do |t|
      t.bigint :xray_pending_review_id, index: true
      t.bigint :transaction_id, index: true
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
