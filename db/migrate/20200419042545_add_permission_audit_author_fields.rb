class AddPermissionAuditAuthorFields < ActiveRecord::Migration[6.0]
  def change
    add_column :role_permissions, :created_at, :datetime
    add_column :role_permissions, :updated_at, :datetime
    add_column :role_permissions, :created_by, :bigint, index: true
    add_column :role_permissions, :updated_by, :bigint, index: true
    add_column :user_permissions, :created_at, :datetime
    add_column :user_permissions, :updated_at, :datetime
    add_column :user_permissions, :created_by, :bigint, index: true
    add_column :user_permissions, :updated_by, :bigint, index: true
  end
end
