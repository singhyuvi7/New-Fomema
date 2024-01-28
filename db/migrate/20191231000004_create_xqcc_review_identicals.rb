class CreateXqccReviewIdenticals < ActiveRecord::Migration[5.2]
  def change
    create_table :xqcc_review_identicals do |t|
      t.belongs_to :xray_review
      t.belongs_to :transaction
      t.timestamps
    end
  end
end
