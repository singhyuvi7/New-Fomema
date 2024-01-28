class DropTransactionsPcrReviewsFields < ActiveRecord::Migration[6.0]
  def change
    remove_column :transactions, :xray_pcr_review_decision, :string
    remove_column :transactions, :xray_pcr_review_comment, :text
  end
end
