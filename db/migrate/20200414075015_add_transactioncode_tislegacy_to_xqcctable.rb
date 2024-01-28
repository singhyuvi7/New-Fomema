class AddTransactioncodeTislegacyToXqcctable < ActiveRecord::Migration[6.0]
  def change
    add_column :xray_pending_reviews, :is_legacy, :boolean, default: false, null: false, index: true
    add_column :xray_pending_reviews, :trans_id, :string, index: true

    add_column :xqcc_pools, :is_legacy, :boolean, default: false, null: false, index: true
    add_column :xqcc_pools, :trans_id, :string, index: true

    add_column :xray_reviews, :is_legacy, :boolean, default: false, null: false, index: true
    add_column :xray_reviews, :trans_id, :string, index: true

    add_column :xqcc_review_identicals, :is_legacy, :boolean, default: false, null: false, index: true
    add_column :xqcc_review_identicals, :trans_id, :string, index: true

    add_column :xqcc_comments, :is_legacy, :boolean, default: false, null: false, index: true
    add_column :xqcc_comments, :trans_id, :string, index: true

    add_column :pcr_pools, :is_legacy, :boolean, default: false, null: false, index: true
    add_column :pcr_pools, :trans_id, :string, index: true

    add_column :pcr_reviews, :is_legacy, :boolean, default: false, null: false, index: true
    add_column :pcr_reviews, :trans_id, :string, index: true

    add_column :xray_pending_decisions, :is_legacy, :boolean, default: false, null: false, index: true
    add_column :xray_pending_decisions, :trans_id, :string, index: true

    add_column :xray_review_approvals, :is_legacy, :boolean, default: false, null: false, index: true
    add_column :xray_review_approvals, :trans_id, :string, index: true

    add_column :xray_retakes, :is_legacy, :boolean, default: false, null: false, index: true
    add_column :xray_retakes, :trans_id, :string, index: true

    add_column :digital_xray_movements, :is_legacy, :boolean, default: false, null: false, index: true
    add_column :digital_xray_movements, :trans_id, :string, index: true

    add_column :xqcc_batches, :is_legacy, :boolean, default: false, null: false, index: true
    add_column :xqcc_batches, :trans_id, :string, index: true

  end
end
