class CreateApprovalAssignments < ActiveRecord::Migration[6.0]
  def change
    create_table :approval_assignments do |t|
      t.string :category
      t.bigint :last_approval_approver_id
      t.timestamps
    end
  end
end
