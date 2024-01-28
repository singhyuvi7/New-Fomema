class AddLegacyidToXqccTable < ActiveRecord::Migration[6.0]
  def change
    add_column :xray_pending_reviews, :legacy_id, :bigint, index: true

    add_column :xqcc_pools, :legacy_id, :bigint, index: true

    add_column :xray_reviews, :legacy_id, :bigint, index: true

    add_column :xqcc_review_identicals, :legacy_id, :bigint, index: true

    add_column :xqcc_comments, :legacy_id, :bigint, index: true

    add_column :pcr_pools, :legacy_id, :bigint, index: true

    add_column :pcr_reviews, :legacy_id, :bigint, index: true

    add_column :xray_pending_decisions, :legacy_id, :bigint, index: true

    add_column :xray_review_approvals, :legacy_id, :bigint, index: true

    add_column :xray_retakes, :legacy_id, :bigint, index: true

    add_column :digital_xray_movements, :legacy_id, :bigint, index: true

    add_column :xqcc_batches, :legacy_id, :bigint, index: true

  end
end
