class CreateXrayReviewDecisions < ActiveRecord::Migration[5.2]
  def change
    create_table :xray_review_decisions do |t|
      t.belongs_to :xray_review
      t.string :decision, index: true

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
