class CreateXrayPendingReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :xray_pending_reviews do |t|
      t.belongs_to :transaction
      t.string :quarantine_type, index: true
      t.string :prev_unsuitable_type, index: true
      t.string :quarantine_reason, index: true
      t.string :source, index: true
      t.text :comment
      t.string :status, index: true
      t.string :decision, index: true
      t.datetime :transmitted_at, index: true
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
      t.bigint :reviewed_by, index: true
    end
  end
end
