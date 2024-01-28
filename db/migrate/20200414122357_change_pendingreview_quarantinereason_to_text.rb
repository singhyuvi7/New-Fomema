class ChangePendingreviewQuarantinereasonToText < ActiveRecord::Migration[6.0]
  def change
    change_column :xray_pending_reviews, :quarantine_reason, :text
  end
end
