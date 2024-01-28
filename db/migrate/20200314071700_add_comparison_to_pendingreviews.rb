class AddComparisonToPendingreviews < ActiveRecord::Migration[6.0]
  def change

    add_column :xray_pending_reviews, :is_audit_comparison, :string, index: true
    add_column :xray_pending_reviews, :compare_transaction_id, :bigint, index: true

  end
end
