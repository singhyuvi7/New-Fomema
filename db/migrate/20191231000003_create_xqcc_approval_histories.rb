class CreateXqccApprovalHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :xqcc_approval_histories do |t|
      t.references :historyable, polymorphic: true, index: { name: :historyable_index }
      t.text :comment
      t.string :status, index: true

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
