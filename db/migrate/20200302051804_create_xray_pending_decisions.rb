class CreateXrayPendingDecisions < ActiveRecord::Migration[6.0]
  def change
    create_table :xray_pending_decisions do |t|
      t.belongs_to :transaction
      t.text :comment
      t.string :status, index: true
      t.string :approval_status, index: true
      t.string :decision, index: true
      t.references :sourceable, polymorphic: true, index: { name: :sourceable_index }
      t.datetime :transmitted_at, index: true
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
      t.bigint :reviewed_by, index: true
    end
  end
end
