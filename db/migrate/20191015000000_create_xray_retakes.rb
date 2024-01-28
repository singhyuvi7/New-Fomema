class CreateXrayRetakes < ActiveRecord::Migration[5.2]
  def change
    create_table :xray_retakes do |t|
      t.string :code, index: true
      t.belongs_to :requestable, polymorphic: true, index: { name: :requestable_index }
      t.belongs_to :transaction
      t.belongs_to :retake_reason
      t.belongs_to :xray_facility
      t.text :comment
      t.json :review_data
      t.string :status, index: true
      t.bigint :approval_by, index: true
      t.string :approval_decision
      t.text :approval_comment
      t.text :follow_up_comment
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
