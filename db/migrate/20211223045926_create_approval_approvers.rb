class CreateApprovalApprovers < ActiveRecord::Migration[6.0]
  def change
    create_table :approval_approvers do |t|
      t.string :category
      t.bigint :user_id
      t.string :status
      t.bigint :created_by
      t.bigint :updated_by
      t.timestamps
    end
  end
end
