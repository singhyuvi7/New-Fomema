class RenameTransactionsXrayPcrReviewIdPcrReviewBy < ActiveRecord::Migration[6.0]
  def change
    rename_column :transactions, :xray_pcr_review_id, :pcr_review_by
  end
end
