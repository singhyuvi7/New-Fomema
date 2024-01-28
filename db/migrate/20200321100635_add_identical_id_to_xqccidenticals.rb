class AddIdenticalIdToXqccidenticals < ActiveRecord::Migration[6.0]
  def change
    add_column :xqcc_review_identicals, :identical_xray_review_id, :bigint, index: true

    remove_column :xqcc_review_identicals, :transaction_id
  end
end
